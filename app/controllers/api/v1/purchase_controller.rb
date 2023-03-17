class Api::V1::PaymentController < ApplicationController
    def index
        @purchases = Purchase.all
        render json: @purchases, status: :ok
    end

    def create
        # payload = request.body.read
        # endpoint_secret = "#{Rails.application.credentials[Rails.env.to_sym][:stripe_endpoint]}"
        # sig_header = request.env['HTTP_STRIPE_SIGNATURE']

        # event = Stripe::Webhook.construct_event(
        #     payload, sig_header, endpoint_secret
        # )
      


        event_id = params[:id]
        data = params[:data][:object]

        logger.info 'data -----------------------'
        logger.info data
        logger.info 'data -----------------------'

        checkout_session_id = data[:id]
        line_items = Stripe::Checkout::Session.list_line_items(checkout_session_id)[:data]

        payment_status = data[:payment_status]
        is_subscribing = data[:custom_fields][0][:dropdown][:value]

        amount = data[:amount_total].to_f / 100
        customer = data[:customer_details]
        shipping = data[:shipping_details]
        payment_id = data[:payment_intent]

        # handle newletter
        if is_subscribing
            @subscription = Subscription.where(email: customer[:email])[0]
            if @subscription && !@subscription.subscribed
                # resubscribe
                @subscription.subscribed = true
            else
                # new subscription
                @subscription = Subscription.new(email: customer[:email])
                @subscription.save
            end
        end

        # add purchase to database
        @purchase = Purchase.new(stripe_id: payment_id, fulfilled: false)
        @purchase.save

        # notify admin of purchase
        AdminMailer.with(
            amount: amount,
            customer: customer,
            shipping: shipping,
            items: line_items,
        ).order_email.deliver_now

        render status: :ok
    end
end

