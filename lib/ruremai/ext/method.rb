module Ruremai
  module MethodMixin
    def rurema!(options = {})
      if locale = options[:locale]
        Ruremai.launch self, Array(locale)
      else
        Ruremai.launch self
      end
    end
  end
end

class Method
  include Ruremai::MethodMixin
end

class UnboundMethod
  include Ruremai::MethodMixin
end
