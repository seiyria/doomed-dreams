turf
	New()
		..()
		if(hasCurrent)
			spawn while(src)
				hasCurrent=0
				sleep(delay)
				overlays += new/obj/electric
				hasCurrent=1
				sleep(delay)
				overlays = new/list()

	stepped_on(mob/m)
		if(hasCurrent)
			m.death("electricity")
		else
			trigger(m)
	trap
		layer=MOB_LAYER+1
		density=1

		fakerealityorb
			isTriggerable=1
			density=0
			activate()
				if(isActive)return
				isActive=1

				var/list/players=list()
				for(var/mob/m in oview(10,src))
					players += m

					m.isInBossFight=1
					m.isInBossFight=1

				if(players.len<2)
					oview(10,src) << "What?! How did this happen?! Bug #rfo1"
					return
				if(players.len>2)
					oview(10,src) << "What?! How did this happen?! Bug #rfo2"
					return

				var/mob/p1 = pick(players)
				players -= p1
				var/mob/p2 = pick(players)
				players -= p2

				oview(10,src) << "<b>\[Ominous Voice]</b> Little did you know, [p2], I've been following you the whole time!"
				flick("fakerealorb",src)
				sleep(10)
				flick("fakerealorb",src)
				sleep(5)
				flick("fakerealorb",src)
				sleep(2)
				icon_state="fakerealorb"

				oview(10,src) << "<b>\[Reality Orb?]</b> Now, [p2], it's time for me to destroy you from the inside out!"
				sleep(10)
				icon_state="white"
				missile(/obj/fakerealorb,src,p1)
				p1.real_state="evil"
				p1.set_state()
				sleep(10)

				oview(10,src) << "<b>\[[p1]]</b> It's time to meet your end, once and for all!"

				p1.setup_hp()
				p2.setup_hp()
				p1.hp*=2
				p1.max_hp*=2

				p1.clear_input()
				p2.clear_input()

		realityorb
			name="Reality Orb"
			pheight=0
			icon_state="realorb"
			trigger(mob/m)
				if(m.is_locked())return
				EarnMedal("Circularity in a Cold, Square World", m)
				m.lock_input()
				m.isEndlesslyFalling=1
				spawn(0)
					m << "<b>\[Reality Orb]</b> You've found me at last!"
					sleep(20)
					m << "<b>\[Reality Orb]</b> Gosh, I was wondering how long I'd have to sit here!"
					sleep(20)
					m << "<b>\[Reality Orb]</b> Lets get out of here!"
					sleep(20)
					var/turf/trap/warp/t = locate("endlesstop")
					if(t)
						m.warp(t.px,t.py,t.z)
						spawn while(src)
							sleep(world.tick_lag)
							m.vel_y++
						sleep(10)
						m << "<b>\[Ominous Voice]</b> And so it ends, another man taken away from reality."
						sleep(30)
						m << "<b>\[Ominous Voice]</b> Now, he's surrounded by the pieces of his mind."
						sleep(30)
						m << "<b>\[Ominous Voice]</b> If only death called him, he'd be free from the chains of his mind."
						sleep(20)
						m << "<b>\[Ominous Voice]</b> But now he's stuck, here, forevermore!"
						sleep(50)
						m << "<i>You imagine that you hear distant laughter..</i>"
						sleep(10)
						m << ""
						m << "<u>Random Statistics</u>:"
						m << "You died [m.deaths] times."
						m << "You saved [m.saves] times."
						m << "You cheated [m.hasCheated] times."
						m << "You bounced on springs [m.springBounces] times."
						if(m.hasCheated)
							EarnMedal("Cheaters Can Prosper",m)
						if(m.saves<=13 && !m.hasCheated)
							EarnMedal("Hardcore",m)
						if(m.deaths<=10 && !m.hasCheated)
							EarnMedal("Survivor",m)
						if(m.saves<=13 && m.deaths<=10 && !m.hasCheated)
							EarnMedal("Beyond Reality",m)
						//statistic ideas?

		spikes
			name="Spike Trap"
			pheight=0
			icon_state="spikes"
			trigger(mob/m)
				if(m.py%32 < 8)
					..()
					m.death(src)
		spike
			icon_state="spike"
			name="Spike"
			up
				dir=NORTH
				pwidth=32
				pheight=16
			down
				dir=SOUTH
				pwidth=32
				pheight=16
				New()
					..()
					py+=16
			left
				dir=WEST
				pwidth=16
				pheight=32
				New()
					..()
					px+=16
			right
				dir=EAST
				pwidth=16
				pheight=32
			trigger(mob/m)
				m.death(src)
		warp
			var/warpPoint
			pheight=32
			pwidth=32
			density=0
			icon_state="warp"
			trigger(mob/m)

				//yay, lazy hacks
				if(m.recentlyTeleported || !m.density)return
				m.recentlyTeleported=1
				spawn(50)
					m.recentlyTeleported=0

				..()

				spawn(10)
					var/turf/trap/warp/t = locate(warpPoint)
					if(t)
						if(inside(m.px,m.py,m.pwidth,m.pheight))
							m.warp(t.px,t.py,t.z)
					else if(!t && warpPoint)
						m << "You can't go back now.. Come on!"
						EarnMedal("Faint of Mind",m)

			seamlesswarp
				icon_state="white"
				layer=TURF_LAYER
				trigger(mob/m)
					..()
					spawn(10)
						var/turf/trap/warp/t = locate(warpPoint)
						if(t)
							m.warp(t.px,t.py,t.z)

			lockwarp
				icon_state="warp"
				trigger(mob/m)
					if(!icon_state)return
					..()
					spawn(10)
						var/turf/trap/warp/t = locate(warpPoint)
						if(t)
							m.warp(t.px,t.py,t.z)
							m.lock_input()
							icon_state="white"
		trapdoor
			trapfloor
				pheight=32
				icon_state="block"
				triggIS()
					if(isTriggered())return
					flick("block_fadeout",src)
					icon_state="block_faded"
				resetIS()
					flick("block_fadein",src)
					icon_state="block"
					density=1
			var/trigtime=10
			pheight=0
			icon_state="trapdoor"
			trigger(mob/m)
				spawn(trigtime)
					if(!isTriggered())
						..()
						density=0
			resetIS()
				..()
				density=1

		spring
			pheight=0
			pwidth=32
			delay=10
			var/vel_change=20
			var/spring_mul=3
			icon_state="spring"
			trigger(mob/m)
				m.springBounces++
				m << sound(SGM,volume=20)
				..()
			up
				dir=NORTH
				trigger(mob/m)
					if(m.py%32 < 8 && m.density)
						..()
						m.vel_y=vel_change
			down
				dir=SOUTH
				pwidth=26
				New()
					..()
					py+=32
					px+=3
				trigger(mob/m)
					if(m.py%32 > 7 && m.density)
						..()
						m.vel_y=-m.vel_y*spring_mul

			right
				dir=WEST
				pwidth=0
				pheight=32
				New()
					..()
					px+=32
				trigger(mob/m)
					if(m.px%32 > 7 && m.density)
						..()
						m.vel_x=-m.vel_x*spring_mul
						if(abs(m.vel_x)<0.0001)
							m.vel_x=-5
			left
				dir=EAST
				pwidth=0
				pheight=32
				trigger(mob/m)
					if(m.px%32 < 8 && m.density)
						..()
						m.vel_x=-m.vel_x*spring_mul
						if(abs(m.vel_x)<0.0001)
							m.vel_x=5