class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 1040}
  validate :picture_size
  
  private
    #Validates picture size to be uploaded
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "Size should be less than 5MB")
      end
    end
end
