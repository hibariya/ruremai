require 'cgi'

module Ruremai
  module Locator
    class Rurema < Base
      URI_BASE = 'https://docs.ruby-lang.org/ja/'
      major, minor, teeny = *RUBY_VERSION.split('.').map(&:to_i)
      PATH_VERSION_PART = case major
      when 0, 1
        [major, minor, teeny]
      when 2
        [major, minor, 0]
      else
        [major, minor]
      end.join(".")
      
      def candidates
        method_owner.ancestors.inject([]) {|all, mod| all + candidates_for(mod) }
      end

      private

      def candidates_for(mod)
        uri_part    = [PATH_VERSION_PART, 'method', escape(mod.name)].join('/')
        method_name = escape(name.to_s)

        # s: singleton mehtod, m: module function, i: instance method
        ordered_types = receiver.is_a?(Module) ? %w(s m i) : %w(i m s)
        ordered_types.map {|type|
          URI.parse("#{URI_BASE}#{uri_part}/#{type}/#{method_name}.html")
        }
      end

      def escape(str)
        CGI.escape(str).gsub(/(%[\dA-Z]{2})/) {|s|
          %(=#{s[1..-1].downcase})
        }
      end
    end
  end
end
