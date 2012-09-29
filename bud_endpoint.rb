# 
# Web API for receiving zip file uploads from sensing node.
#
# Uses Goliath, an aysnc ruby web server framework.
#
require 'goliath'

class BudEndpoint < Goliath::API
  use Goliath::Rack::Params           # parse & merge query and body parameters
  use Goliath::Rack::DefaultMimeType  # cleanup accepted media types
  use Goliath::Rack::Formatters::JSON # JSON output formatter
  use Goliath::Rack::Render           # auto-negotiate response format
  use Goliath::Rack::Heartbeat

  DATA= "DAQ_buff"
  CLEANED= "DAQ_cleaned"

  def response(env)
    logger.info "Received: #{params}"
    time = Time.now.to_f
    z = {}
    if params["uploaded"] and params["uploaded"][:tempfile]
      zipped_data = params["uploaded"][:tempfile].read
      begin
        filename = app_folder + "/data/#{time}.zip"
        File.open(filename, 'wb') { |f| f.write(zipped_data) }
        z = params["uploaded"].merge({:output_filename => filename})
        z.delete(:tempfile)
      rescue Exception => e
        logger.error "Exception: #{e.message}"
      end
    else
      logger.info "DAQ received non-data packet:  #{params.inspect}"
      return [200,{},{}]
    end
    z.default = nil
    params.default = nil
    x = params.merge({:ts => time, "uploaded" => z})
    logger.info "DAQ_buff: #{x}"
    redis.rpush "DAQ_buff", Marshal.dump(x)
    redis.set "DAQ_last_received_ts", time.to_i
    [201, {}, {}]
  end

end

# curl -i -F uploaded=@/Users/ericzou/Downloads/text_file.txt http://54.243.213.2:9000