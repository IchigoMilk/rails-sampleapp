require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  setup do
    @admin     = users(:honoka)
    @non_admin = users(:nagisa)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      if user.activated?
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      else
        assert_select 'a[href=?]', user_path(user), text: user.name, count: 0
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "user profile links" do
    log_in_as(@admin)
    get users_path
    User.paginate(page: 1).each do |user|
      get user_path(user)
      if user.activated?
        assert_template 'users/show'
      else
        assert_template layout: nil
      end
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
