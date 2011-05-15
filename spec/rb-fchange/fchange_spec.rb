# -*- encoding: utf-8 -*-
require 'spec_helper'

describe FChange do

  before(:each) do
    @results = []
    @notifier = FChange::Notifier.new
    @notifier.watch(@fixture_path.to_s, :recursive) do |event|
      @results += [event.watcher.path]
    end
  end

  it "should work with path with an apostrophe" do
    custom_path = @fixture_path.join("custom 'path")
    file = custom_path.join("newfile.rb").to_s
    begin
      File.delete file
    rescue
    end
    run
    FileUtils.touch file
    stop
    begin
      File.delete file
    rescue
    end
    @results.include?(@fixture_path.to_s).should be_true
  end

  it "should catch new file" do
    file = @fixture_path.join("newfile.rb")
    begin
      File.delete file
    rescue
    end
    run
    FileUtils.touch file
    stop
    begin
      File.delete file
    rescue
    end
    @results.include?(@fixture_path.to_s).should be_true
  end

  it "should catch file update" do
    file = @fixture_path.join("folder1/file1.txt")
    File.exists?(file).should be_true
    run
    FileUtils.touch file
    stop
    @results.include?(@fixture_path.to_s).should be_true
  end

  it "should catch files update" do
    file1 = @fixture_path.join("folder1/file1.txt")
    file2 = @fixture_path.join("folder1/folder2/file2.txt")
    File.exists?(file1).should be_true
    File.exists?(file2).should be_true
    run
    FileUtils.touch file1
    FileUtils.touch file2
    stop
    @results.include?(@fixture_path.to_s).should be_true
  end

  it "should catch new directory" do
    dir = @fixture_path.join("new_dir")
    begin
      Dir.delete dir
    rescue
    end
    run
    Dir.mkdir dir
    stop
    begin
      Dir.delete dir
    rescue
    end
    @results.include?(@fixture_path.to_s).should be_true
  end

  it "should catch directory rename" do
    dir = @fixture_path.join("new_dir")
    dir_new = @fixture_path.join("new_dir1")
    begin
      Dir.mkdir dir
    rescue
    end
    begin
      Dir.delete dir_new
    rescue
    end
    run
    File.rename(dir, dir_new)
    stop
    begin
      Dir.delete dir_new
    rescue
    end
    @results.include?(@fixture_path.to_s).should be_true
  end

  it "should catch file rename" do
    file = @fixture_path.join("folder1/file1.txt")
    file_new = @fixture_path.join("folder1/file3.txt")
    File.exists?(file).should be_true
    File.exists?(file_new).should be_false
    run
    File.rename(file, file_new)
    stop
    File.rename(file_new, file)
    @results.include?(@fixture_path.to_s).should be_true
  end

#  it "should work with none-ANSI path" do
#    dir = @fixture_path.join("../тест")
#    Dir.mkdir dir unless Dir.exists? dir
#    file = dir.join("тест");
#    File.delete file if File.exists? file
#    File.exists?(file).should be_false
#    @notifier.watch(dir.to_s, :all_events, :recursive) do |event|
#      @results += [event.watcher.path]
#    end
#    run
#    FileUtils.touch file
#    stop
#    File.delete file
#    Dir.delete dir
#    @results.should == [@fixture_path.to_s, @fixture_path.to_s]
#  end
  
  def run
    sleep 0.6
    Thread.new { @notifier.run }
    sleep 0.6
  end

  def stop
    sleep 0.6
    @notifier.stop
  end

end
