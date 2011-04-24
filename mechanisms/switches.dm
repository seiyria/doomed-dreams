turf
	trap
		trigger
			delay=5
			density=0
			invisible
				icon_state="white"
				layer=TURF_LAYER
			var/list/parents=list()
			var/doesDelay
			var/tDelay
			name="Switch"
			pheight=0
			icon_state="switch"
			stepped_on(mob/m)
				..(m)

			New()
				..()
				spawn(30)
					for(var/atom/a in world)
						if(a.isTriggerable && a.tag==tag)
							parents+=a
							a.mechanisms += src

			trigger(mob/m)
				if(m.client && m.py%32 < 8 && !isTriggered())
					..()
					if(parents.len)
						spawn for(var/atom/o in parents)
							o.mechanisms[src]=1
							if(doesDelay)
								sleep(tDelay)
					else
						world.log << "[tag]  [x],[y],[z] [src] has no parent!"

			resetIS()
				..()
				if(parents.len)
					for(var/atom/o in parents)
						o.mechanisms[src]=0
				else
					world.log << "\[[tag]] [src] has no parent!"

		triggerable
			isTriggerable=1
			layer=TURF_LAYER

			multi_portal
				cType="and"
				pheight=32
				density=0

				activate()
					if(!isActive)
						world << "<b>\[Ominous Voice]</b> You dare open up the path that will drag you deeper into the void?!"
						overlays += new/icon('icons.dmi',"warp")
					..()

				trigger(mob/m)
					if(isActive)
						var/turf/trap/warp/t = locate("multi_entrance")
						if(t)
							m.warp(t.px,t.py,t.z)
				deactivate()

			pvp_portal
				cType="and"
				pheight=32
				density=0

				activate()
					if(!isActive)
						world << "<b>\[Ominous Voice]</b> Rest assured, you'll go no farther!"
						overlays += new/icon('icons.dmi',"warp")
					..()

				trigger(mob/m)
					if(isActive)
						var/turf/trap/warp/t = locate("2p_pvp_puzzle")
						if(t)
							m.warp(t.px,t.py,t.z)


			simple_door
				cType="or"
				icon_state="door"
				density=1
				pwidth=16
				trigger()
				activate()
					if(!isActive)
						..()
						flick("door_opening",src)
						icon_state="door_open"
						density=0
				deactivate()
					if(isActive && doesReset)
						..()
						flick("door_closing",src)
						icon_state="door"
						density=1
				New()
					..()
					px+=8


