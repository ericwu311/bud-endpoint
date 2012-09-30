class PhpCmd
  @queue = :php_file_queue

  def self.perofrm(filename, options={})
    if system(cmd filename)
      # success!  move on
    else
      PhpScheudler.schedule(filename, :number_of_tries => options[:number_of_tries])
    end
  end

  def cmd(filename)
    "php uploader_cmdline.php -input_file='#{filename}'"    
  end
end
