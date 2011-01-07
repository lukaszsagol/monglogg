module Monggler
  class Helper
    class << self
      def current_app_name
        Rails.application.class.name.split('::').first.underscore
      end
    end
  end
end
