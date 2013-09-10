# Ruremai [![Build Status](https://travis-ci.org/hibariya/ruremai.png?branch=master)](https://travis-ci.org/hibariya/ruremai)

Ruremai provides `Method#rurema!` method.
`Method#rurema!` opens `rurema` (RUby REference MAnual) by your $BROWSER.

Quick start:

```
$ gem i ruremai
Successfully installed ruremai-0.0.3
Parsing documentation for ruremai-0.0.3
1 gem installed
$ irb -r ruremai
irb(main):001:0> Object.method(:name).rurema!
```

## Supported reference manuals

* (www.rubydoc.info)[http://www.rubydoc.info/stdlib] (en)
* (doc.ruby-lang.org/ja/)[http://doc.ruby-lang.org/ja/] (ja)

## Usage

Method#rurema!:

```ruby
  Object.method(:name).rurema!
```

With locale (availables: en, ja):

```ruby
  Object.method(:name).rurema! locale: :en # Give high priority to `en'
```

Object#mean? (shortcut):

```ruby
  Object.mean?.name
```

## Options

### Locale priority

By default, `Method#rurema!` detects a manual in following order:

1. en
2. ja

So `Method#rurema!` attempts to open manual that written in English.

```ruby
Ruremai.locales # => ['en', 'ja']
Object.method(:name).rurema! # Open http://www.rubydoc.info/stdlib/core/2.0.0/Module:name
```

To change this behaviour, Set an ordered locales. Like below:

```ruby
Ruremai.locales = %w(ja en)
Object.method(:name).rurema! # Open http://doc.ruby-lang.org/ja/2.0.0/method/Module/i/name.html
```

### Verbose mode (for debug)

```ruby
irb(main):001:0> Ruremai.verbose = true
=> true
irb(main):002:0> Object.method(:name).rurema!
Start: http://www.rubydoc.info
Scored method types: {:instance_method=>-1, :module_function=>0, :singleton_method=>1}
Scored method types: {:instance_method=>-1, :module_function=>0, :singleton_method=>1}
202: http://www.rubydoc.info/stdlib/core/2.0.0/Object.name
202: http://www.rubydoc.info/stdlib/core/2.0.0/Object:name
202: http://www.rubydoc.info/stdlib/core/2.0.0/Module.name
200: http://www.rubydoc.info/stdlib/core/2.0.0/Module:name
```

## TODO

* Support other manuals.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
