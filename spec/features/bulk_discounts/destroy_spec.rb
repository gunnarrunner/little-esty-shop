require 'rails_helper'
RSpec.describe 'Can destroy the bulk discount and delete them from the table' do
  before :each do    
    visit "/merchants/#{@merchant1.id}/bulk_discounts"
  end

  it 'can delete an artist from the show page' do

    within "#associated-bulk-discounts-#{@merchant1.id}" do
      within "#associated-bulk-discount-#{@bulk_discount2.id}" do
        click_on("Delete Bulk Discount")
      end
    end

    expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")

    within "#associated-bulk-discounts-#{@merchant1.id}" do
      expect(page).to have_content("Percentage Discount #{@bulk_discount1.percentage_discount * 100}%")
      expect(page).to have_content("threshold of #{@bulk_discount1.quantity_threshold}")

      expect(page).to_not have_content("Percentage Discount #{@bulk_discount2.percentage_discount * 100}%")
      expect(page).to_not have_content("threshold of #{@bulk_discount2.quantity_threshold}")
    end
  end
end