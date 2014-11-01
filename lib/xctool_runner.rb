require 'ga_logger'

# @author Vittorio Monaco
class XctoolRunner
  # Creates a new instance given a GAConfiguration object
  #
  # @param configuration [GAConfiguration] the configuration you want to use to build and run the tests (see #GAConfiguration)
  def initialize(configuration)
    @configuration=configuration
  end
    
  # Builds the tests target through xctool
  #
  # @note This method supports both workspace- and project-based environments
  def build()
    workspace = @configuration.workspace
    scheme = @configuration.scheme
    target = @configuration.target
    project = @configuration.project
    xctool = @configuration.xctool_path
    
    building = workspace
    if workspace.nil?
      building = project
    end
    
    GALogger.log("Building " + building + " with scheme " + scheme + "...")
    
    toBuild = buildArgument()
    system(xctool + toBuild + 
           ' -scheme ' + scheme +
           ' -sdk iphonesimulator' +
           ' build-tests', out: $stdout, err: :out)
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
    workspace = @configuration.workspace
    scheme = @configuration.scheme
    target = @configuration.target
    project = @configuration.project
    xctool = @configuration.xctool_path
    reporter = @configuration.reporter
    suffix = @configuration.suffix
    
    GALogger.log("Running tests for file " + filename + '...')
    
    toBuild = buildArgument()
    system(xctool + toBuild +
           ' -scheme ' + scheme +
           ' -sdk iphonesimulator' +
           ' run-tests' +
           ' only ' + target + ':' + filename + suffix +
           ' -reporter ' + reporter, out: $stdout, err: :out)
  end
end