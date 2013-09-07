require 'cgi'

module Ruremai
  module Locator
    class RubyDocInfo < Base
      URI_BASE = 'http://www.rubydoc.info/'

      locale 'en'

      def candidates
        type_chars  = {module_function: '.', singleton_method: '.', instance_method: ':'}
        method_name = escape(target.name.to_s)
        uri_parts   = ['core', detect_library_name].compact.map {|slug|
          ['stdlib', slug, RUBY_VERSION, method_owner_name.gsub(/::/, '/')].join('/')
        }

        uri_parts.map {|uri_part|
          ordered_method_types.map {|type|
            type_char = type_chars[type]

            URI.parse("#{URI_BASE}#{uri_part}#{type_char}#{method_name}")
          }
        }.flatten.uniq
      end

      private

      def detect_library_name
        return nil unless source_location = target.source_location

        source_path = source_location.first
        load_path   = $LOAD_PATH.detect {|path|
          source_path.start_with?(path)
        }

        return nil unless load_path

        library_path = source_path.sub(load_path, '')

        File.basename(library_path.split('/')[1], '.*') # /alpha/bravo.rb -> alpha
      end

      def escape(str)
        CGI.escape(str).gsub(/(%[\dA-Z]{2})/, &:downcase)
      end
    end
  end
end
