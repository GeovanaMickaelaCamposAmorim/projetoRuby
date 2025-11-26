class Cliente < ApplicationRecord
  belongs_to :contratante
  has_one :ficha_crediario, dependent: :destroy

  validates :cli_nome, :cli_cpf, :cli_data_nasc, :cli_endereco, :cli_telefone1,
            :contratante_id, presence: true
  validates :cli_cpf, uniqueness: true
  validates :status, inclusion: { in: [ "ativo", "inativo" ] }
  validate :data_nascimento_valida

  after_create :criar_ficha_crediario_inicial

  def status_display
    status == "ativo" ? "Ativo" : "Inativo"
  end

  def status_class
    status == "ativo" ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"
  end

  def data_nascimento_valida
    if cli_data_nasc.present? && cli_data_nasc > Date.today
      errors.add(:cli_data_nasc, "não pode ser no futuro")
    elsif cli_data_nasc.present? && cli_data_nasc < 150.years.ago
      errors.add(:cli_data_nasc, "não pode ser há mais de 150 anos")
    end
  end 

  def criar_ficha_crediario_inicial
    build_ficha_crediario(
      contratante_id: contratante_id,
      fic_valor_total: 0,
      fic_status: "concluida" # ficha zerada = concluída
    ).save!
  end
end