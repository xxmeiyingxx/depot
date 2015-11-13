class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :now


  def now
    @time = Time.zone.now
    @time_d = Time.zone.now.strftime("%Y年%m月%d日(#{%w(日 月 火 水 木 金 土)[Time.zone.now.wday]})")
    @time_r = Time.zone.now.strftime("日本時間：%H時%M分%S秒")
  end

  private

    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end

end
