require 'rails_helper'

RSpec.describe 'the merchant invoice show' do

  describe 'display' do
    it 'shows header text merchant name and invoice id' do
      visit merchant_invoice_path(@merchant1.id, @invoice1.id)

      within('#header') do
        expect(page).to have_content(@merchant1.name)
        expect(page).to have_content("Invoice ##{@invoice1.id}")
      end
    end

    it 'shows status, created on, and total revenue' do
      visit merchant_invoice_path(@merchant1.id, @invoice1.id)

      within('#invoice_info') do
        expect(page).to have_content("Status: #{@invoice1.status}")
        expect(page).to have_content("Created on: #{@invoice1.created_at.strftime("%A, %B %d, %Y")}")
        expect(page).to have_content("Total Revenue: $787.00")
      end
    end

    it 'shows customer header and name' do
      visit merchant_invoice_path(@merchant1.id, @invoice1.id)

      within('#customer') do
        expect(page).to have_content('Customer:')
        expect(page).to have_content("#{@invoice1.customer.first_name} #{@invoice1.customer.last_name}")
      end
    end

    it 'shows all items on invoice and their attributes' do
      visit merchant_invoice_path(@merchant1.id, @invoice1.id)

      within('#items') do
        expect(page).to have_content('Items on this Invoice:')

        within("#item-#{@item1.id}") do
          expect(page).to have_content("Item Name: #{@item1.name}")
          expect(page).to have_content("Quantity: #{@invoice_item1.quantity}")
          expect(page).to have_content("Unit Price: #{@invoice_item1.unit_price}")
          expect(page).to have_select('invoice_item[status]', selected: @invoice_item1.status)
        end

        within("#item-#{@item2.id}") do
          expect(page).to have_content("Item Name: #{@item2.name}")
          expect(page).to have_content("Quantity: #{@invoice_item15.quantity}")
          expect(page).to have_content("Unit Price: #{@invoice_item15.unit_price}")
          expect(page).to have_select('invoice_item[status]', selected: @invoice_item15.status)
        end

        within("#item-#{@item3.id}") do
          expect(page).to have_content("Item Name: #{@item3.name}")
          expect(page).to have_content("Quantity: #{@invoice_item16.quantity}")
          expect(page).to have_content("Unit Price: #{@invoice_item16.unit_price}")
          expect(page).to have_select('invoice_item[status]', selected: @invoice_item16.status)
        end
      end
    end

    it 'does not show item info not on invoice' do
      visit merchant_invoice_path(@merchant1.id, @invoice1.id)

      expect(page).to_not have_content(@item4.name)
      expect(page).to_not have_content(@item5.name)
      expect(page).to_not have_content(@item8.name)
      expect(page).to_not have_content(@item10.name)
    end

    it 'can show the discounted revenue' do
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

      visit merchant_invoice_path(@merchant8.id, @invoice100.id)

      expect(page).to have_content("$1,880.00")
    end

    it 'can show the discounted revenue' do
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

      visit merchant_invoice_path(@merchant8.id, @invoice100.id)

      expect(page).to have_link("Bulk Discount Applied to this Invoice Item")

      visit merchant_invoice_path(@merchant8.id, @invoice103.id)

      expect(page).to_not have_link("Bulk Discount Applied to this Invoice Item")
    end
  end

  describe 'forms' do
    it 'can select a new status, submit form, and see the updated status' do
      visit merchant_invoice_path(@merchant1.id, @invoice1.id)

      within("#item-#{@item1.id}") do
        expect(@invoice_item1.status).to_not eq('pending')

        page.select 'pending', from: 'invoice_item[status]'
        click_button 'Update Item Status'
      end

      expect(current_path).to eq(merchant_invoice_path(@merchant1.id, @invoice1.id))

      within("#item-#{@item1.id}") do
        updated_invoice_item = InvoiceItem.find(@invoice_item1.id)

        expect(updated_invoice_item.status).to eq('pending')

        expect(page).to have_select('invoice_item[status]', selected: 'pending')
      end
    end
  end
end


