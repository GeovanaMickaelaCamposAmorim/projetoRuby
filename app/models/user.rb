class User < ApplicationRecord
  has_secure_password
  enum :role, { admin: "admin", vendedor: "vendedor" }

  has_many :user_sessions, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :role, presence: true
end

# admin@tags.com
# vendedor@tags.com
