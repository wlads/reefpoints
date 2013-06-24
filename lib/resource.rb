class Middleman::Sitemap::Resource
  def method_missing(method, *args, &block)
    if %w{title summary twitter category comments github}.include?(method.to_s)
      data[method]
    else
      super
    end
  end
end
