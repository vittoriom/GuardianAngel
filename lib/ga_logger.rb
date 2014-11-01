# @author Vittorio Monaco
class GALogger
  :Error
  :Warning
  :Success
  :Default
  
  # Logs a message on the console
  #
  # @param message [String] a string to log
  # @param type [Symbol] specifies the type of message. This can be :Error, :Warning, :Success or :Default
  # @note depending on the message type, a different color will be used to print the message on the console
  def self.log(message, type = :Default)
    puts sequenceForType(type) + '### ' + message + ' ###' + sequenceForType(:Default)
  end
  
  # Returns the character code to print with the right color given a message type
  #
  # @param type [Symbol] the message type. This can be :Error, :Warning, :Success or :Default
  def self.sequenceForType(type)
    case type
    when :Success
      return "\033[32m"
    when :Error
      return "\033[31m"
    when :Warning
      return "\033[33m"
    else
      return "\033[0m"
    end
  end
end