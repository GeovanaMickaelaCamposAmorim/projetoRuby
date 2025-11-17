require "test_helper"

class TagTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tag_template = tag_templates(:one)
  end

  test "should get index" do
    get tag_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_tag_template_url
    assert_response :success
  end

  test "should create tag_template" do
    assert_difference("TagTemplate.count") do
      post tag_templates_url, params: { tag_template: { color: @tag_template.color, name: @tag_template.name, store_name: @tag_template.store_name } }
    end

    assert_redirected_to tag_template_url(TagTemplate.last)
  end

  test "should show tag_template" do
    get tag_template_url(@tag_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_tag_template_url(@tag_template)
    assert_response :success
  end

  test "should update tag_template" do
    patch tag_template_url(@tag_template), params: { tag_template: { color: @tag_template.color, name: @tag_template.name, store_name: @tag_template.store_name } }
    assert_redirected_to tag_template_url(@tag_template)
  end

  test "should destroy tag_template" do
    assert_difference("TagTemplate.count", -1) do
      delete tag_template_url(@tag_template)
    end

    assert_redirected_to tag_templates_url
  end
end
