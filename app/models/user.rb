class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  #Activates an account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  #Sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  #Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  
  #Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end  
  
  #Returns true if password reset link expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end        
  private
    # Converts email to all lower case
    def downcase_email
      self.email = email.downcase
    end
    
    #Creates and assign the activation digest to the new user
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end  
        
end
