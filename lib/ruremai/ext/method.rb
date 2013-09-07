class Method
  def rurema!(options = {})
    if locale = options[:locale]
      Ruremai.launch self, Array(locale)
    else
      Ruremai.launch self
    end
  end
end
