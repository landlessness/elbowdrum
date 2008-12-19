set :branch, "master"
set :application, "elbowdrum"
set :ssh_options, { :forward_agent => true }
set :git_shallow_clone, 1
set :git_enable_submodules, 1 
set :scm, :git
set :scm_username, "bmulloy" 
set :scm_passphrase, "passw0rd"
set :repository, "git@github.com:brianmulloy/tic-toc-bloc.git"
# set :deploy_via, :remote_cache
set :user, "bmulloy2"
set :use_sudo, false
set :keep_releases, 3

set :deploy_to, "/home/bmulloy2/#{application}"

role :app, "elbowdrum.com"
role :web, "elbowdrum.com"
role :db,  "elbowdrum.com", :primary => true

default_run_options[:pty] = true 