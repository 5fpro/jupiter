require 'yaml'
require 'erb'

rails_env       = 'development'
database_yml    = File.expand_path("../../../../config/database.yml", __FILE__)
db_config       = YAML.load_file(database_yml)[rails_env]
application_yml = File.expand_path("../../../../config/application.yml", __FILE__)
app_config      = YAML.load(ERB.new(File.read(application_yml)).result)[rails_env]['backup']

# encoding: utf-8

##
# Backup Generated: my_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t my_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:jupiter, 'jupiter_backup') do

  ##
  # Archive [Archive]
  #
  # Adding a file or directory (including sub-directories):
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/directory/"
  #
  # Excluding a file or directory (including sub-directories):
  #   archive.exclude "/path/to/an/excluded_file.rb"
  #   archive.exclude "/path/to/an/excluded_directory
  #
  # By default, relative paths will be relative to the directory
  # where `backup perform` is executed, and they will be expanded
  # to the root of the filesystem when added to the archive.
  #
  # If a `root` path is set, relative paths will be relative to the
  # given `root` path and will not be expanded when added to the archive.
  #
  #   archive.root '/path/to/archive/root'
  #

  ##
  # Redis [Database]
  #
  database Redis do |db|
    db.mode               = :copy # or :sync
    # Full path to redis dump file for :copy mode.
    db.rdb_path           = 'your/path/dump.rdb'
    # When :copy mode is used, perform a SAVE before
    # copying the dump file specified by `rdb_path`.
    db.invoke_save        = false
    db.host               = 'localhost'
    db.port               = 6379
    db.socket             = '/tmp/redis.sock'
    db.password           = 'my_password'
    db.additional_options = []
  end

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = db_config['database']
    db.username           = db_config['username']
    db.password           = db_config['password'].to_s # nil not allowed
    db.host               = "localhost"
  end

  ##
  # Amazon Simple Storage Service [Storage]
  #
  store_with S3 do |s3|
    # AWS Credentials
    s3.access_key_id     = app_config['s3']['connection_settings']['aws_access_key_id']
    s3.secret_access_key = app_config['s3']['connection_settings']['aws_secret_access_key']
    s3.region            = app_config['s3']['connection_settings']['region']
    s3.bucket            = app_config['s3']['connection_settings']['bucket']
    s3.path              = "/#{rails_env}"
    s3.keep              = 5
    # s3.keep              = Time.now - 2592000 # Remove all backups older than 1 month.
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
end
