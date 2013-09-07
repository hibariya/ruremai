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

      # XXX can't care singleton method
      # TODO: owner, receiver 両方に定義されていることがあるよ。そのときは receiver の方を優先したいよ
      def method_owner_name
        if name = target.owner.name
          name
        elsif target.respond_to?(:receiver)
          target.receiver.name
        else
          nil
        end
      end

      def ordered_method_types
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
