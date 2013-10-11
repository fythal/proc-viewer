#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'active_resource'

class Ann < ActiveResource::Base
  self.site = 'http://localhost:3000'
  self.include_root_in_json = true
end
