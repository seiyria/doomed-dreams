
#define isTrap(t) 		istype(t,/turf/trap)
#define isclient(c) 	istype(c,/client)
#define isPlatform(p) 	istype(p,/mob/platform)
#define isFWall(f)		istype(f,/turf/wall/friction)

world
	tick_lag = 0.25
	view = 9

turf
	//stack is my own variable, adding to the hackiness, whee.
	stack=1
	icon_state = "white"

	wall
		trigger()
		density = 1
		icon_state = "wall"

		// autojoining tiles, unnecessary but prettier than plain gray
		New()
			..()
			var/n = 0
			var/turf/t = locate(x,y+1,z)
			if(t && istype(t,type)) n += 1
			t = locate(x+1,y,z)
			if(t && istype(t,type)) n += 2
			t = locate(x,y-1,z)
			if(t && istype(t,type)) n += 4
			t = locate(x-1,y,z)
			if(t && istype(t,type)) n += 8
			icon_state = "wall-[n]"

		short_wall
			icon_state = "short-wall"
			density = 1
			pheight = 16

			New()
				..()
				icon_state = "short-wall"

		short_ceiling
			icon_state = "short-ceiling"
			density = 1
			ceiling = 1

			New()
				..()
				py += 16
				pheight = 16
				icon_state = "short-ceiling"

		ramp_1
			density = 1
			pwidth = 32
			pheight = 16
			pleft = 0
			pright = 16
			icon_state = "ramp-1"

			New()
				..()
				icon_state = "ramp-1"

		ramp_2
			density = 1
			pwidth = 32
			pheight = 16
			pleft = 17
			pright = 32
			icon_state = "ramp-2"

			New()
				..()
				icon_state = "ramp-2"

		ramp_3
			density = 1
			pwidth = 32
			pheight = 16
			pleft = 0
			pright = 32
			icon_state = "ramp-3"

			New()
				..()
				icon_state = "ramp-3"

		ramp_4
			density = 1
			pwidth = 32
			pheight = 16
			pleft = 32
			pright = 0
			icon_state = "ramp-4"

			New()
				..()
				icon_state = "ramp-4"

// we don't want to use these keys for any of the demos
client
	Northwest()
	Southwest()
	Northeast()
	Southeast()