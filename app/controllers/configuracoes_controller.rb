class ConfiguracoesController < ApplicationController
  before_action :set_configuracao

  def index
  end

  def update
    puts "=== DEBUG UPDATE ==="
    puts "Params recebidos: #{params.inspect}"
    puts "Configuração params: #{configuracao_params.inspect}"
    puts "Configuração existe?: #{@configuracao.persisted?}"
    puts "Configuração ID: #{@configuracao.id}"

    if @configuracao.update(configuracao_params)
      puts "✅ UPDATE SUCESSO!"
      puts "Nova cor fundo: #{@configuracao.cor_fundo_menu}"
      puts "Nova cor fonte: #{@configuracao.cor_fonte_menu}"
      redirect_to configuracoes_path, notice: "Configurações salvas com sucesso!"
    else
      puts "❌ UPDATE FALHOU!"
      puts "Erros: #{@configuracao.errors.full_messages}"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_configuracao
    @configuracao = Configuracao.first_or_initialize
  end

  def configuracao_params
    params.require(:configuracao).permit(
      :nome_loja, :cnpj, :telefone, :endereco, :instagram,
      :cor_fundo_menu, :cor_fonte_menu, :logo
    )
  end
end
