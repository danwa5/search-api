# Search Term API

A Rails API with an end point to capture a search term request and then count the frequency of the search term
within a 15 minute block of time. A second endpoint, utilizing SNS/SQS, is also provided as a more scalable solution.

## Development

### Initialization

```shell
$ gem install bundler
$ bundle check || bundle install
```

### Database

Create database and run migrations

```shell
$ rake db:setup
```

### Run Test Suite

```shell
$ COVERAGE=true rspec
$ open coverage/index.html
```

### Usages

METHOD 1

```
curl 'http://localhost:3000/api/v1/search' \
  -X POST \
  -d 'q=beer'
```

METHOD 2

```
curl 'http://localhost:3000/api/v2/search' \
  -X POST \
  -d 'q=beer'
```
