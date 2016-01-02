# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "linode"
  s.version = "0.9.0"
  s.date = "2016-01-02"
  s.description = "This is a wrapper around Linode's automation facilities."
  s.summary = "a Ruby wrapper for the Linode API"
  s.authors = ["Rick Bradley"]
  s.email = "rick@rickbradley.com"
  s.homepage = "http://github.com/rick/linode"
  s.licenses = ["MIT"]

  s.rubygems_version = "2.2.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]

  s.extra_rdoc_files = [
    "README.md"
  ]

  # Manifest
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<httparty>, ["~> 0.0"])
  s.add_runtime_dependency(%q<json>, ["~> 1.0"])
end

