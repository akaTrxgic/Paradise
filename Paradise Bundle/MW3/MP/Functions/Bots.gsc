spawnBots(num, team)
{
    if(team == "enemy")
        team = self getenemyteam();
    else
        team = self.pers["team"];

    bot = [];

	for (i = 0; i < num; i++)
	{
		bot[i] = addtestclient();
        if(!isDefined(bot[i]))
        {
            wait 1.5;
            continue;
        }
        bot[i].pers["isBot"] = true;
        bot[i] thread spawnBot(team);
        wait 1;
	}
}
GetEnemyTeam()
{
    if(self.pers["team"] == "allies")
        team = "axis";
    else
        team = "allies";
    
    return team;
}
SpawnBot(team)
{
    self endon("disconnect");
    
    while(!isDefined(self.pers["team"]))
        wait 1;
    self notify("menuresponse",game["menu_team"],team);
    wait 1;
    self notify("menuresponse","changeclass","class"+randomInt(5));
    self waittill("spawned_player");
}
