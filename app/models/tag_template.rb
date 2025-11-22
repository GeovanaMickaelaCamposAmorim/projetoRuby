class TagTemplate < ApplicationRecord
  belongs_to :label_config, optional: true

  has_one_attached :logo

  validates :name, presence: true
  validates :color, presence: true
end
