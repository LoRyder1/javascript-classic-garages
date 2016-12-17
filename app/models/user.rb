require "net/http"
require "uri"

class User < ActiveRecord::Base
  has_secure_password
  has_many :garages

  # attr_reader :entered_password

  enum authy_status: [:unverified, :onetouch, :sms, :token, :approved, :denied]
  validates :email,  presence: true, format: { with: /\A.+@.+$\Z/ }, uniqueness: true
  # validates :name, presence: true
  validates :country_code, presence: true
  validates :phone_number, presence: true

  # def password
  #   @password ||= BCrypt::Password.new(password_hash)
  # end

  # def password=(new_password)
  #   @entered_password = new_password
  #   @password = BCrypt::Password.create(new_password)
  #   self.password_hash = @password
  # end

  # def self.authenticate(email, password)
  #   user = User.find_by_email(email)
  #   return user if user && (user.password == password)
  #   nil
  # end
end
