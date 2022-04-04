class Find
  include Enumerable({Path, File::Info})

  struct Skip; end

  macro prune
    next Find::Skip
  end

  # Skips dangling symlinks for compatibility with ruby
  def self.find(*paths)
    paths = paths.compact_map { |path| Path[path] }

    new(paths).each do |path, info|
      exists = File.exists?(path) rescue false
      yield(path.to_s) if exists
    end
  end

  def self.new(paths : Enumerable(String?))
    new paths.compact_map { |path| Path.new(path) }
  end

  def initialize(@paths : Enumerable(Path))
  end

  def each
    search_path = [] of Path
    @paths.each do |path|
      search_path << path
      while !search_path.empty?
        file = search_path.pop

        info = File.info?(file, follow_symlinks: false)
        next unless info # File deleted beteen list and now

        skip = yield({file.not_nil!, info.not_nil!})
        next if skip == Find::Skip

        if info.directory?
          begin
            fs = Dir.children(file)
          rescue ex
            dir_children_error ex
            next
          end

          fs.sort.reverse!.each { |f| search_path.push(file.join(f)) }
        end
      end
    end
  end

  # Override
  protected def dir_children_error(ex) : Nil
  end
end
