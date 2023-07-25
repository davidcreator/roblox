local achievements = {}


achievements["Welcome"] = {
	ImageId = 6915066359; -- ID of the achievement's image
	Description = "Thanks for playing the game!"; -- The description for this achievement
	
	OrderRank = 1; -- The position this achievement will appear on the GUI
}

achievements["10 minutes"] = {
	ImageId = 228648990;
	Description = "You've played for 10 minutes. Keep going!";
	OrderRank = 2;
}

achievements["Energetic"] = {
	ImageId = 541620958;
	Description = "You're quite energetic to have walked 500 studs already!";
	OrderRank = 3;
}


return achievements;