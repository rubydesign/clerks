class AddCidToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :c_id, :string
    add_column :orders, :vatid, :string
    with_id = Order.all.select{|o| o.cid}
    with_id.each do |order|
      order.c_id = order.cid
      order.vatid = order.vat_id
      order.save
    end
  end
end
