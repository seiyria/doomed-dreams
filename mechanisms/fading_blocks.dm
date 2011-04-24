

mob/platform
	fading
		stack=1
		icon_state="block"
		var/isSet=0
		var/hangtime=20
		pheight=32
		pwidth=32
		New()
			..()
			//these tags will be like ABC1, ABC2, etc.

			//if they don't have a tag, they're doin' it wrong.
			if(!tag)
				world.log << "NO TAG FOR ME AT [x],[y],[z]!"
				del src

			//we only want to use the first one..
			if(!findtext(tag,"1"))return

			var/list/accompany[12]
			spawn(30)
				for(var/mob/platform/fading/f in world)
					if(findtext(f.tag,copytext(tag,1,4)))
						accompany[text2num(copytext(f.tag,4))]=f
				new/fademanager(accompany)