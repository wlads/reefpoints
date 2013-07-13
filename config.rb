require 'builder'
Dir['./lib/*'].each { |f| require f }

activate :blog do |blog|
  blog.permalink = ":year/:month/:day/:title.html"
  blog.sources = "posts/:year-:month-:day-:title.html"
  blog.paginate = true
  blog.tag_template = 'tag.html'
  blog.taglink = 'categories/:tag.html'
  blog.calendar_template = 'calendar.html'
  blog.author_template = 'author.html'
  blog.authorlink = 'authors/:author.html'
end

module Middleman::Blog::BlogArticle
  def summary
    data['summary']
  end

  def tags
    article_tags = data['tags']

    if data['tags'].is_a? String
        article_tags = article_tags.split(',').map(&:strip)
    else
      article_tags = Array.wrap(article_tags)
    end
    Array.wrap(data['legacy_category']) + article_tags
  end
end

helpers do
  def tag_links(tags)
    tags.map do |tag|
      link_to tag_name(tag), tag_path(tag), class: 'tag-link'
    end.join(', ')
  end

  def tag_name(tag)
    case tag
    when 'ruby on rails'
      'Ruby on Rails'
    when 'jquery'
      'jQuery'
    when 'postgresql', 'postgres'
      'PostgreSQL'
    when 'jquery'
      'jQuery'
    when 'javascript'
      'JavaScript'
    when 'ember'
      'Ember.js'
    when 'backbone'
      'Backbone.js'
    else
      tag.split(' ').map(&:capitalize).join(' ')
    end
  end
end

set :markdown_engine, :redcarpet
set :markdown, :layout_engine => :erb, :fenced_code_blocks => true, :lax_html_blocks => true, :renderer => ::Highlighter::HighlightedHTML.new
activate :highlighter
activate :author_pages
activate :legacy_category
ignore 'author.html.haml'
page 'sitemap.xml', layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :haml, remove_whitespace: true
