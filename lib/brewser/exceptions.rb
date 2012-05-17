module Brewser
  # A general exception
  class Error < StandardError; end

  # Raised when behavior is not implemented, usually used in an abstract class.
  class NotImplemented < Error; end

  # Raised when removed code is called, an alternative solution is provided in message.
  class ImplementationRemoved < Error; end

end