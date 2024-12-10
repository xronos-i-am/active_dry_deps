# frozen_string_literal: true

module ActiveDryDeps
  class Notifications

    attr_reader :subscriptions

    def initialize
      @subscriptions = { dependency_injected: [] }
    end

    def subscribe(event:, &block)
      subscriptions.fetch(event) << block
    end

    def emit(event:, **payload)
      subscriptions.fetch(event).call(**payload)
    end

  end
end
