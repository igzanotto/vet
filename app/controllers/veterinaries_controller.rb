class VeterinariesController < ApplicationController
  def index
    @pet = Pet.find(params[:pet_id])
    if params[:query].present? # si la query esta presente
      if User.search_by_location(params[:query]).size.positive? # Si la query encuentra algo
        @veterinaries = User.where(type_of_user: "Veterinary")
        @vet_filtered = @veterinaries.search_by_location(params[:query])
          # GEOCODING
          @markers = @vet_filtered.geocoded.map do |vet|
            {
              lat: vet.latitude,
              lng: vet.longitude,
              image_url: helpers.asset_url("paw-solid.png"),
              info_window: render_to_string(partial: "info_window", locals: {vet: vet})
            }
          end
      else
        "No results found" # Si no encuentra resultados
      end
    else
      @vet_filtered = User.where(type_of_user: "Veterinary") # Si no buscamos nada que traiga todas

        # GEOCODING
        @markers = @vet_filtered.geocoded.map do |vet|
          {
            lat: vet.latitude,
            lng: vet.longitude,
            image_url: helpers.asset_url("paw-solid.png"),
            info_window: render_to_string(partial: "info_window", locals: {vet: vet})
          }
        end
    end

    # STIMULUS FOR SEARCH
    respond_to do |format|
      format.html
      format.text { render partial: "veterinaries/card", locals: { veterinaries: @veterinaries }, formats: [:html] }
    end
  end

  def vet_profile
    @veterinary = current_user
    @reviews = Review.where(user: @veterinary).last(10)
    @reviews_filtered = Review.where(user: @veterinary).average(:rating)
    @average = @reviews_filtered.to_i

    @appointment = Appointment.new
    @review = Review.new

    # CALENDAR

    start_date = params.fetch(:start_time, Date.today).to_date

    # For a monthly view:
    @appointments = Appointment.where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week, user: @veterinary)
  end

  def show
    @pet = Pet.find(params[:pet_id])
    @veterinary = User.find(params[:id])

    @reviews = Review.where(user: @veterinary).last(3)
    @reviews_filtered = Review.where(user: @veterinary).average(:rating)
    @average = @reviews_filtered.to_i

    @appointment = Appointment.new
    @review = Review.new



    # CALENDAR

    start_date = params.fetch(:start_time, Date.today).to_date

    # For a monthly view:
    @appointments = Appointment.where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week, user: @veterinary)
  end
end
