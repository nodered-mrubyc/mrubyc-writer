=begin
BUZZER = 16
pinMode(BUZZER, 0)
digitalWrite(BUZZER, 1)
=end
BUZZER = 16
pwm = PWM.new()
pwm.pin(BUZZER)
# 開始するチャンネル番号を指定
pwm.start(2)
while true
  # 周期を設定する。
  # ド:261Hz, 倍数16(4)
  # 1 ÷ 261 × 10000000 = 38314
  # 38314 ÷ 16 = 2394(0x95A)
  pwm.cycle(0x95A,4)
  sleep 1
  pwm.cycle(0x84D,4)
  sleep 1
  pwm.cycle(0x76A,4)
  sleep 1
  pwm.cycle(0x6EF,4)
  sleep 1
  pwm.cycle(0x639,4)
  sleep 1
  pwm.cycle(0x58C,4)
  sleep 1
  pwm.cycle(0x4F3,4)
  sleep 1
end