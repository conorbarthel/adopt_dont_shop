PetApplication.destroy_all
Pet.destroy_all
Shelter.destroy_all
Application.destroy_all
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
