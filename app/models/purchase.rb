class Purchase < ActiveRecord::Base

  default_scope {order('created_at DESC') }

  has_one :basket , :as => :kori ,  :autosave => true
  belongs_to :supplier , optional: true

  def order!
    self.ordered_on = Date.today
    save!
  end

  def receive!
    items = basket.receive!
    return stamp_today items
  end

  def inventory!
    items = basket.inventory!
    return stamp_today items
  end

  private
  def stamp_today items
    self.ordered_on = Date.today unless ordered_on
    self.received_on = Date.today
    self.save!
    items
  end
end
