require "test_helper"

class MovimentacaoCrediariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movimentacao_crediario = movimentacao_crediarios(:one)
  end

  test "should get index" do
    get movimentacao_crediarios_url
    assert_response :success
  end

  test "should get new" do
    get new_movimentacao_crediario_url
    assert_response :success
  end

  test "should create movimentacao_crediario" do
    assert_difference("MovimentacaoCrediario.count") do
      post movimentacao_crediarios_url, params: { movimentacao_crediario: { ficha_crediario_id: @movimentacao_crediario.ficha_crediario_id, mov_observacao: @movimentacao_crediario.mov_observacao, mov_tipo: @movimentacao_crediario.mov_tipo, mov_valor: @movimentacao_crediario.mov_valor } }
    end

    assert_redirected_to movimentacao_crediario_url(MovimentacaoCrediario.last)
  end

  test "should show movimentacao_crediario" do
    get movimentacao_crediario_url(@movimentacao_crediario)
    assert_response :success
  end

  test "should get edit" do
    get edit_movimentacao_crediario_url(@movimentacao_crediario)
    assert_response :success
  end

  test "should update movimentacao_crediario" do
    patch movimentacao_crediario_url(@movimentacao_crediario), params: { movimentacao_crediario: { ficha_crediario_id: @movimentacao_crediario.ficha_crediario_id, mov_observacao: @movimentacao_crediario.mov_observacao, mov_tipo: @movimentacao_crediario.mov_tipo, mov_valor: @movimentacao_crediario.mov_valor } }
    assert_redirected_to movimentacao_crediario_url(@movimentacao_crediario)
  end

  test "should destroy movimentacao_crediario" do
    assert_difference("MovimentacaoCrediario.count", -1) do
      delete movimentacao_crediario_url(@movimentacao_crediario)
    end

    assert_redirected_to movimentacao_crediarios_url
  end
end
