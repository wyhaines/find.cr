module Find
  struct Skip; end

  macro prune
     next Find::Skip
  end

  def self.find(*paths)
    paths.each do |path|
      search_path = [path]
      while !search_path.empty?
        file = search_path.shift
        skip = yield file.dup
        next if skip == Find::Skip

        begin
          next unless !file.nil? && File.exists?(file)
        rescue
          next
        end

        if File.directory?(file)
          begin
            fs = Dir.children(file)
          rescue
            next
          end

          fs.sort.reverse.each { |f| search_path.unshift(File.join(file, f)) }
        end
      end
    end
  end
end