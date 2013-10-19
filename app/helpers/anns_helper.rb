# -*- coding: utf-8 -*-
module AnnsHelper


  #
  # 警報パネルで警報または一括警報へのリンクのヘルパー
  #
  def link_or_name(item)
    return "" if item.nil?

    case item
    when Ann
      # 手順書が設定されているときは手順書へのリンク
      if item.procedure.nil?
        item.name
      else
        link_to item.name, item.procedure.path, class: "ann"
      end
    when Panel
      # 一括警報のときは、一括警報のパネル (裏盤または現場盤) のリンク
      link_to item.name, panel_path(item), class: "panel"
    end
  end

end
