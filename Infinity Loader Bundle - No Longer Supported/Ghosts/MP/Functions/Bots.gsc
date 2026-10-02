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
    
    spawnBots(count, team, callback, stopWhenFull, notifyWhenDone, difficulty)
    {
        if (!isDefined(level.botnames))
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
        }

        if (!isDefined(level.botcount))
            level.botcount = 0;

        level endon("game_ended");

        function_wait_time = GetTime() + 15000;
        connectingArray = [];
        squad_index = 0;

        while(level.players.size < maps\mp\bots\_bots_util::bot_get_client_limit() && connectingArray.size < count && gettime() < function_wait_time)
        {
            name = level.botnames[level.botcount % level.botnames.size];
            level.botcount++;

            bot = AddBot(name, 0, 0, 0);

            if (isDefined(bot))
            {
                bot.pers["team"] = team;
                bot.pers["isBot"] = true;

                connecting = SpawnStruct();
                connecting.bot = bot;
                connecting.ready = false;
                connecting.abort = false;
                connecting.index = squad_index;
                connecting.difficulty = difficulty;

                connectingArray[connectingArray.size] = connecting;

                bot thread maps\mp\bots\_bots::spawn_bot_latent(team, callback, connecting);
                squad_index++;

                wait 0.3; 
            }
            
            else
            {
                if (isDefined(stopWhenFull) && stopWhenFull)
                {
                    if (isDefined(notifyWhenDone))
                        self notify(notifyWhenDone);
                    return;
                }
                wait 0.5;
                continue;
            }
        }

        connectedComplete = 0;

        while (connectedComplete < connectingArray.size && GetTime() < function_wait_time)
        {
            connectedComplete = 0;
            foreach (connecting in connectingArray)
            {
                if (connecting.ready || connecting.abort)
                    connectedComplete++;
            }
            wait 0.05;
        }

        if (isDefined(notifyWhenDone))
            self notify(notifyWhenDone);

        foreach (connecting in connectingArray)
        {
            if (isDefined(connecting.bot))
            {
                connecting.bot.pers["isBot"] = true;
            }
        }

    }

    hook maps\mp\bots\_bots::bot_drop()
    {
        wait 0.1;
        return;
    }

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

    botSetup()
    {
        if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
            return;

        self clearperks();
        self setRank(randomintrange(0, 49), randomintrange(0, 15));
        self thread botsCantWin();
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