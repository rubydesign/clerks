# encoding : utf-8
class OrdersController < AdminController
  include Print

  before_action :load_order, :only => [ :show, :edit, :destroy, :update , :cancel,
                                        :ship, :shipment ,  :pay , :deduct_only]

  def index
    query = params[:q] || {}
    if query[:order_number_eq]
      query[:order_number_eq] = query[:order_number_eq].gsub(/\s/ , "")
      query[:order_number_eq] = query[:order_number_eq][1 .. -1]  if query[:order_number_eq][0] == "R"
      query[:order_number_eq] = query[:order_number_eq][0 .. -2]  if query[:order_number_eq].length == 10
    end
    @q = Order.ransack( query )
    @order_scope = @q.result( :distinct => true).includes(:basket => {:items => :product} )
    @orders = @order_scope.page(params[:page])
  end
  def show
  end

  def new
    basket = Basket.create!
    @order = Order.new :email => current_clerk.email , :basket => basket , :ordered_on => Date.today
    if( copy = params[:address])
      order = Order.find copy
      @order.email = order.email
      @order.address = order.address
    end
    @order.save!
    redirect_to edit_basket_path basket
  end

  def pay
    @order.pay_now
    @order.save
    return redirect_to orders_path , :notice => t(:update_success) + ":#{@order.number}"
  end

  def deduct_only
    @order.ship_now
    @order.basket.deduct!
    @order.save!
    return redirect_to order_path(@order), :notice => t(:update_success)
  end

  def ship
    @order.generate_order_number
    return deduct_only
  end

  # after many user mistakes we now let the user undo those, cancel to go back to edit
  def cancel
    @order.cancel!
    return redirect_to order_path(@order), :notice => t(:update_success)
  end

  def shipment
    return if request.get?
    return redirect_to order_path(@order), :notice => t(:update_success) if @order.update_attributes(params_for_order)
  end

  def edit
  end

  def update
    @order.build_basket unless @order.basket
    respond_to do |format|
      if @order.update_attributes(params_for_order)
        format.html { redirect_to(@order, :notice => t(:update_success, :model => :order)) }
        format.json { respond_with_bip(@order) }
      else
        format.html { render :action => :shipment }
        format.json { respond_with_bip(@order) }
      end
    end
  end

  def destroy
    if @order.basket.locked?
      flash.notice = t(:basket_locked)
    else
      @order.destroy
      flash.notice = t(:order) + " " + t(:deleted)
    end
    redirect_to orders_url
  end

  def rakennus
    load_order
    @invoice = true
    @template = "rakennus"
  end

  private

  def load_order
    @order = Order.find(params[:id])
  end

  def params_for_order
    params.require(:order).permit(:payment_info,:note , :message,
                      :shipment_info,:shipment_price,:shipment_tax,:shipment_type,
                      :name ,:street, :city , :phone , :email , :vat_id , :cid)
  end
end
