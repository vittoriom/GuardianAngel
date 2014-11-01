# @author Vittorio Monaco
class GAConfiguration
  GAConfigurationScheme = "scheme"
  GAConfigurationWorkspace = "workspace"
  GAConfigurationTarget = "target"
  GAConfigurationSuffix = "suffix"
  GAConfigurationReporter = "reporter"
  GAConfigurationXctoolPath = "xctool"
  GAConfigurationProject = "project"
  
  GAConfigurationDefaultReporter = "pretty"
  GAConfigurationDefaultXctoolPath = "xctool"
  GAConfigurationDefaultSuffix = "Test"

  # @return the configured xcode scheme
  def scheme
    @scheme
  end
  
  # @return the configured xcode project, if not using workspaces
  def project
    @project
  end
  
  # @return the configured xcode workspace, if not using projects
  def workspace
    @workspace
  end
  
  # @return the configured suffix for tests files
  def suffix
    @suffix
  end
  
  # @return the configured xcode tests target
  def target
    @target
  end
  
  # @return the configured xctool reporter
  def reporter
    @reporter
  end
  
  # @return the configured xctool executable path
  def xctool_path
    @xctool_path
  end
  
  # Prints the configuration instance
  # @return a [String] representation of the instance 
  def to_s
    hashForOutput = {
      GAConfigurationScheme => @scheme,
      GAConfigurationWorkspace => @workspace,
      GAConfigurationTarget => @target,
      GAConfigurationSuffix => @suffix,
      GAConfigurationReporter => @reporter,
      GAConfigurationXctoolPath => @xctool_path,
      GAConfigurationProject => @project
    }
    
    return hashForOutput.to_s
  end
  
  # Creates a sample GAConfiguration instance to instruct the user
  #
  # @return [GAConfiguration] an instance that should not be used apart from outputting on the console
  def self.sample
    sample = GAConfiguration.new({
      GAConfigurationWorkspace => 'MyProject',
      GAConfigurationScheme => 'MyProject-Dev',
      GAConfigurationTarget => 'MyProjectTests',
      GAConfigurationSuffix => GAConfigurationDefaultSuffix,
      GAConfigurationReporter => GAConfigurationDefaultReporter,
      GAConfigurationXctoolPath => GAConfigurationDefaultXctoolPath
    })
        
    return sample
  end
  
  # Creates an instance with the given configuration, or uses a default one if not provided
  # @param configuration [GAConfiguration]
  #
  # @note by default the #suffix is implied as "Test", the #reporter as "pretty" and the #xctool_path as "xctool"
  def initialize(configuration = { GAConfigurationSuffix => "Test", GAConfigurationReporter => "pretty", GAConfigurationXctoolPath => "xctool" })
    @scheme = configuration[GAConfigurationScheme]
    @workspace = configuration[GAConfigurationWorkspace]
    @target = configuration[GAConfigurationTarget]
    @suffix = configuration[GAConfigurationSuffix]
    @reporter = configuration[GAConfigurationReporter]
    @xctool_path = configuration[GAConfigurationXctoolPath]
    @project = configuration[GAConfigurationProject]
  end
  
  # Merges two GAConfiguration instances
  #
  # @param other [GAConfiguration] another instance of GAConfiguration you want to merge
  # @note nil values will not overwrite valid values of self
  def merge(other)
    unless other.scheme.nil?
      @scheme = other.scheme
    end
    unless other.workspace.nil?
      @workspace = other.workspace
    end
    unless other.target.nil?
      @target = other.target
    end
    unless other.suffix.nil?
      @suffix = other.suffix
    end
    unless other.reporter.nil?
      @reporter = other.reporter
    end
    unless other.xctool_path.nil?
      @xctool_path = other.xctool_path
    end
    unless other.project.nil?
      @project = other.project
    end
    
    return self
  end
end