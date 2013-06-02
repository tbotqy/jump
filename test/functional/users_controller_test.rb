require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { closed_only: @user.closed_only, created_at: @user.created_at, deleted_flag: @user.deleted_flag, friends_updated: @user.friends_updated, initialized_flag: @user.initialized_flag, lang: @user.lang, name: @user.name, profile_image_url_https: @user.profile_image_url_https, screen_name: @user.screen_name, statuses_updated: @user.statuses_updated, time_zone: @user.time_zone, token: @user.token, token_secret: @user.token_secret, token_updated: @user.token_updated, tweet_created_at: @user.tweet_created_at, twitter_id: @user.twitter_id, updated_at: @user.updated_at, utc_offset: @user.utc_offset }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { closed_only: @user.closed_only, created_at: @user.created_at, deleted_flag: @user.deleted_flag, friends_updated: @user.friends_updated, initialized_flag: @user.initialized_flag, lang: @user.lang, name: @user.name, profile_image_url_https: @user.profile_image_url_https, screen_name: @user.screen_name, statuses_updated: @user.statuses_updated, time_zone: @user.time_zone, token: @user.token, token_secret: @user.token_secret, token_updated: @user.token_updated, tweet_created_at: @user.tweet_created_at, twitter_id: @user.twitter_id, updated_at: @user.updated_at, utc_offset: @user.utc_offset }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
