Pet.destroy.all
Shelter.destroy.all
Application.destroy.all

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
