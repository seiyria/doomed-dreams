mob
	var
		list/keys = list()
		input_lock = 0
		key_repeat = 0
		jumped = 0

	proc
		is_locked()
			return input_lock>0

		lock_input()
			input_lock += 1

		unlock_input()
			input_lock -= 1
			if(input_lock < 0)
				input_lock = 0

		clear_input()
			input_lock = 0
			for(var/k in keys)
				keys[k] = 0

		clear_input_nounlock()
			for(var/k in keys)
				keys[k] = 0

	verb
		KeyDown(k as text)
			set hidden = 1

			if(input_lock) return
			keys[k] = 1

			if(k == "up")
				jumped = 1

		KeyUp(k as text)
			set hidden = 1
			keys[k] = 0

		Repeat(k as text)
			set hidden = 1

			if(input_lock) return

		Action(x as num)
			set hidden = 1
			if(input_lock && !isEndlesslyFalling && x!=11 && x!=9) return 0
			switch(x)
				//shoot
				if(0)
					FirePixelProjectile(src, (dir_state==STATE_RIGHT ? 0 : 180), /bullets/bullet, (dir_state==STATE_RIGHT ? pixel_x+32 : 0), pixel_y)

				//completely restart
				if(9)
					if(isInBossFight)return
					var/obj/savepoint/s = locate("Tower One - Bottom")
					if(s)
						warp(s.px,s.py,s.z)
						clear_input()
						density=1
					else
						src << "The beginning could not be found?!"
				//haxsave
				if(10)
					if(isInBossFight)return
					save()
					EarnMedal("Dirty Cheater",src)
					hasCheated++
				//respawn
				if(11)
					if(isInBossFight)return
					warp(saved_px,saved_py,saved_z)
					clear_input()
					density=1
				//haxwarp
				if(12)
					if(isInBossFight)return
					var/list/l = list()
					for(var/obj/savepoint/o in world)
						l += o.tag
					var/xx = input(src, "Where would you like to go?","Haxwarping") in l + "Cancel"
					var/obj/savepoint/s = locate(xx)
					if(s)
						warp(s.px,s.py,s.z)
						px = s.px
						py = s.py
						EarnMedal("Dirty Cheater",src)
						hasCheated++

		EnterKey()
			set hidden = 1
			if(input_lock) return 0

		Cancel()
			set hidden = 1