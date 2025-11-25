class User < ApplicationRecord
  has_secure_password

  has_many :user_sessions, dependent: :destroy
  has_many :sessions, dependent: :destroy
  belongs_to :contratante, optional: true
  has_many :gastos, foreign_key: "user_id"

  enum :usu_tipo, { master: "master", admin: "admin", vendedor: "vendedor", cliente: "cliente" }
  enum :usu_status, { ativo: "Ativo", inativo: "Inativo" }, suffix: true

  validates :usu_nome, :usu_email, :usu_telefone, :usu_tipo, presence: true
  validates :usu_email, uniqueness: true

  alias_attribute :email_address, :usu_email


  def self.existe_master?
    master.exists?
  end

  def self.master_ativo?
    master.ativo.exists?
  end


  scope :ativos, -> { where(usu_status: "Ativo") }
end


# Master User:
# Email: admin@loja.com"
# senha: "senha123"
