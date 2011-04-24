/*
Random statistics to add:
-time spent total
-time spent sitting around on platforms
-time spent idle
-time spent on a wall

Traps to add:
-water
-firetraps
-deadly platforms that crawl along a floor

Mechanisms to add:
-floating and hovering, in conjunction with..
-windtunnels, basically a constant stream of air in any given direction, with a given range
	possibly preventing motion if they're strong enough.

AI to implement and add (or maybe just use movement loop and customize there):
-bats that move in a semi-random pattern, starting from the ceiling, and only move
	when you jump near them
-floor-based monsters that just run around
-machines that actually fire at you, and are destructible
	->probably can function exactly like a platform, but with shooting.

Multiplayer Additions:
2p - pvp fight at the end
3p - boss fight
4p - undecided, either battle royale or boss fight


[Wednesday - 23:15:22] DarkChowder: if(!t.inside(px+dpx%16,py+dpy%16,pwidth,pheight))

[Wednesday - 23:18:56] DarkChowder: if(vel_x|vel_y) pixel_move(vel_x, vel_y)

[Wednesday - 23:24:25] DarkChowder: if(!t.isTriggered())
                              t.trigger(src)
[Wednesday - 23:24:26] DarkChowder: if(!tt.isTriggered())
                         tt.trigger(src)
*/