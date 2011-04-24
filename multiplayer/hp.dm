mob
	var
		hp	   = 0
		max_hp = 20

	proc
		setup_hp()
			winshow(src,"hp")
			for(var/x=1 to 10)
				winset(src,"hp","value=[x*10]")
				sleep(world.tick_lag)
			hp=20

		redraw_hp()
			winset(src,"hp","value=[round(abs(hp/max_hp)*100)]")

		clean_hp()
			winshow(src,"hp",0)

		subtract_hp(amt)
			hp -= amt
			redraw_hp()
			if(hp<=0)
				clean_hp()
				return 0
			return 1