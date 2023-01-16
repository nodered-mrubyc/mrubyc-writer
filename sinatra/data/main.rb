# coding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require "tempfile"
require 'webrick'
require 'webrick/https'
require 'openssl'

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
  # f_json = Tempfile.open(["t_", ".json"], tempdir="./jsonFile")
  f_json = Tempfile.open(["t_", ".json"])
  f_json.puts json
  f_json.close
  p f_json.path
  # f_json_name = f_json.path[..-5-1]
  # f_json_name[0, 11] = ""
  # p f_json_name
  # コマンド実行
  # Tempfile(json)をローカル上に保存
  cmd_save = "ruby ./save_json_file.rb -r #{f_json.path} -w json_program"
  # JSON -> mruby/c
  cmd_json2mrubyc = "ruby ./my_json2mruby.rb -r json_program -w mrubyc_program"
  # mruby/c -> byte
  cmd_mrubyc2byte = "ruby ./convert_mrubyc.rb -r mrubyc_program -w mrubyc_program"
  `#{cmd_save}`
  `#{cmd_json2mrubyc}`
  `#{cmd_mrubyc2byte}`
  # 一時ファイルを削除する
  File.unlink(f_json)
end


# 後日実装
post "/download_mrb" do
  # Rubyデータ
  ruby = params[:ruby_data]
  # 一時ファイルに保存
  f_ruby = Tempfile.open(["t_", ".rb"])
  f_ruby.puts ruby
  f_ruby.close
  p f_ruby.path
  # mruby/c -> byte
  f_byte = Tempfile.open(["t_", ".mrb"])
  f_byte.close
  # コマンド実行
  cmd = "ruby ./convert_mrubyc.rb -r #{f_ruby.path} -w mrubyc_program_self"
  `#{cmd}`
  # 一時ファイルを削除する
  File.unlink(f_ruby)
  f_byte.unlink
end