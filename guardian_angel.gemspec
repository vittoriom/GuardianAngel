Gem::Specification.new do |s|
  s.name        = 'guardian-angel'
  s.version     = '0.0.5'
  s.homepage    = 'https://github.com/vittoriom/GuardianAngel'
  s.date        = '2014-11-03'
  s.summary     = "Guardian Angel"
  s.description = "A file watcher for iOS developers that makes it quicker to iterate through TDD"
  s.authors     = ["Vittorio Monaco"]
  s.email       = 'vittorio.monaco1@gmail.com'
  s.files       = ["lib/guardian_angel.rb", 
                   "lib/ga_logger.rb", 
                   "lib/ga_runner.rb", 
                   "lib/ga_loader.rb", 
                   "lib/ga_configuration.rb",
                   "lib/xctool_runner.rb",
                   "lib/xcodebuild_runner.rb"]
  s.license     = 'MIT'
  s.executables << 'guardian-angel'
  s.executables << 'xctestfile'
  s.add_runtime_dependency 'filewatcher', '~> 0.3'
  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_runtime_dependency 'xcpretty', '~> 0.1'
end