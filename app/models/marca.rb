class Marca < ApplicationRecord
  belongs_to :contratante
  has_many :produtos, dependent: :restrict_with_error
  
  validates :nome, presence: true
  
  # Converte para maiúsculo antes de salvar
  before_save :upcase_nome
  
  # Validação de unicidade (case insensitive)
  validates :nome, uniqueness: { 
    scope: :contratante_id, 
    case_sensitive: false,
    message: "já existe"
  }

  # Para compatibilidade se quiser manter ambos
  alias_attribute :mar_nome, :nome

  private

  def upcase_nome
    self.nome = nome.upcase.strip if nome.present?
  end
end