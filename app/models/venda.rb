# app/models/venda.rb
class Venda < ApplicationRecord
  belongs_to :user
  belongs_to :cliente, optional: true
  belongs_to :contratante
  has_many :venda_items, dependent: :destroy  


  validates :ven_valor_total, :ven_valor_final, :user_id, :contratante_id, presence: true
end