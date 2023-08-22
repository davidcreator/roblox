local gunSettings = {
	ammo = 16, --How many bullets the player can shoot before having to reload
	bulletsPerShot = 1, --How many pellets the bullet splits into after being shot
	fireRate = 1 / 6.75, --The time before another bullet can be shot again
	spread = 1, --The maximum inaccuracy of each bullet that is multiplied by the distance the bullet travels
	cameraRecoil = 1, --How much the camera jumps up after each shot
	reloadTime = 5, --How much time it takes to reload to a full magazine
	automatic = false, --Whether the player can hold down left click to shoot or not
	damage = 26, --The damage each pellet of the bullet does to a player
	damageFalloff = 0.1, --How much the damage decreases for every stud it travels
}

return gunSettings