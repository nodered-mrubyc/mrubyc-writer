# coding: utf-8
require 'sinatra'
require 'json'
require "tempfile"

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

get '/input' do
  erb :input
end

post "/download_rb" do
  # JSONデータ
  json = params[:json_data]
  # 一時ファイルに保存
  f_json = Tempfile.open(["t_", ".json"])
  f_json.puts json
  f_json.close
  p f_json.path
  # JSON -> mruby/c
  f_mruby = Tempfile.open(["t_", ".rb"])
  f_mruby.close
  # コマンド実行
  cmd = "ruby ./my_json2mruby.rb -r #{f_json.path} -w #{f_mruby.path}"
  `#{cmd}`
  # 実行結果を取得
  @generated_code = File.open(f_mruby).read
  # 一時ファイルを削除する
  File.unlink(f_json)
  File.unlink(f_mruby)
  # 実行結果を表示
  erb :result
end


post "/download_mrb" do
end

