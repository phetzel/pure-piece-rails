class Customer < ApplicationRecord
    validates :stripe_id, presence: true
    has_many :orders
    before_validation :create_on_stripe, on: :create
    def create_on_stripe
      params = { email: email, name: name }
      response = Stripe::Customer.create(params)
      self.stripe_id = response.id
    end
  end
  