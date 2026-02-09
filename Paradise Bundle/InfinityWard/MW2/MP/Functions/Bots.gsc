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
        wait .75;
	}
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

/*
needs implemented...
BotRenamer()
{
    names = [ "Hawkfeet",
            "TricksyCantNac",
            "FemboyLew",
            "WetCucumber69",
            "XxtrikXxruthl3ssXx",
            "AFK Dang",
            "HelloWorld('Print')",
            "DiddysBabyOil",
            "NickGurr36",
            "Joe Rogaine",
            "TicklishAltarBoy",
            "Chief Slapahoe",
            "Queef Jerky",
            "Jenna Tolls",
            "Higger Nater",
            "RimReaperAssAtak",
            "DougDimmadome",
            "GrandmasDealDoe"
            ];

    if(!isdefined(level.BotNameIndex))
        level.BotNameIndex = 0;

    if(level.BotNameIndex >= names.size)
        level.BotNameIndex = 0;

    name = names[level.BotNameIndex];
    level.BotNameIndex++;

    return name;
}
*/