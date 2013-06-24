Dir['./lib/*'].each { |f| require f }

activate :blog do |blog|
  blog.permalink = ":year/:month/:day/:title.html"
  blog.sources = "posts/:year-:month-:day-:title.html"
  blog.paginate = true
  blog.tag_template = 'tag.html'
  blog.taglink = 'categories/:tag'
  blog.calendar_template = 'calendar.html'
  blog.author_template = 'author.html'
  blog.authorlink = 'authors/:author'
end

module Middleman::Blog::BlogArticle
  def summary
    data['summary']
  end
end

set :markdown_engine, :redcarpet
set :markdown, :layout_engine => :erb, :fenced_code_blocks => true, :lax_html_blocks => true, :renderer => ::Highlighter::HighlightedHTML.new
activate :highlighter
activate :author_pages
activate :legacy_category

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :haml, remove_whitespace: true

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_path, "/Content/images/"
end
