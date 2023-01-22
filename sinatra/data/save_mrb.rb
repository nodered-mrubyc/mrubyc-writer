/オプションの設定/
require 'optparse'
require 'json'
require 'fileutils'

#winで動かす時用のエンコーディング形式の明示
Encoding.default_external = 'utf-8'

$file_name = ""

def Read_filename()
  option = {}
  OptionParser.new do |opt|
    opt.on('-r Filename',   '読み込む.jsonファイル名を指定') {|name| option[:r] = name}
    opt.on('-w Filename',   '書き込む.jsonファイル名を指定') {|name| option[:w] = name}
    opt.parse!(ARGV)
  end

  if option[:r] != nil
    # jsonfilesname_r = option[:r]
    $jsonfilesname_r = option[:r]
  else
    puts "---.jsonファイルを入力してください---"
    filenames = Dir.open("jsonFile",&:to_a)
    filenames.each do |filename|
      if filename.include?(".json") == true
        p filename
      end
    end
    $jsonfilesname_r = gets().chomp()
  end

  if option[:w] != nil
    $jsonfilesname_w = option[:w]
  else
    $jsonfilesname_w = "json_program"
  end

  #$file_name_w = jsonfilesname_w.gsub(/.json/,"")
end

def Save_json(jsonfilesname_r, jsonfilesname_w)
  File.open("#{jsonfilesname_r}", "r"){|f|
    writing_f = File.open("./jsonFile/#{jsonfilesname_w}.json", "w")
    tFile = f.read
    f.close
    writing_f.write("\n")
    writing_f.write(tFile)  # ファイルに書き込む
    writing_f.write("\n") 
    writing_f.close
  }
end

##########以下main文###################
Read_filename()
Save_json($jsonfilesname_r, $jsonfilesname_w)