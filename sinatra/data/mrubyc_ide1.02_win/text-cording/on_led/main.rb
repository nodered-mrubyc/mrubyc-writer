while  true # 無限ループ
  puts "Serial Connect"
  digitalWrite(1, 1) # LED2をON
  sleep(1) # 1秒スリープ
  digitalWrite(1, 0) # LED2をOFF
  sleep(1) # 1秒スリープ
end