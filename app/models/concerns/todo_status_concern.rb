module TodoStatusConcern
  extend ActiveSupport::Concern

  included do
    include AASM
    aasm column: :status, enum: true do
      state :pending, initial: true
      state :doing
      state :finished

      event :to_doing do
        transitions from: [:pending, :finished], to: :doing
      end

      event :to_pending do
        transitions from: :doing, to: :pending
      end

      event :to_finished do
        transitions from: [:pending, :doing], to: :finished
      end
    end
  end
end
