# frozen_string_literal: true

module ActiveDryDeps
  class Container < Hash

    def resolve(container_key)
      unless key?(container_key)
        self[container_key] = Object.const_get(container_key)
      end

      self[container_key]
    end

    def register(container_key, &block)
      self[container_key.to_s] = block
    end

  end
end
