require 'rails_helper'
RSpec.describe 'it shows the desciription of a bulk discounts show page along with its attributes' do
  before :each do  
    visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}"
  end

  it 'can show the attributes for a specific bulk discount' do
    expect(page).to have_content("#{@bulk_discount1.percentage_discount}")
    expect(page).to have_content("#{@bulk_discount1.quantity_threshold}")
  end
end