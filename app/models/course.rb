class Course < ActiveRecord::Base
  has_many :lesson, dependent: :destroy
  validates :name, presence: true, length: { maximum: 127 }, uniqueness: { case_sensitive: false }
end
