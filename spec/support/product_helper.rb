module ProductHelper
  def product_count
    click_button(:filter)
    all(".supplier").count
  end
  def category_count
    click_button(:filter)
    all(".line").count
  end
  def create_ab type , hash
    attribute , values = hash.first
    values.each do | value|
      create type , attribute => value
    end
  end
  def product_ab hash
    create_ab :product , hash
    visit products_path
  end
  def category_ab hash
    create_ab :category , hash
    visit categories_path
  end
  def order_ab hash
    create_ab :order , hash
    visit orders_path
  end
  def order_count
    click_button(:filter)
    all(".number").count
  end
end

RSpec.configure do |config|
  config.include ProductHelper
end
