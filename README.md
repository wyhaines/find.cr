![SplayTreeMap CI](https://img.shields.io/github/workflow/status/wyhaines/find.cr/Find.cr%20CI?style=for-the-badge&logo=GitHub)
[![GitHub release](https://img.shields.io/github/release/wyhaines/find.cr.svg?style=for-the-badge)](https://github.com/wyhaines/find.cr/releases)
![GitHub commits since latest release (by SemVer)](https://img.shields.io/github/commits-since/wyhaines/find.cr/latest?style=for-the-badge)

# find.cr

This shard is inspired by the Ruby module:

https://ruby-doc.org/stdlib-2.7.2/libdoc/find/rdoc/index.html

It implements a simple API for the top down traversal of a set of paths, and it provides a convenience method for a simple-to-use matching system that depends on Crystal's file matching syntax.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     find:
       github: wyhaines/find.cr
   ```

## Usage

```crystal
require "find"
```

The API is simple.

```crystal
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