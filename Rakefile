$: << File.expand_path('../lib', __FILE__)

require "resque/tasks"

load 'lib/tasks/resque.rake'


task :test do 
  files = Dir["spec/**/*_spec.rb"]
  system 'rspec -fd'
end

task :autotest do 
  system 'kicker -e "bundle exec rake test" lib spec'
end