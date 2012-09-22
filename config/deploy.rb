require "bundler/capistrano"
require "capistrano"     

set :apps_path, "/apps"
set :application, "bud_endpoint"
set :deploy_to, "/apps/#{application}"

set :user, "ubuntu"
set :use_sudo, false

set :scm, :git
set :repository,  "https://github.com/VerdigrisTech/bud-endpoint.git"
set :branch, 'master'
set :git_shallow_clone, 1

set :deploy_via, :remote_cache

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

ssh_options[:keys] = [ENV['EC2_DEPLOY_KEY']] # need to pass this variable for the location of key
ssh_options[:forward_agent] = true

role :app, "54.243.213.2"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  # Assumes you are using Passenger
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log
      ln -s #{apps_path}/shared/datalog #{latest_release}/data
    CMD

    
  end
end