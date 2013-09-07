require 'ruremai/mean'

module Ruremai
  module ObjectMixin
    def mean?(*args)
      if args.empty?
        return Ruremai::Mean.new(self)
      else
        args.each do |method|
          self.method(method.to_sym).rurema!
        end
      end
    end
  end
end

class Object
  include Ruremai::ObjectMixin
end
