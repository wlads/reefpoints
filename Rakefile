task :default do
  pids = [
    spawn("jekyll"),
    spawn("sass --watch sass:stylesheets2"),
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  loop do
    sleep 1
  end
end
