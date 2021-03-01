require "./spec_helper"
require "uuid"

describe Find do
  it "works on an empty directory" do
    begin
      tempdir = Dir.mkdir File.join(Dir.tempdir, UUID.random.to_s)
      a = [] of String?
      Find.find(tempdir) {|f| a << f}
      a.should eq [tempdir]
    ensure
      tempdir.close if tempdir && tempdir.open?
    end
  end
end
