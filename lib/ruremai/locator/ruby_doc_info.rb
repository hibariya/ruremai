require 'cgi'

module Ruremai
  module Locator
    class RubyDocInfo < Base
      locale   'en'
      base_uri 'http://www.rubydoc.info'

      def candidates
        method_name   = escape(target.name.to_s)
        type_chars    = {module_function: '.', singleton_method: '.', instance_method: ':'}
        library_names = ['core', detect_library_name].compact

        library_names.each.with_object([]) {|library_name, uris|
          owner_constants.each do |constant|
            constant_name = constant.name.gsub(/::/, '/')

            method_types.each do |type|
              type_char = type_chars[type]

              uris << base_uri + "/stdlib/#{library_name}/#{RUBY_VERSION}/#{constant_name}#{type_char}#{method_name}"
            end
          end
        }.uniq
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
