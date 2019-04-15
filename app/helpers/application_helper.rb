# -*- coding: utf-8 -*-
module ApplicationHelper
  def ext_link(name = nil, options = nil, html_options = nil, &block)
    target_blank = {target: "_blank"}
    if block_given?
      options ||= {}
      options = options.merge(target_blank)
    else
      html_options ||= {}
      html_options = html_options.merge(target_blank)
    end
    link_to(name, options, html_options, &block)
  end

  # users are stored in the session by email
  # if user is not logged i , return nil
  def current_clerk
    return @current_clerk if @current_clerk
    return nil unless session[:clerk_email]
    @current_clerk = Clerk.where( :email => session[:clerk_email] ).limit(1).first
  end
  def current_basket_or_nil
    return @current_basket unless @current_basket.nil?
    if session[:current_basket]
      Basket.where( :id => session[:current_basket] ).limit(1).first
    else
      nil
    end
  end
  # the current user has a shopping basket which is also stored in the session
  # we *always* return a basket, even if we have to create one (and then store in the session)
  # this is not associated with the user until an order is finalized at which point the order gets the users email (not id)
  # that way people don't have to log in to order, but if they are we can retrieve their orders by email
  def current_basket
    @current_basket = current_basket_or_nil
    if @current_basket.nil?
      @current_basket = Basket.new(:kori_type => "Order")
      @current_basket.save!
      session[:current_basket] = @current_basket.id
    end
    @current_basket
  end

  # when the order is made and the basket locked, it's time to make a new one
  def new_basket
    session[:current_basket] = nil
  end

  def shipping_method name
    ShippingMethod.method(name)
  end

  def markdown( text )
    return "" if text.blank?
    return sanitize Kramdown::Document.new(text).to_html
  end

  # euros displays the prices in ... da da .. . euros.
  # This could of course be configurable, but since taxes and possibly shipping don't work in us, i wait for the pull
  def euros( price )
    price ? number_to_currency(price , :precision => 2 , :unit => "€") : 0.0
  end

  # this is the helper that best in place uses to display euros.
  # it is different so it can be overriden
  def best_euros p
    euros(p)
  end
  def best_euros p
    euros(p).sub("€", "") + " / " + euros(p/1.24)
  end

  def date d
    return "" unless d
    I18n.l d
  end

end
