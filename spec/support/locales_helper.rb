require 'i18n'

# load our gem locales files
I18n.load_path += Dir[File.join(File.expand_path(__dir__), '../../', 'config/locales', '*.yml')]
