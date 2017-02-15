class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :order_status
  after_create :set_order_status # rails 5 only else before_create :set_order_status#
  # before_validation :setorder_status
  has_many :order_items

  before_save :update_subtotal

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  private

  def set_order_status
    self.order_status_id = 1 if order_status_id.nil? # rails 5 needs if clause#
  end

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
