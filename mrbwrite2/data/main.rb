# coding: utf-8
require 'sinatra'
require 'json'
require 'webrick'
require 'securerandom'
require 'open3'

set :bind, '0.0.0.0'
basedir    = "/root/data/public/files"
basedir_js = "/files"

get '/' do
  id0 = SecureRandom.hex(10)
  redirect "/input/#{id0}"
end

get '/input/:id' do
  @id = params[:id]
  @basedir    = basedir
  @basedir_js = basedir_js
  erb :input
end

get '/error/:msg' do
  @msg = params[:msg]
  erb :error
end

post "/compile/:id" do
  @id2 = params[:id]
  
  # 入力
  source = params[:source_data]
  mruby  = params[:mruby]
  code   = params[:code]
  p source, mruby, code
  
  filename = "#{basedir}/#{@id2}"
  
  #すでにファイルがある場合は戻る
  if FileTest.exist?( "#{filename}.#{code}" )
    puts "ERROR: File already exists"
    msg = "#{@id2}_is_already_used"
    redirect "/error/#{msg}"
  end
  
  #ファイルの保存
  File.open("#{filename}.#{code}", "w"){|fp|
    fp.puts source
    fp.close
  }
  
  # json --> mruby/c
  if code == "json"
    # JSON -> mruby/c
    cmd = "ruby ./nodered2mruby.rb/nodered2mruby.rb #{filename}.json > #{filename}.rb"
    puts cmd
    
    cpr, cpe, cps = Open3.capture3( cmd )
    unless cpe.empty? 
      puts "Error: #{cpe}"
      msg = "json2mruby_command_cannot_work"
      redirect "/error/#{msg}"
    end
  end
  
  # mruby/c --> byte code
  cmd = "/usr/local/#{mruby}/bin/mrbc #{filename}.rb"
  puts cmd
  
  cpr, cpe, cps = Open3.capture3( cmd )
  unless cpe.empty? 
    puts "Error: #{cpe}"
    msg = "mrbc_command_cannot_work"
    redirect "/error/#{msg}"
  end
  
  # ページ遷移. 元のページへ戻る
  redirect "/input/#{@id2}"
end
