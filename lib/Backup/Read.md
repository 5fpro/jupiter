1. gem install backup -v '~> 4.2.0'

2. setting redis path  on Backup/models/db.rb 
    db.rdb_path = 'your/path/dump.rdb'

3. setting psql db host
    db.host               = "your host"
    
4. setting s3 inf on application.yml
    backup:
    s3:
      connection_settings:
        aws_access_key_id: ""
        aws_secret_access_key: ""
        bucket: ''
        region: ''

5. start backup
  make sure you under jupiter directory
  run 'backup perform --trigger jupiter --root-path lib/Backup' 
