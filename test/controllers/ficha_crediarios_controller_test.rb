require "test_helper"

class FichaCrediariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ficha_crediario = ficha_crediarios(:one)
  end

  test "should get index" do
    get ficha_crediarios_url
    assert_response :success
  end

  test "should get new" do
    get new_ficha_crediario_url
    assert_response :success
  end

  test "should create ficha_crediario" do
    assert_difference("FichaCrediario.count") do
      post ficha_crediarios_url, params: { ficha_crediario: { cliente_id: @ficha_crediario.cliente_id, contratante_id: @ficha_crediario.contratante_id, fic_status: @ficha_crediario.fic_status, fic_valor_total: @ficha_crediario.fic_valor_total } }
    end

    assert_redirected_to ficha_crediario_url(FichaCrediario.last)
  end

  test "should show ficha_crediario" do
    get ficha_crediario_url(@ficha_crediario)
    assert_response :success
  end

  test "should get edit" do
    get edit_ficha_crediario_url(@ficha_crediario)
    assert_response :success
  end

  test "should update ficha_crediario" do
    patch ficha_crediario_url(@ficha_crediario), params: { ficha_crediario: { cliente_id: @ficha_crediario.cliente_id, contratante_id: @ficha_crediario.contratante_id, fic_status: @ficha_crediario.fic_status, fic_valor_total: @ficha_crediario.fic_valor_total } }
    assert_redirected_to ficha_crediario_url(@ficha_crediario)
  end

  test "should destroy ficha_crediario" do
    assert_difference("FichaCrediario.count", -1) do
      delete ficha_crediario_url(@ficha_crediario)
    end

    assert_redirected_to ficha_crediarios_url
  end
end
