Feature: 警報の手順書の管理

  手順書が改訂されたら、簡単にアップデートして常に最新の手順書を参照できるように
  手順書検索システムの管理者として
  手順書の属性変更や手順書のアップロードを管理できるようにしたい

  Scenario: 警報の手順書をアップロードする画面を表示する
    Given ある警報がある
    And その警報には、改定番号 0 の手順書が割り当てられている
    And その警報には、改定番号 1 の手順書が割り当てられている
    When その警報の編集画面を表示させる
    And 手順書の新規作成のリンクをクリックする
    Then 手順書の新規作成の画面が表示される
    And 手順書を割り当てる警報が判別できるように、画面に警報の名称が表示される
    And 改訂番号を入力するフィールドがある
    And 改訂日を入力するフィールドがある
    And 最新の手順書の改定番号 1 が表示される

  @wip
  Scenario: 手順書の新規作成の画面で警報の手順書をアップロードする
    Given ある警報がある
    And その警報は警報パネル m1 の b1 に割り当てられている
    When その警報の手順書の新規作成の画面を表示させる
    And 手順書の改訂番号に 6 を入力する
    And 手順書ファイルをアップロードする
    And 手順書作成のボタンをクリックする
    Then 手順書の詳細画面が表示される
    And 警報の編集画面に戻るためのリンクがある
    And 改定番号の 6 が表示されている
    And 手順書を表示するリンクがある
    And 手順書ファイル名は自動設定され、警報の割り当て場所と改定番号 6 が含まれている
