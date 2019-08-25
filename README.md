# Inktionary

## Set up development envirionment

- rbenv
- Lamby
- docker
- dynamodb docker image: https://hub.docker.com/r/amazon/dynamodb-local/
- etc

```shell
# strap convention
bin/bootstrap
bin/setup
```

## Start development servers

```shell
foreman start -f Procfile.dev
```

## Set up database

```shell
RAILS_ENV=development rails db:setup
```

```shell
RAILS_ENV=test rails db:setup
```

```shell
# Some other commands available
RAILS_ENV=development rails db:create
RAILS_ENV=development rails db:describe
RAILS_ENV=development rails db:delete
RAILS_ENV=development rails db:seed
```
