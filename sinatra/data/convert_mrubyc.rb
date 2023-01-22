#オプションの付与
require 'optparse'

# 追記
require 'open-uri'

#winで動かす時用のエンコーディング形式の明示
Encoding.default_external = 'utf-8'

require 'fileutils'

#コンパイル&転送するプログラム名
$file_name = ""

#mrbcおよびmrbwriteのあるディレクトリ
$mrubycompiler_folder = "./mrubyc_ide1.02_win"

$Device_Name = "RBoard"

$Auto_Run_Flag = false #生成されたプログラムをすぐにデバイスに流し込むか(RBoard用)
$Poat_Num = "COM3" #RBoardをUSB接続したときのポート番号

$error_flag = false

def Read_filename()
  option = {}
  OptionParser.new do |opt|
    opt.on('-r Filename',   '読み込む.rbファイル名を指定') {|name| option[:r] = name}
    opt.on('-w Filename',   'バイト コードのファイル名を入力') {|name| option[:w] = name}
    opt.parse!(ARGV)
  end

  if option[:r] != nil
    mrubyc_program = option[:r]
  else
    puts "---.rbファイルを入力してください---"
    filenames = Dir.open("createdRuby",&:to_a)
    filenames.each do |filename|
      if filename.include?(".rb") == true
        p filename
      end
    end
    mrubyc_program = gets().chomp()
  end

  # 追記
  if option[:w] != nil
    $byte_program = option[:w]
  else
    $byte_program = "mrubyc_program"
  end

  $file_name = mrubyc_program.gsub(/.rb/,"")

end

def Compile_to_mrb(file_name, byte_program)
  puts "---指定したRubyコードを.mrbにコンパイルします。---"
  # コマンドを実行
  cmd = system("cd #{$mrubycompiler_folder} && mrbc ../public/createdRuby/#{file_name}.rb && cd ..")
  p cmd
  
  #コンパイルの成功の確認
  $error_flag = true
  filenames = Dir.open("createdRuby",&:to_a)
  filenames.each do |filename|
    if filename == "#{file_name}.mrb"
      $error_flag = false
      puts "コンパイル成功!"

      break
    end
  end
end


#生成したプログラムをデバイスに流し込む（RBoard用）
def Pouting_program_to_device(filename)

  if $error_flag == true
    puts "コンパイル失敗"
    return 0
  end

  if $Auto_Run_Flag == false
    puts "Q. 生成した.mrbコードを「#{$Device_Name}」で実行しますか？"
    puts "yes   or   no"
    answer = gets

    if answer.include?("y") != true
      return
    end
  end

  #puts file_name
  puts "---書き込みを開始します。リセットボタンを押してください---"
  begin
    #puts "#{$mrubycompiler_folder}/mrbwrite -l  #{$Poat_Num} -s 19200 #{filename}.mrb"
    system("#{$mrubycompiler_folder}/mrbwrite -l  #{$Poat_Num} -s 19200  ./createdRuby/#{filename}.mrb")
    # puts "system出力終了"
  rescue => err
    puts "「#{$Device_Name}」にてmrubycコード実行中にエラーが起きました。"
    puts err
    puts "------------"
  end


end

# def save_file(url)
#   filename = File.basename(url)
#   open(filename, 'wb'){|file|
#     OpenURI.open_uri(url, {:proxy=>nil}){|data|  #プロクシは使わない
#       puts "\t"+data.content_type #ダウンロードするファイルのタイプを表示
#       file.write(data.read) #ファイル名で保存
#     }
#   }
# end

# open("./createdRuby/mrubyc_program.mrb", "r"){|io|
#   while line=io.gets  #line = filepath(url)
#     line.chomp!
#     print line
#     save_file(line.chomp)
#   end
# }


##########以下main文###################
Read_filename()
Compile_to_mrb($file_name, $byte_program)
Pouting_program_to_device($file_name)