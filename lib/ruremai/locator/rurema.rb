module Ruremai
  module Locator
    module Rurema
      class Ja < Base
        def uri_base
          'http://doc.ruby-lang.org/ja/'
        end

        def candidates
          uri_part    = [RUBY_VERSION, 'method', owner.name.gsub(/::/, '/')].join('/')
          method_name = CGI.escape(name.to_s).gsub(/(%[\dA-Z]+)/) {|s| %(=#{s[1..-1].downcase}) }

          %w(i s m).map {|type|
            URI.parse("#{uri_base}#{uri_part}/#{type}/#{method_name}.html")
          }
        end
      end
    end
  end
end
