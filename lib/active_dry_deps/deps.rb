# frozen_string_literal: true

module ActiveDryDeps
  module Deps

    CONTAINER = Container.new

    extend Notifications::ClassMethods

    module_function

    # include Deps[routes_admin: 'Lib::Routes.admin'] use as `routes_admin`
    # include Deps['Lib::Routes.admin'] use as `admin`
    # include Deps['Lib::Routes'] use as `Routes()`
    # include Deps['OrderService::Recalculate.call'] use as `Recalculate()`
    def [](*keys, **aliases)
      m = Module.new

      receiver_methods = +''
      dependencies = []

      keys.each do |resolver|
        dependency = Dependency.new(resolver)
        receiver_methods << dependency.receiver_method_string << "\n"
        dependencies << dependency
      end

      aliases.each do |alias_method, resolver|
        dependency = Dependency.new(resolver, receiver_method_alias: alias_method)
        receiver_methods << dependency.receiver_method_string << "\n"
        dependencies << dependency
      end

      m.module_eval(receiver_methods)
      m.include(Notifications.included_dependency_decorator(dependencies))
      m
    end

    def register(...)
      CONTAINER.register(...)
    end

  end
end
