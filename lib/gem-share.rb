# encoding: utf-8

require 'rubygems'

module Share

  VERSION = [ 0, 1 ]

  class Error < StandardError; end

  def appname
    @@appname ||= File.basename $0, '.rb'
    @@appname
  end

  def set_appname name
    case name
    when nil
      @@appname = File.basename $0, '.rb'
    when String, Symbol
      @@appname = name.to_s
    else
      raise Error, "#{name.inspect} is not a valid application name!", caller
    end
  end

  module_function :appname, :set_appname

  def default_system_path
    "/var/share/#{appname}"
  end

  def system_path
    @@system_path ||= default_system_path
    @@system_path
  end

  def set_system_path path
    case path
    when nil
      @@system_path = default_system_path
    when String
      @@system_path = File.expand_path path
    else
      raise Error, "#{path.inspect} is not a valid path!", caller
    end
  end

  module_function :default_system_path, :system_path, :set_system_path

  def default_user_path
    File.expand_path "~/.local/share/#{appname}"
  end

  def user_path
    @@user_path ||= default_user_path
    @@user_path
  end

  def set_user_path path
    case path
    when nil
      @@user_path = default_user_path
    when String
      @@user_path = File.expand_path path
    else
      raise Error, "#{path.inspect} is not a valid path!", caller
    end
  end

  module_function :default_user_path, :user_path, :set_user_path

  def default_instance_path
    File.expand_path './share'
  end

  def instance_path
    @@instance_path ||= default_instance_path
    @@instance_path
  end

  def set_instance_path path
    case path
    when nil
      @@instance_path = default_instance_path
    when String
      @@instance_path = File.expand_path path
    else
      raise Error, "#{path.inspect} is not a valid path!", caller
    end
  end

  module_function :default_instance_path, :instance_path, :set_instance_path

  def vendor_paths
    @@vendor_paths ||= []
    @@vendor_paths
  end

  def share_by_src src
    spec = Gem::Specification.find do |spec|
      File.fnmatch File.join(spec.full_gem_path, '*'), src
    end
    if spec
      share_by_gem spec
    elsif src
      base = src[ /^\/.*\/(lib|bin)\// ]
      base && File.expand_path('../share', base)
    else
      nil
    end
  end

  def share_by_gem spec
    File.expand_path 'share', spec.gem_dir
  end

  def register_vendor_path *paths
    if paths.length == 0
      return register_vendor_path share_by_src(caller_locations[0].path)
    end
    @@vendor_paths ||= []
    result = false
    paths.each do |pth|
      case pth
      when nil
        next
      when Gem::Specification
        full = share_by_gem pth
      when String
        full = File.expand_path pth
      else
        raise Error, "#{pth.inspect} is not a valid path!", caller
      end
      if !@@vendor_paths.include?(full)
        @@vendor_paths << full
        result = true
      end
    end
    result
  end

  module_function :vendor_paths, :share_by_src, :share_by_gem,
      :register_vendor_path

  def share_paths
    [ *vendor_paths, *system_path, *user_path, *instance_path ]
  end

  def find_share_file name
    if String === name
      paths = share_paths
      paths.reverse_each do |path|
        full = File.expand_path name, path
        if File.exist? full
          return full
        end
      end
      nil
    else
      raise Error, "#{name.inspect} is not a valid name!", caller
    end
  end

  def get_share_file name
    @@found_files ||= {}
    @@found_files[name] ||= find_share_file name
    @@found_files[name]
  end

  module_function :share_paths, :find_share_file, :get_share_file

  class << self

    alias :appname= :set_appname
    private :set_appname

    alias :system_path= :set_system_path
    private :set_system_path

    alias :user_path= :set_user_path
    private :set_user_path

    alias :instance_path= :set_instance_path
    private :set_instance_path

    alias :<< :register_vendor_path
    private :share_by_src, :share_by_gem

    alias :[] :get_share_file
    alias :to_a :share_paths

  end

end

