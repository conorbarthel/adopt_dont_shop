class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def self.find_pet_apps_with_id(app_id)
    joins(:application).where("application_id = #{app_id}")
  end
end
