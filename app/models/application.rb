class Application < ApplicationRecord
  validates :name, presence:true
  validates :street_address, presence:true
  validates :city, presence:true
  validates :state, presence:true
  validates :zipcode, presence:true

  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def update_pets_status
    pets.each do |pet|
      pet.update!(adoptable: false)
    end
  end
end
