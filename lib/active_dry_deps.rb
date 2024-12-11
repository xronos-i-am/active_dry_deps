# frozen_string_literal: true

require 'active_dry_deps/version'
require 'active_dry_deps/configuration'
require 'active_dry_deps/railtie' if defined? Rails

module ActiveDryDeps

  autoload :Deps,               'active_dry_deps/deps'
  autoload :Dependency,         'active_dry_deps/dependency'
  autoload :Container,          'active_dry_deps/container'
  autoload :Notifications,      'active_dry_deps/notifications'
  autoload :DependencyMap,      'active_dry_deps/dependency_map'
  autoload :DependencyInjector, 'active_dry_deps/dependency_injector'

  class Error < StandardError; end
  class DependencyNameInvalid < Error; end
  class CircularDependency < Error; end

end
