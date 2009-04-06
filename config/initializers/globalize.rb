I18n.load_path << "#{RAILS_ROOT}/config/locales"
I18n.load_path.push File.join(RAILS_ROOT,"lib","plugins","**","locales")
require 'globalize/i18n/missing_translations_log_handler'
I18n.missing_translations_logger = RAILS_DEFAULT_LOGGER
I18n.exception_handler = :missing_translations_log_handler