class User < ApplicationRecord

  # after_commit :create_paystack_customer, on: :create
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def to_s
    email
  end

  after_create do
    return if paystack_customer_id.present?

    paystack = Paystack.new(Rails.application.credentials[:paystack][:PAYSTACK_PUBLIC_KEY], Rails.application.credentials[:paystack][:PAYSTACK_PRIVATE_KEY])

    paystack_customers = PaystackCustomers.new(paystack)

    customer = paystack_customers.create( email: email )

    update(paystack_customer_id: customer['data']['customer_code'])
  end
end
