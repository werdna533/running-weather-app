module Types
  class UserType < Types::BaseObject
    field :uuid, ID, null: false
    field :run_preferences, [Types::RunPreferenceType], null: true

    # Convenience method for returning the latest preference
    field :latest_run_preference, Types::RunPreferenceType, null: true

    def latest_run_preference
      object.run_preferences.order(created_at: :desc).first
    end
  end
end
