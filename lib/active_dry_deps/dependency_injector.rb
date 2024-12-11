# frozen_string_literal: true

module ActiveDryDeps
  class DependencyInjector

    attr_reader :dependencies

    def initialize
      @dependencies = []
    end

    def receiver_methods
      dependencies = @dependencies

      dependency_injected =
        proc do |receiver|
          Deps::NOTIFICATIONS.emit(:dependency_injected, receiver: receiver, dependencies: dependencies)
        end

      m = Module.new
      m.define_singleton_method(:included, &dependency_injected)
      m.define_singleton_method(:prepended, &dependency_injected)
      m.define_singleton_method(:extended, &dependency_injected)
      m.module_eval(dependencies.map(&:receiver_method_string).join("\n"))
      m
    end

  end
end
