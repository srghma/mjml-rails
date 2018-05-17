require 'rails/generators/erb/mailer/mailer_generator'

module Mjml
  module Generators
    class MailerGenerator < Erb::Generators::MailerGenerator
      source_root File.expand_path('templates', __dir__)

      protected

      def format
        nil # Our templates have no format
      end

      def formats
        [format]
      end

      def handler
        :mjml
      end
    end
  end
end
