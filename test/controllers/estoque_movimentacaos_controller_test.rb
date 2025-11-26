require "test_helper"

class EstoqueMovimentacaosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @estoque_movimentacao = estoque_movimentacaos(:one)
  end

  test "should get index" do
    get estoque_movimentacaos_url
    assert_response :success
  end

  test "should get new" do
    get new_estoque_movimentacao_url
    assert_response :success
  end

  test "should create estoque_movimentacao" do
    assert_difference("EstoqueMovimentacao.count") do
      post estoque_movimentacaos_url, params: { estoque_movimentacao: { emv_data: @estoque_movimentacao.emv_data, emv_quantidade: @estoque_movimentacao.emv_quantidade, emv_tipo: @estoque_movimentacao.emv_tipo, emv_valor_total: @estoque_movimentacao.emv_valor_total, produto_id: @estoque_movimentacao.produto_id } }
    end

    assert_redirected_to estoque_movimentacao_url(EstoqueMovimentacao.last)
  end

  test "should show estoque_movimentacao" do
    get estoque_movimentacao_url(@estoque_movimentacao)
    assert_response :success
  end

  test "should get edit" do
    get edit_estoque_movimentacao_url(@estoque_movimentacao)
    assert_response :success
  end

  test "should update estoque_movimentacao" do
    patch estoque_movimentacao_url(@estoque_movimentacao), params: { estoque_movimentacao: { emv_data: @estoque_movimentacao.emv_data, emv_quantidade: @estoque_movimentacao.emv_quantidade, emv_tipo: @estoque_movimentacao.emv_tipo, emv_valor_total: @estoque_movimentacao.emv_valor_total, produto_id: @estoque_movimentacao.produto_id } }
    assert_redirected_to estoque_movimentacao_url(@estoque_movimentacao)
  end

  test "should destroy estoque_movimentacao" do
    assert_difference("EstoqueMovimentacao.count", -1) do
      delete estoque_movimentacao_url(@estoque_movimentacao)
    end

    assert_redirected_to estoque_movimentacaos_url
  end
end
