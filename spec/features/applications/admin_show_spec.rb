require 'rails_helper'

RSpec.describe 'the admin applications show' do
  before(:each) do
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @application = Application.create!(name: 'Mike',
                                      street_address: "123 Blake st.",
                                      city: "Denver",
                                      state: "CO",
                                      zipcode: "80211",
                                      status:'Pending')
    @pet_application = PetApplication.create(application_id: @application.id, pet_id: @shelter_1.pets.first.id)
    @pet_application_2 = PetApplication.create(application_id: @application.id, pet_id: @shelter_1.pets.last.id)
  end

  it "for every pet that has an application there is a button to approve the application for that pet" do
    visit "/admin/applications/#{@application.id}"

    expect(page).to have_content("Mr. Pirate")
    expect(page).to have_content("Clawdia")
    expect(page).to_not have_content("Lucille Bald")

    click_on "Approve Mr. Pirate Application"
  end

  it "when the button is pressed visitor is redirected to show page" do
    visit "/admin/applications/#{@application.id}"
    click_on "Approve Mr. Pirate Application"
    expect(current_path).to eq("/admin/applications/#{@application.id}")
  end

  it "next to the approved pet is an indicator that they have been approved" do
    visit "/admin/applications/#{@application.id}"
    click_on "Approve Mr. Pirate Application"
    expect(page).to have_content("Mr Pirate has been approved")
    expect(page).to_not have_content("Approve Mr. Pirate Application")
  end
end
