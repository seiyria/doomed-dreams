

fademanager
	var/list/reallist=list()
	New(list/blocks)

		for(var/mob/platform/fading/t in blocks)
			t.density=0
			t.icon_state="block_faded"
			reallist += t

		spawn while(src)
			for(var/x=1 to reallist.len)
				var/mob/platform/fading/t=reallist[x]

				flick("block_fadein",t)
				t.density=1
				t.icon_state="block"

				sleep(t.hangtime)

				flick("block_fadeout",t)
				t.icon_state="block_faded"
				t.density=0
