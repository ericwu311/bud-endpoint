namespace :resque do 
  task :setup do 
    require_relative '../../config/environment'
  end
end