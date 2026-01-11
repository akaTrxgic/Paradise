addbot(num, team)
    {
        if(team == "enemy")
            team = self getenemyteam();
        else
            team = self.pers["team"];

        bot = [];
        number = int(num);

	    for(i=0; i<number; i++)
	    {
		    bot[i] = addtestclient(BotRenamer());

    		if (!isdefined(bot[i])) 
            {
		    	wait 1;
			    continue;
    		}
			
		    bot[i].pers["isBot"] = true;
		    bot[i] thread SpawnBot(team);
            wait 5;
        }
    }

    SpawnBot(team)
    {
        self endon("disconnect");

        while(!isdefined(self.pers["team"]))
            wait .05;

        self notify("menuresponse", game["menu_team"], team);
        wait .05;

        self notify("menuresponse", "changeclass", "class"+ randomint(5));
    }

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

GetEnemyTeam()
{
    if(self.pers["team"] == "allies")
        team = "axis";
    else
        team = "allies";
    
    return team;
}