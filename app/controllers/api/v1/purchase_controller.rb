class Api::V1::PurchaseController < ApplicationController
    before_action :authenticate_user!, only: [:index, :update]
    def index
        @purchases = Purchase.all
        render json: @purchases, status: :ok
    end

    def show
        data = Stripe::Checkout::Session.retrieve(params[:id])
        shipping = data[:shipping_details]
        
        line_items = Stripe::Checkout::Session.list_line_items(params[:id])[:data]
        render json: {
            id: params[:id],
            shipping: shipping,
            items: line_items
        }, status: :ok
    end

    def create
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
        @purchase = Purchase.new(
            stripe_id: checkout_session_id, 
            fulfilled: false,
            email: customer[:email]
        )
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

    def update
        @purchase = Purchase.find_by_id(params[:id])
        
        if @purchase.update(purchase_params)
            render json: @purchase, status: :ok
        else
            render json: { 
                data: @purchase.errors.full_messages, 
                status: "failed" 
            }, status: :unprocessable_entity
        end  
    end

    private
    def purchase_params
        params.require(:purchase).permit(:id, :fulfilled)
    end
end

