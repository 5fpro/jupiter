require 'active_support/concern'

module TodoStatusConcern
  extend ActiveSupport::Concern

  def self.included(base)
    base.send(:include, AASM)
    base.send(:aasm, column: :status, enum: true, whiny_transitions: false) do
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
