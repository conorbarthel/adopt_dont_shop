require 'rails_helper'

RSpec.describe 'the shelters pets index' do
  before(:each) do
    PetApplication.destroy_all
    Pet.destroy_all
    Shelter.destroy_all
    Application.destroy_all
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'Boulder shelter', city: 'Boulder, CO', foster_program: false, rank: 9)
    @bare_y = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @shelter.id)
    @lobster = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter.id)
    @pet_3 = Pet.create(adoptable: true, age: 1, breed: 'domestic shorthair', name: 'Sylvester', shelter_id: @shelter_2.id)
    @pet_4 = Pet.create(adoptable: true, age: 1, breed: 'orange tabby shorthair', name: 'Lasagna', shelter_id: @shelter.id)
  end

  it 'lists all the pets associated with the shelter, with their attributes' do
    visit "/shelters/#{@shelter.id}/pets"

    expect(page).to have_content(@bare_y.name)
    expect(page).to have_content(@bare_y.breed)
    expect(page).to have_content(@bare_y.age)
    expect(page).to have_content(@shelter.name)

    expect(page).to have_content(@lobster.name)
    expect(page).to have_content(@lobster.breed)
    expect(page).to have_content(@lobster.age)
    expect(page).to have_content(@shelter.name)

    expect(page).to_not have_content(@pet_3.name)
    expect(page).to_not have_content(@pet_3.shelter_name)
  end

  it 'displays a link to create a new pet' do
    visit "/shelters/#{@shelter.id}/pets"

    expect(page).to have_link("Create a Pet")
    click_on("Create a Pet")
    expect(page).to have_current_path("/shelters/#{@shelter.id}/pets/new")
  end

  it 'displays a link to edit each pet' do
    visit "/shelters/#{@shelter.id}/pets"
    
    expect(page).to have_link("Edit #{@bare_y.name}")
    expect(page).to have_link("Edit #{@lobster.name}")

    click_link("Edit #{@bare_y.name}")

    expect(page).to have_current_path("/pets/#{@bare_y.id}/edit")
  end

  it 'displays a link to delete each pet' do
    visit "/shelters/#{@shelter.id}/pets"

    expect(page).to have_link("Delete #{@bare_y.name}")
    expect(page).to have_link("Delete #{@lobster.name}")

    click_link("Delete #{@bare_y.name}")

    expect(page).to have_current_path("/pets")
    expect(page).to_not have_content(@bare_y.name)
  end

  it 'displays a form for a number value' do
    visit "/shelters/#{@shelter.id}/pets"

    expect(page).to have_content("Only display pets with an age of at least...")
    expect(page).to have_select("age")
  end

  it 'only displays records above the given return value' do
    visit "/shelters/#{@shelter.id}/pets"

    find("#age option[value='3']").select_option
    click_button("Filter")
    expect(page).to have_content(@lobster.name)
    expect(page).to_not have_content(@bare_y.name)
    expect(page).to_not have_content(@pet_3.name)
  end

  it 'allows the user to sort in alphabetical order' do
    visit "/shelters/#{@shelter.id}/pets"

    expect(@bare_y.name).to appear_before(@lobster.name)
    expect(@lobster.name).to appear_before(@pet_4.name)

    expect(page).to have_link("Sort alphabetically")
    click_on("Sort alphabetically")

    expect(@bare_y.name).to appear_before(@pet_4.name)
    expect(@pet_4.name).to appear_before(@lobster.name)
  end
end
