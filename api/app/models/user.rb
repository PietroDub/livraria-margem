require 'uri'

class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true, length: { minimum: 15 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_digest, presence: true, length: { minimum: 8 }
end
