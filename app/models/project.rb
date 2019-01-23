class Project < ApplicationRecord
  has_many :chatrooms, dependent: :destroy
end