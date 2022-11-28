# frozen_string_literal: true

require_relative 'lib/actiondoc/version'

Gem::Specification.new do |spec|
  spec.name          = 'actiondoc'
  spec.version       = ActionDoc::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Alistair Israel']
  spec.email         = ['aisrael@gmail.com']

  spec.summary       = 'Generate documentation for GitHub Actions'
  spec.description   = 'Ruby Gem to generate documentation for GitHub Actions'
  spec.homepage      = 'https://github.com/aisrael/actiondoc'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('~> 2.7.1')

  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/aisrael/actiondoc'
  spec.metadata['changelog_uri'] = 'https://github.com/aisrael/actiondoc/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = %w[actiondoc]
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_development_dependency 'aruba', '~> 2.1.0'
  spec.add_development_dependency 'contracts', '0.16.1'
  spec.add_development_dependency  'cucumber', '~> 8.0.0'
  spec.add_development_dependency  'minitest', '~> 5.16.3'
  spec.add_development_dependency  'rake', '~> 13.0.6'
  spec.add_development_dependency  'rubocop', '~> 1.39.0'
  spec.add_development_dependency  'rubocop-minitest', '~> 0.23.2'
  spec.add_development_dependency  'rubocop-rake', '~> 0.6.0'
end
