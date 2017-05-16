require "benchmark"
require "color-console"
require "fiddlesticks/os"

class Fiddlesticks

  def measure(&block)
    no_gc = (ARGV[0] == "--no-gc")
    no_gc ? GC.disable : GC.start

    memory_before   = `ps -o rss= -p #{Process.pid}`.to_i/1024
    gc_stat_before  = GC.stat

    time = Benchmark.realtime do
      yield
    end

    unless no_gc
      GC.start(full_mark: true, immediate_sweep: true, immediate_mark: false)
    end

    gc_stat_after = GC.stat
    memory_after  = `ps -o rss= -p #{Process.pid}`.to_i/1024

    if OS.windows?
      total_memory = "Support coming soon"
    elsif OS.mac?
      total_memory = "%d GB" % (`sysctl hw.memsize`.split(" ").last.to_i/1024/1024/1000)
    elsif OS.linux?
      total_memory = %x(free).split(" ")[7].to_i/1024
    else
      total_memory = "OS Not Found!"
    end

    memory_used = "%d MB" % (memory_after - memory_before)

    gc = no_gc ? "disabled" : "enabled"
    gc_count = gc_stat_after[:count] - gc_stat_before[:count]


    header = ["Ruby Version", "GC", "GC Sweeps", "Total Memory", "Memory Used", "Time"]
    data   = [ RUBY_VERSION, gc, gc_count, total_memory, memory_used, time.round(2)]

    Console.display_table([header, data], width: 100, col_sep: "|", row_sep: "-")
  end
end
