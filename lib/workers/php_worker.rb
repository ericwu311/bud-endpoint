class PhpWorker
  @queue = :php_file_queue

  def self.perform(filename)
    cmd = "php uploader_cmdline.php -input_file='#{filename}'"
    system cmd
  end

end