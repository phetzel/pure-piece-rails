class NewsletterMailer < ApplicationMailer
    def subscribe_email
        @subscription = params[:subscription]
        mail(to: @subscription.email, subject: "Thanks for joining our mailing list.")
    end

    def newsletter_email
        @subscription = params[:subscription] 
        @newsletter = params[:newsletter] 
        mail(to: @subscription.email,  subject: @newsletter.subject)
    end
end
