# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject

    field :save_user_preferences, mutation: Mutations::SaveUserPreferences

  end
end
