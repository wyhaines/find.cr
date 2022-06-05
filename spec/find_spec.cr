require "./spec_helper"
require "uuid"
require "file_utils"

def make_tmpdir(path : String? | Path = nil)
  dirname = nil
  if path.nil?
    dirname = File.join(Dir.tempdir, UUID.random.to_s)
  else
    dirname = File.join(Dir.tempdir, path)
  end
  Dir.mkdir dirname

  dirname
rescue
  nil
end

def with_tmpdir(path : Nil | String | Path = nil, &blk : String ->)
  tempdir = make_tmpdir(path)
  if !tempdir.nil? && File.exists? tempdir
    Dir.open(tempdir) { blk.call(tempdir) }
  end
ensure
  FileUtils.rm_rf tempdir if !tempdir.nil? && File.exists?(tempdir) && File.directory?(tempdir)
end

describe Find do
  it "works on an empty directory" do
    with_tmpdir do |tempdir|
      a = [] of String
      Find.find(tempdir) { |f| a << f.to_s }
      a.should eq [tempdir]
    end
  end

  it "works if asked to find something that does not exist" do
    with_tmpdir do |tempdir|
      a = [] of String
      Find.find(File.join(tempdir, "a")) { |f| a << f.to_s }
      a.empty?.should be_true
    end
  end

  it "finds the expected set of files in a multilevel directory structure" do
    with_tmpdir do |tempdir|
      File.open("#{tempdir}/a", "w") { }
      Dir.mkdir("#{tempdir}/b")
      File.open("#{tempdir}/b/a", "w") { }
      File.open("#{tempdir}/b/b", "w") { }
      Dir.mkdir("#{tempdir}/c")
      a = [] of String
      Find.find(tempdir) { |f| a << f.to_s }
      a.should eq [tempdir, "#{tempdir}/a", "#{tempdir}/b", "#{tempdir}/b/a", "#{tempdir}/b/b", "#{tempdir}/c"]
    end
  end

  it "deals with relative paths correctly" do
    with_tmpdir do |tempdir|
      File.open("#{tempdir}/a", "w") { }
      Dir.mkdir("#{tempdir}/b")
      File.open("#{tempdir}/b/a", "w") { }
      File.open("#{tempdir}/b/b", "w") { }
      Dir.mkdir("#{tempdir}/c")
      a = [] of String
      Dir.cd(tempdir) { Find.find(".") { |f| a << f.to_s } }
      a.should eq [".", "./a", "./b", "./b/a", "./b/b", "./c"]
    end
  end

  it "can prune entries out of the list of paths" do
    with_tmpdir do |tempdir|
      File.open("#{tempdir}/a", "w") { }
      Dir.mkdir("#{tempdir}/b")
      File.open("#{tempdir}/b/a", "w") { }
      File.open("#{tempdir}/b/b", "w") { }
      Dir.mkdir("#{tempdir}/c")
      a = [] of String
      Find.find(tempdir) do |f|
        a << f.to_s
        Find.prune if f.to_s == "#{tempdir}/b"
      end
      a.should eq [tempdir, "#{tempdir}/a", "#{tempdir}/b", "#{tempdir}/c"]
    end
  end
end
