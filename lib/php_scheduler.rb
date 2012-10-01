#TODO add check for infinit loop
class PhpScheduler

  GiveUpException = Class.new(StandardError)

  def self.schedule(filename, options={})
    options.symbolize_keys!

    num_of_tries = options[:num_of_tries]
    case num_of_tries
    when nil, 0
      Resque.enqueue(PhpCmd, filename, :num_of_tries => 1)
    when 1..5
      Resque.enqueue_in(5.seconds, PhpCmd, filename, :num_of_tries => num_of_tries + 1)
    else
      raise GiveUpException, "Php scheduler gave up file #{filename}, tried #{num_of_tries} times - at #{Time.now}"
      # give up, emailing, logging, screaming, do something here
    end
  end

end
