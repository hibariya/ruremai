module Ruremai
  module Locator
    class Rurema < Base
      class Ja < Rurema
        def uri_base
          'http://doc.ruby-lang.org/ja/'
        end

        def candidates
          uri_part    = [RUBY_VERSION, 'method', escape(method_owner)].join('/')
          method_name = escape(name.to_s)
          types       =
            if receiver.is_a?(Module)
              %w(s m i)
            else
              %w(i m s)
            end

          types.map {|type|
            URI.parse("#{uri_base}#{uri_part}/#{type}/#{method_name}.html")
          }
        end
      end

      def escape(str)
        CGI.escape(str).gsub(/(%[\dA-Z]{2})/) {|s|
          %(=#{s[1..-1].downcase})
        }
      end
    end
  end
end
