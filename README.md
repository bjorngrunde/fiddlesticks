# fiddlesticks

Simple wrapper to measure optimization or to find bottlenecks in your codebase.

As for now: 
 Works on Mac.
 Not yet tested in Linux distributions.
 Not yet implemented support for Windows.

Install
```
gem install fiddlesticks
```
Gem File

```
gem 'fiddlesticks', '~> 0.2.0'
```
Use
```
optimize = Fiddlesticks::Core.new

optimize.measure do
  100000.times do
    "SOME STRING".downcase
  end
 end
 ```
 The ***measure*** method will accept a block and print a table with usefull information that may help when optimizing your code.
 
 ```
+--------------+---------+-----------+--------------+-------------+--------------+
| Ruby Version | GC      | GC Sweeps | Total Memory | Memory Used | Time         |
+--------------+---------+-----------+--------------+-------------+--------------+
| 2.4.0        | enabled |        32 | 16.00 GB     | 1936.08 MB  | 1.37 Seconds |
+--------------+---------+-----------+--------------+-------------+--------------+

```

If you want to print out memory in different formats user ***configure*** method. It accepts a Hash  with the keys:
 1. total_memory: [Symbol] format: ':kb', ':mb', ':gb', standard ':gb'
 2. used_memory: [Symbol] format: ':kb', ':mb', ':gb', standard ':mb'
 3. gc_enabled: [Boolean] format: 'true, 'false', standard 'true'
 
```
optimize = Fiddlesticks::Core.new

optimize.configure({total_memory: :mb, used_memory: :kb, gc_enabled: false })

optimize.measure do
 #run a block of code
end
```
Will support Mac, Linux and Windows once the project is completed.
