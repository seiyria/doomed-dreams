
obj
	trap
		lasers
			deactivate()
				if(tag)
					..()
			delay=10
			var/range
			var/shots=1
			var/shotType
			isTriggerable=1

			New()
				..()
				if(!tag)isActive=1
				if(findtext(name,"Arc") || findtext(name,"Pulse"))return
				spawn while(src)
					if(isActive)
						for(var/mob/player/c in world)
							if(c in oview(15,src))
								for(var/a=1 to shots)
									var/i =text2num(pick(range))
									FirePixelProjectile(src, findtext(name,"Random") ? rand(i-50,i+50) : i, shotType, 0, 0)
									sleep(0.1)
								break
					sleep(delay)

			laser
				name="Laser Shooter"
				shots=1
				shotType=/bullets/lasers/red
				left
					icon_state="laser_left"
					range=list("180","210","140")
				right
					icon_state="laser_right"
					range=list("0","330","30")
				up
					icon_state="laser_up"
					range=list("90","120","60")
				down
					icon_state="laser_down"
					range=list("270","240","300")

			rapid_laser
				name="Rapid Laser Shooter"
				shots=25
				shotType=/bullets/lasers/yellow
				left
					icon_state="laser_left"
					range=list("180")
				right
					icon_state="laser_right"
					range=list("0")
				up
					icon_state="laser_up"
					range=list("90")
				down
					icon_state="laser_down"
					range=list("270")

			random_laser
				name="Random Laser Shooter"
				delay=16
				shots=1
				shotType=/bullets/lasers/blue
				left
					icon_state="laser_left"
					range=list("180")
				right
					icon_state="laser_right"
					range=list("0")
				up
					icon_state="laser_up"
					range=list("90")
				down
					icon_state="laser_down"
					range=list("270")
			arc
				shotType=/bullets/lasers/green
				var
					rangeMin=0
					rangeMax=360
					skip=0
				New()
					..()
					spawn while(src)
						if(isActive)
							for(var/v = rangeMin to rangeMax step skip)
								FirePixelProjectile(src, v, shotType, 0, 0)
								sleep(delay)
						sleep(35)

				full_arc_laser
					name="Pulse Laser Shooter"
					delay=0
					skip=1
					left
						rangeMin=110
						rangeMax=250
						icon_state="laser_left"
					right
						rangeMin=-70
						rangeMax=70
						icon_state="laser_right"
					up
						rangeMin=20
						rangeMax=160
						icon_state="laser_up"
					down
						rangeMin=200
						rangeMax=340
						icon_state="laser_down"

				steady_arc_laser
					New()
						delay=world.tick_lag
						..()
					skip=5
					range=4
					name="Arc Laser Shooter"
					left
						rangeMin=110
						rangeMax=250
						icon_state="laser_left"
					right
						rangeMin=290
						rangeMax=430
						icon_state="laser_right"
					up
						rangeMin=20
						rangeMax=160
						icon_state="laser_up"
					down
						rangeMin=200
						rangeMax=340
						icon_state="laser_down"