
GM.Name = "Climb"
GM.Author = "Clark (Aide)"
GM.Website = "www.HavocGamers.net"

TEAM_CLIMBER = 1

team.SetUp(TEAM_CLIMBER, "Climber", Color(155, 17, 30))

team.SetSpawnPoint(TEAM_CLIMBER, {"info_player_terrorist", "info_player_counterterrorist"})

function GM:GetGameDescription( )
	return self.Name
end