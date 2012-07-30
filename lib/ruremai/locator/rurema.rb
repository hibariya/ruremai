module Ruremai
  module Locator
    module Rurema
      class Ja < Base
        def uri_base
          'http://doc.ruby-lang.org/ja/'
        end

        def candidates
          uri_parts = [RUBY_VERSION, 'method']
          if @method.receiver.instance_of?(Class)
            uri_parts << CGI.escape(receiver.name).gsub(/(%[\dA-Z]{2})/) {|s|
              %(=#{s[1..-1].downcase})
            }
            types = %w(s m i)
          else
            uri_parts << CGI.escape(receiver.class.name).gsub(/(%[\dA-Z]{2})/) {|s|
              %(=#{s[1..-1].downcase})
            }
            types = %w(i m s)
          end
          uri_part = uri_parts.join('/')
          method_name = CGI.escape(name.to_s).gsub(/(%[\dA-Z]+)/) {|s| %(=#{s[1..-1].downcase}) }

          types.map {|type|
            URI.parse("#{uri_base}#{uri_part}/#{type}/#{method_name}.html")
          }
        end
      end
    end
  end
end
