
//part of a ridiculous hack in tandem with my sd_pixel_projectiles hack
bullets
	parent_type=/obj/sd_px_projectile

	Hit(atom/a)
		if(a==owner)return
		if(ismob(owner))
			var/mob/m=owner
			if(m.client)
				if(istype(a,/obj/savepoint))
					flick("save_trig",a)
					m.save()

			if(ismob(a))
				var/mob/trg=a
				if(trg.client)
					if(m.isInBossFight && trg.isInBossFight)
						trg.death(m)

		del src

	New(cz, cw)
		cx+=cz
		cy+=cw
		..()

	bullet
		icon_state="bullet"
		speed=16
		range=64
		pheight=4
		pwidth=4
		cy=7

	lasers
		Hit(atom/a)
			if(ismob(a))
				var/mob/m = a
				if(m.client)
					m.death(owner)
			..()
		speed=40
		range=64
		pheight=4
		pwidth=8
		cy=13
		cx=3
		red
			icon_state="laser_red"
		yellow
			icon_state="laser_yellow"
			pwidth=32
		blue
			icon_state="laser_blue"
		green
			icon_state="laser_green"
			speed=20
			range=20
		arrow
			speed=60
			pheight=5
			pwidth=16
			icon_state="arrow"