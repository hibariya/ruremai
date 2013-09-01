module Ruremai
  module Locator
    class Rurema < Base
      URI_BASE = 'http://doc.ruby-lang.org/ja/'

      def candidates
        uri_part    = [RUBY_VERSION, 'method', escape(method_owner)].join('/')
        method_name = escape(name.to_s)

        # s: singleton mehtod, m: module function, i: instance method
        ordered_types =
          if receiver.is_a?(Module)
            %w(s m i)
          else
            %w(i m s)
          end

        ordered_types.map {|type|
          URI.parse("#{URI_BASE}#{uri_part}/#{type}/#{method_name}.html")
        }
      end

      private

      def escape(str)
        CGI.escape(str).gsub(/(%[\dA-Z]{2})/) {|s|
          %(=#{s[1..-1].downcase})
        }
      end
    end
  end
end
