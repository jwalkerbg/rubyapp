# frozen_string_literal: true

require_relative "lib/rubyapp/version"

Gem::Specification.new do |spec|
  spec.name = Rubyapp::NAME
  spec.version = Rubyapp::VERSION
  spec.authors = ["Ivan Cenov"]
  spec.email = ["i_cenov@botevgrad.com"]

  spec.summary = "Ryby skeleton of CLI application"
  spec.description = "Ruby skeleton of CLI application. Uses TOML file for configuration."
  spec.homepage = "https://github.com/jwalkerbg/rubyapp.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jwalkerbg/rubyapp.git"
  spec.metadata["changelog_uri"] = "https://github.com/jwalkerbg/rubyapp/blob/master/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "bigdecimal", "~>3.1"
  spec.add_dependency "json", "~> 2.8"
  spec.add_dependency "json-schema", "~> 5.0"
  spec.add_dependency "logger", "~> 1.6"
  spec.add_dependency "ruby-lsp"
  spec.add_dependency "toml-rb", "~> 3.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
