#define DEBUG

var
	BGM = 'sfx/MoogMixHigh.wav'
	DGM = 'sfx/death.wav'
	SGM = 'sfx/spring.wav'
	SAVE= 'sfx/save.wav'
	const
		K_RIGHT = "right"
		K_LEFT = "left"
		K_JUMP = "up"
		K_UP = "up"
		K_DOWN = "down"

		STATE_RIGHT = "right"
		STATE_LEFT = "left"
		STATE_STANDING = "standing"
		STATE_MOVING = "moving"
		STATE_CLIMBING = "climbing"

mob
	player
	icon_state = "mob"
	var/real_state="mob"
	pwidth = 24
	pheight = 24

	// For a sidescroller we want to keep track of the mob's velocity in each direction.
	var
		vel_x = 0
		vel_y = 0

		offset_x = 0
		offset_y = 0

		dir_state = STATE_RIGHT
		move_state = STATE_STANDING

		saved_px
		saved_py
		saved_z

		recentlyTeleported

		on_ladder

		deaths=0
			//break down into death by arrow, laser, etc
		saves =0
		hasCheated=0
		springBounces=0
		isEndlesslyFalling
		isInBossFight

	Login()
		..()
		loc=locate(2,2,1)
		clean_hp()
		px = world.icon_size * x
		py = world.icon_size * y

		saved_px=px
		saved_py=py
		saved_z =z

		set_state()
		src << sound(BGM,repeat=1,volume=50)

		spawn() movement_loop()


	// When we bump a wall we want to set the velocity for that direction to zero.
	// we also want to know what we hit, in case we hit a spring or a platform, or some-such
	x_bump(atom/a)
		if(a.hasCurrent)
			death("the electricity")
		else if(isTrap(a))
			var/turf/trap/t=a
			t.trigger(src)
		else
			vel_x = 0

	y_bump(atom/a)
		if(a.hasCurrent)
			death("the electricity")
		if(vel_y<0 && isPlatform(a))
			var/mob/platform/p=a
			p.riders += src
			platform = p
			onPlatform=1
		else if(isTrap(a))
			var/turf/trap/t=a
			t.trigger(src)
		vel_y = 0


	activate()
	trigger()
	deactivate()
	triggIS()
	resetIS()
	proc
		// by default you can only bump into dense turfs
		can_bump(atom/a)
			. = ..()
			if(isturf(a))
				return a.density

			if(istype(a, /mob/platform))
				return a.density

			return 0

		warp(zx,zy,zz)
			var/turf/t = locate(round(zx/32),round(zy/32),zz)
			loc = t
			px=zx
			py=zy

		save()
			saved_px = px
			saved_py = py
			saved_z  = z
			src << sound(SAVE,volume=20)
			if(saves++>50)
				EarnMedal("Safety First",src)

		death(a)
			if(client && !input_lock)
				if(hp>0)
					if(subtract_hp(1))return
				world << "[src] died because of [a]!"
				if(istype(a,/mob))
					if(isEndlesslyFalling && hp<=0)return
					var/mob/derp=a
					if(derp.client && real_state=="evil")
						isEndlesslyFalling=1
						world << "<b>\[Ominous Voice]</b> Ha.. Ha.. hahahaha! You think you've won?! Not a chance! You'll never defeat ME, [src]!"


						var/turf/trap/warp/t = locate("endless1")
						if(t)
							derp.warp(t.px,t.py,t.z)
							derp.lock_input()
							derp.clean_hp()
							spawn while(derp)
								sleep(world.tick_lag)
								derp.vel_x=0.25
						EarnMedal("Clear Mind",derp)
						EarnMedal("Shadowed Mind",src)

					else if(derp.client && real_state=="mob")
						isEndlesslyFalling=1
						world << "<b>\[Ominous Voice]</b> You can't win! You'll have to try harder than that to stop me, [src]!"

						var/turf/trap/warp/t = locate("endlesstop")
						if(t)
							warp(t.px,t.py,t.z)
							clean_hp()
							spawn while(src)
								sleep(world.tick_lag)
								vel_y=-0.25
						EarnMedal("Shadowed Mind",derp)
						EarnMedal("Shadowed Mind",src)

				lock_input()
				clear_input_nounlock()
				density=0
				src << sound(DGM)
				if(deaths++>200)
					EarnMedal("Unlucky?",src)
				//Insert awesome death animation here

		// The set_dir and set_move procs are used for managing the mob's icon_state.
		set_dir(d)
			if(dir_state == d) return
			dir_state = d
			set_state()

		set_move(m)
			if(move_state == m) return
			move_state = m
			set_state()

		set_state()
			icon_state = "[real_state]-[move_state]-[dir_state]"

		movement_loop()

			// In a sidescroller you have a constant downward acceleration
			//unless, of course, you happen to be on a ladder.


			var/turf/t = get_tile()

			if(istype(t,/turf/ladder))
				if(keys[K_UP] || keys[K_DOWN])
					if(!on_ladder)
						vel_y = 0
					on_ladder = 1
			else
				on_ladder = 0

			var/list/ground = get_ground()
			var/list/right=on_right()
			var/list/left =on_left()
			var/on_ground = ground.len

			// If we're on a ladder we want the arrow keys to move us in
			// all directions. Gravity will not affect you.
			if(on_ladder)
				if(keys[K_RIGHT])
					set_dir(STATE_RIGHT)
					if(!right.len)
						if(vel_x < 5)
							vel_x += 1

				if(keys[K_LEFT])
					set_dir(STATE_LEFT)
					if(!left.len)
						if(vel_x > -5)
							vel_x -= 1

				if(keys[K_UP])
					if(vel_y < 5)
						vel_y += 1

				if(keys[K_DOWN])
					if(!on_ground)
						if(vel_y > -5)
							vel_y -= 1

				// On a ladder your vertical movement speed will decrease if
				// you're not pressing up or down.
				if(!keys[K_UP] && !keys[K_DOWN])
					if(vel_y > 0)
						vel_y -= 1
					else if(vel_y < 0)
						vel_y += 1
			else
				if(!on_ground || onPlatform || isTrap(loc))
					if(platform)
						platform.riders-=src
						platform=null
					onPlatform=0
					vel_y -= 1

				if(jumped)
					jumped = 0
					if(on_ground || onPlatform)
						vel_y = 11

					else if(right.len || left.len)
						if(right.len)
							var/turf/tt = right[1]
							vel_y = tt.y_mod
							vel_x = -tt.x_mod
						if(left.len)
							var/turf/tt = left[1]
							vel_y = tt.y_mod
							vel_x = tt.x_mod
						//modify this value for higher jumps

				if(keys[K_RIGHT])
					set_dir(STATE_RIGHT)
					if(!right.len)
						if(vel_x < 5)
							vel_x += 1

				if(keys[K_LEFT])
					set_dir(STATE_LEFT)
					if(!left.len)
						if(vel_x > -5)
							vel_x -= 1

			// if you're not pressing left or right, slow down
			if(!keys[K_RIGHT] && !keys[K_LEFT])
				if(vel_x > 0)
					vel_x -= 1
				else if(vel_x < 0)
					vel_x += 1

			if(on_ladder)
				set_move(STATE_CLIMBING)
			else
				if(vel_x == 0)
					set_move(STATE_STANDING)
				else
					set_move(STATE_MOVING)

			if(right.len && isFWall(right[1]))
				var/turf/wall/friction/f=right[1]
				vel_y+=f.v_mod

			if(left.len && isFWall(left[1]))
				var/turf/wall/friction/f=left[1]
				vel_y+=f.v_mod

			if(vel_x != 0 || vel_y != 0)
				pixel_move(vel_x, vel_y)

			spawn(world.tick_lag) movement_loop()

		// The on_ground proc returns 1 if you're standing on the ground and zero otherwise.
	/*	on_ground()
			var/ty = round((py-1) / world.icon_size)
			var/tx = round(px / world.icon_size)

			//platform hack
			if(onPlatform)return 1

			// for some nearby tiles that are below you...
			for(var/x = 0 to 1)
				var/atom/t = locate(tx+x,ty,z)
				if(!t || !t.density || !t.stack) continue

				if(t.pleft != t.pright)
					if(py <= t.height(px,py,pwidth,pheight))
						return 1
				else
					// If you're over top of one and it is dense, your on the ground.
					if(px <= t.px - pwidth) continue
					if(px >= t.px + t.pwidth) continue

					// if you're actually standing on the tile
					if(py != t.py + t.pheight) continue

					return 1

			return 0*/

		// The get_ground proc returns a list of objects that you're standing on. This
		// can be used in place of the on_ground proc. If the list returned is empty,
		// you're not on the ground.
		get_ground()
			. = list()
			for(var/atom/a in oview(2,src))
				if(!can_bump(a)) continue

				// If you're not lined up with it's top edge we can ignore this object
				if(a.pleft == a.pright)
					if(py != a.py + a.pheight) continue
				else
					if(py != a.height(px,py,pwidth,pheight)) continue

				// If you're not lined up horizontally we can also ignore the object
				if(px > a.px + a.pwidth) continue
				if(px + pwidth < a.px) continue
				. += a

		// The on_right and on_left procs return 1 if your are touching a wall on
		// your left or right.
		on_right()
			. = list()
			for(var/atom/a in oview(2,src))
				if(!can_bump(a)) continue

				// If you're not lined up with it's left edge we can ignore this object
				if(px + pwidth != a.px) continue

				if(a.pleft != a.pright)
					if(py >= a.py + a.pleft) continue
					if(py + pheight < a.py) continue

				else
					// If you're not lined up vertically we can also ignore the object
					if(py >= a.py + a.pheight) continue
					if(py + pheight < a.py) continue

				. += a

		on_left()
			. = list()
			for(var/atom/a in oview(2,src))
				if(!can_bump(a)) continue

				if(px != a.px + a.pwidth) continue

				if(a.pleft != a.pright)
					if(py >= a.py + a.pright) continue
					if(py + pheight < a.py) continue

				else
					if(py >= a.py + a.pheight) continue
					if(py + pheight < a.py) continue

				. += a
		get_tile()
			var/tx = round((px + pwidth  / 2) / world.icon_size)
			var/ty = round((py + pheight / 2) / world.icon_size)

			return locate(tx,ty,z)