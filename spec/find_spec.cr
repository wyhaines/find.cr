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
  # FileUtils.rm_rf(tmpdir) if tmpdir && tmpdir.open?
  FileUtils.rm_rf tempdir if !tempdir.nil? && File.exists?(tempdir) && File.directory?(tempdir)
end

describe Find do
  it "works on an empty directory" do
    with_tmpdir do |tempdir|
      a = [] of String?
      Find.find(tempdir) { |f| a << f }
      a.should eq [tempdir]
    end
  end

  it "works if asked to find something that does not exist" do
  end
end
