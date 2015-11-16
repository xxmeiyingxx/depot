class StoreController < ApplicationController
  before_action :now

  def index
    @products = Product.order(:title)

    if session[:counter].nil?
      session[:counter] = 1
    else
      session[:counter] += 1
    end

    @counter = session[:counter]

  end
end
