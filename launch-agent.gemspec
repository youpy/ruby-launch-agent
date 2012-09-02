# -*- encoding: utf-8 -*-
require File.expand_path('../lib/launch_agent/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["youpy"]
  gem.email         = ["youpy@buycheapviagraonlinenow.com"]
  gem.description   = %q{A library to use launchd easily}
  gem.summary       = %q{A library to use launchd easily}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = %q{launch-agent}
  gem.require_paths = ["lib"]
  gem.version       = LaunchAgent::VERSION

  gem.add_dependency('plist')
  gem.add_dependency('docopt', '0.5.0')
  gem.add_development_dependency('rspec', ['~> 2.8.0'])
  gem.add_development_dependency('rake')
end
