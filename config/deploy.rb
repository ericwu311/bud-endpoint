puts "Deploying Bud-Endpoint..."

require "bundler/capistrano"
require "capistrano"   

set :apps_path, "/apps"
set :application, "bud_endpoint"
set :deploy_to, "/apps/#{application}"

set :env, "production"

set :user, :ops
set :use_sudo, false

set :scm, :git
set :repository,  "https://github.com/VerdigrisTech/bud-endpoint.git"
set :branch, 'master'
set :git_shallow_clone, 1

set :deploy_via, :remote_cache

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

# ssh_options[:keys] = [ENV['EC2_DEPLOY_KEY']] # need to pass this variable for the location of key
ssh_options[:forward_agent] = true

if ENV['DEPLOYMENT_MODE'] == 'test'
  role :app, "192.168.33.10"
else
  role :app, "54.243.213.2"  
end

namespace :deploy do
  task :start do
    run "/apps/bud_endpoint/current/bin/goliath start"
  end

  task :stop do 
    run "/apps/bud_endpoint/current/bin/goliath stop"
  end
  # Assumes you are using Passenger
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end

  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -s #{apps_path}/shared/data #{latest_release}/data
    CMD
  end

  task :cleanup do 

  end
end
