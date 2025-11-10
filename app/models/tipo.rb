class Tipo < ApplicationRecord
  belongs_to :contratante
  has_many :produtos

  validates :tip_nome, :contratante_id, presence: true
  
  # Converte para maiúsculo antes de salvar
  before_save :upcase_fields
  
  # Validações de unicidade (case insensitive)
  validates :tip_nome, uniqueness: { 
    scope: :contratante_id, 
    case_sensitive: false,
    message: "já existe"
  }
  
  validates :tip_sigla, uniqueness: { 
    scope: :contratante_id, 
    case_sensitive: false,
    message: "já existe"
  }, allow_blank: true

  private

  def upcase_fields
    self.tip_nome = tip_nome.upcase.strip if tip_nome.present?
    self.tip_sigla = tip_sigla.upcase.strip if tip_sigla.present?
  end
end