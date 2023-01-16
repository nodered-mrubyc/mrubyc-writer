BUZZER = 16

pinMode(BUZZER, 0)
while true
  I2C.write(0x18, 0x08, 0x03)
  ans = I2C.read(0x18,0x05,2)
  a = ans[1] | ((ans[0] & 0x1f)<<8)
  a = (a.to_f)* 0.0625

  if a.to_s > 25
    digitalWrite(BUZZER, 0)
  else
    digitalWrite(BUZZER, 1)
  end
  # puts("ans:"+a.to_s+"\r\n")
  sleep(5)
end