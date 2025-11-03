class User < ApplicationRecord
  has_secure_password

  # Associações
  has_many :user_sessions, dependent: :destroy
  has_many :sessions, dependent: :destroy
  belongs_to :contratante, optional: true
  has_many :gastos, foreign_key: 'user_id'

  # Enums de string com suffix para evitar conflitos
  enum usu_tipo: { master: "master", admin: "admin", vendedor: "vendedor", cliente: "cliente" }, _suffix: true
  enum usu_status: { ativo: 'Ativo', inativo: 'Inativo' }, _suffix: true

  # Validações
  validates :usu_nome, :usu_email, :usu_telefone, :usu_tipo, presence: true
  validates :usu_email, uniqueness: true

  # Aliases para compatibilidade
  alias_attribute :email_address, :usu_email

  # Método para pegar o role (mais amigável)
  def role
    usu_tipo
  end

  # Métodos de conveniência para checagem de role
  def admin?
    usu_tipo_admin?
  end

  def master?
    usu_tipo_master?
  end

  def vendedor?
    usu_tipo_vendedor?
  end

  def cliente?
    usu_tipo_cliente?
  end
end
