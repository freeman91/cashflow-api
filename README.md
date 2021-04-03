## Dev Environment setup

```sh
# install and start postgres
brew install postgresql
sudo brew services start postgres
pg_ctl -D /usr/local/var/postgres start

# sart mailcatcher
mailcatcher
```

## spin up development server

```
rails s -p 3001
```

## Jupiter deployment

```
[MacOS error installing puma](https://github.com/puma/puma/issues/2304)

# If admin db doesn't exist
createdb

# create postgres user if it doesn't exist
psql
admin=# CREATE USER cashflow_user WITH PASSWORD 'cashflow_password';
admin=# ALTER ROLE cashflow_user CREATEROLE CREATEDB;

# install ruby packages
# need ruby version 2.7.2 (use rvm)

gem install bundler
bundler install
rails db:create
rails db:migrate

# restore db from a backup
psql cashflow_development < cashflow_backup_xxx.bak

# spin up the backend server
rails s -p 3001 -d --binding=0.0.0.0
```


## After restart

### if data is not up to date
```sh
dropdb cashflow_development
createdb cashflow_development

# restore db from a backup
psql cashflow_development < cashflow_backup_xxx.bak
```
