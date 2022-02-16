class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    if params[:search]
      @results = Pet.search(params[:search])
    else
      @results = []
    end
    if params[:reason]
      @application[:description] = params[:reason]
      @application[:status] = "Pending"
      @application.save
    end
  end

  def admin_show
    @application = Application.find(params[:id])
    @pet_applications = @application.pet_applications
    # @pet_application = PetApplication.find_by(application_id: @application.id, pet_id: pet.id)
    # if @pet_application.status == nil
    #   @pet_application.update(status: "Pending")
    # end
  end

  def update
    pet = Pet.find(params[:pet_id])
    application = Application.find(params[:id])
    @pet_application = PetApplication.find_by(pet_id: pet.id, application_id: application.id)
    @pet_application.update(status: params[:status])
    redirect_to("/admin/applications/#{application.id}")
  end

  def new
  end

  def create
    new_application = Application.create(application_params)
    if new_application.id == nil
      flash[:alert] = "All fields must be filled in"
      redirect_to '/applications/new'
    else
      new_application[:status] = "In Progress"
      new_application.save
      redirect_to "/applications/#{new_application.id}"
    end
  end

  private
    def application_params
      params.permit(
                    :name,
                    :street_address,
                    :city,
                    :state,
                    :zipcode,
                    :description,
                    :pet_names,
                    :status)
    end

end
