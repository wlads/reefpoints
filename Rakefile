require 'middleman-gh-pages'

# config
source_dir   = "."
posts_dir    = "source/posts"
new_post_ext = "md"

desc "Create a new post in #{source_dir}/#{posts_dir}"

task :new, :title do |t, args|
  mkdir_p "#{source_dir}/#{posts_dir}"
  args.with_defaults(:title => "new-post")
  title = args.title
  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.gsub(/\s/, '_').gsub(/\./, '_').downcase}.#{new_post_ext}"

  if File.exists?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ["y", "n"]) == "n"
  end

  puts "Create a new post: #{filename}"

  open(filename, "w") do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: '#{title.gsub(/&/, '&amp')}'"
    post.puts "twitter: "
    post.puts "github: "
    post.puts "author: ''"
    post.puts "tags: "
    post.puts "social: true"
    post.puts "published: false"
    post.puts "summary: ''"
  end
end

task :preview do
  sh "bundle exec middleman"
end
