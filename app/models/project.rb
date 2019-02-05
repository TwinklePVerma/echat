class Project < ApplicationRecord
  validates_presence_of :name, :public_key, :secret_key

  has_many :chatrooms, dependent: :destroy

  scope :find_project, ->(id) { find_by(public_key: id) }
end
