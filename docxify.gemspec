require_relative "lib/docxify/version"

Gem::Specification.new do |spec|
  spec.name = "docxify"
  spec.version = DocXify::VERSION
  spec.authors = ["Andy Jeffries", "FounderCatalyst Ltd"]
  spec.email = ["andy@foundercatalyst.com"]

  spec.summary = "DocXify is a gem to help you generate Word documents from Ruby."
  spec.description = "Using a relatively simple DSL, you can generate Word DocX documents from Ruby."
  spec.homepage = "https://github.com/foundercatalyst/docxify"
  spec.required_ruby_version = ">= 3.0.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/foundercatalyst/docxify"
  spec.metadata["changelog_uri"] = "https://github.com/foundercatalyst/docxify/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "image_size", "~> 3.0"
  spec.add_dependency "rubyzip", "~> 2.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
