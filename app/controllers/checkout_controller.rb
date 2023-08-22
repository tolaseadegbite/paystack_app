class CheckoutController < ApplicationController
    
    def create
        total_price = @cart.sum(&:price)
        cart_items = @cart.pluck(:name)
        reference = "#{@cart.pluck(:id).join().to_i}_#{rand.to_s[2..10]}"

        @paystack = Paystack.new(Rails.application.credentials[:paystack][:PAYSTACK_PUBLIC_KEY],Rails.application.credentials[:paystack][:PAYSTACK_PRIVATE_KEY])

        @payment = PaystackTransactions.new(@paystack)

        @result = @payment.initializeTransaction(
            :reference => reference,
            :amount => total_price * 100,
            :email => current_user.email,
            callback_url: root_url,
            channels: ["card"],
            metadata: {
                payment_medium: "Website",
                custom_fields: [
                    {
                        "display_name": "Cart Items",
                        "variable_name": "Cart Items",
                        "value": cart_items
                    }
                ]
            }
        )
        auth_url = @result['data']['authorization_url']
        respond_to do |format|
            format.html { redirect_to auth_url, allow_other_host: true }
        end
    end
end