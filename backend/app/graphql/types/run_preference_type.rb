module Types
  class RunPreferenceType < Types::BaseObject
    field :city, String, null: false
    field :duration, Integer, null: false
    field :skin_type, String, null: false
  end
end