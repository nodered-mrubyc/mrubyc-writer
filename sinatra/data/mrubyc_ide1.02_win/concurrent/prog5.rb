pinMode(12,1)
$s = 0
while true
  if digitalRead(12)==0 then
    $s = 1 - $s
    sleep 1
  end
  sleep 0.1
end