class LemonSour < ApplicationRecord
  mount_uploader :sour_image, SourImageUploader
  validates :name, presence: true
end
