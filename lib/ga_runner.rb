require 'ga_logger'
require 'guardian_angel'
require 'xctool_runner'

# @author Vittorio Monaco
class GARunner
  # Creates a new instance given a GAConfiguration object and a filename to run tests
  #
  # @param configuration [GAConfiguration] the configuration you want to use to run the tests (see #GAConfiguration)
  # @param filename [String] the name of the file you want to run the tests for
  # @note filename can also be a tests file
  def initialize(configuration, filename)
        @configuration=configuration
        @filename=filename
        @runner=XctoolRunner.new(configuration)
  end
  
  # Runs unit tests for the given filename, if a tests file exists
  # 
  # @param filename [String] the file you want to run tests for
  # @note filename must be a code file, not a tests file. If you're not sure whether the file is a tests file or not, use #test instead
  # @note if a corresponding tests file cannot be found, outputs a warning line
  def testIfAvailable(filename)
      suffix = @configuration.suffix
      
      fileExists = system("find . | grep '" + filename + suffix + "' > /dev/null")
      if !fileExists
        GALogger.log(filename + " doesn't seem to have associated tests. You should think about creating some.", :Warning)
        return
      end
      
      @runner.test(filename)
  end
  
  # Tries to run unit tests for the filename setup during initialization
  # 
  # @note if the filename is a tests file, this method strips the tests suffix and runs the tests for the right file instead, after having built the tests project first
  # (see #buildIfNeeded)
  # (see #testIfAvailable)
  def test()    
    filename = @filename
    suffix = @configuration.suffix
    
    buildIfNeeded()
    if isTest()
      filename = @filename.slice(/(?<file>.*)#{suffix}$/, "file")
    end
    
    testIfAvailable(filename)
  end
  
  # @return true if the filename is a tests file
  def isTest()
    return @filename.end_with? @configuration.suffix
  end
  
  # This method builds the tests project if the filename setup during initialization is a tests file
  # (see #isTest)
  def buildIfNeeded()
    if isTest()
       GALogger.log(@filename + ' is a test, building all the tests...')
       GuardianAngel.buildWithConfiguration(@configuration)
    end
  end
end