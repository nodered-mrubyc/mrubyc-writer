while true
	if sw() == 0
		digitalWrite(0, 1)
		sleep(0.5)
		digitalWrite(0, 0)
		sleep(0.5)
	else
		digitalWrite(1, 1)
		sleep(0.5)
		digitalWrite(1, 0)
		sleep(0.5)
	end
end