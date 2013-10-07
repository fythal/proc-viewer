Feature: 警報パネルの名前とサイズの変更

  手順書検索システムの管理者として
  警報の手順書をパネルの名前とサイズを変更したい

  それによって、ユーザーであるインストラクタが実際の警報の階層構造をイ
  メージして目的の手順書へ範囲を狭めるために警報パネルの枠作りをするこ
  とができる

  Scenario: 警報パネルの名称を変更する
    Given 警報パネル foo がある
    When その警報パネルの編集画面を表示する
    And 警報パネルの番号として bar を入力する
    And 編集の実行のボタンをクリックする
    Then 警報パネルの番号として bar が表示される
    Then 警報パネルの番号が bar に変更される