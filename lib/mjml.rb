require 'action_view'
require 'action_view/template'
require 'mjml/mjmltemplate'
require 'mjml/railtie'
require 'rubygems'

module Mjml
  mattr_accessor :template_language, :raise_render_exception, :mjml_binary_version_supported, :mjml_binary_error_string

  @@template_language = :erb
  @@raise_render_exception = false
  @@mjml_binary_version_supported = '4.0.'
  @@mjml_binary_error_string = "Couldn't find the MJML #{Mjml.mjml_binary_version_supported} binary.. have you run $ npm install mjml?"

  def self.check_version(bin)
    IO.popen("#{bin} --version") { |io| io.read.include?("mjml-core: #{Mjml.mjml_binary_version_supported}") }
  rescue StandardError
    false
  end

  def self.discover_mjml_bin
    # Check for a global install of MJML binary
    mjml_bin = 'mjml'
    return mjml_bin if check_version(mjml_bin)

    # Check for a local install of MJML binary
    installer_path = (`npm bin` || `yarn bin`).chomp
    mjml_bin = File.join(installer_path, 'mjml')
    return mjml_bin if check_version(mjml_bin)

    puts Mjml.mjml_binary_error_string
    nil
  end

  BIN = discover_mjml_bin

  class Handler
    def template_handler
      @_template_handler ||= ActionView::Template.registered_template_handler(Mjml.template_language)
    end

    def call(template)
      compiled_source = template_handler.call(template)
      if template.formats.include?(:mjml)
        "Mjml::Mjmltemplate.to_html(begin;#{compiled_source};end).html_safe"
      else
        compiled_source
      end
    end
  end

  def self.setup
    yield self if block_given?
  end
end
