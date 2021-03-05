# find.cr

This shard is inspired by the Ruby module:

https://ruby-doc.org/stdlib-2.7.2/libdoc/find/rdoc/index.html

It implements a simple API for the top down traversal of a set of paths.

The API is simple.

```
require 'find'

total_size = 0

Find.find(ENV["HOME"]) do |path|
  if File.directory?(path)
    if File.basename(path).start_with?('.')
      Find.prune       # Don't look any further into this directory.
    else
      next
    end
  end

  total_size += FileTest.size(path)
end
```