class LabelConfig < ApplicationRecord
  has_one_attached :logo

  validates :name, presence: true
  validates :color, presence: true

  before_create :set_default_if_first

  private

  def set_default_if_first
    self.is_default = true if LabelConfig.count.zero?
  end
end
