client
	verb
		chat(s as text)
			set hidden=1
			if(false_text(s))return
			s = html_encode(s)
			world << "<b>\[[key]]</b> [s]"
	proc
		false_text(text)
			var/x=0                                                                                   //and so on.
			while(++x<=lentext(text))
				if(copytext(text,x,x+1)!=" ")
					return FALSE

			return TRUE