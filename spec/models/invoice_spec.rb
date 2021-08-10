require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should belong_to(:customer) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    context 'status' do
      it { should validate_presence_of(:status) }
      it { should define_enum_for(:status).with_values([:in_progress, :completed, :cancelled]) }
    end
  end

  before :each do
    @merchant8 = Merchant.create!(name: "Best Buy", status: "enabled")

    @bulk_discount7 = BulkDiscount.create!(percentage_discount: 0.2, quantity_threshold: 100, merchant_id: @merchant8.id)
    @bulk_discount8 = BulkDiscount.create!(percentage_discount: 0.3, quantity_threshold: 200, merchant_id: @merchant8.id)
    # @bulk_discount9 = BulkDiscount.create!(percentage_discount: 0.15, quantity_threshold: 200, merchant_id: @merchant8.id)

    @customer11 = Customer.create!(first_name: "Caleb", last_name: "Wittman")

    @invoice100 = Invoice.create!(status: 'completed', customer_id: @customer11.id)
    @invoice101 = Invoice.create!(status: 'completed', customer_id: @customer11.id)
    @invoice102 = Invoice.create!(status: 'completed', customer_id: @customer11.id)
    @invoice103 = Invoice.create!(status: 'in_progress', customer_id: @customer11.id)


    @transaction100 = Transaction.create!(credit_card_number: '1234234534564567', credit_card_expiration_date: nil, result: true, invoice_id: @invoice100.id)
    @transaction101 = Transaction.create!(credit_card_number: '1234234534564567', credit_card_expiration_date: nil, result: true, invoice_id: @invoice101.id)
    @transaction102 = Transaction.create!(credit_card_number: '1234234534564567', credit_card_expiration_date: nil, result: true, invoice_id: @invoice102.id)
    @transaction103 = Transaction.create!(credit_card_number: '1234234534564567', credit_card_expiration_date: nil, result: false, invoice_id: @invoice103.id)

    @item18 = Item.create!(name: 'Big T.V.', description: 'Big TV', unit_price: 800, merchant_id: @merchant8.id)
    @item19 = Item.create!(name: 'Bigger T.V.', description: 'Bigger TV', unit_price: 1200, merchant_id: @merchant8.id)
    @item20 = Item.create!(name: 'T.V.', description: 'TV', unit_price: 400, merchant_id: @merchant8.id)


    
    @invoice_item22 = InvoiceItem.create!(invoice_id: @invoice100.id, item_id: @item18.id, quantity: 125, unit_price: @item18.unit_price, status: 'shipped')
    @invoice_item23 = InvoiceItem.create!(invoice_id: @invoice101.id, item_id: @item19.id, quantity: 200, unit_price: @item19.unit_price, status: 'shipped')
    @invoice_item24 = InvoiceItem.create!(invoice_id: @invoice102.id, item_id: @item20.id, quantity: 99, unit_price: @item20.unit_price, status: 'shipped')
    @invoice_item25 = InvoiceItem.create!(invoice_id: @invoice103.id, item_id: @item18.id, quantity: 50, unit_price: @item18.unit_price, status: 'shipped')
    @invoice_item26 = InvoiceItem.create!(invoice_id: @invoice100.id, item_id: @item19.id, quantity: 150, unit_price: @item19.unit_price, status: 'shipped')
    @invoice_item27 = InvoiceItem.create!(invoice_id: @invoice101.id, item_id: @item20.id, quantity: 130, unit_price: @item20.unit_price, status: 'shipped')
  end

  it 'calculates invoice total revenue' do
    expect(@invoice1.invoice_items.count).to eq(3)
    expect(@invoice1.total_revenue).to eq(78750)
  end

  it 'returns list of invoices from old to new with invoice_items that have not been shipped' do
    expect(Invoice.incomplete_invoices_by_date.length).to eq(13)
  end

  # describe 'instance methods' do
  #   describe '#invoice_discounted_revenue' do
  #     it 'can calculate the discounted revenue for a invoice' do
  #       expect(@invoice100.invoice_discounted_revenue).to eq(224000)
  #     end
  #   end
  # end
end
