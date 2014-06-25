# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mecab/ext/version'
require_relative 'version'

Gem::Specification.new do |spec|
  spec.add_dependency "activesupport", "~> 3.2.13", ">= 3.2.13"
  spec.add_dependency "mini_portile", "~> 0"

  spec.name          = "mecab-ext-heavy"
  spec.version       = Mecab::Ext::Heavy::VERSION
  spec.authors       = ["Tadashi Saito"]
  spec.email         = ["tad.a.digger<AT>gmail.com"]
  spec.description   = %q{Make mecab-ruby more handy for most of rubyist.}
  spec.summary       = %q{extensions for mecab-ruby}
  spec.homepage      = "https://github.com/tadd/mecab-ext-heavy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/) + 
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions = "extconf.rb"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "rspec", "~> 2.13.0", ">= 2.13.0"
  spec.add_development_dependency "simplecov", "~> 0.7.1", ">= 0.7.1"
  spec.add_development_dependency "coveralls", "~> 0.6.7", ">= 0.6.7"
end
