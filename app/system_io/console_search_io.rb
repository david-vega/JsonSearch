class ConsoleSearchIO
  def initialize

  end

  def start
    while true
      input = gets.chomp

      system 'clear'

      puts input
      break if input == 'exit'
    end
  end
end
