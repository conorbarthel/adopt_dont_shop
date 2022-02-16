require 'rails_helper'

RSpec.describe 'the admin applications show' do
  before(:each) do
    # Pet.destroy_all
    # Shelter.destroy_all
    # Application.destroy_all
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pirate = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @claw = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @bald = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @application = Application.create!(name: 'Mike',
                                      street_address: "123 Blake st.",
                                      city: "Denver",
                                      state: "CO",
                                      zipcode: "80211",
                                      status:'Pending')
    @application_2 = Application.create!(name: 'Dani',
                                      street_address: "123 Iris st.",
                                      city: "Arvada",
                                      state: "CO",
                                      zipcode: "80200",
                                      status:'Pending')
    @pet_application = PetApplication.create(application_id: @application.id, pet_id: @shelter_1.pets.first.id)
    @pet_application_2 = PetApplication.create(application_id: @application.id, pet_id: @shelter_1.pets.last.id)
    @pet_application_3 = PetApplication.create(application_id: @application_2.id, pet_id: @shelter_1.pets.last.id)
  end

  it "Has a title and displays application status" do
    visit "/admin/applications/#{@application.id}"

    within '#header' do
      expect(page).to have_content("Admin Applications")
      expect(page).to have_content("#{@application.status}")
    end
  end

  it "for every pet that has an application there is a button to approve the application for that pet" do
    visit "/admin/applications/#{@application.id}"

    expect(page).to have_content("#{@pirate.name}")
    expect(page).to have_content("#{@claw.name}")
    expect(page).to_not have_content("#{@bald.name}")

    click_on "Approve Mr. Pirate Application"
  end

  it "when the button is pressed visitor is redirected to show page" do
    visit "/admin/applications/#{@application.id}"
    click_on "Approve Mr. Pirate Application"
    expect(current_path).to eq("/admin/applications/#{@application.id}")
  end

  it "next to the approved pet is an indicator that they have been approved" do
    visit "/admin/applications/#{@application.id}"
    #save_and_open_page
    click_on "Approve Mr. Pirate Application"

    expect(page).to have_content("#{@pirate.name} Approved")
    expect(page).to_not have_content("Approve #{@pirate.name} Application")
  end

  it "approving or rejecting a pet on one application doesn't change the other" do
    visit "/admin/applications/#{@application.id}"
    click_on "Approve Clawdia"
    visit "/admin/applications/#{@application_2.id}"
    click_on "Approve Clawdia"
  end

  it "application is approved if all pets on the application are approved" do
    visit "/admin/applications/#{@application.id}"
    click_on "Approve Mr. Pirate Application"
    click_on "Approve Clawdia Application"
    #save_and_open_page
    within '#header' do
      expect(page).to have_content("Approved")
    end
  end

  it "application is rejected if any pet on the application is rejected" do
    visit "/admin/applications/#{@application.id}"
    click_on "Approve Mr. Pirate Application"
    expect(current_path).to eq("/admin/applications/#{@application.id}")
    click_on "Reject Clawdia Application"
    expect(current_path).to eq("/admin/applications/#{@application.id}")
    #save_and_open_page
    within '#header' do
      expect(page).to have_content("Rejected")
    end
  end

  it "If application is approved pets are no longer adoptable" do
    visit "/admin/applications/#{@application.id}"
    click_on "Approve Mr. Pirate Application"
    click_on "Approve Clawdia Application"
    visit "/pets/#{@claw.id}"
    #save_and_open_page
    expect(page).to have_content("false")
    expect(page).to_not have_content("true")
  end

  it "does not have buttons to approve or reject adopted pets on other applications" do
    visit "/admin/applications/#{@application.id}"
    click_on "Approve Mr. Pirate Application"
    click_on "Approve Clawdia Application"
    visit "/admin/applications/#{@application_2.id}"
    save_and_open_page
    expect(page).to have_content(@claw.name)
    expect(page).to_not have_content( "Approve Clawdia Application")
  end
end
