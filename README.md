# find.cr

Ruby had a very simple built in library for searching through a set of paths:

https://ruby-doc.org/stdlib-2.7.2/libdoc/find/rdoc/index.html

It implemented a very simple API -- `find(*paths)` to search a set of paths,

The method would yield to a block for each path found, and within the block, a call to `Find.prune` would immediately skip to the next path. It was very simple, and easy to use.

This shard is intended as a spiritual successor to that shard, implementing the same very simple API. It may grow some new features over time, but those will be driven by need.
