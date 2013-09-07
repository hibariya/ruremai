require 'cgi'

module Ruremai
  module Locator
    class Rurema < Base
      URI_BASE = URI('http://doc.ruby-lang.org')

      locale 'ja'

      def candidates
        method_name = escape(target.name.to_s)
        type_chars  = {module_function: 'm', singleton_method: 's', instance_method: 'i'}

        owner_constants.each.with_object([]) {|constant, uris|
          constant_name = escape(constant.name)

          method_types.each do |type|
            type_char = type_chars[type]

            uris << URI_BASE + "/ja/#{RUBY_VERSION}/method/#{constant_name}/#{type_char}/#{method_name}.html"
          end
        }
      end

      private

      def escape(str)
        CGI.escape(str).gsub(/(%[\da-z]{2})/i) {|s|
          %(=#{s[1..-1].downcase})
        }
      end
    end
  end
end
