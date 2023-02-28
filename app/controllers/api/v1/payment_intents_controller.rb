class Api::V1::PaymentIntentsController < ApplicationController
    def create
        @payment_intent = Stripe::PaymentIntent.create(
            amount: calculate_order_amount(params[:payment_intent]['items']),
            currency: 'usd',
            automatic_payment_methods: {
              enabled: true,
            },
        )

        render json: { client_secret: @payment_intent.client_secret  }, status: :ok
    end


    private

    def payment_intent_params
        params.require(:payment_intent).permit(
            :items
        )
    end

    def calculate_order_amount(_items)
        # Replace this constant with a calculation of the order's amount
        # Calculate the order total on the server to prevent
        # people from directly manipulating the amount on the client
        1400
    end
      
end