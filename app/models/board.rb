# -*- coding: utf-8 -*-
class Board < ActiveRecord::Base
  SORT_PRIORITIZATION = [
    'H11-P700', 'H11-P701', 'H11-P702',
    'H11-P704-2', 'H11-P704-1', 'H11-P703',
    'H11-P705', 'H11-P706',
  ]

  has_many :panels

  def <=>(other)
    if SORT_PRIORITIZATION.index(code)
      if SORT_PRIORITIZATION.index(other.code)
        return SORT_PRIORITIZATION.index(code) <=> SORT_PRIORITIZATION.index(other.code)
      else
        return -1
      end
    else
      if SORT_PRIORITIZATION.index(other.code)
        return 1
      end
    end

    result = (code <=> other.code)

    return (code.nil? ? 1 : -1) if result.nil?

    if result == 0
      return name <=> other.name
    else
      return result
    end
  end
end
