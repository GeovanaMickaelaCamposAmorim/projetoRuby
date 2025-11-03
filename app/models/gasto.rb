class Gasto < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :contratante

  # Aliases para compatibilidade
  alias_attribute :data, :gas_data
  alias_attribute :descricao, :gas_descricao  
  alias_attribute :valor, :gas_valor
  alias_attribute :data_cadastro, :gas_data_cadastro

  # Validations
  validates :gas_data, presence: true
  validates :gas_descricao, presence: true, length: { maximum: 255 }
  validates :gas_valor, presence: true, numericality: { greater_than: 0 }
  validates :user_id, presence: true
  validates :contratante_id, presence: true

  # Scopes para consultas comuns
  scope :por_data, ->(data) { where(gas_data: data.beginning_of_day..data.end_of_day) }
  scope :por_periodo, ->(inicio, fim) { where(gas_data: inicio.beginning_of_day..fim.end_of_day) }
  scope :do_contratante, ->(contratante_id) { where(contratante_id: contratante_id) }
  scope :do_usuario, ->(user_id) { where(user_id: user_id) }
  scope :ordenados_por_data, -> { order(gas_data: :desc) }
  scope :ordenados_por_valor, -> { order(gas_valor: :desc) }

  # Métodos de classe
  def self.total_no_periodo(inicio, fim, contratante_id = nil)
    query = por_periodo(inicio, fim)
    query = query.do_contratante(contratante_id) if contratante_id
    query.sum(:gas_valor)
  end

  def self.ultimos_gastos(limit = 10)
    ordenados_por_data.limit(limit)
  end

  def self.maiores_gastos(limit = 5)
    ordenados_por_valor.limit(limit)
  end

  def self.resumo_por_mes(contratante_id, meses: 6)
    (0..meses-1).map do |i|
      data = Date.today.beginning_of_month - i.months
      total = do_contratante(contratante_id)
               .por_periodo(data.beginning_of_month, data.end_of_month)
               .sum(:gas_valor)
      { mes: data.strftime('%b/%Y'), total: total }
    end.reverse
  end

  # Métodos de instância
  def data_formatada
    gas_data.strftime('%d/%m/%Y')
  end

  def data_hora_formatada
    gas_data.strftime('%d/%m/%Y %H:%M')
  end

  def valor_formatado
    "R$ #{'%.2f' % gas_valor}".gsub('.', ',')
  end

  def descricao_resumida
    gas_descricao.truncate(50)
  end

  def usuario_nome
    user&.usu_nome || 'N/A'
  end

  def contratante_nome
    contratante&.cnt_nome_loja || 'N/A'
  end

  # Validações customizadas
  validate :data_nao_pode_ser_futura
  validate :valor_deve_ser_positivo

  private

  def data_nao_pode_ser_futura
    if gas_data.present? && gas_data > Time.zone.now
      errors.add(:gas_data, "não pode ser uma data futura")
    end
  end

  def valor_deve_ser_positivo
    if gas_valor.present? && gas_valor <= 0
      errors.add(:gas_valor, "deve ser maior que zero")
    end
  end
end