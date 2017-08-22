require 'bcrypt'

class User < Sequel::Model(:users)
  def_column_accessor :username
  def_column_accessor :email

  def password=(password)
    self.password_digest = generate_password_digest(password)
  end

  def generate_password_digest(password)
    BCrypt::Password.create(password, cost: 12)
  end

  def valid_password?(password)
    BCrypt::Password.new(password_digest) == password
  end

  def self.authenticate(username, password)
    user = User[username: username]
    user && user.valid_password?(password)
  end
end
