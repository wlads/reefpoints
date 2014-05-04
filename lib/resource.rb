class Middleman::Sitemap::Resource
  def method_missing(method, *args, &block)
    if %w{title summary twitter category comments github social}.include?(method.to_s)
      data[method] || metadata[:locals][method.to_s]
    else
      super
    end
  end
end
