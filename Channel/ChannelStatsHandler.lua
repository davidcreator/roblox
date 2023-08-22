local httpService = game:GetService("HttpService")

local id = "UCE4hHKx3Qnwo4vz-26xiX0Q"


while wait(5) do
	
	local link = httpService:GetAsync("https://www.googleapis.com/youtube/v3/channels?part=statistics&id=" .. id .. "&key=AIzaSyD8Mru34qlgyVISGybnidJkqjwr-fzxlsQ")
	
	local dataFromLink = httpService:JSONDecode(link)
	
	
	local subs = tostring(dataFromLink.items[1].statistics.subscriberCount)
	
	local views = tostring(dataFromLink.items[1].statistics.viewCount)
	
	local uploads = tostring(dataFromLink.items[1].statistics.videoCount)


	script.Parent.Subs.Text = "Subscribers: " .. subs
	
	script.Parent.Views.Text = "Views: " .. views
	
	script.Parent.Uploads.Text = "Uploads: " .. uploads
end