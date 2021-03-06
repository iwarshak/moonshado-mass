if RUBY_VERSION =~ /1\.9/
  require 'digest/md5'
end

if RUBY_VERSION =~ /1.8/
  require 'md5'
end

module Moonshadosms
  API_ENDPOINT = 'api.moonshado.com'
  
  class Sender
    attr_accessor :originating_address, :api_key, :token, :logger, :mailer_callback, :response_callbacks, :keyword, :exception_callback, :error_callback
    
    def initialize(originating_address, keyword, api_key)
      @originating_address = originating_address
      @api_key = api_key
      @keyword = keyword
      @response_callbacks = []
    end
    
    def status(moonshado_claimcheck)
      d = {
        :api_key => @api_key,
        :reporting_keys => moonshado_claimcheck
      }
      response = RestClient.get "https://#{API_ENDPOINT}/gateway/reports", :params => d
      return response
    end
    
    def deliver(message, recipients = [])
      text = prepare_text(message)
      send_time = Time.now
      recipients.each do |recipient|
        if RUBY_VERSION =~ /1\.9/
          moonshado_claimcheck = Digest::MD5.hexdigest(Time.now.to_s + rand.to_s + recipient).to_s
        elsif RUBY_VERSION =~ /1.8/
          moonshado_claimcheck = MD5.md5(Time.now.to_s + rand.to_s + recipient).to_s
        end
        d = {
              :api_key => @api_key,
              :message => {
                :reporting_key => moonshado_claimcheck,
                :originating_address => @originating_address,
                :device_address => prepend_country_code(recipient),
                :keyword => @keyword,
                :shorten => 'truncate',
                :body => text
              }
        }
        response = nil
        begin
          response = RestClient.post "https://#{API_ENDPOINT}/gateway/sms", d
          code = Crack::XML.parse(response)["status"]["code"] rescue nil
          info = Crack::XML.parse(response)["status"]["info"] rescue nil          
          if code == "10"
            logger.info("response #{response}") if logger
            logger.info("Sent #{message} to #{recipient} Info: #{info}") if logger
            response_callbacks.each do |response_callback|
              response_callback.call(:recipient => recipient, :moonshado_claimcheck => moonshado_claimcheck )
            end
          else
            error_str = "Could not send message to #{recipient}. Code: #{code} Info: #{info} Error: #{response}"
            logger.error("Error in Moonshado SMS #{error_str}") if logger
            mailer_callback.call("Error in Moonshado SMS", error_str) if mailer_callback
            error_callback.call("Error in Moonshado SMS. #{error_str}") if error_callback
          end
        rescue => ex
          exception_class = ex.class          
          if response && response.respond_to?(:body)
            response_string = "Exception: #{exception_class} - #{response.body}\n#{d}\n#{ex.inspect}"
          else
            response_string = "Exception: #{exception_class} - #{d}\n#{ex.inspect}"
          end
          logger.error("Caught exception sending message to #{recipient}. Error: #{response_string}") if logger
          mailer_callback.call("Exception in Moonshado SMS", "#{response_string}") if mailer_callback
          exception_callback.call(ex, d.merge(:response => response_string)) if exception_callback
        end        
      end
    end
    
    private
    
    def prepend_country_code(number)
      if number =~ /^1/
        number
      else
        "1#{number}"
      end
    end
    
    def prepare_text(message)
      strip_unicode(message)[0..159]
    end
  
    def strip_unicode(message)
      message.unpack("c*").reject {|c| c <0 || c>255}.pack("c*")
    end
  end
end