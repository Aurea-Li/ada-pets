class PetsController < ApplicationController
  def index
    pets = Pet.all
    render json: jsonify(pets)
  end

  def show
    pet = Pet.find_by(id: params[:id])

    if pet
      render json: jsonify(pet)
    else
      render_error(:not_found, {
        pet_id: ["Pet not found"]
        }
      )
    end
  end

  def create
  pet = Pet.new(pet_params)

    if pet.save
      render json: {id: pet.id }
    else
      render_error(:bad_request, pet.errors.messages)
    end
  end

  private

    def pet_params
      params.require(:pet).permit(:name, :age, :human)
    end

    def jsonify(pet_data)
      return pet_data.as_json(only: [:id, :name, :age, :human])
    end
end
