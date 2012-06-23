# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "chef-handler-librato"
  s.version     = "1.1.0"
  s.authors     = ["Brian Scott"]
  s.email       = ["brainscott@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Push reporting stats to Librato metrics}
  s.description = %q{Push reporting stats to Librato metrics}


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "librato-metrics"
  s.add_runtime_dependency "librato-metrics"
  s.add_runtime_dependency "chef"
end