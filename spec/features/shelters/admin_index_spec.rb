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

  it 'lists all the shelter names' do
    visit "/admin/shelters"

    expect(@shelter_2.name).to appear_before(@shelter_3.name)
    expect(@shelter_3.name).to appear_before(@shelter_1.name)
  end

  it "has a section that lists Pending Applications" do
    visit "/admin/shelters"

    within '#pending' do
      expect(page).to have_content("Shelter's with Pending Applications")
      expect(page).to have_content("#{@shelter_1.name}")
      expect(page).to_not have_content("#{@shelter_2.name}")
      expect(page).to_not have_content("#{@shelter_3.name}")
    end
  end

  it "lists applications in alphabetical order" do
    application_2 = Application.create!(name: 'Dani',
                                      street_address: "123 Iris st.",
                                      city: "Arvada",
                                      state: "CO",
                                      zipcode: "80200",
                                      status:'Pending')
    pet_application_2 = PetApplication.create(application_id: application_2.id, pet_id: @shelter_3.pets.first.id)
    visit "/admin/shelters"

    within '#pending' do
      expect(@shelter_1.name).to appear_before(@shelter_3.name)
    end
  end
end
