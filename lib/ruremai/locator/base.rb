require 'uri'

module Ruremai
  module Locator
    class Base
      class << self
        def candidates(method)
          new(method).candidates
        end

        def locale(name = nil)
          name ? @locale = name : @locale
        end

        def base_uri(uri = nil)
          uri ? @base_uri = URI(uri) : @base_uri
        end
      end

      attr_reader :target

      def initialize(target_method)
        @target = target_method
      end

      def candidates
        []
      end

      private

      def base_uri
        self.class.base_uri
      end

      def owner_candidates
        [].tap {|candidates|
          if target.respond_to?(:receiver)
            receiver   = target.receiver
            candidates << receiver if receiver.is_a?(Module) && receiver.name
          end

          owner      = target.owner
          candidates << owner if owner.name
        }
      end

      def method_types
        scored_method_types.sort_by {|type, score|
          [-score, type]
        }.map {|type, _|
          type
        }
      end

      def scored_method_types
        name = target.name

        {instance_method: 0, module_function: 0, singleton_method: 0}.tap {|t|
          unless target.respond_to?(:receiver)
            t[:instance_method] += 1 # from Module#instance_method (not Method#unbind) ?
            next
          end

          receiver = target.receiver

          if receiver.is_a?(Module)
            t[:module_function]  += 1
            t[:singleton_method] += 1

            if receiver.private_instance_methods.include?(name)
              t[:module_function]  += 1
            else
              t[:singleton_method] += 1
            end
          else
            t[:module_function] += 1
            t[:instance_method] += 1

            if receiver.private_methods.include?(name)
              t[:module_function] += 1
            else
              t[:instance_method] += 1
            end
          end

          puts %(Scored method types: #{t.inspect}) if Ruremai.verbose
        }
      end
    end
  end
end
