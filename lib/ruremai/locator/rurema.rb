require 'cgi'

module Ruremai
  module Locator
    class Rurema < Base
      locale   'ja'
      base_uri 'http://doc.ruby-lang.org'

      def candidates
        method_name = escape(target.name.to_s)
        type_chars  = {module_function: 'm', singleton_method: 's', instance_method: 'i'}

        const_candidates.each.with_object([]) {|const, uris|
          const_name = escape(const.name)

          method_types.each do |type|
            type_char = type_chars[type]

            uris << base_uri + "/ja/#{RUBY_VERSION}/method/#{const_name}/#{type_char}/#{method_name}.html"
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
