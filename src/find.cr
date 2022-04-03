module Find
  struct Skip; end

  macro prune
    next Find::Skip
  end

  # Skips dangling symlinks for compatibility with ruby
  def self.find(*paths)
    super(*paths) do |path|
      exists = File.exists?(path) rescue false
      yield(path) if exists
    end
  end
  
  def self.find_all(*paths)
    paths.each do |path|
      search_path = [path]
      while !search_path.empty?
        file = search_path.shift
        next if file.nil?

        skip = yield file.dup
        next if skip == Find::Skip

        if File.directory?(file)
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
