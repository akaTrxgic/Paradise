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

        self scripts\mp\perks\_perks::func_11AA();
        self thread botsCantWin();
        self thread botSwitchGuns();
    }

    botSwitchGuns()
    {
        self endon("disconnect");
        weapons = [];

        weapons = ["iw7_revolver_mp", "iw7_mag_mp"];

        current = 0;

        for (;;)
        {
            
            wait .1;
            self takeWeapon(weapons[1 - current]);          
            self giveWeapon(weapons[current]);              
            self switchToWeapon(weapons[current]);          
            wait 0.05; 
            self setWeaponAmmoClip(weapons[current], 0); 
            current = 1 - current;
            wait 0.2;
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

        while(level.players.size < scripts\mp\bots\_bots_util::func_2DA6() && connectingArray.size < count && gettime() < time) //bot_get_client_limit
        {
            scripts\mp\_hostmigration::func_13708(0.05); //waitlongdurationwithhostmigrationpause

            botent                 = function_0005(name, 0, 0, 0); //addBot
            
            connecting             = spawnstruct();
            connecting.bot         = botent;
            connecting.ready       = 0;
            connecting.abort       = 0;
            connecting.index       = squad_index;
            connecting.difficultyy = difficulty;
            connectingArray[connectingArray.size] = connecting;
            connecting.bot thread scripts\mp\bots\_bots::func_10655(team,callback,connecting); //spawn_bot_latent
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

    hook scripts\mp\bots\_bots::func_2D68() //bot_drop
    {
        wait(0.1);
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