# frozen_string_literal: true

module ActiveDryDeps
  class DependencyInjector

    attr_reader :dependencies

    def initialize
      @dependencies = []
    end

    def receiver_module
      m =
        Module.new do
          def self.included(receiver_module)
            receiver_module.define_singleton_method(:included) do |receiver|
              ActiveDryDeps::Deps::NOTIFICATIONS.emit(event: :dependency_injected, receiver: receiver.name, dependencies: dependencies)
            end
          end
          def self.extended
          end
          def self.prepended

          end
        end

      m.module_eval(dependencies.map(&:receiver_method_string).join("\n"))
      m
    end

  end
end
