class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :order_status
  after_create :set_order_status # rails 5 only else before_create :set_order_status#
  has_many :order_items

  before_save :update_subtotal

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  private

  def set_order_status
    if order_status_id.nil?
      self.order_status_id = 1 # rails 5 needs if clause#
    end
  end

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
