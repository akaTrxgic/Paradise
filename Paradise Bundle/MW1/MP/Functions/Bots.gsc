addTestClients(num, team)
{
    setDvar("sv_botsPressAttackBtn", "1");
    setDvar("sv_botsRandomInput", "1");

    if(team == "enemy")
        team = self getenemyteam();
    else
        team = self.pers["team"];

    bot = [];

    for (i = 0; i < num; i++)
    {
        bot[i] = addtestclient();
        if (!isdefined(bot[i]))
        {
            wait 1;
            continue;
        }

        bot[i].pers["isBot"] = true;
        bot[i] thread TestClient(team);
        wait .75;
    }
}
TestClient(team)
{
    self endon("disconnect");

    while(!isDefined(self.pers["team"]))
        wait 1;
    self notify("menuresponse", game["menu_team"], team);
    wait 0.1;
 
    classes = getArrayKeys(level.classMap);
    okclasses = [];
    for (i = 0; i < classes.size; i++)
    {
        if (!issubstr(classes[i], "sniper") && isDefined(level.default_perk[level.classMap[classes[i]]]))
            okclasses[okclasses.size] = classes[i];
    }
    assert(okclasses.size);

    for (;;)
    {
        randomClass = okclasses[randomint(okclasses.size)];

        if (!level.oldschool)
            self notify("menuresponse", "changeclass", randomClass);

        self waittill("spawned_player");

        wait 0.1;
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