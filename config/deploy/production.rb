set :rails_env, 'production'

servers = ['jupiter.5fpro.com']

shadow_server = 'jupiter-shadow.5fpro.com'
role :app,             servers
role :web,             servers + [ shadow_server ]  # for assets precompile
role :db,              shadow_server
role :whenever_server, shadow_server
role :sidekiq_server,  shadow_server
role :assets_sync_server, shadow_server

