# encoding: utf-8

require 'pp'

a = nil
b = nil
c = []
d = 'Ololo'
e = [ 'Lalala' ]

r = [ *a, *b, *c, *d, *e ]

pp r
