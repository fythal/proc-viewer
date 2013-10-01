Feature: 警報を編集する

  手順書検索システムの管理者として
  既存の警報を警報パネルに配置したり、手順書をアップロードしたい
  それによって、ユーザーであるインストラクタは効率的に警報の手順書にア
  クセスすることができ、訓練準備のための労働時間を短縮し、人件費を抑制
  することができる。また最新の手順書をアップロードできるようにすること
  で、最新の手順書にアクセスすることができ、「最新の設備」の提供につな
  がる。

  @wip
  Scenario: 既存の警報を警報パネルに割り当てる
    Given 警報パネルに割り当てられていない警報がある
    When その警報の編集画面を表示する
    And 警報パネルについて、パネル番号に "n1"、警報の場所に "a1" を入力する
    And 手順書の編集ボタンをクリックする
    Then 警報の詳細ページが表示される
    And 正常に警報が編集されたされたメッセージが表示される
    And 警報パネルの番号は "n1"、警報の場所は "a1" となっている