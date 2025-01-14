class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.order_by_shelter_name
    #order("name desc")
    find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
  end

  def self.name_and_city(id)
    #find_by_sql("SELECT name, city FROM shelters WHERE id = #{id}")
    find_by_sql("SELECT * FROM shelters WHERE id = #{id}")
  end

  def self.find_pending_applications
    joins(pets: :applications).where(applications: {:status => "Pending"}).order(:name)
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def adoptable_pets_count
    pets.where(adoptable: true).count
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def average_pet_age
    pets.average(:age)
  end
end
