class Tamanho < ApplicationRecord
  belongs_to :contratante
  has_many :produtos

  validates :tam_nome, :contratante_id, presence: true
  
  # Converte para maiúsculo antes de salvar
  before_save :upcase_tam_nome
  
  # Validação de unicidade (case insensitive)
  validates :tam_nome, uniqueness: { 
    scope: :contratante_id, 
    case_sensitive: false,
    message: "já existe"
  }

  private

  def upcase_tam_nome
    self.tam_nome = tam_nome.upcase.strip if tam_nome.present?
  end
end