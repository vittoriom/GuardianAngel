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
  def self.readConfiguration()
    configuration = GAConfiguration.new
    
    begin
      jsonDictionary = JSON.parse(File.read(CONFIG_FILENAME))
      configurationMerge = GAConfiguration.new(jsonDictionary)
      configuration = configuration.merge(configurationMerge)
    rescue
      GALogger.log("#{CONFIG_FILENAME} not found, using defaults", :Warning)
    end
    
    validateConfiguration(configuration)
    outputConfiguration(configuration)
    
    return configuration
  end
  
  # Returns a possible workspace, in case one is not provided in the configuration
  #
  # @note this searches only in the current directory
  def self.findWorkspace
    workspace = value = `find . -maxdepth 1 -name '*.xcworkspace'`
    return nil if workspace.empty?
    
    return File.basename(workspace, ".*")
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
        if configuration.project.nil?
          GALogger.log("workspace or project was not specified, exiting", :Error)
          outputSampleConfiguration()
          abort
        end
      end
      
      configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationWorkspace => possibleWorkspace)
      configuration = configuration.merge(configurationMerge)
    end
    
    if configuration.scheme.nil?
      configurationMerge = nil
      
      unless configuration.project.nil?
        configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationScheme => configuration.project)
      end
      unless configuration.workspace.nil?
        configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationScheme => configuration.workspace)
      end
      
      if configurationMerge.nil?
        GALogger.log("scheme was not specified, exiting", :Error)
        outputSampleConfiguration()
        abort
      else
        configuration = configuration.merge(configurationMerge)
      end
    end
    
    if configuration.target.nil?
      configurationMerge = nil
      
      unless configuration.scheme.nil?
        configurationMerge = GAConfiguration.new(GAConfiguration::GAConfigurationTarget => configuration.scheme + 'Tests')
      end
      
      if configurationMerge.nil?
        GALogger.log("target was not specified, exiting", :Error)
        outputSampleConfiguration()
        abort
      else
        configuration = configuration.merge(configurationMerge)
      end
    end
    
    xctoolExists = system("which #{configuration.xctool_path} > /dev/null")
    if !xctoolExists
      GALogger.log(configuration.xctool_path + " can't be found. Aborting.", :Error)
      abort
    end
  end
  
  # Outputs a sample configuration to let the user know how to create a valid one
  #
  # (see #GAConfiguration)
  def self.outputSampleConfiguration()
    GALogger.log('Sample configuration JSON: ' + GAConfiguration.sample.to_s, :Warning)
  end
  
  # Outputs a given configuration on the console
  # 
  # @param [GAConfiguration] the configuration you want to print
  def self.outputConfiguration(configuration)
    puts configuration.to_s
  end
  
  # Returns a filename from a given array
  #
  # @param argv [Array<String>] an array of strings
  #
  # @note the method will take the last element of the array
  # @note the method will take only the filename if the element of the array is a file, removing the extension and the path
  def self.getFileFromArgv(argv) 
    fileToTest = nil
    argv.each do|a| 
      fileToTest = File.basename(a, ".*")
    end

    if fileToTest.nil?
      GALogger.log('Failed to get file', :Error)
      abort
    end
    
    return fileToTest
  end
end