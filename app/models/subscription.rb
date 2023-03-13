class Subscription < ApplicationRecord
    before_create :add_unsubscribe_hash
    after_create :send_welcome_email
    validates :email, presence: true, uniqueness: true

    private

    def add_unsubscribe_hash
        self.unsubscribe_hash = SecureRandom.hex
    end

    def send_welcome_email
        NewsletterMailer.with(subscription: self).subscribe_email.deliver_now
    end
end
