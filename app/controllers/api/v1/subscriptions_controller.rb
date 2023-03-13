class Api::V1::SubscriptionsController < ApplicationController
    before_action :authenticate_user!, only: [:index, :update, :destroy]
    before_action :set_subscription, only: [:show, :update, :destroy]

    def index
        @subscriptions = Subscription.all
        render json: @subscriptions, status: :ok
    end

    def create
        # check if email already exists
        @subscription = Subscription.where(email: subscription_params[:email])[0]
        if @subscription && !@subscription.subscribed
            # resubscribe
            @subscription.subscribed = true
        else
            # new subscription
            @subscription = Subscription.new(subscription_params)
        end

        if @subscription.save
            render json: @subscription, status: :ok
        else 
            render json: { 
                data: @subscription.errors.full_messages, 
                status: "failed" 
            }, status: :unprocessable_entity
        end

    end

    def update
        if @subscription.update(subscription_params)
            render json: @subscription, status: :ok
        else
            render json: { 
                data: @subscription.errors.full_messages, 
                status: "failed" 
            }, status: :unprocessable_entity
        end  
    end


    def unsubscribe
        @subscription = Subscription.where(unsubscribe_hash: subscription_params[:hash])[0]
        @subscription.subscribed = false

        if @subscription.save
            render json: { data: 'Successfully unsubscribed', status: 'sucess' }, status: :ok
        else
            render json: { data: 'Failed to unsubscribe', status: 'failed' }
        end
    end
    
    # private
    def set_subscription
        @subscription = Subscription.find_by_id(params[:id])
    rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: :unauthorized
    end

    def subscription_params
        params.require(:subscription).permit(:email, :subscribed, :enabled, :hash)
    end
end