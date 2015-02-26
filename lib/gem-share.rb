# encoding: utf-8

class SharePath

  class << self

    private :new

    def get name
      nm = name.intern
      @shares ||= {}
      @shares[nm] ||= new nm
      @shares[nm]
    end

    alias :[] :get

  end

  attr_reader :name
  attr_accessor :prefix

  def initialize name
    @name = name
    @prefix = ''
    # TODO: defaults
  end

  def detect_share_path src
    # TODO
  end

  def register_vendor_path path = nil
    @vendor_paths ||= []
    # TODO: gemspec as path
    pth = path || detect_share_path(caller_locations[0].path)
    if pth
      full = File.expand_path pth
      @vendor_paths << full unless @vendor_paths.include?(full)
      full
    else
      nil
    end
  end

  alias :register :register_vendor_path
  alias :<< :register_vendor_path

  attr_reader :vendor_paths

  attr_accessor :system_path
  attr_accessor :user_path
  attr_accessor :instance_path

  def to_a
    [ *@vendor_paths, *@system_path, *@user_path, *@instance_path ]
  end

  def search name
    list = to_a
    list.each do |path|
      ep = File.expand_path @prefix + name, path
      if File.exist?(ep)
        return ep
      end
    end
    nil
  end

  def get_file name
    @found[name] ||= search name
    @found[name]
  end

  alias :[] :get_file

end
