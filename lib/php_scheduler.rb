class PhpScheduler

  def self.schedule(filename, options={})
    num_of_tries = options[:num_of_tries]
    case num_of_tries
    when nil, 0
      Resque.enqueue(PhpCmd, filename, :num_of_tries => 1)
    when 1..5
      Resque.enqueue_in(5.seconds, PhpCmd, filename, :num_of_tries => num_of_tries + 1)
    else
      # give up, emailing, logging, screaming, do something here
    end
  end

end