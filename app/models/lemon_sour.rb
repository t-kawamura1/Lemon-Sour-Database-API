class LemonSour < ApplicationRecord
  mount_uploader :sour_image, SourImageUploader
  validates :name, presence: true

  def self.initial_display?
    @lemon_sours == LemonSour.order(updated_at: :desc)
  end
end
