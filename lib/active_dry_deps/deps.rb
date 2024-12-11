# frozen_string_literal: true

module ActiveDryDeps
  module Deps

    CONTAINER     = Container.new
    NOTIFICATIONS = Notifications.new

    module_function

    # include Deps[routes_admin: 'Lib::Routes.admin'] use as `routes_admin`
    # include Deps['Lib::Routes.admin'] use as `admin`
    # include Deps['Lib::Routes'] use as `Routes()`
    # include Deps['OrderService::Recalculate.call'] use as `Recalculate()`
    def [](*keys, **aliases)
      injector = DependencyInjector.new

      keys.each do |resolver|
        injector.dependencies << Dependency.new(resolver)
      end

      aliases.each do |alias_method, resolver|
        injector.dependencies << Dependency.new(resolver, receiver_method_alias: alias_method)
      end

      injector.receiver_methods
    end

    def register(...)
      CONTAINER.register(...)
    end

    def subscribe(...)
      NOTIFICATIONS.subscribe(...)
    end

  end
end
