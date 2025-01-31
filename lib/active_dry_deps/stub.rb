# frozen_string_literal: true

module ActiveDryDeps
  module StubDeps
    def stub(key, value)
      self::CONTAINER.stub(key, value)
    end

    def unstub(*keys)
      self::CONTAINER.unstub(*keys, container: CONTAINER_ORIG.merge(GLOBAL_STUBS))
    end

    def global_stub(key, value)
      GLOBAL_STUBS[key] = value
      self::CONTAINER.stub(key, value)
    end

    def global_unstub(*keys)
      self::CONTAINER.unstub(*keys, container: CONTAINER_ORIG)
    end
  end

  module StubContainer
    def stub(key, value)
      self[key] = value
    end

    def unstub(*unstub_keys, container:)
      if unstub_keys.empty?
        replace(container)
      else
        unstub_keys.each do |key|
          if container.key?(key)
            self[key] = container[key]
          else
            delete(key)
          end
        end
      end
    end
  end

  module Deps
    def self.enable_stubs!
      StubDeps.const_set(:CONTAINER_ORIG, Deps::CONTAINER.dup)
      StubDeps.const_set(:GLOBAL_STUBS, {})

      Deps::CONTAINER.extend(StubContainer)
      Deps.extend StubDeps
    end
  end
end
