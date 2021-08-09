require 'rails_helper'
RSpec.describe 'Update an existing bulk discount on their show page' do
  before :each do
    visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount4.id}/edit"
  end

  it 'can click on a button and be taken to a edit form path with information pre-populated' do
    visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount4.id}"
    
    click_button("Edit this Bulk Discount")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount4.id}/edit")

    expect(page).to have_field("Percentage Discount", with: '0.35')
    expect(page).to have_field("Quantity Threshold", with: '40')
  end

  it 'edit a bulk discount and redirect to its show page' do
    
    fill_in("Percentage Discount", with: 0.05)
    fill_in("Quantity Threshold", with: 10)

    old_percentage = 0.35
    old_quantity = 40
    new_percentage = 0.05
    new_quantity = 10


    click_button('Update Bulk Discount')

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount4.id}")
    expect(page).to have_content(new_percentage)
    expect(page).to have_content(new_quantity)
    expect(page).to_not have_content(old_percentage)
    expect(page).to_not have_content(old_quantity)
  end

  it 'edit a bulk discount and has a flash error for not filling in a spot' do

    fill_in("Percentage Discount", with: "")
    fill_in("Quantity Threshold", with: 10)

    click_button('Update Bulk Discount')

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount4.id}/edit")
    expect(page).to have_content("Error: Percentage discount can't be blank, Percentage discount is not a number\nPercentage Discount\nQuantity Threshold")
  end
end