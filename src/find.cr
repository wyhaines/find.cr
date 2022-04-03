module Find
  struct Skip; end

  macro prune
    next Find::Skip
  end

  # Skips dangling symlinks for compatibility with ruby
  def self.find(*paths)
    find_with_stat(*paths) do |path, info|
      exists = File.exists?(path) rescue false
      yield(path) if exists
    end
  end
  
  def self.find_with_info(*paths)
    paths.each do |path|
      search_path = [path]
      while !search_path.empty?
        file = search_path.shift
        next if file.nil?

        info = File.info?(file)
        next unless info # File deleted beteen list and now
      
        skip = yield file, info
        next if skip == Find::Skip

        if info.directory?
          begin
            fs = Dir.children(file)
          rescue
            next
          end

          fs.sort.reverse!.each { |f| search_path.unshift(File.join(file, f)) }
        end
      end
    end
  end
end
