require "benchmark"
require "color-console"
require "fiddlesticks/os"
require "fiddlesticks/memory"

module Fiddlesticks
  class Core
    include OS
    include Memory


    def initialize(total_memory: :gb, used_memory: :mb, gc_enabled: true)
      @config = {
        total_memory: total_memory,
        used_memory: used_memory,
        gc_enabled: gc_enabled
      }
      @valid_keys = @config.keys
    end

    def configure(opt = {})
      opt.each { |k, v| @config[k.to_sym] = v if @valid_keys.include? k.to_sym }
    end

    def measure(&block)
      total_memory_type = @config.fetch(:total_memory)
      used_memory_type  = @config.fetch(:used_memory)
      gc_enabled   = @config.fetch(:gc_enabled)

      gc_enabled ? GC.start : GC.disable
      memory_before = get_memory(used_memory_type)
      gc_stat_before  = GC.stat

      time = Benchmark.realtime do
        yield
      end

      if gc_enabled
        GC.start(full_mark: true, immediate_sweep: true, immediate_mark: false)
      end

      gc_stat_after = GC.stat
      memory_after  = get_memory(used_memory_type)
      memory_total = total_memory(total_memory_type)

      puts "#{memory_before} #{memory_after}"
      memory_used = calculate_memory(memory_before, memory_after, used_memory_type)

      gc = gc_enabled ? "enabled" : "disabled"

      gc_count = gc_stat_after[:count] - gc_stat_before[:count]


      header = ["Ruby Version", "GC", "GC Sweeps", "Total Memory", "Memory Used", "Time"]
      data   = [ RUBY_VERSION, gc, gc_count, memory_total, memory_used, "#{time.round(2)} Seconds"]

      Console.display_table([header, data], width: 100, col_sep: "|", row_sep: "-")
    end
  end
end