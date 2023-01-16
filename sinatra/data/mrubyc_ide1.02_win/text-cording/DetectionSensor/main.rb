# LCDに温度を表示するための関数
$lcd = I2C.new
sleep(1)
def rgb(r,g,b)
  $lcd.write(0x62,0x00,0x00)
  $lcd.write(0x62,0x08,0xFF)
  $lcd.write(0x62,0x01,0x20)
  $lcd.write(0x62,0x04,r)
  $lcd.write(0x62,0x03,g)
  $lcd.write(0x62,0x02,b)
end
def send_txt(txt)
  $lcd.write(0x3E,0x80,0x02)
  sleep_ms(5)
  $lcd.write(0x3E,0x80,0x0C)
  sleep_ms(5)
  cnt = txt.size
  i = 0
  while(i < cnt)
    if(i == 15)
      $lcd.write(0x3E,0x80,0xC0)
    end
  $lcd.write(0x3E,0x40,(txt[i]).ord)
  i = i+1
  end
end
rgb(255,255,255)

# 温度センサの設定
adc = ADC.new()
adc.ch(7)
temp = 0

# ブザーの設定
BUZZER = 16
pinMode(BUZZER, 0)

flag = 0 # スイッチが押された→１　押されていない→０
count = 0


while true
  adc.start
  a = adc.read_v
  adc.stop
  a = (3.3 / a)-1
  temp = 1.0/(Math.log(a)/4275+1/298.15)-273.15
  sleep(1)
  ondo = temp.to_s

  # LCDに温度を表示
  send_txt("               ")
  send_txt(ondo)

  # 温度に応じて内部LEDを点灯
  if ondo < '27' && ondo >= '25'
    digitalWrite(0, 1)
    digitalWrite(1, 0)
    digitalWrite(5, 0)
    digitalWrite(6, 0)
    digitalWrite(BUZZER, 0) # ブザーを止める
    sleep(0.5)
    count = 0
  elsif  ondo < '25' && ondo >= '23'
    digitalWrite(0, 1)
    digitalWrite(1, 1)
    digitalWrite(5, 0)
    digitalWrite(6, 0)
    digitalWrite(BUZZER, 0) # ブザーを止める
    sleep(0.5)
    count = 0
  elsif  ondo < '23' && ondo >= '21'
    digitalWrite(0, 1)
    digitalWrite(1, 1)
    digitalWrite(5, 1)
    digitalWrite(6, 0)
    digitalWrite(BUZZER, 0) # ブザーを止める
    sleep(0.5)
    count = 0
  elsif  ondo < '21'
    digitalWrite(0, 1)
    digitalWrite(1, 1)
    digitalWrite(5, 1)
    digitalWrite(6, 1)
    sleep(0.5)
    case sw()
    when 1 # スイッチが押されていないとき
      if flag == 0
        digitalWrite(BUZZER, 1) # ブザーを鳴らす
        sleep(0.5)
      else
        digitalWrite(BUZZER, 0) # ブザーを止める
        sleep(0.5)
        count += 1
        if count == 20 # スイッチが押されてカウントがしきい値になったら
          flag = 0 # フラグを下ろす
          count = 0
        end
    end
    when 0 # スイッチが押されたとき
      flag = 1 # スイッチが押されたフラグを立てる
    end
  else
    digitalWrite(0, 0)
    digitalWrite(1, 0)
    digitalWrite(5, 0)
    digitalWrite(6, 0)
    digitalWrite(BUZZER, 0) # ブザーを止める
    count = 0
  end
end