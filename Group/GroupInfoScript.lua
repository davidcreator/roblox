local groupId = 2929563
 
 
local groupData = game:GetService("GroupService"):GetGroupInfoAsync(groupId)
 
 
local httpService = game:GetService("HttpService")
 
local url = 'https://groups.rprxy.xyz/v1/groups/' .. groupId
 
 
while wait(5) do
   
   
    local memberCount = httpService:JSONDecode(httpService:GetAsync(url)).memberCount
 

    script.Parent.MemberCount.Text = "🔴[LIVE] Members: " .. memberCount
 
 
    script.Parent.GroupImage.Image = groupData.EmblemUrl
    script.Parent.GroupName.Text = groupData.Name
    script.Parent.GroupDescription.Text = groupData.Description
end