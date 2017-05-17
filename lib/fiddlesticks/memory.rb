module Fiddlesticks
  module Memory

    def get_memory type
      memory = `ps -o rss= -p #{Process.pid}`.to_i
      case type
      when :mb then memory = memory/1024
      when :gb then memory = memory/1024/1024/1000
      else
        memory
      end
      memory
    end

    def total_memory
      if OS.windows?
        total_memory = "Support coming soon"
      elsif OS.mac?
        total_memory = "%d GB" % (`sysctl hw.memsize`.split(" ").last.to_i/1024/1024/1000)
      elsif OS.linux?
        total_memory = %x(free).split(" ")[7].to_i/1024/1024/1000
      else
        total_memory = "OS Not Found!"
      end
      total_memory
    end

    def calculate_memory before, after
      memory_used = (after - before)
      return memory_used = "%d MB" % memory_used unless memory_used == "0"
      "Less than 1 MB"
    end
  end
end