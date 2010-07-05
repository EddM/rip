Gem::Specification.new do |s|
  s.name = 'rip'
  s.version = '0.0.1'
  s.summary = 'Quick and dirty IP address wrappers'
  s.homepage = 'http://github.com/EddM/rip'
  
  s.authors = ['Edd Morgan']
  s.email = 'ejam@me.com'
  
  s.require_paths = ['lib']
  s.files = Dir['lib/*']
  s.test_files = Dir['spec/*.rb']
  
  s.platform = Gem::Platform::RUBY
end