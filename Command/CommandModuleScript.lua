local requiredPermissionLevel = 1
local requiredMinimumArguments = 1


function bring(cmdUser, permissionLevel, args)
	
	if #args >= requiredMinimumArguments then
		
		if permissionLevel >= requiredPermissionLevel then
			
			--execute command
		end
	end
end

return bring
