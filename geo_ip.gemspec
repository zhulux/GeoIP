# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geo_ip/version'

Gem::Specification.new do |spec|
  spec.name          = 'geo_ip'
  spec.version       = GeoIP::VERSION
  spec.authors       = ['Bruce Shi']
  spec.email         = ['shibocuhk@gmail.com']

  spec.summary       = 'Geo IP Info'
  spec.description   = 'Geo IP Info'
  spec.homepage      = 'https://github.com/shibocuhk/GeoIP'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://github.com/shibocuhk/GeoIP'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12'
end
