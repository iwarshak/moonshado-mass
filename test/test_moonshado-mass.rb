require 'helper'

class TestMoonshadoMass < Test::Unit::TestCase
  should "handle normal working case" do
    @client = Moonshadosms::Sender.new('66637', 'keyword', 'abc123')
    @numbers = ['2105555555']
    RestClient.stubs(:post)
    Crack::XML.stubs(:parse).returns({"status" => {"code" => "10", :info => "yay"}})
    
    response_handler = Object.new
    response_handler.expects(:handler).times(1)
    @client.response_callbacks << Proc.new{|c| response_handler.handler(c)}
    @client.deliver("test", @numbers)
  end
  
  should "handle a number error" do
    @client = Moonshadosms::Sender.new('66637', 'keyword', 'abc123')
    @numbers = ['2105555555']
    RestClient.stubs(:post)
    Crack::XML.stubs(:parse).returns({"status" => {"code" => "11", :info => "oops"}})
    
    error = Object.new
    error.expects(:handler).with(regexp_matches(/Error in Moonshado SMS/)).times(1)
    @client.error_callback = Proc.new {|c| error.handler(c)}
    @client.deliver("test", @numbers)
  end
  
  should "handle exceptions" do    
    @client = Moonshadosms::Sender.new('66637', 'keyword', 'abc123')
    @numbers = ['2105555555']
    
    exception_handler = Object.new
    exception_handler.expects(:handler).with(anything, anything).times(1)
    @client.exception_callback = Proc.new do |ex, opts| 
      exception_handler.handler(ex, opts)
    end
    
    mailer_handler = Object.new
    mailer_handler.expects(:handler).with(regexp_matches(/Exception in Moonshado SMS/), anything).times(1)
    @client.mailer_callback = Proc.new do |subject, body| 
      mailer_handler.handler(subject, body)
    end
    
    logger = Object.new
    logger.expects(:error).with(regexp_matches(/Caught exception sending message to/)).times(1)
    @client.logger = logger
    
    RestClient.stubs(:post).raises
    @client.deliver("test", @numbers)
  end
end
