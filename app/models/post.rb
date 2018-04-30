class Post < ApplicationRecord
  validates :content, presence: true
  validates :content, length: { maximum: 120 }
  validates :power, presence: true
  validates :power, length: { maximum: 90 }

  belongs_to :user
end
