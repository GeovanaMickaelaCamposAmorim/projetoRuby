class ConfiguracoesController < ApplicationController
  before_action :set_contratante

  def index
  end

  def update
    puts "=== DEBUG UPDATE ==="
    puts "Params recebidos: #{params.inspect}"
    puts "Contratante params: #{contratante_params.inspect}"
    puts "Contratante existe?: #{@contratante.persisted?}"
    puts "Contratante ID: #{@contratante.id}"

    puts "🔄 Atualizando contratante..."
    if @contratante.update(contratante_params)
      puts "✅ UPDATE SUCESSO!"
      puts "Novo nome loja: #{@contratante.cnt_nome_loja}"
      puts "Novo CNPJ: #{@contratante.cnt_cnpj}"

      # Reseta o cache do current_contratante
      @current_contratante = nil

      redirect_to configuracoes_path, notice: "Configurações salvas com sucesso!"
    else
      puts "❌ UPDATE FALHOU!"
      puts "Erros detalhados:"
      @contratante.errors.each do |error|
        puts "  - #{error.attribute}: #{error.message} (valor: #{@contratante[error.attribute]})"
      end
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_contratante
    @contratante = Contratante.first_or_initialize
  end

  def contratante_params
    params.require(:contratante).permit(
      :cnt_nome_loja,
      :cnt_cnpj,
      :cnt_telefone,
      :cnt_endereco,
      :cnt_cep,
      :cnt_nome_responsavel,
      :cnt_email_responsavel,
      :cnt_telefone_responsavel,
      :logo
    )
  end
end
