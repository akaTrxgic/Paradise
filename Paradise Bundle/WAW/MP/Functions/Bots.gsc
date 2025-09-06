kys()
{
    self suicide();
}
toggleFreezeBots()
{
    if (!isDefined(self.frozenbots))
        self.frozenbots = 0;

    if (self.frozenbots == 0)
    {
        self.frozenbots = 1;
        self iPrintLn("All bots ^1Frozen");

        self.freezeBotsLoop = true;
        self thread freezeBotsThread(); // Start loop in thread
    }
    else
    {
        self.frozenbots = 0;
        self.freezeBotsLoop = false;

        players = level.players;
        for (i = 0; i < players.size; i++)
        {
            player = players[i];
            if (isDefined(player.pers["isBot"]) && player.pers["isBot"])
            {
                player freezeControls(false);
            }
        }

        setDvar("testClients_doAttack", 1);
        setDvar("testClients_doCrouch", 1);
        setDvar("testClients_doMove", 1);
        setDvar("testClients_doReload", 1);

        self iPrintLn("All bots ^2Unfrozen");
    }
}

freezeBotsThread()
{
    while (self.freezeBotsLoop)
    {
        players = level.players;
        for (i = 0; i < players.size; i++)
        {
            player = players[i];
            if (isDefined(player.pers["isBot"]) && player.pers["isBot"])
            {
                player freezeControls(true);
            }
        }
        wait 0.025;
    }
}

tpBots()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {   
        player = players[i];
        if(isDefined(player.pers["isBot"])&& player.pers["isBot"])
        {
            player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"]);

        }
    }
    self iprintln("All Bots ^1Teleported");
}
kickAllBots()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];    
        if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
        {   
            kick( player getEntityNumber());
        }
    }
    self iprintln("All bots ^1kicked");     
}
addTestClients()
{
    setDvar("sv_botsPressAttackBtn", "1");
    setDvar("sv_botsRandomInput", "1");

    for (i = 0; i < 1; i++)
    {
        bot = addtestclient();
        if (!isdefined(bot))
        {
            println("^1FAILED TO ADD BOT");
            wait 1;
            continue;
        }

        bot.pers["isBot"] = true;

        bot thread TestClient();
    }
}
TestClient()
{
    self endon("disconnect");


    self notify("menuresponse", game["menu_team"], "allies");
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