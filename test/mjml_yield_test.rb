require 'test_helper'

class YieldTestMailer < ActionMailer::Base
  self.view_paths = File.expand_path('views/yield_test_root', __dir__)
  self.mailer_name = 'yield_test'

  layout 'default'

  def foo
    mail(to: 'foo@bar.com', from: 'john.doe@example.com', &:mjml)
  end
end

class MjmlYieldTest < ActiveSupport::TestCase
  setup do
    @original_renderer = Mjml.renderer
    @original_processing_options = Mjml.processing_options
  end

  teardown do
    Mjml.renderer = @original_renderer
    Mjml.processing_options = @original_processing_options
  end

  test 'foo' do
    email = YieldTestMailer.foo
    assert_equal 'text/html', email.mime_type

    assert_match(/text in layout/, email.body.encoded.strip)
    assert_match(/text in foo/, email.body.encoded.strip)
  end
end
