class Video < ApplicationRecord
  validates :name, presence: true
  has_one_attached :file
end
