class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, length: { minimum: 15 }
  validates :password, presence: true 
  validates :password_digest, presence: true, length: { minimum: 8 }
end