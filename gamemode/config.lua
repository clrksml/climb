
/*
	Random Map Change
	Set this to false if you'd like a custom addon to handle map changing.
*/
CLIMB_MAPCHANGE = true

/*
	Map time limit
	Set this to the amount of seconds until map change.
*/
CLIMB_MapTime = 3600

/*
	SQL Details
	Set your hostname/ip, username, password, database name, and port here.
*/
if SERVER then
	CLIMB_HOST = "hostname"
	CLIMB_USER = "username"
	CLIMB_PASS = "password"
	CLIMB_NAME = "databasename"
	CLIMB_PORT = 3306
end

/*
	Custom scoreboard
	Set this true if you want to use a custom scoreboard.
*/
CLIMB_SCOREBOARD = false

/*
	Maxium Number of Saves
	If set to anything above 0 this will then place a restriction on the maxium number of saves a player can make.
*/
CLIMB_MAXSAVES = 0
