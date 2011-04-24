atom
	parent_type=/triggerable
	deactivate()
		..()
	//caused by other forces
	activate()
		..()

	//caused by being collided with
	trigger(mob/m)
		..()

	resetIS()
		icon_state=copytext(icon_state,1,findtext(icon_state,"_"))

	triggIS()
		if(isTriggered())return
		icon_state="[icon_state]_trig"

	isTriggered()
		return findtext(icon_state,"trig")

	New()
		..()
		if(isTriggerable)
			mechanisms=list()
			spawn while(src)
				sleep(10)
				var/count
				for(var/o in mechanisms)
					if(mechanisms[o]==1)
						count++
				if(cType=="and" && count == mechanisms.len)
					activate()
				else if(cType=="or" && count > 0)
					activate()
				else
					deactivate()
triggerable

	var
		isActive
		delay=30
		isTriggerable=0
		doesReset=1
		list/mechanisms
		cType="or"

	proc
		deactivate()
			isActive=0
		//caused by other forces
		activate()
			isActive=1

		//caused by being collided with
		trigger(mob/m)
			triggIS()
			spawn(delay)
				if(doesReset)
					resetIS()

		resetIS()

		triggIS()

		isTriggered()