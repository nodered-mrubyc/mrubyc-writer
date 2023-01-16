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

adc = ADC.new()
adc.ch(7)
temp = 0
while true
    adc.start
    a = adc.read_v
    adc.stop
    a = (3.3 / a)-1
    temp = 1.0/(Math.log(a)/4275+1/298.15)-273.15
    sleep(1)
    send_txt("                ")
    send_txt(temp.to_s)
    #puts("ans:" + temp.to_s)
end