
//These traps are meant for things that are independent of the floor
//Things like arrow traps, boulder traps, etc
obj
	trap
		proximity
			var/range
			var/canfire=1

			New()
				..()
				spawn monitor()
			proc
				lockfire()
					canfire=0

				lockfiretimer()
					canfire=0
					spawn(delay)
						canfire=1

				unlockfire()
					canfire=1

				monitor()

				get_dirs()
					.=list()
					var/turf/t=loc
					.+=t
					for(var/x=0, x<range, x++)
						t=get_step(t,dir)
						.+=t
			arrow
				name = "Arrow Shooter"
				range=3
				pwidth=8
				left
					dir=WEST
					icon_state="arrow_left"
				right
					dir=EAST
					icon_state="arrow_right"

				monitor()
					while(src)
						for(var/turf/t in get_dirs())
							var/mob/m = locate(/mob) in t
							if(m && m.density && canfire)
								lockfiretimer()
								FirePixelProjectile(src, (dir==EAST ? 0 : 180), /bullets/lasers/arrow, 0, 0)

						sleep(world.tick_lag)
			resettable
				spikewall
				spikeceiling
			nonresettable
				boulder