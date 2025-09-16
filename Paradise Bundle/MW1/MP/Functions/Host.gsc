add1Min()
{
    {
    }
}

sub1Min()
{
    {  
    }

    level.timelimit -= 60;
    self iPrintln("^1Subtracted 1 Minute.");
}


//BOT SHIT

fillLobby()
{
    level.i = 0;
    while (level.i < 18) 
    {
        wait .125;
        addTestClients();
        level.i++;
        wait 0.5;
    }
    self iprintln("Lobby ^1filled");
}
addTestClients()
{
    setDvar("sv_botsPressAttackBtn", "1");
    setDvar("sv_botsRandomInput", "1");

    for (i = 0; i < 1; i++) // CHANGE 1 TO ADD MORE BOTS
    {
        ent = addtestclient();

        if (!isdefined(ent))
        {
            println("^1FAILED TO ADD BOT");
            wait 1;
            continue;
        }

        ent.pers["isBot"] = true;

        // GET PLAYER TEAM AND SET BOT TO OPPOSITE
        enemyTeam = (self.pers["team"] == "axis") ? "allies" : "axis";

        ent thread setupBot(enemyTeam);
    }
}

setupBot(team)
{
    self endon("disconnect");

    wait 0.05;

    self.sessionteam = team;
    self.pers["team"] = team;
    self.team = team;

    wait 0.1;

    class = "rifleman"; // default stock class
    self.pers["class"] = class;
    self.sessionstate = "playing";

    self notify("menuresponse", game["menu_team"], team);
    wait 0.2;
    self notify("menuresponse", "changeclass", class);

    for (;;)
    {
        self waittill("spawned_player");
        wait 1.0;
    }
}














