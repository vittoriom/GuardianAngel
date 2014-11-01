require 'ga_logger'
require 'xctool_runner'

# @author Vittorio Monaco
class GuardianAngel
  # Creates a new instance given a GAConfiguration object
  #
  # @param configuration [GAConfiguration] the configuration you want to use to run the tests (see #GAConfiguration)
  def initialize(configuration)
    @configuration=configuration
    @runner=XctoolRunner.new(configuration)
  end
     
  # Convenience method to build tests in a stand-alone fashion
  #
  # @param configuration [GAConfiguration] the configuration you want to use to run the tests (see #GAConfiguration)
  def self.buildWithConfiguration(configuration)
    watcher = GuardianAngel.new(configuration)
    watcher.buildTests()
  end
  
  # Builds the tests target through xctool
  #
  # (see #XctoolRunner)
  # @note a configuration must be already setup for this method to work
  def buildTests()    
    @runner.build()
  end
  
  # Starts watching for changes to .m or .swift files in the caller directory
  #
  # @note this uses the gem filewatcher
  def watch()
    GALogger.log("Watching...")
    system("filewatcher '*.{m,swift}' 'xctestfile $FILENAME'", out: $stdout, err: :out)
  end
end