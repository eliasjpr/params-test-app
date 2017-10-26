require "granite_orm/adapter/pg"
require "crypto/bcrypt/password"

class User < Granite::ORM::Base
  adapter pg
  has_many :posts
  before_save :encrypt_password

  property password : String?

  validate :email, "is required", ->(user : User) do
    (user.email != nil) && (!user.email.not_nil!.empty?)
  end

  validate :password, "is to short", ->(user : User) do
    (user.password != nil) && (user.password.not_nil!.size >= 8)
  end

  primary id : Int64
  field email : String
  field encrypted_password : String
  timestamps

  def encrypt_password
    @encrypted_password = Crypto::Bcrypt::Password.create(@password.not_nil!, cost: 10).to_s
  end

  def authenticate(password : String)
    if enc = @encrypted_password
      bcrypt_password = Crypto::Bcrypt::Password.new(enc)
      return bcrypt_password == password
    else
      return false
    end
  end
end
