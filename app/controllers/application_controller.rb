class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :now
  before_action :authorize
  # Basic認証テスト
  before_action :authenticate

  def now
    @time = Time.zone.now
    @time_d = Time.zone.now.strftime("%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[Time.zone.now.wday]})")
    @time_r = Time.zone.now.strftime("日本時間：%H時%M分%S秒")
    @time_j = Time.zone.now.strftime("%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[Time.zone.now.wday]})・日本時間：%H時%M分%S秒")
  end

  private

    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "ログインしてください"
      end
    end

    # Basic認証テスト
    def authenticate
      authenticate_or_request_with_http_basic('Administration') do |username, password|
        md5_of_password = Digest::MD5.hexdigest(password)
      username == 'admin' && md5_of_password == '5f4dcc3b5aa765d61d8327deb882cf99'
      end
    end

end
