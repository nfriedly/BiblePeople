require 'test_helper'

class PersonVersesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:person_verses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person_verse" do
    assert_difference('PersonVerse.count') do
      post :create, :person_verse => { }
    end

    assert_redirected_to person_verse_path(assigns(:person_verse))
  end

  test "should show person_verse" do
    get :show, :id => person_verses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => person_verses(:one).to_param
    assert_response :success
  end

  test "should update person_verse" do
    put :update, :id => person_verses(:one).to_param, :person_verse => { }
    assert_redirected_to person_verse_path(assigns(:person_verse))
  end

  test "should destroy person_verse" do
    assert_difference('PersonVerse.count', -1) do
      delete :destroy, :id => person_verses(:one).to_param
    end

    assert_redirected_to person_verses_path
  end
end
