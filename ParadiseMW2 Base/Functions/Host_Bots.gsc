debugexit()
{
   wait 0.4;
    exitlevel( 1 );
    wait 0.1;
}

reverseladders()
{
    if ( getdvar( "jump_ladderPushVel" ) == "128" )
    {
        setDvar("jump_ladderPushVel", 500);
        self iPrintln("Reverse Ladder Bounces: [^2ON^7]");
    }
    else
    {
        setDvar("jump_ladderPushVel", 128);
        self iPrintln("Reverse Ladder Bounces: [^1OFF^7]");
    }
}

editTime(type)
{
    timeLeft       = GetDvar("scr_"+level.gametype+"_timelimit");
    timeLeftProper = int(timeLeft);
    if(type == "add")
        setTime = timeLeftProper + 1;
    if(type == "sub")
        setTime = timeLeftProper - 1;
    SetDvar("scr_"+level.gametype+"_timelimit",setTime);
    time = setTime - getMinutesPassed();
    wait .05;
    
    if(type == "add")
        self iPrintln("^2Added 1 minute");
    else if(type == "subtract")
        self iPrintln("^1Subtracted 1 minute");
}


FastRestart()
{
    for(i = 0; i < level.players.size; i++)
    {
        if (isDefined( level.players[i].pers["isBot"])) 
        {
            kick ( level.players[i] getEntityNumber() );
        }
    }
    wait 1;
    map_restart( 0 );
}
DeleteAllDamageTriggers()
{
    damagebarriers = GetEntArray("trigger_hurt", "classname");
    for(i = 0; i < damagebarriers.size; i++) damagebarriers[i] delete();
    level.damagetriggersdeleted = true;
}

togglelobbyfloat()
{
    if(self.floaters == false)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] thread enableFloaters();
        self iprintln("Floaters [^2ON^7]");
        self.floaters = true;
    }
    else
    {
        for(i = 0; i < level.players.size; i++)level.players[i] notify("stopFloaters");
        self iprintln("Floaters [^1OFF^7]");
        self.floaters = false;
    }
}

enableFloaters()
{ 
    self endon("disconnect");
    self endon("stopFloaters");

    for(;;)
    {
        if(level.gameended && !self isonground())
        {
            floatersareback = spawn("script_model", self.origin);
            self playerlinkto(floatersareback);
            self freezecontrols(true);
            for(;;)
            {
                floatermovingdown = self.origin - (0,0,0.5);
                floatersareback moveTo(floatermovingdown, 0.01);
                wait 0.01;
            } 
            wait 6;
            floatersareback delete();
        }
        wait 0.05;
    }
}
doHostAction(value)
{
    if(value == "FastRestart")
        FastRestart();
    else if(value == "debugexit")
        debugexit();
}
kickSped(player)
{
   if (!player isHost() || player != self || !player isDeveloper())
   {
        Kick(player GetEntityNumber());
   }
   else
   {
        self iPrintln("^1ERROR: ^7Can't Kick Player");
   }
}    
banSped(player)
{
    if(player isHost() || player isdeveloper())
    {
        self iPrintln("^1ERROR: ^7Can't Ban Player");
        return;
    }
    
    SetDvar("Paradise_"+player GetXUID(),"Banned");
    Kick(player GetEntityNumber());
    self iPrintln(player getName()+" Has Been ^1Banned");
}

//Bot Options
//---------------------------------------------------------

SpawnBotsAmount(var)
{
    for(i = 5; i < var; i++)
    { 
        maps\mp\bots\_bot::spawn_bot("autoassign");
        wait .7;
    }
}
spawnTeamBots(n, team)
{
	for (i = 0; i < n; i++)
	{
		maps\mp\bots\_bot::spawn_bot("autoassign");
	}
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
            {
                player freezeControls(false);
            }
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

