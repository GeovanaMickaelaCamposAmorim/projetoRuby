require "test_helper"

class ConfiguracoesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get configuracoes_index_url
    assert_response :success
  end

  test "should get update" do
    get configuracoes_update_url
    assert_response :success
  end
end
