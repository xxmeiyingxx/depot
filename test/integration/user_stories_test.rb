require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "buying a product" do
    LineItem.delete_all         # お掃除
    Order.delete_all            # お掃除
    ruby_book = products(:ruby) # 購入したい本
    # ここまでで準備完了

    get "/"                       # http://localhost:3000にアクセス
    assert_response :success
    assert_template "index"

    post_via_redirect "/line_items", product_id: ruby_book.id
    assert_response :success
    assert_template "show"

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders",
                      order: { name:     "Dave Thomas",
                               address:  "123 The Street",
                               email:    "dave@example.com",
                               pay_type: "現金"}
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Dave Thomas", order.name
    assert_equal "123 The Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "現金", order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Ikeuchi-s <test@def.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end
