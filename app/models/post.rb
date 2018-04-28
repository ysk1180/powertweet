class Post < ApplicationRecord
  validates :content, presence: true
  validates :content, length: { maximum: 100 }
  validates :power, presence: true
  validates :power, length: { maximum: 100 }

  belongs_to :user
end
