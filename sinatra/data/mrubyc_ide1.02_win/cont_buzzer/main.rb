BUZZER = 16
pinMode(BUZZER, 0)
#digitalWrite(BUZZER, 1)

pwm = PWM.new()
pwm.ch(7)
#PWM.start(2)
PWM.cycle(0x95A,4)
while true
    pwm.start
    a = adc.read_v
    adc.stop
    # adc値 × 100％ ÷ adcの最大値
    a = (a*100/3.3).to_i
    PWM.rate(a,7)
end