# SimpleDB

## Getting started

Clone the repo.

```shell
$ git clone git@github.com:ktravers/simple_db.git
```

`cd` into project directory.

```shell
$ cd simple_db
```

Install bundler if necessary

```shell
$ gem install bundler --no-ri --no-rdoc
```

Use bundler to install gems.

```shell
$ bundle
```

## Usage

The API exposes `get`, `set`, and `unset` methods for (you guessed it) getting, setting, and deleting key values pairs.

```ruby
db = SimpleDb.new

db.set("foo", "bar")
db.get("foo")
#=> "bar"

db.unset("foo")
db.get("foo")
#=> nil
```

Additionally, these operations can be wrapped in transactions.

Initiate a transaction by calling `SimpleDb#begin`

```ruby
db.set("foo", "bar")

db.begin
db.set("foo", "babar")
db.set("baz", "qux")
```

Commit a transaction by calling `SimpleDb#commit`

```ruby
db.set("foo", "bar")

db.begin
db.set("foo", "babar")
db.set("baz", "qux")
db.commit

db.get("foo")
#=> "babar"
db.get("baz")
#=> "qux"
```

Rollback a transaction by calling `SimpleDb#rollback`

```ruby
db.set("foo", "bar")

db.begin
db.set("foo", "babar")
db.set("baz", "qux")
db.commit

db.get("foo")
#=> "babar"
db.get("baz")
#=> "qux"

db.rollback

db.get("foo")
#=> "bar"
db.get("baz")
#=> nil
```

## Testing

Run tests with minitest

```shell
ruby simple_db_test.rb
```
