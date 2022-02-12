require 'rails_helper'

RSpec.describe 'Application show page' do
  before(:each) do
    @application = Application.create!(name: 'Mike',
                                      street_address: "123 Blake st.",
                                      city: "Denver",
                                      state: "CO",
                                      zipcode: "80211",
                                      description: 'I work from home',
                                      pet_names: 'Rufus',
                                      status:'In Progress')
    @spca = Shelter.create!(name: "SPCA", rank:2, city: "Santa Cruz")
    @sadie = @spca.pets.create!(name: "Sadie", age:2)
    @maggie = @spca.pets.create!(name: "Maggie", age:1)
    @tucker = @spca.pets.create!(name: "Tucker", age:1)

  end

  it "should display application's attributes" do
    visit "applications/#{@application.id}"

    expect(page).to have_content("Mike")
    expect(page).to have_content("23 Blake st., Denver, CO, 80211")
    expect(page).to have_content("I work from home")
    expect(page).to have_content("Rufus")
    expect(page).to have_content("In Progress")
  end

  it "should have a search bar that will shows pets that match the search" do
    visit "applications/#{@application.id}"
    expect(page).to have_content("Add a Pet to this Application")
    fill_in("Search Pets by Name", with:"ie")
    click_on "Search"
    #save_and_open_page
    expect(page).to have_content("Sadie")
    expect(page).to have_content("Maggie")
  end

  it "should have a button next to each pet to add them to the application" do
    visit "applications/#{@application.id}"
    fill_in("Search Pets by Name", with:"Sadie")
    click_on "Search"
    click_on "Adopt this Pet"
    save_and_open_page
    expect(current_path).to eq("/applications/#{@application.id}")
    expect(page).to have_content("Sadie")
    expect(page).to_not have_content("Adopt this Pet")
  end
end
