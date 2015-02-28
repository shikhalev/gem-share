# encoding: utf-8

require 'pp'
require_relative 'lib/share-paths'

Share.register_vendor_path

pp Share::to_a
