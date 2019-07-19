# Inktionary

## Set up database

```shell
# Start a dynamodb-local in a terminal for local development.
docker run -p 8000:8000 amazon/dynamodb-local -jar DynamoDBLocal.jar -inMemory -sharedDb
```

```rb
bundle exec rake db:create
bundle exec rake db:explain
bundle exec rake db:delete
bundle exec rake db:seed
```

## Start development servers

```shell
foreman start -f Procfile.dev
```
