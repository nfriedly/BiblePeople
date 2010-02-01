require 'test_helper'

class VersesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:verses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create verse" do
    assert_difference('Verse.count') do
      post :create, :verse => { }
    end

    assert_redirected_to verse_path(assigns(:verse))
  end

  test "should show verse" do
    get :show, :id => verses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => verses(:one).to_param
    assert_response :success
  end

  test "should update verse" do
    put :update, :id => verses(:one).to_param, :verse => { }
    assert_redirected_to verse_path(assigns(:verse))
  end

  test "should destroy verse" do
    assert_difference('Verse.count', -1) do
      delete :destroy, :id => verses(:one).to_param
    end

    assert_redirected_to verses_path
  end
end
