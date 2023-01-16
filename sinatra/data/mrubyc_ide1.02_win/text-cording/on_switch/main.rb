while true
  if sw() == 0
    digitalWrite(0, 1)
    sleep(1)
  else
    digitalWrite(0, 0)
  end
end