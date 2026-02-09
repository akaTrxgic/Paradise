#ifdef MP
botControls(action)
{
    if(action == "teleport")
        self tpBots();

    else if(action == "kick")
        self kickallbots();
}

kickAllBots()
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];    
        if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
            kick( player getEntityNumber());
    }
    self iprintln("All bots ^1kicked");     
}
#endif

toggleFreezeBots()
{
    if (!isDefined(self.frozenbots))
        self.frozenbots = 0;

    if (!self.frozenbots)
    {
        self.frozenbots = 1;
        self iPrintLn("All bots ^1Frozen");

        self.freezeBotsLoop = true;
        self thread freezeBotsThread();
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
                player freezeControls(false);
        }

        setDvar("testClients_doAttack", 1);
        setDvar("testClients_doCrouch", 0);
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
                player freezeControls(true);
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
            player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"]);
    }
    self iprintln("All Bots ^1Teleported");
}

GetEnemyTeam()
{
    if(self.pers["team"] == "allies")
        team = "axis";
    else
        team = "allies";
    
    return team;
}