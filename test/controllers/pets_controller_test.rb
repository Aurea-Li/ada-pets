require 'test_helper'

describe PetsController do
  PET_FIELDS = %w(id age name human).sort

  def parse_body(expected_type:, expected_status: :success)
    must_respond_with expected_status

    expect(response.header['Content-Type']).must_include 'json'
    body = JSON.parse(response.body)

    expect(body).must_be_kind_of expected_type
    return body
  end

  describe "index" do

    it "is a real working route" do
      get pets_path
      must_respond_with :success

      body = parse_body(expected_type: Array)
      expect(body.length).must_equal Pet.count

      body.each do |pet|
        expect(pet.keys.sort).must_equal PET_FIELDS
      end
    end

    it "returns an empty array when there are no pets" do

      Pet.destroy_all

      get pets_path

      body = parse_body(expected_type: Array)
      expect(body).must_equal []

    end
  end

  describe "show" do
    let (:pet) {
      pets(:one)
    }

    it "returns the pet with valid id" do

      get pet_path(pet.id)

      body = parse_body(expected_type: Hash)

      expect(body["id"]).must_equal pet.id
    end

    it "returns error array and not found status for invalid id" do

      pet.destroy

      get pet_path(pet.id)

      body = parse_body(expected_type: Hash, expected_status: :not_found)

      expect(body["errors"]["pet_id"]).must_equal ["Pet not found"]
    end


  end

  describe "create" do
    let (:pet_data) {
      {
        pet: {
          name: "Bob",
          age: 2,
          human: "Aurea"
        }
      }
    }

    it "adds pet for valid pet data" do

      expect{
        post pets_path, params: pet_data
      }.must_change('Pet.count', +1)

      body = parse_body(expected_type: Hash)

      expect(Pet.last.name).must_equal pet_data[:pet][:name]

    end

    it "returns error if invalid pet" do

      pet_data[:pet][:name] = nil

      expect{
        post pets_path, params: pet_data
      }.wont_change('Pet.count')

      body = parse_body(expected_type: Hash, expected_status: :bad_request)

      expect(body).must_include "errors"
    end
  end
end









































#   it "returns json" do
#     get pets_path
#     expect(response.header['Content-Type']).must_include 'json'
#   end

#   it "returns an Array" do
#     get pets_path

#     body = JSON.parse(response.body)
#     body.must_be_kind_of Array
#   end

#   it "returns all of the pets" do
#     get pets_path

#     body = JSON.parse(response.body)
#     body.length.must_equal Pet.count
#   end

#   it "returns pets with exactly the required fields" do
#     keys = %w(age human id name)
#     get pets_path
#     body = JSON.parse(response.body)
#     body.each do |pet|
#       pet.keys.sort.must_equal keys
#     end
#   end
# end

# describe "show" do
#   # This bit is up to you!
#   it "can get a pet" do
#     get pet_path(pets(:two).id)
#     must_respond_with :success
#   end
# end

# describe "create" do
#   let(:pet_data) {
#     {
#       name: "Jack",
#       age: 7,
#       human: "Captain Barbossa"
#     }
#   }

#   it "creates a new pet given valid data" do
#     expect {
#     post pets_path, params: { pet: pet_data }
#   }.must_change "Pet.count", 1

#     body = JSON.parse(response.body)
#     expect(body).must_be_kind_of Hash
#     expect(body).must_include "id"

#     pet = Pet.find(body["id"].to_i)

#     expect(pet.name).must_equal pet_data[:name]
#     must_respond_with :success
#   end

#   it "returns an error for invalid pet data" do
#     # arrange
#     pet_data["name"] = nil

#     expect {
#     post pets_path, params: { pet: pet_data }
#   }.wont_change "Pet.count"

#     body = JSON.parse(response.body)

#     expect(body).must_be_kind_of Hash
#     expect(body).must_include "errors"
#     expect(body["errors"]).must_include "name"
#     must_respond_with :bad_request
#   end
