require 'minitest/autorun'
require 'fiddlesticks/core'

class FiddlesticksTest < Minitest::Test

  def setup
    @num_rows = 100000
    @num_col  = 10
    @data     = Array.new(@num_rows) { Array.new(@num_col) { "X"* 1000 } }
  end

  def test_basic_flow
    optimize = Fiddlesticks::Core.new

    assert_respond_to(optimize, :measure)

    result = optimize.measure do
      csv = @data.map do |row|
        row.join(",")
      end.join("\n")
    end

    assert_equal(result[0][0], "Ruby Version")
    assert_equal(result[0][1], "GC")
    assert_equal(result[0][2], "GC Sweeps")
    assert_equal(result[0][3], "Total Memory")
    assert_equal(result[0][4], "Memory Used")
    assert_equal(result[0][5], "Time")

    assert_equal(result[1][0], RUBY_VERSION)
    assert_equal(result[1][1], "enabled")
    assert(result[1][2].to_s =~ /\A\s*(\d{2})\s*\Z/)
    assert(result[1][3].to_s =~ /\A\s*(\d+\.*\d{0,4})\s*(GB)\s*\Z/)
    assert(result[1][4].to_s =~ /\A\s*(\d+\.*\d{0,4})\s*(MB)\s*\Z/)
    assert(result[1][5].to_s =~ /\A\s*(\d+.?\d+)\s*(Seconds)\s*\Z/)
  end

  def test_configuration
    optimize = Fiddlesticks::Core.new

    assert_respond_to(optimize, :configure)

    optimize.configure(total_memory: :mb, used_memory: :gb)

    result = optimize.measure do
      csv = @data.map do |row|
        row.join(",")
      end.join("\n")
    end

    assert_equal(result[0][0], "Ruby Version")
    assert_equal(result[0][1], "GC")
    assert_equal(result[0][2], "GC Sweeps")
    assert_equal(result[0][3], "Total Memory")
    assert_equal(result[0][4], "Memory Used")
    assert_equal(result[0][5], "Time")

    assert_equal(result[1][0], RUBY_VERSION)
    assert_equal(result[1][1], "enabled")
    assert(result[1][2].to_s =~ /\A\s*(\d{0,2})\s*\Z/)
    assert(result[1][3].to_s =~ /\A\s*(\d+\.*\d+\.*\d{0,4})\s*(MB)\s*\Z/)
    assert(result[1][4].to_s =~ /\A\s*(\d+\.*\d{0,4})\s*(GB)\s*\Z/)
    assert(result[1][5].to_s =~ /\A\s*(\d+.?\d+)\s*(Seconds)\s*\Z/)
  end

end
