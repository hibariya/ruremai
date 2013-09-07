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
      end

      attr_reader :target

      def initialize(target_method)
        @target = target_method
      end

      def candidates
        []
      end

      private

      def owner_constants
        constants = []

        if target.respond_to?(:receiver)
          receiver = target.receiver

          constants << receiver if receiver.is_a?(Module) && receiver.name
        end

        constants << target.owner if target.owner.name

        constants
      end

      def method_types
        method_types_with_score.sort_by {|_, score|
          score
        }.reverse.map {|type, _|
          type
        }
      end

      def method_types_with_score
        owner, name = target.owner, target.name

        has_singleton_methohd = owner.methods.include?(name)
        has_private_method    = owner.private_instance_methods.include?(name)
        has_instance_method   = owner.instance_methods.include?(name)

        {singleton_method: 0, instance_method: 0, module_function: 0}.tap {|t|
          t[:module_function]  += 1 if has_singleton_methohd  && has_private_method
          t[:singleton_method] += 1 if has_singleton_methohd  && !has_private_method
          t[:instance_method]  += 1 if !has_singleton_methohd && has_instance_method

          next unless target.respond_to?(:receiver)

          if target.receiver.is_a?(Module)
            t[:module_function]  += 1
            t[:singleton_method] += 1
          else
            t[:instance_method]  += 1
          end
        }
      end
    end
  end
end
