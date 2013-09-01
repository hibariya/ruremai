class Method
  def rurema!(options = {})
    options = {locale: Ruremai.primary_locale}.merge(options)

    Ruremai.launch self, options[:locale]
  end
end
