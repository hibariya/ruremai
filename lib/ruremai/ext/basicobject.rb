require 'ruremai/what_is_this'

class BasicObject
  def what?(*args)
    self.class.what_impl(self, args)
  end

  def self.what?(*args)
    self.what_impl(self, args)
  end

  def self.what_impl(receiver, args)
    if args.empty?
      return ::WhatIsThis.new(receiver)
    else
      args.each do |method|
        receiver.method(method.to_sym).rurema!
      end
    end
  end
end
