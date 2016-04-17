class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password    
  validates :password, length: { minimum: 6 }
  
  #Returns the hash digest of the given string
  def User.digest(string)
    cost = BCrypt::Engine::MIN_COST
    BCrypt::Password.create(string, cost: cost)
  end     
  #forgets an user
  def forget
    update_attribute(:remember_digest, nil)
  end
  #Returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end  
  #Remembers the user in the database for use in a persistent session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end                                             
  #Returns true if the given token matches with remember_digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
