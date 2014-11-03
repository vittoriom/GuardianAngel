require 'ga_logger'

# @author Vittorio Monaco
class XcodebuildRunner
  # Creates a new instance given a GAConfiguration object
  #
  # @param configuration [GAConfiguration] the configuration you want to use to build and run the tests (see #GAConfiguration)
  def initialize(configuration)
    @configuration=configuration
  end
  
  # Tells the runner to prepare the environment for a subsequent test run
  #
  # @param filename [String] the name of the file the caller wishes to test
  #
  # @note since xcodebuild doesn't offer a way to test single files, this method doesn't do anything
  # (see #build)
  def prepareForFile(filename)
  end
    
  # Builds (and runs) the tests target through xcodebuild
  #
  # @note This method supports both workspace- and project-based environments
  def build()
    workspace = @configuration.workspace
    scheme = @configuration.scheme
    target = @configuration.target
    project = @configuration.project
    xctool = @configuration.xctool_path
    
    building = workspace
    building = project if workspace.nil?
    
    GALogger.log("Building " + building + " with scheme " + scheme + "...")
    
    toBuild = buildArgument()
    buildSucceeded = system("xcodebuild" + toBuild + 
                            ' -scheme ' + scheme +
                            ' -sdk iphonesimulator' +
                            ' test | xcpretty -tc', out: $stdout, err: :out)
                            
    if buildSucceeded
      GALogger.log('Tests are fine. Start coding :)', :Success)
    else
      GALogger.log('Tests failed. Fix them before you start iterating.', :Error)
    end
  end
  
  # Returns the main argument for xctool to build the project/workspace
  #
  # Example:
  # -workspace 'MyWorkspace.xcworkspace'
  # or
  # -project 'MyProject.xcodeproj'
  def buildArgument()
     workspace = @configuration.workspace
     scheme = @configuration.scheme
     project = @configuration.project
     
     toBuild = ''
     if workspace.nil?
       toBuild = " -project '" + project + ".xcodeproj'"
     else  
       toBuild = " -workspace '" + workspace + ".xcworkspace'"
     end 
     
     return toBuild
  end
  
  # Runs tests for the specified file
  #
  # @param filename [String] the file you wish to run the tests for
  # @note This method supports both workspace- and project-based environments
  def test(filename)
    scheme = @configuration.scheme
    target = @configuration.target
    xctool = @configuration.xctool_path
    reporter = @configuration.reporter
    suffix = @configuration.suffix
    
    GALogger.log("Running tests for file " + filename + '...')
    
    toBuild = buildArgument()
    system("xcodebuild" + toBuild +
           ' -scheme ' + scheme +
           ' -sdk iphonesimulator' +
           ' test | xcpretty -tc', out: $stdout, err: :out)
  end
end