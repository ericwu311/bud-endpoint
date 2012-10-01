#TODO: better namespace and require, by creating a BudEndpoint module
require_relative '../php_scheduler'

class PhpCmd
  @queue = :php_file_queue

  def self.perform(filename, options={})
    options.symbolize_keys!
    
    if system(cmd filename)
      # success!  move on
    else
      puts "====", options[:num_of_tries], "-======="
      PhpScheduler.schedule(filename, :num_of_tries => options[:num_of_tries])
    end
  end

  def self.cmd(filename)
    "php uploader_cmdline.php -input_file='#{filename}'"    
  end
end
