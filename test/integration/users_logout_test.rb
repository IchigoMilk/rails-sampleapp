require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:honoka)
  end

  test "login and logout" do
    get login_path
    post login_path, session: { email: "", password: "" }
    delete logout_path
    assert_not is_logged_in?
  end
end
