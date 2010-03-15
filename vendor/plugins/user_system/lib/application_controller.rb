class ApplicationController < ActionController::Base

  def initialize #:nodoc:
    super
    ApplicationController.save_instance(self)
  end
  def self.save_instance(c) #:nodoc:
    @instance = c
  end
  def self.get_controller #:nodoc:
    @instance
  end
end