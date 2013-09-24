# -*- coding: utf-8 -*-

Given(/^「HPCS 電気故障」という警報がある$/) do
  @ann = Ann.new(name:"HPCS 電気故障")
  @ann.save
end

Given(/^ある警報がある$/) do
  steps %{ Given 「HPCS 電気故障」という警報がある }
end

Given(/^その警報には、スキャンされた手順が関連づけられている$/) do
  procedure = Procedure.create!(ann: @ann)
end

Given(/^その警報には、スキャンされた手順が関連づけられている$/) do
  @ann.panel = "n1"
  @ann.window = "c6"
  @ann.save
end

When(/^「(.*)」というキーワードを入力する$/) do |keyword|
  visit "/anns?keyword=#{URI.encode(keyword)}"
end

Then(/^「(.*)」の警報がリストアップされる$/) do |name|
  expect(page).to have_content(name)
end

Then(/^その警報名称の部分はリンクとなっており、スキャンされた手順にアクセスできる$/) do
  expect(page).to have_link('HPCS 電気故障', :href => "/assets/procs/ann-n1-c6.pdf")
end

Given(/^警報の編集画面が表示されている$/) do
  steps %{ Given 「HPCS 電気故障」という警報がある }
  visit "/anns/#{@ann.to_param}/edit"
end

Given(/^警報パネルと警報窓の入力フィールドがある$/) do
  expect(page).to have_field(I18n.t(:panel_number), :type => 'text')
  expect(page).to have_field(I18n.t(:window_number), :type => 'text')
end

When(/^警報パネルと警報窓に適切な情報を設定する$/) do
  fill_in I18n.t(:panel_number), :with => 'n1'
  fill_in I18n.t(:window_number), :with => 'd3'
  # click_button I18n.t(:update_ann)
  click_button "Update Ann"
end

When(/^その警報の編集画面を表示させる$/) do
  visit "/anns/#{@ann.to_param}/edit"
end

When(/^手順書の新規作成のリンクをクリックする$/) do
  click_link('Create Procedure')
end

Then(/^情報が更新された警報が表示される$/) do
  expect(page.status_code).to eq(200)
  expect(page.current_path).to eq(ann_path(@ann))

  expect(page).to have_selector('#ann_panel', :text => 'n1')
  expect(page).to have_selector('#ann_panel_location', :text => 'd3')
end

Given(/^ある警報窓にすでに警報が割り当てられている$/) do
  steps %{
    Given 「HPCS 電気故障」という警報がある
  }
  Panel.assign(@ann, panel: "n1", to: "a1")
  expect(@ann.panel).not_to be_nil
  expect(@ann.location).not_to be_nil
end

When(/^その警報窓に違う警報を割り当てようとする$/) do
  @another_ann = Ann.create!(:name => "CRD 電気故障")
  visit "/anns/#{@another_ann.to_param}/edit"
  fill_in I18n.t(:panel_number), :with => @ann.panel.number
  fill_in I18n.t(:window_number), :with => @ann.location.location
  # click_button I18n.t(:update_ann)
  click_button "Update Ann"
end

Then(/^すでに警報が割り当てられているという注意が表示される$/) do
  expect(page).to have_selector('#error_explanation ul li', :text => I18n.t(:ann_already_assigned_to_other_ann))
end

Then(/^すでに割り当てられている警報の警報窓の設定は変更されない$/) do
  # 妥当性確認でエラーが発生している時点で、すでにデータベースに保存さ
  # れている警報窓の情報は影響を受けないことは確実だが、機能ファイルに
  # よってステークホルダーに理解してもらうために、設定しているステップ
  # である。
  ann = Ann.find(@ann.to_param)
  expect(ann.panel).to eq(@assigned_panel)
  expect(ann.window).to eq(@assigned_window)
end

Then(/^割り当てようとした警報の警報窓の設定は変更されない$/) do
  expect(@another_ann.panel).to be_nil
  expect(@another_ann.window).to be_nil
end

Given(/^警報対応へのパスが得られない警報がある$/) do
  @ann = Ann.create(name: "no-proc ann")
  expect(@ann.proc_path).to be_nil
end

Given(/^警報の一覧の画面が表示されている$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^それぞれの警報の近くに「お気に入りに登録」というリンクがある$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^警報の「お気に入りに登録」をクリックする$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^その警報がお気に入りに登録される$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^不整合なデータを表示させる$/) do
  visit '/broken_objects'
end

Then(/^パスが得られないとして、その警報名が表示される$/) do
  expect(page).to have_selector('#broken_anns a', :text => @ann.name)
end

Given(/^警報対応へのパスにはファイルが存在しない警報がある$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^警報対応が存在しないとして、その警報名が表示される$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^あるべき警報対応のファイルのパスが表示される$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^警報が存在しない警報対応がある$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^警報が存在しないとして、その警報対応へのパスが表示される$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^その警報対応へのリンクも表示され、どの警報のものか確認できる$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^手順書の新規作成の画面が表示される$/) do
  expect(page.current_path).to eq(new_ann_procedure_path(@ann))
end

Then(/^手順書を割り当てる警報が判別できるように、画面に警報の名称が表示される$/) do
  expect(page).to have_selector('#ann_name', text: @ann.name)
end

Then(/^改定番号を入力するフィールドがある$/) do
  expect(page).to have_field('#procedure_revision')
end

Then(/^改訂日を入力するフィールドがある$/) do
  expect(page).to have_field('#procedure_revised_on')
end

Then(/^手順書の過去のリビジョンを選択できるセレクトボックスが表示されている$/) do
  expect(page).to have_select('#procedure_prev_revision_id')
end

Then(/^リビジョンのセレクトボックスのデフォルト値は、その警報の最新の手順書のリビジョンである$/) do
  expect(page).to have_select('#procedure_prev_revision_id', :selected => @ann.procedure.id)
end
