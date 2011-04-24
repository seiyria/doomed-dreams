
client/New()
	..()
	world << "<i>-->[key] has decided to join us!</i>"
	winset(src,"default","pos=1,1")

client/Del()
	world << "<i><--[key] has decided to leave us!</i>"
	if(mob.z<4)
		del mob
	..()

world
	name = "Doomed Dreams"
	hub  = "divinetraveller.doomeddreams"
	hub_password="uP9BuWynWVhEzung"
	mob = /mob/player

proc
	EarnMedal(name,player)
		if(world.SetMedal(name,player))
			player << "<i>You have earned: [name]</i>"