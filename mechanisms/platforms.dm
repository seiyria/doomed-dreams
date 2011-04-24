
mob
	var/mob/platform/platform
	var/onPlatform

	platform
		density = 1
		pheight = 16
		pwidth  = 32

		stack=1
		var/list/riders=list()
		var/stepSize=3
		var/maxStep=15

		New()
			..()
			if(!tag)isActive=1
			if(findtext(name,"fading"))return
			spawn movement_loop()

		horizontal
			harmful
				name="wall"
				isTriggerable=1
				activate()
					icon_state = "meanplatform"
					movement_loop()
					icon_state = "block"

				can_bump(atom/a)
					if(istype(a, /mob/platform))
						return 1
					return ..()

				icon_state = "block"

				pwidth = 32
				pheight = 32
				dir=WEST
				var/initpx
				var/initpy
				var/changeDir

				New()
					..()
					initpx=px
					initpy=py

				movement_loop()
					var
						stepSize2=stepSize
						maxStep2 =maxStep

					for(var/x=1 to maxStep2)
						pixel_move(dir==WEST ? -stepSize2 : stepSize2,0)
						sleep(world.tick_lag)

					changeDir=(dir==EAST ? WEST : EAST)

					while(dir==WEST ? (px < initpx) : (px > initpx))
						pixel_move(dir==WEST ? stepSize2 : -stepSize2,0)
						sleep(world.tick_lag)
					while(dir==WEST ? (px > initpx) : (px < initpx))
						pixel_move(dir==WEST ? -1 : 1,0)
						sleep(world.tick_lag)

					changeDir=(dir==EAST ? EAST : WEST)

					while(py<initpy)
						pixel_move(0,1)
					while(py>initpy)
						pixel_move(0,-1)

				can_bump(mob/m)
					if(istype(m))
						return m.client

				x_bump(mob/m)
					if(istype(m))
						if(dir == EAST)
							if(m.client && changeDir==dir)
								m.vel_x=30
								m.death("vicious wall")
							m.pixel_move(4,0)
							pixel_move(2,0,0)
						else
							if(m.client && changeDir==dir)
								m.vel_x=-30
								m.death("vicious wall")
							m.pixel_move(-2,0)
							pixel_move(-2,0,0)

			icon_state="platform-horizontal"
			movement_loop()
				if(isActive)
					var
						stepSize2=stepSize
						maxStep2 =maxStep

					for(var/x=1 to maxStep2)
						pixel_move(stepSize2,0)
						for(var/mob/m in riders)
							m.pixel_move(stepSize2,0)
						sleep(world.tick_lag)

					for(var/x=1 to maxStep2)
						pixel_move(-stepSize2,0)
						for(var/mob/m in riders)
							m.pixel_move(-stepSize2,0)
						sleep(world.tick_lag)

				spawn(world.tick_lag) movement_loop()


		vertical
			activate()
				isActive=1

			deactivate()
				isActive=0

			harmful
				name="wall"
				isTriggerable=1
				activate()
					icon_state = "meanplatform"
					movement_loop()
					icon_state = "block"

				can_bump(atom/a)
					if(istype(a, /mob/platform))
						return 1
					return ..()

				icon_state = "block"

				pwidth = 32
				pheight = 32
				var/initpy
				var/initpx

				New()
					..()
					initpy=py
					initpx=px

				movement_loop()
					var
						stepSize2=stepSize
						maxStep2 =maxStep
					dir=SOUTH
					for(var/x=1 to maxStep2)
						pixel_move(0,-stepSize2)
						sleep(world.tick_lag)

					while(py < initpy)
						pixel_move(0,stepSize2)
						sleep(world.tick_lag)
					while(py>initpy)
						pixel_move(0,-1)
						sleep(world.tick_lag)

					while(px<initpx)
						pixel_move(1,0)
					while(px>initpx)
						pixel_move(-1,0)

				can_bump(mob/m)
					if(istype(m))
						return m.client

				y_bump(mob/m)
					if(istype(m))
						if(dir == NORTH)
							m.pixel_move(4,0)
							pixel_move(2,0,0)
						else
							if(m.client)
								m.vel_x=-30
								m.death("vicious wall")
							m.pixel_move(-2,0)
							pixel_move(-2,0,0)
			icon_state="platform-vertical"
			movement_loop()
				if(isActive)
					var
						stepSize2=stepSize
						maxStep2 =maxStep

					for(var/x=1 to maxStep2)
						pixel_move(0,stepSize2)
						for(var/mob/m in riders)
							m.pixel_move(0,stepSize2)
						sleep(1)

					for(var/x=1 to maxStep2)
						pixel_move(0,-stepSize2)
						for(var/mob/m in riders)
							m.pixel_move(0,-stepSize2)
						sleep(1)

				spawn(world.tick_lag) movement_loop()

		diamond
			icon_state="platform-diamond"
			movement_loop()
				var
					stepSize2=stepSize
					maxStep2 =maxStep

				for(var/x=1 to maxStep2)
					pixel_move(stepSize2,stepSize2)
					for(var/mob/m in riders)
						m.pixel_move(stepSize2,stepSize2)
					sleep(1)

				for(var/x=1 to maxStep2)
					pixel_move(stepSize2,-stepSize2)
					for(var/mob/m in riders)
						m.pixel_move(stepSize2,-stepSize2)
					sleep(1)

				for(var/x=1 to maxStep2)
					pixel_move(-stepSize2,-stepSize2)
					for(var/mob/m in riders)
						m.pixel_move(-stepSize2,-stepSize2)
					sleep(1)

				for(var/x=1 to maxStep2)
					pixel_move(-stepSize2,stepSize2)
					for(var/mob/m in riders)
						m.pixel_move(-stepSize2,stepSize2)
					sleep(1)

				spawn(world.tick_lag) movement_loop()

		circle
			icon_state="platform-circle"
			var
				angle=0
				radius=2.2
			movement_loop()

				pixel_move(cos(angle)*radius,sin(angle)*radius)
				for(var/mob/m in riders)
					m.pixel_move(cos(angle)*radius,sin(angle)*radius)

				sleep(1)
				angle++
				spawn(world.tick_lag) movement_loop()

		wave
			icon_state="platform-wave"
			maxStep=30
			var
				amplitude=20
				oscil	 =50
			movement_loop()
				var
					maxStep2 =maxStep

				for(var/x=1 to maxStep2)

					pixel_move(x,amplitude*sin(oscil*x))
					for(var/mob/m in riders)
						m.pixel_move(x,amplitude*sin(oscil*x))

					sleep(1)

				for(var/x=1 to maxStep2)
					//to make a constantly vertically-going platform, don't make these negative
					pixel_move(-x,amplitude*sin(oscil*-x))
					for(var/mob/m in riders)
						m.pixel_move(-x,amplitude*sin(oscil*-x))

					sleep(1)
				spawn(world.tick_lag) movement_loop()

		DblClick()
			var/list/l = list("cancel","stepSize","maxStep")
			if(istype(src,/mob/platform/wave))
				l += "amplitude"
				l += "oscil"
			if(istype(src,/mob/platform/circle))
				l+= "radius"
			var/x =input(usr,"modify which variable?") in l
			if(x!="cancel")
				var/y = input(usr,"change it to what?",,vars[x]) as num
				vars[x]=y
