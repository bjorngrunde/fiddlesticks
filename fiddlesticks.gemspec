Gem::Specification.new do |s|
  s.name        = "fiddlesticks"
  s.version     = '0.1.0'
  s.authors     = ["Björn Grunde"]
  s.email       = "bjorngrunde@live.se"
  #s.homepage    = ""
  s.summary     = "Shows memory usage for a block of code"
  s.description = "Fiddlesticks accepts a block of code and willl show the memory used. This is great to find bottlenecks in your codebase or when you optimize your code."
  s.required_rubygems_version = ">= 1.3.6"
  s.files = ["lib/fiddlesticks.rb", "lib/fiddlesticks/os.rb"]
  s.add_runtime_dependency 'color-console', '~> 0'
  # s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.license = 'MIT'
end
