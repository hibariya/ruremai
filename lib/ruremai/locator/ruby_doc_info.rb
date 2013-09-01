require 'cgi'

module Ruremai
  module Locator
    class RubyDocInfo < Base
      URI_BASE = 'http://www.rubydoc.info/'

      locale 'en'

      def candidates
        method_name = escape(name.to_s)
        uri_parts   = ['core', detect_library_name].compact.map {|slug|
          ['stdlib', slug, RUBY_VERSION, method_owner.gsub(/::/, '/')].join('/')
        }

        # `.': class method, `:': instance method
        ordered_types =
          if receiver.is_a?(Module)
            %w(. :)
          else
            %w(: .)
          end

        uri_parts.map {|uri_part|
          ordered_types.map {|type|
            URI.parse("#{URI_BASE}#{uri_part}#{type}#{method_name}?process=true")
          }
        }.flatten
      end

      private

      def detect_library_name
        return nil unless source_location = @method.source_location

        source_path = source_location.first
        load_path   = $LOAD_PATH.detect {|path|
          source_path.start_with?(path)
        }

        library_path = source_path.sub(load_path, '')

        File.basename(library_path.split('/')[1], '.*') # XXX
      end

      def escape(str)
        CGI.escape(str).gsub(/(%[\dA-Z]{2})/, &:downcase)
      end
    end
  end
end
