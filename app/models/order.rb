require "reference_number"

class Order < ActiveRecord::Base
  has_one :basket , :as => :kori , :autosave => true , :dependent => :destroy

  store :address, accessors: [ :name , :street , :city , :phone , :vat_id , :cid] #, coder: JSON

  validates :ordered_on,  :presence => true

  validates :name,  :presence => true , :if => :needs_address?
  validates :street,:presence => true , :if => :needs_address?
  validates :city,  :presence => true , :if => :needs_address?
  validates :phone, :presence => true , :if => :needs_address?
  validates :email, :presence => true , :email => true
  #validates :order_number, uniqueness: true

  default_scope { order('created_at DESC')}

  def self.nimi_has(nimi)
    where("address like ? " , "% #{nimi}%" )
  end

  def self.ransackable_scopes(auth_object = nil)
    [:nimi_has]
  end
  #  private_class_method :ransackable_scopes

  # many a european goverment requires buisnesses to have running order/transaction numbers.
  # this is what we use, but it can easily be changed by redifining this method
  # format RYYYYRUNIN  R, 4 digit year and a running number
  def generate_order_number
    return unless self.order_number.blank?
    last = Order.unscoped.where.not(order_number: nil).order("order_number DESC").first
    if last
      num = last.order_number % 100000 + 1
    else
      num = 30000
    end
    self.order_number = Time.now.year * 100000 + num
  end

  def number
    "R#{self.order_number}"
  end
  def id_number
    self.order_number ? self.number : self.id.to_s
  end

  def total_price
    basket.total_price + shipment_price.round(2)
  end

  # total tax is for when the rates don't matter, usually to cutomers.
  # only on bills or invoices do we need the detailed list you get from the taxes function
  def total_tax
    basket.total_tax + shipment_tax_value
  end

  # return a hash of rate => amount , because products may have different taxes,
  # the items in an order may have a collection of tax rates.
  def taxes
    cart = basket.taxes
    #relies on basket creating a default value of 0
    cart[self.shipment_tax] += shipment_tax_value if self.shipment_tax and self.shipment_tax != 0
    cart
  end

  def pay_now
    self.paid_on = Date.today
  end
  def ship_now
    self.shipped_on = Date.today
  end

  # go back to edit mode, but return inventiry and zero shipped
  def cancel!
    self.shipped_on = nil
    self.basket.cancel_order!
    self.save
  end

  def shipment_type= typ
    calc = ShippingMethod.all[typ.to_sym]
    return nil unless calc
    cost = calc.price_for(self.basket)
    write_attribute(:shipment_type, typ)
    self.shipment_price = cost
    self.shipment_tax = RubyClerks.config("defaults.tax").to_f rescue 0
  end

  # this returns a finnish reference number, as used in the finnish bank system
  # for referencing payments to bills.
  def viite
    return "" unless self.order_number
    base = self.number[1 .. -1]
    ReferenceNumber.new(base).to_s
  end

  private
  # the name says a lot ,but what for? for shipping. For pickup or store sales we don't need an address
  def needs_address?
    return false unless shipment_type
    return shipment_type != "pickup"
  end
  def shipment_tax_value
    (self.shipment_tax * self.shipment_price / ( 100.0 + self.shipment_tax)).round(4)
  end
end
