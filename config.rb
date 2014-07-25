require 'builder'
require 'byebug'
require 'middleman-blog/tag_pages'
require 'active_support/inflector'

Dir['./lib/*'].each { |f| require f }

activate :blog do |blog|
  blog.permalink = ":year/:month/:day/:title.html"
  blog.sources = "posts/:year-:month-:day-:title.html"
  blog.paginate = true
  blog.tag_template = 'category.html'
  blog.taglink = 'categories/:tag.html'
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

  def illustration
    data['illustration']
  end

  def illustration_alt
    data['illustration_alt']
  end
end

helpers do
  def ordinal_date(date)
    number = date.day.ordinalize
    ordinal = number.slice!(-2,2)

    "#{date.strftime('%B')} #{number}<sup>#{ordinal}</sup>, #{date.strftime('%Y')}"
  end

  def tag_links(tags)
    tags.map do |tag|
      link_to tag_path(tag), class: 'post__tag' do
        "#{tag_name(tag)}&nbsp;<span class='post__tag__count'>(#{tag_count(tag)})</span>"
      end
    end.join(' ')
  end

  def tag_count(tag)
    blog.articles.select { |article| article.tags.include?(tag) }.size
  end

  def tag_name(tag)
    Middleman::Blog::TagPages.tag_name(tag)
  end

  def active_state_for(path)
    page_classes.split.first == (path) ? 'active' : nil
  end

  def all_ads
    { }
  end

  def ad_partial
    all_ads[(all_ads.keys & current_page.tags).first]
  end

  def has_ad?
    (all_ads.keys & current_page.tags).any?
  end

  def has_illustration?
    !current_page.illustration.nil?
  end
end

set :markdown_engine, :redcarpet
set :markdown, :layout_engine => :erb, :fenced_code_blocks => true, :lax_html_blocks => true, :renderer => ::Highlighter::HighlightedHTML.new
activate :highlighter
activate :author_pages
activate :legacy_category
activate :asset_hash, ignore: /images/
ignore 'author.html.haml'
page 'sitemap.xml', layout: false
page 'atom.xml', layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :haml, remove_whitespace: true
