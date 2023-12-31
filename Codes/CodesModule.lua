local codes = {}


--[[Structure

codes["CODE NAME"] = {
	reward = {"Number Type"} ---> Number is how much of the Type you get. You can also give a tool as a value in the array.
	
	--Optional values:
	maxRedeems = Integer ---> The amount of times the code can be redeemed before it becomes invalid
	repeatable = Boolean ---> Whether a player can use the code more than once
	expiresAt  = Number  ---> When the code will expire. You can get this time by entering this into the command bar:   
                           --            print(os.time({year=2022, month=12, day=25, hour=0, minute = 0, second = 0}))
}

]]--

codes["FREE CASH 123"] = {
	reward = {"500 Cash"};
	maxRedeems = 1;
}

codes["SUPERHUMAN"] = {
	reward = {"40 WalkSpeed", "15 JumpHeight", "1000 MaxHealth", "1000 Health"};
	repeatable = true;
}

codes["500K LIKES"] = {
	reward = {"30000 Cash", script.Parent:WaitForChild("ToolRewards"):WaitForChild("ClassicSword")};
	expiresAt = 1671926400;
}


return codes