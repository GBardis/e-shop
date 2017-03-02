class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :order_status
  # before_create :set_order_status # rails 5 only else before_create :set_order_status#
  #  before_validation :set_order_status
  has_many :order_items, dependent: :destroy
  # has_many :products, through: :order_items
  before_save :update_subtotal
  enum status: { cancelled: 0, in_progress: 1, completed: 2, invoiced: 3 }

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  private

  # def set_order_status
  # self.order_status_id = 1 if order_status_id.nil? # rails 5 needs if clause#
  # end

  def update_subtotal
    self[:subtotal] = subtotal
  end
end
