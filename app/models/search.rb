# -*- coding: utf-8 -*-

# == 検索
#
# ユーザー (User) が検索を行ったときの検索語を記録するためのクラス。
#
# 検索 (Search オブジェクト) を利用することによって、検索の履歴や「お気
# に入り」の検索を設定することができる。同じ検索を何回も行いたいときで
# も、検索フィールドに毎回同じキーワードを再入力する必要がなくなる。

class Search < ActiveRecord::Base
  belongs_to :user

  validates! :keywords, presence: true
  validates! :user, presence: true
end
