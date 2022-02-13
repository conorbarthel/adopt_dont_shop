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

  def update

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
