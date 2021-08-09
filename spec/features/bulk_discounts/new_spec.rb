require 'rails_helper'
RSpec.describe 'it can go to a new form and make a new bulk discount' do
  before :each do
    visit "/merchants/#{@merchant1.id}/bulk_discounts/new"
  end
  it 'can click a link on the admin merchant index page and be taken to new form' do
    visit "/merchants/#{@merchant1.id}/bulk_discounts"
    
    click_link("Create a new bulk discount")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
  end

  it 'can fill and create a new merchant thorugh the admin merchant path' do

    fill_in("Percentage Discount", with: 0.50)
    fill_in("Quantity Threshold", with: 75)

    click_button("Create Bulk Discount")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")
    bulk_discount = BulkDiscount.last

    within "#associated-bulk-discounts-#{@merchant1.id}" do
      within "#associated-bulk-discount-#{bulk_discount.id}" do
        expect(page).to have_content("Percentage Discount #{bulk_discount.percentage_discount * 100}%")
        expect(page).to have_content("threshold of #{bulk_discount.quantity_threshold}")
        expect(page).to_not have_content("Percentage Discount #{@bulk_discount3.percentage_discount * 100}%")
        expect(page).to_not have_content("threshold of #{@bulk_discount3.quantity_threshold}")
        expect(page).to_not have_content("Percentage Discount #{@bulk_discount5.percentage_discount * 100}%")
        expect(page).to_not have_content("threshold of #{@bulk_discount5.quantity_threshold}")
      end
    end
      
  end

  it 'does not fill out a name and redirects to the new form and gives a flash message' do
    fill_in("Percentage Discount", with: "")
    fill_in("Quantity Threshold", with: "Hello")

    click_button("Create Bulk Discount")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
    expect(page).to have_content("Error: Percentage discount can't be blank, Percentage discount is not a number\nPercentage Discount\nQuantity Threshold")
  end
end