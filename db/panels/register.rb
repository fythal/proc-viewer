#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'active_resource'

class Ann < ActiveResource::Base
  self.site = 'http://localhost:3000'
  self.include_root_in_json = true
end

require 'yaml'
anns = YAML.load(ARGF)

anns.each do |ann|
  Ann.create(ann)
end
