# encoding: utf-8

require 'rubygems'

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

    def app_name
      @app_name ||= File.basename $0, '.rb'
    end

    def default_system_path
      "/var/share/#{app_name}"
    end

    def default_user_path
      File.expand_path "~/.local/#{app_name}/share"
    end

    def default_instance_path
      File.expand_path 'share', '.'
    end

  end

  attr_reader :name

  def initialize name
    @name = name
    @vendor_paths = []
    @system_path = self.class.default_system_path
    @user_path = self.class.default_user_path
    @instance_path = self.class.default_instance_path
  end

  def detect_share_path src
    if src
      base = src[ /^\/.*\/(lib|bin)\// ]
      base && File.expand_path('../share', base)
    else
      nil
    end
  end

  def register_vendor_path path = nil
    @vendor_paths ||= []
    case path
    when String
      full = File.expand_path path
    when Gem::Specification
      full = File.expand_path 'share', path.gem_dir
    else
      full = detect_share_path caller_locations[0].path
    end
    if full && File.directory?(full) && !@vendor_paths.include?(full)
      @vendor_paths << full
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
      ep = File.expand_path name, path
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
