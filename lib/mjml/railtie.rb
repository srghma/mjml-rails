module Mjml
  class Railtie < Rails::Railtie
    config.mjml = Mjml
    config.app_generators.mailer template_engine: :mjml

    initializer 'mjml-rails.register_template_handler' do
      handler = Mjml::Handler.new
      extension = :mjml

      # from https://github.com/joliss/markdown-rails/blob/master/lib/markdown-rails/engine.rb#L39
      if (defined? ActionView::Template::Handlers) && ActionView::Template::Handlers.respond_to?(:register_template_handler)
        ActionView::Template::Handlers
      # >= v2.1.0 <= v2.1.0
      elsif (defined? ActionView::Template) && ActionView::Template.respond_to?(:register_template_handler)
        ActionView::Template
      # >= v2.2.1 <= v2.3.8
      elsif (defined? ActionView::TemplateHandlers) && ActionView::TemplateHandlers.respond_to?(:register_template_handler)
        ActionView::TemplateHandlers
      # <= v2.0.3
      elsif (defined? ActionView::Base) && ActionView::Base.respond_to?(:register_template_handler)
        ActionView::Base
      # I give up...
      else
        raise "Couldn't find `register_template_handler' method in ActionView module."
      end.register_template_handler extension, handler

      Mime::Type.register_alias 'text/html', :mjml
    end
  end
end
