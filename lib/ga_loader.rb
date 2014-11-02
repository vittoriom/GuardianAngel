require 'json'
require 'ga_logger'
require 'ga_configuration'

CONFIG_FILENAME = 'guardian_angel.json'

# @author Vittorio Monaco
class GALoader
  # Reads the configuration from the file guardian_angel.json
  #
  # @note if the file is not found, it will try to build with default values instead
  # @note this also outputs the final GAConfiguration built on the console
  # (see #GAConfiguration)
  def self.readConfiguration(silent = false)
    configuration = GAConfiguration.new
    
    begin
      jsonDictionary = JSON.parse(File.read(CONFIG_FILENAME))
      configurationMerge = GAConfiguration.new(jsonDictionary)
      configuration = configuration.merge(configurationMerge)
    rescue
      GALogger.log("#{CONFIG_FILENAME} not found or not a valid JSON, using defaults", :Warning) unless silent
    end
    
    validateConfiguration(configuration)
    outputConfiguration(configuration) unless silent
    
    return configuration
  end
  
  # Returns a possible workspace, in case one is not provided in the configuration
  #
  # @note this searches only in the top level directory
  def self.findWorkspace
    return findFile("xcworkspace")
  end
  
  # Returns a possible project, in case one is not provided in the configuration
  #
  # @note this searches only in the top level directory
  def self.findProject
    return findFile("xcodeproj")
  end
  
  # Returns the first file with the given extension
  #
  # @param extension [String] the file extension you want to search
  # @return nil if no file is found, the first file with the given extension otherwise
  def self.findFile(extension)
    files = Dir.glob("*.#{extension}")
    return nil if files.empty?
    
    return File.basename(files.first, ".*")
  end
  
  # Validates a given configuration
  #
  # @param configuration [GAConfiguration] the configuration to validate
  # @note required attribute is workspace/project
  # @note if scheme is not specified, the same as the workspace/project will be used
  # @note if target is not specified, '{workspace|project}Tests' will be used
  # @note the method will also make sure that the configured xctool executable can be found, or aborts otherwise 
  def self.validateConfiguration(configuration)
    if configuration.workspace.nil? 
      possibleWorkspace = findWorkspace()
      
      if !possibleWorkspace
        possibleProject = configuration.project
        if possibleProject.nil?
          possibleProject = findProject()
          
          if !possibleProject
            GALogger.log("workspace or project was not specified and cannot be found, exiting", :Error)
            outputSampleConfiguration(eventuallyAbort = true)
          end
        end
        
        configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationProject => possibleProject)
      else
        configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationWorkspace => possibleWorkspace)
      end
      
      configuration = configuration.merge(configurationMerge)
    end
    
    if configuration.scheme.nil?
      unless configuration.project.nil?
        configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationScheme => configuration.project)
      end
      unless configuration.workspace.nil?
        configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationScheme => configuration.workspace)
      end
      
      configuration = configuration.merge(configurationMerge)
    end
    
    if configuration.target.nil?
      configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationTarget => configuration.scheme + 'Tests')      
      configuration = configuration.merge(configurationMerge)
    end
    
    xctoolExists = system("which #{configuration.xctool_path} > /dev/null")
    if !xctoolExists
      GALogger.log(configuration.xctool_path + " can't be found. Aborting.", :Error)
      abort
    end
  end
  
  # Outputs a sample configuration to let the user know how to create a valid one
  # 
  # @param eventuallyAbort [Bool] pass true if you want to abort after printing out the sample configuration. Default is false.
  #
  # (see #GAConfiguration)
  def self.outputSampleConfiguration(eventuallyAbort = false)
    GALogger.log('Sample configuration JSON: ' + GAConfiguration.sample.to_s, :Warning, '')
    if eventuallyAbort
      abort
    end
  end
  
  # Outputs a given configuration on the console
  # 
  # @param [GAConfiguration] the configuration you want to print
  def self.outputConfiguration(configuration)
    GALogger.log(configuration.to_s, :Default, '')
  end
  
  # Returns a filename from a given array
  #
  # @param files [Array<String>] an array of strings
  #
  # @note the method will take the last element of the array
  # @note the method will take only the filename if the element of the array is a file, removing the extension and the path
  def self.getFileFromArray(files) 
    fileToTest = files.first
    
    if fileToTest.nil?
      GALogger.log('Failed to get file', :Error)
      abort
    else
      return File.basename(fileToTest, ".*")
    end
  end
end