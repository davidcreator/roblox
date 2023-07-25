local abbreviations = {
	N = 10^30;
	O = 10^27;
	Sp = 10^24;
	Sx = 10^21;
	Qn = 10^18;
	Qd = 10^15;
	T = 10^12;
	B = 10^9;
	M = 10^6;
	K = 10^3
}


function abbreviateNums(number)
	
	
	local abbreviatedNum = number
	local abbreviationChosen = 0
	
	
	for abbreviation, num in pairs(abbreviations) do
		
		if number >= num and num > abbreviationChosen then
			
			local shortNum = number / num
			local intNum = math.floor(shortNum)
				
			abbreviatedNum = tostring(intNum) .. abbreviation .. "+"
			abbreviationChosen = num
		end
	end
	
	return abbreviatedNum
end



print(abbreviateNums(10000000)) --> 10M
print(abbreviateNums(10 ^ 30)) --> 1N
print(abbreviateNums(10 ^ 32)) --> 100N