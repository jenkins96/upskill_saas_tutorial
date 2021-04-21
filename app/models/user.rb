class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :plan
  has_one :profile
  
  attr_accessor :stripe_card_token
  # If Pro user passes validation (email, password, etc...)
  # then call Stripe and tell Stripe to set up a subscription upon charging the customer's chard.
  # Stripe respondes back with customer data.
  # Store customer.id as the customer token and save the user.
  def save_with_subscription
    if valid?
      # Stripe now automatically adds id to the product so I could not used the params...
      customer = Stripe::Customer.create(description: email, plan: "price_1IiVbPKH5ooJNoHbBTXw55dQ", card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  end
end
