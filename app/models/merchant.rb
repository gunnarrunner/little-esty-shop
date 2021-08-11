class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  validates :name, presence: true

  def top_customers
    invoices.joins(:customer, :transactions)
            .where(transactions: {result: true})
            .select("customers.*, count(transactions.id) as total_count")
            .group("customers.id, invoice_items.id")
            .distinct
            .order(total_count: :desc)
            .limit(5)
  end

  def quantity_threshold
    bulk_discounts.minimum(:quantity_threshold)
  end

  def maximum_discount(quantity)
    bulk_discounts.where('quantity_threshold <= ?', quantity).maximum(:percentage_discount)
  end

  def total_discount_revenue(invoice_id)
    merchant_invoice_items = self.invoice_items.where('invoice_id = ?', invoice_id)

    discounted_revenue = 0
    merchant_invoice_items.each do |item|
      if self.quantity_threshold == nil
        discounted_revenue += (item.quantity * item.unit_price)
      elsif item.quantity >= self.quantity_threshold
        discounted_revenue += ((item.quantity * item.unit_price) - ((item.quantity * item.unit_price) * (self.maximum_discount(item.quantity))))
      else
        discounted_revenue += (item.quantity * item.unit_price)
      end
    end
    discounted_revenue
  end

  def self.enabled_merchants
    where("status = ?", "enabled")
  end

  def self.disabled_merchants
    where("status = ?", "disabled")
  end

  def self.top_5_merchants_revenue
    joins(items: {invoice_items: {invoice: :transactions}})
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .where(transactions: { result: :success})
    .order(revenue: :desc)
    .limit(5)
  end
  
  def merchant_best_day
    invoices.joins(:transactions)
            .select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
            .group('invoices.id')
            .where(transactions: { result: :success})
            .order('revenue desc', 'invoices.created_at desc')
            .first
            .created_at
  end

  def top_five_items
    items.joins(invoices: :transactions)
    .where(transactions: {result: true})
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group("items.id")
    .order(revenue: :desc)
    .limit(5)
  end

  def ready_to_ship
    invoice_items.joins(:invoice)
    .where(status: ['packaged', 'pending'])
    .select('items.name as item_name, invoice_items.*, invoices.created_at as invoice_date')
    .group('items.id, invoice_items.id, invoices.id')
    .order(:invoice_date)
  end

end
