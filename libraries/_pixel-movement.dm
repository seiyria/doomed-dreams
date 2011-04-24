
world
	icon_size = 32

atom
	// we need these vars for turfs and mobs at least. We probably don't
	// need them for areas, but it's easy to define them for all atoms.
	icon = 'icons.dmi'
	var
		// px/py is your position on the map in pixels
		px

		// pwidth/pheight determine the dimensions of your bounding box
		pwidth = 32
		//pheight = 32

		//pleft/pright determine where you enter on the left and where you exit on the right
		//or vice versa
		//see: ramps
		pleft = 0
		pright = 0

		//stack is my own variable added in as a miniature hack for things like platforms
		//it allows things that normally pass through each other while dense to stack on top of each other
		stack = 0

		hasCurrent=0

	New()
		..()

		if(pleft == 0 && pright == 0)
			pleft = pheight
			pright = pheight
		else
			pheight = max(pleft, pright)

		px = world.icon_size * x
		py = world.icon_size * y

	proc
		// this is called when a mob steps on
		stepped_on(mob/m)
			..()

		// we don't want to take an atom as an argument because we'll be using
		// this proc to check if a move would put an object inside another, we
		// want to check if the move is ok without actually performing it.
		// So, we take the query point, which is defined by the point qx,qy and
		// the size of the atom's bounding box: qw x qh.
		inside(qx,qy,qw,qh)
			if(qx <= px - qw) return 0
			if(qx >= px + pwidth) return 0
			if(qy <= py - qh) return 0
			if(qy >= py + pheight) return 0
			return 1

		height(qx,qy,qw,qh)
			if(pright > pleft)
				. = min(32, qx + qw - px)
				. = py + pleft + (.) * (pright - pleft) / pwidth
				. = min(., py + pright)
			else
				. = max(0, qx - px)
				if(. > px + pwidth) return -100
				. = py + pleft + (.) * (pright - pleft) / pwidth
				. = min(., py + pleft)

mob
	// for some reason, a pixel_step_size of 32 isn't adequate. It results
	// in some shaky camera movement. This shakiness seems to go away with
	// a value of 64.
	// pixel_step_size = 64
	animate_movement = 0

	proc
		// The pixel_move proc moves a mob by (dpx, dpy) pixels.

		// The pixel_move proc moves a mob by (dpx, dpy) pixels.
		pixel_move(dpx, dpy, trigger_bumps = 1)
			var/list/L = can_move(dpx,dpy,trigger_bumps)

			px += L[1]
			py += L[2]
			set_pos()

		can_move(dpx, dpy, trigger_bumps = 1)
			// We could intelligently look for all nearby tiles that you might hit
			// based on your position and direction of the movement, but instead
			// we'll just check every nearby object.
			for(var/atom/t in oview(1,src))

				// We use the src object's can_bump proc to determine what it can
				// collide with. We might have more complex rules than just "dense
				// objects collide with dense objects". For example, you might want
				// bullets and other projectiles to pass through walls that players
				// cannot.
				if(!can_bump(t)) continue

				// this handles bumping sloped objects
				if(t.pleft != t.pright)
					if(!t.inside(px+dpx,py+dpy,pwidth,pheight)) continue

					// check for bumping the sides
					if(px + pwidth < t.px)
						if(t.py + t.pleft > py + 3)
							dpx = t.px - (px + pwidth)
							x_bump(t)
							continue
					if(px > t.px + t.pwidth)
						if(t.py + t.pright > py + 3)
							dpx = t.px + t.pwidth - px
							x_bump(t)
							continue

					// check for bumping the top and bottom
					var/h = t.height(px+dpx,py+dpy,pwidth,pheight)

					if(py + dpy < h)
						if(py + pheight < t.py)
							vel_y = 0
							dpy = t.py - (py + pheight)
							y_bump(t)
						else
							// py = h
							dpy = h - py
							y_bump(t)

				// this handles bumping non-sloped objects
				else
					// You cannot be inside t already, so if the move doesn't put you
					// inside t then we can ignore that turf.
					if(!t.inside(px+dpx,py+dpy,pwidth,pheight)) continue

					// ix and iy measure how far you are inside the turf in each direction.
					var/ix = 0
					var/iy = 0

					// If you draw pictures showing a mob hitting a dense turf from the left
					// side and label px, dpx, pwidth, and t.px it's easy to see how you
					// compute ix. The same can be done for hitting a dense turf from the right.
					if(dpx > 0)
						ix = px + dpx + pwidth - t.px
					else if(dpx < 0)
						ix = (px + dpx) - (t.px + t.pwidth)

					// Same as the ix calculations except we swap y for x and height for width.
					if(dpy > 0)
						iy = py + dpy + pheight - t.py
					else if(dpy < 0)
						iy = (py + dpy) - (t.py + t.pheight)

					// tx and ty measure the fraction of the move (the dpx,dpy move) that it takes
					// for you to hit the turf in each direction.
					var/tx = (abs(dpx) < 0.00001) ? 1000 : ix / dpx
					var/ty = (abs(dpy) < 0.00001) ? 1000 : iy / dpy

					// We use tx and ty to determine if you first hit the object in the x direction
					// or y direction. We modify dpx and dpy based on how you bumped the turf.
					if(ty <= tx)
						dpy -= iy
						if(trigger_bumps)
							y_bump(t)
					else
						dpx -= ix
						if(trigger_bumps)
							x_bump(t)

			// At this point we've clipped your move against all nearby tiles, so the
			// move (dpx,dpy) is a valid one at this point (both might be zero) so we
			// can perform the move.
			return list(dpx, dpy)

		// Set pos computes your mob's x/y given your px/py, sets your loc, and manages the camera.
		//and manages checking for traps!
		set_pos()
			var/tx = round(px / world.icon_size)
			var/ty = round(py / world.icon_size)

			var/turf/tloc = locate(tx,ty,z)
			if(loc != tloc)
				loc = tloc
				Move(loc)

			var/list/ground = get_ground()

			for(var/atom/a in ground)
				a.stepped_on(src)

		/*	for(var/turf/trap/t in oview(1,loc))
				//walking into traps
				if(t.px-t.pwidth/1.5 < px && x<=t.x && y==t.y)
					t.trigger(src)*/

			if(isTrap(loc))
				var/turf/trap/tt=loc
				tt.trigger(src)


			pixel_x = px % world.icon_size + offset_x
			pixel_y = py % world.icon_size + offset_y

			if(client)
				if(client.perspective == EDGE_PERSPECTIVE)
					if(x > client.view && x <= world.maxx - client.view)
						client.pixel_x = pixel_x
					if(y > client.view && y <= world.maxy - client.view)
						client.pixel_y = pixel_y
				else
					client.pixel_x = pixel_x
					client.pixel_y = pixel_y

		x_bump(atom/a)
		y_bump(atom/a)
