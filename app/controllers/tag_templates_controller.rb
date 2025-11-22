class TagTemplatesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :baixar_pdf, :imprimir ]

  def new
    @tag_template = TagTemplate.new
    @produtos = Produto.all.order(:pro_nome)
  end

  def baixar_pdf
    logger.info "🎯 BAIXAR_HTML - INICIANDO"
    puts "✅ HTML - CHEGOU NA ACTION baixar_pdf!"

    begin
      @label_data = prepare_label_data
      @quantity = params[:quantity].to_i || 1

      puts "🔴 [HTML] DADOS PARA ETIQUETA:"
      puts "   product_name: #{@label_data[:product_name]}"
      puts "   brand: #{@label_data[:brand]}"
      puts "   size: #{@label_data[:size]}"
      puts "   color: #{@label_data[:color]}"
      puts "   code: #{@label_data[:code]}"
      puts "   price: #{@label_data[:price]}"
      puts "   quantity: #{@quantity}"

      # Renderização SIMPLES - sem format block
      render 'etiqueta', layout: 'pdf'

    rescue => e
      logger.error "❌ ERRO HTML: #{e.message}"
      puts "🔴 [HTML] ERRO: #{e.message}"
      puts e.backtrace.join("\n")
      redirect_to gerar_etiqueta_path, alert: "Erro ao gerar etiquetas: #{e.message}"
    end
  end

  def imprimir
    logger.info "🎯 IMPRIMIR HTML - INICIANDO"
    puts "✅ HTML - REQUISIÇÃO CHEGOU NO CONTROLLER!"

    begin
      @label_data = prepare_label_data
      @quantity = params[:quantity].to_i || 1
      @auto_print = true

      puts "🔴 [HTML IMPRIMIR] DADOS:"
      puts @label_data.inspect
      puts "Quantidade: #{@quantity}"

      # Renderização SIMPLES
      render 'etiqueta', layout: 'pdf'

    rescue => e
      logger.error "❌ ERRO HTML IMPRIMIR: #{e.message}"
      puts "🔴 [HTML IMPRIMIR] ERRO: #{e.message}"
      puts e.backtrace.join("\n")
      render plain: "Erro: #{e.message}", status: 500
    end
  end

  private

  def prepare_label_data
    data = {
      product_name: params[:product_name] || "Produto",
      brand: params[:brand] || "Marca",
      size: params[:size] || "Tamanho",
      color: params[:color] || "Cor",
      code: params[:code] || "COD-001",
      price: params[:price] || "R$ 0,00",
      phone: params[:phone] || "(75) 91234-5678",
      instagram: params[:instagram] || "@instagram",
      facebook: params[:facebook] || "@facebook",
      label_color: params[:label_color] || "#4E4E4E"
    }

    puts "🎯 DADOS FINAIS:"
    puts data.inspect
    data
  end
end
