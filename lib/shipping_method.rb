class ShippingMethod
  def initialize data
    @data = data
    @name = @data[:name]
    @type = @data[:type]
    @description = @data[:description]
  end
  attr_reader :data , :name , :type , :description

  # the relevant interface for a shipping method is
  # a) whether it applies to the order (basket) : available?
  # b) how much sendin costs, price_for(basket)
  def price_for(basket)
    raise "Not implemented in #{self}"
  end
  def available?(basket)
    true
  end

  ## class stuff after here, global list etc
  @@methods = nil
  def self.all
    return @@methods if @@methods
    @@methods = {}
    config = RubyClerks.config(:shipping)
    config.each do |key , method|
      puts "key #{key} meth #{method}"
      begin
        clas_name = method[:class]
        clas = clas_name.constantize
      rescue
        puts "No such Class #{method[:class]}, check config.yml"
      end
      @@methods[key] = clas.new( method.merge(:type => key) ) if clas
    end
    @@methods
  end
  def self.method(name)
    return self.all.values.first if name.nil?
    m = self.all[name.to_sym]
    m.blank? ?  self.all.values.first : m
  end
end
class Pickup < ShippingMethod
  def initialize data
    super(data)
  end
  def price_for(basket)
    0.0
  end
  def available?(basket)
    true
  end
end
