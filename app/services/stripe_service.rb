require 'stripe'

class StripeService
  class StripeException < StandardError
  end

  attr_reader :shop

  def initialize(shop)
    @shop = shop
  end

  def add_card(token_id, email, name)
    create_customer(email, name) unless customer.present?
    card = customer.sources.create(source: token_id)
    shop.update!(card_id: card.id)
  end

  def credit_card_info
    card = shop.stripe_token
    customer.sources.retrieve(card) if card
  end

  def update_credit_card(token_id)
    card = customer.sources.create(source: token_id)
    card.save
    card_id = card.id
    customer.default_source = card_id
    customer.save
    shop.update!(card_id: card_id)
  end

  def customer
    customer_id = shop.customer_id
    return unless customer_id.present?

    @customer ||= Stripe::Customer.retrieve(customer_id)
  end

  private

  def create_customer(email, name)
    customer_params = {
      email: email,
      description: "#{shop.name} #{name}"
    }
    @customer = Stripe::Customer.create(customer_params)
    shop.update!(customer_id: @customer.id)
  end
end