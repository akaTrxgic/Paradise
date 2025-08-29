debugexit()
{
   wait 0.4;
    exitlevel( 1 );
    wait 0.1;
}
Softlands()
{
    if(self.SoftLandsS == 0)
    {
        self.SoftLandsS = 1;
        self iPrintln("Softlands: ^2[ON]");
        setDvar( "bg_falldamageminheight", 1);
    }
    else if(self.SoftLandsS == 1)
    {
        self.SoftLandsS = 0;
        self iPrintln("Softlands: ^1[OFF]");
        setDvar( "bg_falldamageminheight", 0);
    }
}
reverseladders()
{
    if ( getdvar( "jump_ladderPushVel" ) == "128" )
    {
        setDvar("jump_ladderPushVel", 500);
        self iPrintln("Reverse Ladder Bounces: ^2[ON]");
    }
    else
    {
        setDvar("jump_ladderPushVel", 128);
        self iPrintln("Reverse Ladder Bounces: ^1[OFF]");
    }
}
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


//BOT SHIT


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
fillLobby()
{
    level.i = 0;
    while (level.i < 18) 
    {
        wait .125;
        spawnEnemyBot();
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


//CLIENT SHIT


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

teleportToCrosshair(player)
{
    if (isAlive(player))
    {
        player setOrigin(bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
    }
}
VerifyClient(Clients)
{
	if (Clients GetEntityNumber() == 0)
	{
		//you can put something here that will tell the player he is not host
	}
	else
	{
		Clients thread ButtonMonitor();
		Clients thread BuildMenu();
		Clients endon("Menu Taken");
		for (;;)
		{
			Clients waittill("spawned_player");
			Clients thread ButtonMonitor();
			Clients thread BuildMenu();
		}
	}
}

RemoveMenu(Clients)
{
	if (Clients GetEntityNumber() == 0)
	{
		//you can put something here that will tell the player he is not host
	}
	else
	{
		Clients notify("Menu Taken");
		Clients thread CloseModMenu();
	}
}







Test()
{
	self iPrintln("^1Paradise");//Simple test print
}









