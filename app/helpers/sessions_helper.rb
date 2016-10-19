module SessionsHelper

  # 渡されたユーザでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログインしているユーザを返す(ユーザがログイン中のときのみ)
  def current_user
    # この ||= はメモ化の目的
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # ユーザがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
