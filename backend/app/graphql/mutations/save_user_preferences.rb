module Mutations
  class SaveUserPreferences < BaseMutation
    argument :user_uuid, ID, required: true
    argument :city, String, required: true
    argument :duration, Integer, required: true
    argument :skin_type, String, required: true

    field :user, Types::UserType, null: false

    def resolve(user_uuid:, city:, duration:, skin_type:)
      user = User.find_or_create_by(uuid: user_uuid)
      pref = user.run_preferences.create!(
        city: city,
        duration: duration,
        skin_type: skin_type
      )

      { user: user }
    end
  end
end