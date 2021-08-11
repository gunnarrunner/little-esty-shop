require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    # it { should have_many(:) }
    # it { should have_many(:).through(:) }
  end

  describe 'enum status' do
    it { should define_enum_for(:status).with_values([:pending, :packaged, :shipped]) }
  end

  # describe 'validations' do
  #   it { should validate_presence_of(:) }
  # end

  # before :each do

  # end

  describe 'class methods' do
    describe '.locate' do
      it 'locates invoice item with invoice and item ids' do
        expected = InvoiceItem.locate(@invoice1.id, @item1.id)

        expect(expected).to eq(@invoice_item1)
      end
    end

    describe '.total_revenue' do
      it 'calculates total revenue of a collection of invoice items' do
        expected = @invoice1.invoice_items.total_revenue

        expect(expected).to eq(78750)
      end
    end
  end

  describe 'instance methods' do
    describe '#has_discount?' do
      it 'can determine if a invoice item has a discount or not' do
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
        @invoice_item26 = InvoiceItem.create!(invoice_id: @invoice100.id, item_id: @item19.id, quantity: 90, unit_price: @item19.unit_price, status: 'shipped')
        @invoice_item27 = InvoiceItem.create!(invoice_id: @invoice101.id, item_id: @item20.id, quantity: 130, unit_price: @item20.unit_price, status: 'shipped')

        expect(@invoice_item22.has_discount?).to eq(true)
        expect(@invoice_item25.has_discount?).to eq(false)
      end
    end

    describe '#find_discount' do
      it 'can find the discount if it does have one' do
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
        @invoice_item26 = InvoiceItem.create!(invoice_id: @invoice100.id, item_id: @item19.id, quantity: 90, unit_price: @item19.unit_price, status: 'shipped')
        @invoice_item27 = InvoiceItem.create!(invoice_id: @invoice101.id, item_id: @item20.id, quantity: 130, unit_price: @item20.unit_price, status: 'shipped')

        expect(@invoice_item22.find_discount).to eq(@bulk_discount7)
        expect(@invoice_item25.find_discount).to eq(nil)
      end
    end
  end
end
