class Mean
  attr_accessor :receiver

  def initialize(receiver)
    @receiver = receiver
  end

  def method_missing(method_name, *args, &block)
    @receiver.method(method_name).rurema!
  end
end
