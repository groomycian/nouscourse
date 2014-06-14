class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 64 }
  validates :email, presence: true, length: { maximum: 128 }, format: {with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password

  before_save { email.downcase! }
  before_create :create_remember_token

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end

  def generate_md5_hash
    Digest::MD5.hexdigest(SecureRandom.urlsafe_base64.to_s)
  end
end