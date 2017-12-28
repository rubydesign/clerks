# encoding : utf-8
require "admin_helper"
module BasketsHelper
  def has_receipt?
    styles = RubyClerks.config(:print_styles)
    return false if styles.nil?
    return styles.split.include?("receipt")
  end
  def basket_edit_link basket , options = {}
    return "---" unless basket
    return "" unless request.url.include?("basket")
    if basket.locked?
      text =  I18n.t(:locked) + ": "
      case basket.kori
      when Order
        text += I18n.t(:order)
        link = office.order_path(basket.kori)
      when Purchase
        text += I18n.t(:purchase)
        link = office.purchase_path(basket.kori)
      else
        raise "System Error: Locked basket without order #{basket.id}"
      end
    else
      if basket.kori
        key = basket.kori.class.name.downcase
        text = I18n.t(key)
      else
        text = t(:basket)
      end
      link = office.edit_basket_path(basket)
    end
    return link_to text , link , options
  end
end
