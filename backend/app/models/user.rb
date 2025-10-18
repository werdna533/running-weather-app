class User < ApplicationRecord
    has_many :run_preferences, dependent: :destroy
end
