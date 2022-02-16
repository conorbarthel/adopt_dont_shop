require 'rails_helper'

RSpec.describe 'the applications new page' do
  it "creates a new form with all fields filled out" do
    visit '/pets'
    click_on 'Start an Application'
    expect(current_path).to eq("/applications/new")
    fill_in("Name", with:"Caitlin")
    fill_in("Street address", with:"4562 Alcott St")
    fill_in("City", with:"Denver")
    fill_in("State", with:"CO")
    fill_in("Zipcode", with:"80212")
    fill_in("Why you would be a good owner", with:"I just would")
    click_on 'Submit'
    
    expect(page).to have_content("Caitlin")
    expect(page).to have_content("In Progress")
  end

  it "displays an error message when all fields are not filled" do
    visit '/applications/new'
    fill_in("Name", with:"Caitlin")
    fill_in("Street address", with:"4562 Alcott St")
    fill_in("City", with:"Denver")
    click_on 'Submit'
    #save_and_open_page

    expect(page).to have_content("All fields must be filled in")
  end
end
