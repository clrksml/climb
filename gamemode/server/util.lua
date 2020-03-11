
-- Because garrysmod's table functions are cutting it.

function GetWinningKey( tab )
	local highest = 0
	local winner = nil
	
	for k, v in pairs( tab ) do
		if ( v.time > highest ) then 
			winner = k
			highest = v.time
		elseif (v.time == highest) and (tab[winner].saves >= v.saves) then
			winner = k
			highest = v.time
		end
	end
	
	return winner
end

function SortTable( tab )
	local tbl = {}
	local num = 1
	
	for k, v in SortedPairsByMemberValue(tab, "time", false) do
		tbl[num] = { sid = v.sid, time = v.time,  saves = v.saves }
		num = num + 1
	end
	
	return tbl
end