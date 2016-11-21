require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:honoka)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:   "",
                                    email:  "foo@invalid",
                                    password:               "foo",
                                    password_confirmation:  "bar" }
    assert_template 'users/edit'
  end

  # ログイン後に本来アクセスしたかったページにリダイレクトする仕組み
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal edit_user_url(@user), session[:forwarding_url]
    log_in_as(@user)
    assert_equal nil, session[:forwarding_url]
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email # 冗長か
  end
end
