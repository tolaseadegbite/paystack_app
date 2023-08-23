class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :initialize_session
    before_action :load_cart
    before_action :load_paystack

    def load_cart
        @cart = Product.find(session[:cart])
        render 'carts/cart' if action_name == 'load_cart'
    end

    private

    def initialize_session
        session[:cart] ||= [] #empty cart = empty array
    end

    def load_paystack
        @paystack = Paystack.new(Rails.application.credentials[:paystack][:PAYSTACK_PUBLIC_KEY],Rails.application.credentials[:paystack][:PAYSTACK_PRIVATE_KEY])
    end

end
