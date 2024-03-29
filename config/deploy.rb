# config valid only for current version of Capistrano
require 'capistrano/version'
lock Capistrano::VERSION

set :application, 'jupiter'
set :repo_url, 'git@github.com:5fpro/jupiter.git'
set :deploy_to, '/home/apps/jupiter'
set :ssh_options, {
  user: 'apps',
  forward_agent: true
}

# execjs use node
set :default_env, {
  'EXECJS_RUNTIME' => 'Node'
}

set :rbenv_type, :user
set :rbenv_ruby, IO.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push(*CAP_CONFIG_FILES)

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end


after 'deploy:publishing', 'deploy:restart'
after 'deploy:published', 'bundler:clean'

namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
    # invoke 'unicorn:restart'

    # passenger
    # execute :mkdir, '-p', release_path.join('tmp')
    # execute :touch, release_path.join('tmp/restart.txt')
  end
end

# uncomment while first deploy
# before "deploy:migrate", "deploy:db_create"
# namespace :deploy do
#   task :db_create do
#     on primary fetch(:migration_role) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :rake, "db:create"
#         end
#       end
#     end
#   end
# end

