## Dev Env setup

```sh
brew install postgresql
sudo brew services start postgres
pg_ctl -D /usr/local/var/postgres start
```

### start mailcatcher server http://127.0.0.1:1080/

```
$ mailcatcher
```

## spin up the backend

```
rails s -p 3001
```

## Jupiter deployment

Clone repo then:

```
# install rails gems
bundle install
[MacOS error installing puma](https://github.com/puma/puma/issues/2304)

# create postgres user if it doesn't exist
psql
admin=# CREATE USER cashflow_user WITH PASSWORD 'cashflow_password';
admin=# ALTER ROLE cashflow_user CREATEROLE CREATEDB;

# create cashflow db
rails db:create
rails db:migrate

# restore db from a backup
psql cashflow_development < cashflow_backup_xxx.bak

# spin up the backend server
rails s -p 3001 -d --binding=0.0.0.0
```
