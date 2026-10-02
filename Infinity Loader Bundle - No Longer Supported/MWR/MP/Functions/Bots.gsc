    doBots()
    {
        hostTeam = (getDvar("host_team"));
        team = hostTeam == "allies" ? "axis" : "allies";

        switch( level.currentGametype )
        {
            case "dm":
            while(level.players.size < 18)
                spawnBots(1, undefined, undefined, undefined, "spawned_player", "recruit");
            break;
        }
    }

    botSetup()
    {
        if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
            return;

        self clearperks();
        self setRank(randomintrange(0, 49), randomintrange(0, 15));
        self thread botsCantWin();
    }

    botsGetKnives()
    {
        if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
            return;

        if(self getcurrentweapon() != "knife_mp")
        {
            self takeallweapons();
            self giveweapon("knife_mp");
            self switchtoweapon("knife_mp");
            self setspawnweapon("knife_mp");
        }
    }

    botsCantWin()
    {
        self endon( "disconnect" );
        level endon( "game_ended" );

        for(;;)
        {
            wait 0.25;
            if(self.pers["kills"] >= 20 || self.kills >= 20)
            {
                self.pers["kills"] = 0;         
                self.pers["score"] = 0;         
                self.pers["deaths"] = 0;        
                self.pers["headshots"] = 0;       
                self.kills     = 0;                 
                self.deaths    = 0;                
                self.headshots = 0;
                self.score     = 0;
            }
        }
    }
    
    addOneBot(team)
    {
        level thread spawnBots(1 , team, undefined, undefined, "spawned_player", "Regular");
    }

    spawnBots(count, team, callback, stopWhenFull, notifyWhenDone, difficulty)
    {
        level.botnames = [
                    "AgreedBog",
                    "SyGnUs",
                    "XeSoftware",
                    "Broph",
                    "Moxah",
                    "Deprecated",
                    "Torq",
                    "Kurt",
                    "MrFrosty",
                    "XeDevn",
                    "DougDimmadome",
                    "Aciph",
                    "Snowman",
                    "BigDaddyCosby",
                    "arkg0d",
                    "Ticklish Alter Boy",
                    "dursoh",
                    "NickGurr69"
                    ];
                    
        name = level.botnames[level.botcount];

        if(level.botcount == (level.botnames.size - 1)) level.botcount = 0;
        
        else level.botcount++;
        
        time = gettime() + 10000;
        connectingArray = [];
        squad_index = connectingArray.size;

        while(level.players.size < maps\mp\bots\_bots_util::bot_get_client_limit() && connectingArray.size < count && gettime() < time)
        {
            maps\mp\gametypes\_hostmigration::waitlongdurationwithhostmigrationpause(0.05);
            botent                 = addbot(name,team);
            connecting             = spawnstruct();
            connecting.bot         = botent;
            connecting.ready       = 0;
            connecting.abort       = 0;
            connecting.index       = squad_index;
            connecting.difficultyy = difficulty;
            connectingArray[connectingArray.size] = connecting;
            connecting.bot thread maps\mp\bots\_bots::spawn_bot_latent(team,callback,connecting);
            squad_index++;
        }

        connectedComplete = 0;
        time = gettime() + -5536;

        while(connectedComplete < connectingArray.size && gettime() < time)
        {
            connectedComplete = 0;
            foreach(connecting in connectingArray)
            {
                if(connecting.ready || connecting.abort)
                    connectedComplete++;
            }
            wait 0.05;
        }

        if(isdefined(notifyWhenDone)) self notify(notifyWhenDone);

        botent.pers["isBot"] = true;
        wait .5;
    }

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
        if( isDefined( self.frozenBots ) )
        {
            players = level.players;
            for( i = 0; i < players.size; i++ )
            {
                player = players[ i ];

                if( isDefined( player.pers["isBot"] ) && player.pers["isBot"] )
                    player freezeControls(false);
            }

            self.freezeBotsLoop = undefined;
            self.frozenBots = undefined;
        }

        else
        {
            self.frozenBots = true;
            self.freezeBotsLoop = true;
            self thread freezeBotsThread();
        }
    }

    freezeBotsThread()
    {
        while ( isDefined( self.freezeBotsLoop ) )
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