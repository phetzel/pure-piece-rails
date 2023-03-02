class Subscription < ApplicationRecord
    before_create :add_unsubscribe_hash
    validates :email, presence: true, uniqueness: true

    private

    def add_unsubscribe_hash
        self.unsubscribe_hash = SecureRandom.hex
    end
end
