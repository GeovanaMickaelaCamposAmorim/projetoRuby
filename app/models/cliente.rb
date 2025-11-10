class Cliente < ApplicationRecord
  belongs_to :contratante

  validates :cli_nome, :cli_cpf, :cli_data_nasc, :cli_endereco, :cli_telefone1, 
            :contratante_id, presence: true
  validates :cli_cpf, uniqueness: true
  validates :status, inclusion: { in: ['ativo', 'inativo'] }
  validate :data_nascimento_valida

  def status_display
    status == 'ativo' ? 'Ativo' : 'Inativo'
  end
  
  def status_class
    status == 'ativo' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
  end

  private

  def data_nascimento_valida
    return unless cli_data_nasc.present?
    
    if cli_data_nasc > Date.current
      errors.add(:cli_data_nasc, "Data de nascimento não pode ser uma data futura")
    elsif cli_data_nasc < Date.current - 120.years
      errors.add(:cli_data_nasc, "Data de nascimento não pode ser há mais de 120 anos")
    end
  end
end