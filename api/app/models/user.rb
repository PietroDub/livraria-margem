class User < ApplicationRecord
    validates :name, presence: true, length: { minimun: 3}
    validates :email, presence: true, length: { minimun: 15}
    validates :password, presence: true, length: {minimun: 8}
end