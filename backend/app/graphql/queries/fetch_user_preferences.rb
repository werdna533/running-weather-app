module Queries
  class FetchUserPreferences < GraphQL::Schema::Resolver
    argument :userId, ID, required: true
    type Types::UserType, null: true

    def resolve(userId:)
      ::User.find_by(uuid: userId)
    end
  end
end
