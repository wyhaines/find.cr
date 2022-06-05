class Find
  include Enumerable({Path, File::Info})

  struct Skip; end

  macro prune
    next Find::Skip
  end

  class RaceError < Exception; end

  # For ruby compatibility
  #
  # * Skips dangling symlinks
  def self.find(*paths)
    paths = paths.compact_map { |path| Path[path] }

    new(paths).each do |path, info|
      yield(path)
    end
  end

  def self.new(*paths)
    new paths.compact_map { |path| Path[path] }
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
            fs = Dir.open(file) do |dir|
              {% if Dir.has_method?(:info) %} # Crystal >= 1.5.0?
                dinfo = dir.info
                raise RaceError.new unless dinfo.same_file?(info)
              {% end %}
              dir.children
            end
          rescue ex
            dir_children_error file, ex
            next
          end

          fs.sort.reverse!.each { |f| search_path.push(file.join(f)) }
        end
      end
    end
  end

  # Override
  @[Experimental]
  protected def dir_children_error(path, ex) : Nil
  end
end
