module Fiddlesticks
  module Memory

    def get_memory type
      type.to_sym
      memory = `ps -o rss= -p #{Process.pid}`.to_f

      case type
      when :mb then memory = memory/1024
      when :gb then memory = memory/1024/1024
      when :kb then memory
      end

      return memory if [:kb, :mb, :gb].include?(type)
      raise ArgumentError.new("Argument is not of type Symbol, expected one of(:kb, :mb, :gb)")
    end

    def total_memory type
      type.to_sym
      os = ""

      if OS.windows?
        total_memory = ""
        os = "Windows"
      elsif OS.mac?
        total_memory = `sysctl hw.memsize`.split(" ").last.to_i
        os = "Mac"
      elsif OS.linux?
        total_memory = %x(free).split(" ")[7].to_i
        os = "Linux"
      else
        total_memory = ""
        os = "Unkown OS"
      end

      case type
      when :kb then total_memory
      when :mb then total_memory = total_memory/1024
      when :gb then total_memory = total_memory/1024/1024/1000
      end

      return "%.2f #{type.upcase}" % total_memory if [:kb, :mb, :gb].include?(type) && total_memory.is_a?(Integer)

      raise ArgumentError.new("Argument is not of type Symbol, expected one of(:kb, :mb, :gb)")
      raise NotImplementedError.new("Fiddlesticks either lack support or could not figure out the os: #{os}") if ["Windows", "Unkown OS"].include?(os)
    end

    def calculate_memory before, after, type
      before.to_f && after.to_f && type.to_sym

      memory_used = after - before
      return memory_used = "%g #{type.upcase}" % ("%.4f" % memory_used) unless memory_used == 0
      "Less than 1 MB"
    end
  end
end
