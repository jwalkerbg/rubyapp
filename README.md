# Rubyapp

- [Rubyapp](#rubyapp)
  - [Introduction](#introduction)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Configuration](#configuration)
  - [Development](#development)
  - [Contributing](#contributing)
  - [License](#license)
  - [Code of Conduct](#code-of-conduct)

## Introduction

This project is a simple skeleton of Ruby gem which has CLI interface. Is is used as a skeleton for developing Ruby gems with CLI interface. It has a simple system of runtime configuration.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG
```

## Usage

Run

```bash
bundle exec rubyapp --help
```

to see command line interface options. As this is a skeleton gem, there are two sample options - `param1` and `param2` of `Intereger` type. Two more options are available, that should not depend on concrete application:

* `--version` - shows application name and version and stops.
* `--verbose` - activates verbose logging. What should be logged or not logged depends on this option.

## Configuration

Application configuration is a nested hash table, presented as a JSON object. It consists of thre parts

* Default hardcoded configuration
* Configuration file with TOML format.
* command line options.

The default configuration comes with the gem. It contains **all** options with predefined values. The configuration file can contain parts or all options from the default configuration eventually with other values. By now the file cannot contains options that do not present in the default configuration. At last command line options can contain part or all of default options. TOML content is validated against JSON validation schema. The validation guaranties configurarion structure integrity across the application and simplifies configuration usage.

Options in TOML file override the default options, and options given at command line override previous two.

The application uses configuration with default file name, **config.toml**. A dedicated option `--config FILE` may be used to select other configuration file. Other option `--no-config` makes the application to skip using configuration file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rubyapp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rubyapp/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rubyapp project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rubyapp/blob/master/CODE_OF_CONDUCT.md).
