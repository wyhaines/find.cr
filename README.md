# find.cr

![SplayTreeMap CI](https://img.shields.io/github/workflow/status/wyhaines/find.cr/SplayTreeMap%20CI?style=for-the-badge&logo=GitHub)
[![GitHub release](https://img.shields.io/github/release/wyhaines/find.cr.svg?style=for-the-badge)](https://github.com/wyhaines/find.cr/releases)
![GitHub commits since latest release (by SemVer)](https://img.shields.io/github/commits-since/wyhaines/find.cr/latest?style=for-the-badge)

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

![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/wyhaines/find.cr?style=for-the-badge)
![GitHub issues](https://img.shields.io/github/issues/wyhaines/find.cr?style=for-the-badge)