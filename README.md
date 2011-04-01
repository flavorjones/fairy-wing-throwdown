# Fairy-Wing Throwdown

or

**JSON v XML**

or

**How much slower, exactly, is XML in the real world?**

Backstory is dramatized at http://blog.flavorjon.es/2011/03/json-vs-xml-fairy-wing-throwdown.html 

### TL;DR

1. Is XML parsing more than an order of magnitude (i.e., 10x) slower than JSON parsing in real world situations?
2. Both [@pauldix][] and [@flavorjones][] think XML parsing is slower than than JSON parsing.
3. [@pauldix][] says XML parsing is *more* than an order of magnitude slower than JSON parsing.
4. [@flavorjones][] says XML parsing is *less* than an order of magnitude slower than JSON parsing.
5. The loser must wear [@flavorjones][]'s daughter's dress-up fairy wings **on stage** throughout [@pauldix][]'s RailsConf 2011 presentation.
6. Benchmarks must be performed by close of business Friday, April 1. (No, this is not an April Fool's joke.)

## Tentative Conditions

1. Benchmarks must be performed on Ruby 1.8.7 with any standard compiled extensions / gems.
2. Objective is a specific data structure actually used by these Gentlemen at their place of business, Benchmark Solutions (see `data.json`).
3. Code must take a string (JSON or XML), and return an inflated Ruby data structure exactly matching the objective.
4. Timing should encompass only in-memory operations (not IO).
5. [@jvshahid][] will be the arbiter of whether the implementations violate the spirit of "real worldiness".
  [@flavorjones]: http://twitter.com/flavorjones
  [@pauldix]: http://twitter.com/pauldix
  [@jvshahid]: http://twitter.com/jvshahid
