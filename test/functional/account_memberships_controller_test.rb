require 'test_helper'

class AccountMembershipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:account_memberships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account_membership" do
    assert_difference('AccountMembership.count') do
      post :create, :account_membership => { }
    end

    assert_redirected_to account_membership_path(assigns(:account_membership))
  end

  test "should show account_membership" do
    get :show, :id => account_memberships(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => account_memberships(:one).id
    assert_response :success
  end

  test "should update account_membership" do
    put :update, :id => account_memberships(:one).id, :account_membership => { }
    assert_redirected_to account_membership_path(assigns(:account_membership))
  end

  test "should destroy account_membership" do
    assert_difference('AccountMembership.count', -1) do
      delete :destroy, :id => account_memberships(:one).id
    end

    assert_redirected_to account_memberships_path
  end
end
