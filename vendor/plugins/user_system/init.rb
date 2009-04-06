require "application_controller"
ApplicationController.send(:include, UserSystem)
I18n.load_path << "#{RAILS_ROOT}/vendor/plugins/user_system/locales"