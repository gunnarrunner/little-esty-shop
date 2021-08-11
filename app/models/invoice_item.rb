class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]

  def self.locate(invoice_id, item_id)
    where('invoice_id = ?', invoice_id).where('item_id = ?', item_id).first
  end

  def self.total_revenue
    sum("quantity * unit_price")
  end

  def has_discount?
    bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', quantity)
                  .size >= 1
  end

  def find_discount
    bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', quantity)
                  .order(percentage_discount: :desc)
                  .first
  end
end
