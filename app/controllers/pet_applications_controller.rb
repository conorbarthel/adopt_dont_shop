class PetApplicationsController < ApplicationController
  def create
    application = Application.find(params[:id])
    pet = Pet.find(params[:pet_id])
    PetApplication.create(application_id: application.id, pet_id: pet.id)
    redirect_to "/applications/#{application.id}"
  end

end
