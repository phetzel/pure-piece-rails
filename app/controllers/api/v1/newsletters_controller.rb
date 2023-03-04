class Api::V1::NewslettersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :create]
    def index
    end

    def create
        @subscriptions = Subscription.where(enabled: true, subscribed: true)
        @newsletter = Newsletter.new(newsletter_params)

        if @newsletter.save
            @subscriptions.each do |subscription|
                NewsletterMailer.with(subscription: subscription, newsletter: @newsletter).newsletter_email.deliver_now
            end
            render json: @newsletter, status: :ok
        else
            render json: @response.errors, status: :unprocessable_entity
        end
    end
    
    # private

    def newsletter_params
        params.require(:newsletter).permit(:subject, :message)
    end
end