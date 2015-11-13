class StoreController < ApplicationController
  before_action :now

  def index
    @products = Product.order(:title)
  end
end
