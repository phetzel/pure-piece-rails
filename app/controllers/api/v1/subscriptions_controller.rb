class Api::V1::SubscriptionsController < ApplicationController
    before_action :authenticate_user!, only: [:destroy]
    before_action :set_subscription, only: [:show, :update, :destroy]

    def index
        @subscriptions = Subscription.all
        render json: @subscriptions, status: :ok
    end

    def create
        @subscription = Subscription.new(subscription_params)

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

    def destroy
        if @subscription.destroy
          render json: { data: 'Company deleted successfully', status: 'sucess' }, status: :ok
        else
          render json: { data: 'Something went wrong', status: 'failed' }
        end
    end
    
    # private

    def set_subscription
        @subscription = Subscription.find_by_id(params[:id])
    rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: :unauthorized
    end

    def subscription_params
        params.require(:subscription).permit(:email, :subscribed, :enabled)
    end
end