class Project < ApplicationRecord
  validates_presence_of :name, :public_key, :secret_key
  
  has_many :chatrooms, dependent: :destroy
end