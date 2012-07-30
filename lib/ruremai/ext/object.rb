require 'ruremai/mean'

class Object
  def mean?(*args)
    if args.empty?
      return ::Mean.new(self)
    else
      args.each do |method|
        self.method(method.to_sym).rurema!
      end
    end
  end
end
