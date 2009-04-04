require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessor :password
  before_save :encrypt_password
  attr_accessible :login, :password, :email, :password_confirmation, :guest
  
  validates_presence_of :password, :password_confirmation, :on => :create
  validates_presence_of :password_confirmation, :if => :password_hash_changed?
  validates_confirmation_of :password, :on => :create
  validates_length_of :password, :within => 5..32, :on => :create
  # Login using name and password
  def self.authenticate(login, password)
    user = find_by_login(login) # need to get salt
    if(user and user.authenticated?(password))
      user
    else
      nil
    end
  end
  
  # Checks whether the user has the correct password
  def authenticated?(password)
    password_hash == encrypt(password)
  end
  
  # Encrypts data using instance salt.
  def encrypt(data)
    self.class.encrypt(data, salt)
  end
  
  # Encrypts data using a given salt.
  # Uses SHA256 for encryption.
  def self.encrypt(data, salt)
    Digest::SHA256.hexdigest("--#{salt}--#{data}--")
  end
  
  protected
  # Encrypts password and generates salt.
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA256.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.password_hash = encrypt(password)
  end
end