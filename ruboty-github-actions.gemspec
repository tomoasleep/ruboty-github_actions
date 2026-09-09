# frozen_string_literal: true

require_relative "lib/ruboty/github_actions/version"

Gem::Specification.new do |spec|
  spec.name = "ruboty-github-actions"
  spec.version = Ruboty::GithubActions::VERSION
  spec.authors = ["tomoasleep"]
  spec.summary = "Run GitHub Actions workflows from ruboty"
  spec.description = "A ruboty plugin to trigger GitHub Actions workflows via chat"
  spec.homepage = "https://github.com/tomoasleep/ruboty-github-actions"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir["lib/**/*.rb"] + %w[README.md]
  spec.require_paths = ["lib"]

  spec.add_dependency "octokit", ">= 6.0"
  spec.add_dependency "jwt", ">= 2.0"
  spec.add_dependency "ruboty", ">= 1.3"
end
