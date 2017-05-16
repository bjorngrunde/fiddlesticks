# fiddlesticks

Simple wrapper to measure optimization or to find bottlenecks in your codebase.

As for now: W.i.P

```
  opt = Fiddlesticks.new
  opt.measure do
    1000.times do
      "SOME STRING".downcase
    end
   end
 ```
 The code will return a table with usefull information that may help when optimizing your code.
 ```
 +--------------+---------+-----------+--------------+-------------+------+
| Ruby Version | GC      | GC Sweeps | Total Memory | Memory Used | Time |
+--------------+---------+-----------+--------------+-------------+------+
| 2.4.0        | enabled |        32 | 16 GB        | 1811 MB     | 1.47 |
+--------------+---------+-----------+--------------+-------------+------+

```
Will support Mac, Linux and Windows once the project is completed.
