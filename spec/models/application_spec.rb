require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it {should have_many(:pet_applications)}
    it {should have_many(:pets).through(:pet_applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zipcode) }
  end

  describe 'instance methods' do
    before(:each) do
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @pirate = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      @claw = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @application = Application.create!(name: 'Mike',
        street_address: "123 Blake st.",
        city: "Denver",
        state: "CO",
        zipcode: "80211",
        status:'Pending')
      @pet_application = PetApplication.create(application_id: @application.id, pet_id: @shelter_1.pets.first.id)
      @pet_application_2 = PetApplication.create(application_id: @application.id, pet_id: @shelter_1.pets.last.id)
    end
    describe '.update_pets_status' do
      it "updates adoption status" do
        expect(@application.pets.first.adoptable).to eq(true)
        expect(@application.pets.last.adoptable).to eq(true)
        @application.update_pets_status
        expect(@application.pets.first.adoptable).to eq(false)
        expect(@application.pets.last.adoptable).to eq(false)
      end
    end
  end
end
