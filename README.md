# Rubyapp

- [Rubyapp](#rubyapp)
  - [Introduction](#introduction)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Configuration](#configuration)
    - [Template](#template)
  - [Development](#development)
    - [Control flow](#control-flow)
    - [Add new options/parameters](#add-new-optionsparameters)
    - [Versioning](#versioning)
    - [Developing new application from `rubyapp`](#developing-new-application-from-rubyapp)
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

to see command line interface options. As this is a skeleton gem, there are two sample options - `param1` and `param2` of `Inteeger` type. Two more options are available, that should not depend on concrete application:

* `--version` - shows application name and version and stops.
* `--verbose` - activates verbose logging. What should be logged or not logged depends on this option.

## Configuration

Application configuration is a nested hash table, that presents a JSON object. It consists of three parts

* Default hardcoded configuration.
* Configuration file with TOML format.
* Command line options.

The default configuration comes with the gem. It contains **all** options with predefined values. The configuration file can contain parts or all options from the default configuration eventually with other values. By now the file cannot contains options that do not present in the default configuration. At last command line options can contain part or all of default options. TOML content is validated against JSON validation schema. The validation guaranties configurarion structure integrity across the application and simplifies configuration usage.

Options in TOML file override the default options, and options given at command line override previous two.

The application uses configuration with default file name, **config.toml**. A dedicated option `--config FILE` may be used to select other configuration file. Other option `--no-config` makes the application to skip using configuration file.

The default configuraion is in `rubyapp/config.rb`, in `Config#DEFAULT_CONFIG`. This is a hash structure. It matches exactly the JSON validation schema holded in `Config#CONFIG_SCHEMA`. See these variables in `config.rb` for more information. These two variables have accessors for reading `Config#default_config` and `Config#config_schema` respectively.

TOML configuration files are validated against `Config#CONFIG_SCHEMA`. The default behavior on validation errors is `rubyapp` to log the errors and to stop. See the validation schema. It does not allow additional properties however it has no `"required"` clauses. This allows partial configuration in TOML files. Of course application programmers are allowed to change this by adding `"required"` clauses to make options mandatory in config file. Also, it is possible to add more: pattern checkers, dependencies etc - as needed.

More about TOML syntax:
* [Tom's Obvious Minimal Language](https://toml.io/en/)
* [Learn X in Y minutes](https://learnxinyminutes.com/docs/toml/)

It is important to have default values for all options / parameters hat can appear in TOML files or command-line options.

### Template

When executing

```bash
bundle exec rubyapp --verbose
```

aplication configuration will be shown. First sub-object will be `"template"`. This object contains information about the skeleton `rubyapp`. This information is not for the application developed from the skeletopn. Application name and version are in `lib/rubyapp/version.rb`. Template name and version can be used to know what base the aplication stays on.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Control flow

The application execution begins from **exe/rubyapp**. Here it is:

```ruby
require "rubyapp"
ct = Rubyapp::Mainclass.new
ct.main
```

This code instantiates `Rubyapp::Mainclass` object and calls its `main` function, which is in `lib/rubyapp.rb`. `Mainclass#main` parses TOML file, command line parameters and merges their content with the default configuration. If something wrong happens `main` logs error message and exits. If all goes well, `main` calls `Mainclass#run_app` with one parameter - final configuration has. In this `rubyapp` skeleton, `run_app` logs the configuration if `--verbose` option is given or in TOML file

```toml
[logging]
verbose = true
```

`run_app` function is the place where real application code must begin to live.

### Add new options/parameters

It is common practice when adding new option/parameter to add it to default configuration, TOML file and to command line options. Here is a list of what has to be done so as to have new parameter added. Let this is `param3` of type `integer`, next to `param2`.

`lib/rubyapp/config.rb`

1. Add default value in `DEFAULT_CONFIG["parameters"]` after `"param2"`.
2. Add entry for `"param3"` in `CONFIG_SCHEMA["properties"]["parameters"]["properties"]` after the entry for `"param2"`. You may all what is needed to determine the parameter.
3. Add `"param3"` in `"required"` clause if needed.
4. Add `"param3"` in function `merge_cli_options` in `params` hash.

The default implementation of `merge_cli_options` just inserts command line parameters in `"parameters"` subobject. This is valid only for parameters that are one level under parameters. If the parameters have different (complex) structure `merge_cli_options` may be refactored. There is a commented version of this function below it that shows an example.

`lib/rubyapp/cli.rb`

1. Add `opt.on(...)` for `param3`. See other calls of `opt.on()` for examples.

Options on command line do not have nested structure. They are elements of `ARGV` hash. Potentialy, they can be inserted everywhere into configuration hash in `Config#merge_cli_options`.

### Versioning

Name and version of the application is in `lib/rubyapp/version.rb`. This is the only place that the version is given. `rubyapp.gemspec` uses (requires) `lib/rubyapp/version.rb`.

### Developing new application from `rubyapp`

As `rubyapp` is a skeleton, there are several steps to perform to get ready for a new project. Let the new application is called `myapp`.

1. Rename Directories
  * Rename the main directory (e.g., from `rubyapp/` to `myapp/`).
  * Update subdirectories like `lib/rubyapp/` to `lib/myapp/` and adjust file paths accordingly.
2. Update File Names:
   * Rename files like `lib/rubyapp.rb` to `lib/myapp.rb`.
   * If there’s a CLI file in the `exe` directory (e.g., `exe/rubyapp`), rename it to `exe/myapp`.
3. Update References within Files:
   * Replace all instances of `rubyapp` in the codebase with `myapp`. In Ruby, class and module names are typically capitalized, so:
      * Change any module `Rubyapp` to module `Myapp`.
      * Replace `Rubyapp::` with `Myapp::`.
   * Update any require statements, such as require `"rubyapp"` to require `"myapp"`.
4. Update the Documentation:
   * Modify the README file, usage examples, and any comments that reference `rubyapp`.
5. Verify the Renaming:
   * Run tests and commands to ensure that all instances have been correctly renamed and that everything functions as expected under the new name.

Automation Tips:

You can use a command-line tool like `sed` for batch renaming in files. For example:

```bash
# Recursively replace 'rubyapp' with 'myapp' in all files
find . -type f -exec sed -i 's/rubyapp/myapp/g' {} +
find . -type f -exec sed -i 's/Rubyapp/Myapp/g' {} +
```

Take care about capitalized `Rubyapp` and `Myapp`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jwalkerbg/rubyapp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jwalkerbg/rubyapp/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rubyapp project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rubyapp/blob/master/CODE_OF_CONDUCT.md).
