class TagTemplatesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :baixar_pdf, :imprimir ]

  def new
    @tag_template = TagTemplate.new
    @produtos = Produto.all.order(:pro_nome)
  end

  def baixar_pdf
    logger.info "🎯 BAIXAR_PDF - INICIANDO"
    puts "✅ CHEGOU NA ACTION baixar_pdf!"

    # FORÇAR IGNORAR TURBO
    response.headers["Turbo-Links"] = "false"
    response.headers["X-Frame-Options"] = "ALLOWALL"

    begin
      label_data = prepare_label_data
      quantity = params[:quantity].to_i || 1

      puts "🔴 [DEBUG BAIXAR_PDF] DADOS RECEBIDOS:"
      puts "   product_name: #{label_data[:product_name]}"
      puts "   brand: #{label_data[:brand]}"
      puts "   size: #{label_data[:size]}"
      puts "   color: #{label_data[:color]}"
      puts "   code: #{label_data[:code]}"
      puts "   price: #{label_data[:price]}"
      puts "   quantity: #{quantity}"

      generator = LabelGenerator.new(label_data, quantity)
      pdf = generator.generate_pdf

      puts "🟢 [DEBUG BAIXAR_PDF] PDF GERADO COM SUCESSO!"
      puts "   Tamanho do PDF: #{pdf.render.bytesize} bytes"

      # FORÇAR DOWNLOAD
      send_data pdf.render,
                filename: "etiquetas_#{Time.current.strftime('%Y%m%d_%H%M%S')}.pdf",
                type: "application/pdf",
                disposition: "attachment",
                status: 200

    rescue => e
      logger.error "❌ ERRO: #{e.message}"
      puts "🔴 [DEBUG BAIXAR_PDF] ERRO: #{e.message}"
      puts "🔴 [DEBUG BAIXAR_PDF] BACKTRACE: #{e.backtrace.join('\n')}"
      redirect_to gerar_etiqueta_path, alert: "Erro: #{e.message}"
    end
  end

  def imprimir
    logger.info "🎯 IMPRIMIR - INICIANDO"
    puts "=" * 50
    puts "✅ REQUISIÇÃO CHEGOU NO CONTROLLER!"
    puts "📥 PARÂMETROS RECEBIDOS:"
    puts params.inspect
    puts "=" * 50

    # FORÇAR formato PDF e ignorar Turbo
    respond_to do |format|
      format.pdf do
        begin
          # TESTE COM DADOS FIXOS - IGNORAR PARÂMETROS DA REQUISIÇÃO
          label_data = {
            product_name: "PRODUTO TESTE FIXO",
            brand: "MARCA TESTE",
            size: "M",
            color: "AZUL",
            code: "TESTE-123",
            price: "R$ 99,99",
            phone: "(11) 99999-9999",
            instagram: "@teste",
            facebook: "@teste",
            label_color: "#FF0000"
          }
          quantity = 1

          puts "🔴 [DEBUG] USANDO DADOS FIXOS:"
          puts label_data.inspect
          puts "Quantidade: #{quantity}"

          puts "🔴 [DEBUG] INICIANDO LABEL GENERATOR..."
          generator = LabelGenerator.new(label_data, quantity)

          puts "🔴 [DEBUG] GERANDO PDF..."
          pdf = generator.generate_pdf

          puts "🟢 [DEBUG] PDF GERADO COM SUCESSO!"
          puts "Tamanho: #{pdf.render.bytesize} bytes"

          send_data pdf.render,
                    filename: "etiquetas_impressao.pdf",
                    type: "application/pdf",
                    disposition: "inline"

        rescue => e
          logger.error "❌ ERRO: #{e.message}"
          puts "🔴 [DEBUG] ERRO DURANTE GERAÇÃO: #{e.message}"
          puts "Backtrace:"
          e.backtrace.first(10).each { |line| puts "  #{line}" }
          render plain: "Erro: #{e.message}", status: 500
        end
      end

      format.any do
        # Fallback para outros formatos
        puts "⚠️  Formato não suportado: #{params[:format]}"
        render plain: "Formato não suportado", status: 406
      end
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
