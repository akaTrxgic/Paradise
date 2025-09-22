AddBot(number, team)
    {
        if(team == "enemy")
            team = self GetEnemyTeam();
        else
            team = self.pers["team"];

        bot = [];
        num = int(number);
        for(a=0;a<num;a++)
        {
            bot[a] = AddTestClient(BotRenamer());

            if(!isdefined(bot[a]))
            {
                wait 1;
                continue;
            }

            bot[a].pers["isBot"] = true;
            bot[a] thread SpawnBot(team);
            wait .5;
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
        names = [ "Software","Torq","Sus","Moxah","Cykotic","BravSoldat","Maximus","ZZ9 xiHaXoRZz","Jiggaboo","SyGnUs","Smokey xKoVx","Hated Cotton","Dread","CF4x99","Bog","iProFamily","Xbox 360","WarHeadInc" ];

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