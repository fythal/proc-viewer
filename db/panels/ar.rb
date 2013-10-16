#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'active_resource'

class ProcResource < ActiveResource::Base
  self.site = 'http://localhost:3000'
  self.include_root_in_json = true

  def to_param
    id rescue to_param_using_url
  end
end

class Ann < ProcResource
end

class Board < ProcResource
end

class Panel < ProcResource
end

class ActiveResource::Base
  def to_param_using_url
    (persisted? and url =~ %r|/anns/(\d+)|) ? $~[1] : nil
  end
end
