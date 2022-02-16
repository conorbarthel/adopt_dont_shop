class Application < ApplicationRecord
  validates :name, presence:true
  validates :street_address, presence:true
  validates :city, presence:true
  validates :state, presence:true
  validates :zipcode, presence:true

  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def self.find_pet_apps_with_id(app_id)
    joins(:pet_applications).where("application_id = #{app_id}")
  end
end
