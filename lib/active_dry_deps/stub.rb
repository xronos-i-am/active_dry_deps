# frozen_string_literal: true

module ActiveDryDeps

  module StubDeps

    def stub(key, &block)
      allow(Deps::CONTAINER).to receive(:resolve).with(key).and_wrap_original(&block)
    end

    def unstub
      RSpec::Mocks.space.proxy_for(Deps::CONTAINER).reset
    end

  end

  module Deps

    def self.enable_stubs!
      RSpec.configure do |config|
        config.before(:each) do
          allow(Deps::CONTAINER).to receive(:resolve).and_call_original
        end

        config.include StubDeps
      end
    end

  end

end
