require "benchmark"
require "color-console"
require "fiddlesticks/os"

module Fiddlesticks
  module Core
    def measure(&block)
      #Gargabe Collector, first argument in console to turn it off or on.
      no_gc = (ARGV[0] == "--no-gc")
      #If GC is enabled, sweep memory, starting fresh
      no_gc ? GC.disable : GC.start

      #Collect memory used before block is run
      memory_before   = `ps -o rss= -p #{Process.pid}`.to_i/1024
      #Get Garbage Collectors hash, atm used for the :count key to calculate amount of sweeps done during block execution
      gc_stat_before  = GC.stat

      #Run block
      time = Benchmark.realtime do
        yield
      end

      # Sweep the block
      unless no_gc
        GC.start(full_mark: true, immediate_sweep: true, immediate_mark: false)
      end

      #Get hash for the block that was run
      gc_stat_after = GC.stat
      #Obatin current memory after block is run
      memory_after  = `ps -o rss= -p #{Process.pid}`.to_i/1024

      #Get total memory, this needs to be improved. Should show total memory available before block?
      if OS.windows?
        total_memory = "Support coming soon"
      elsif OS.mac?
        total_memory = "%d GB" % (`sysctl hw.memsize`.split(" ").last.to_i/1024/1024/1000)
      elsif OS.linux?
        total_memory = %x(free).split(" ")[7].to_i/1024/1024/1000
      else
        total_memory = "OS Not Found!"
      end

      #Calculate memory used for the block
      memory_used = "%d MB" % (memory_after - memory_before)

      gc = no_gc ? "disabled" : "enabled"
      gc_count = gc_stat_after[:count] - gc_stat_before[:count]


      header = ["Ruby Version", "GC", "GC Sweeps", "Total Memory", "Memory Used", "Time"]
      data   = [ RUBY_VERSION, gc, gc_count, total_memory, memory_used, "#{time.round(2)} seconds"]

      Console.display_table([header, data], width: 100, col_sep: "|", row_sep: "-")
    end
  end
end