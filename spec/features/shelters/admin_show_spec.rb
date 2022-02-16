require 'rails_helper'

RSpec.describe 'the admin shelters index' do
  before(:each) do
    PetApplication.destroy_all
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
  end

  it "shows shelters name and city" do
    visit "/admin/shelters/#{@shelter_1.id}"

    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_1.city)
  end
end
