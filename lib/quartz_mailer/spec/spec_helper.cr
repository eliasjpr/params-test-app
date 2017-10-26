require "spec"
require "expect"
require "../src/quartz_mailer"

class TestMailer < Quartz::Mailer
  def initialize
    super
    from "from@test.com"
  end

  def deliver
    to "to@test.com"
    super
  end
end
