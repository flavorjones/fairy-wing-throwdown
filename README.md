# Fairy-Wing Throwdown

or

## JSON v XML: How much slower, exactly, is XML in the real world?

### TL;DR

1. Is XML parsing more than an order of magnitude (i.e., 10x) slower than JSON parsing in real world situations?
2. Both @pauldix and @flavorjones think XML parsing is slower than than JSON parsing.
3. @pauldix says XML parsing is *more* than an order of magnitude slower than JSON parsing.
4. @flavorjones says XML parsing is *less* than an order of magnitude slower than JSON parsing.

### Tentative conditions of the bet

1. Benchmarks must be performed on Ruby 1.8.7 with any standard compiled extensions / gems.
2. Objective output is the data structure represented in `data.json`.
3. Timing should encompass only in-memory operations (not IO)
4. Data set should be what a specific service used by Benchmark Solutions (where Paul and I work) in real life. See `data.json`.
5. @jvshahid will be the arbiter of whether the implementations violate the spirit of "real world".
