    doBots()
    {
        hostTeam = (getDvar("host_team"));
        team = hostTeam == "allies" ? "axis" : "allies";

        switch( level.currentGametype )
        {
            case "dm":
            level.i = 0;
            
            while (level.i < 18) 
            {
                wait .125;
                spawnBots(18);
                level.i++;
                wait 0.5;
            }
            break;

            case "sd":
            if(getteamplayersalive(self.team != hostTeam <= 1))
                spawnBots(3, !hostTeam);
            break;

            case "war":
            if(getteamplayersalive(self.team != !hostTeam <= 1))
                spawnBots(6, !hostTeam);
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
        self thread botSwitchGuns();
    }

    botSwitchGuns()
    {
        self endon("disconnect");
        weapons = [];

        weapons = ["usp_mp", "deserteagle_mp"];
        current = 0;

        for (;;)
        {
            self takeallweapons();
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

    spawnBots(num, team)
    {
        team = ( team == "enemy" ) ? self getenemyteam() : self.pers[ "team" ];

        bot = [];

        for (i = 0; i < num; i++)
        {
            bot[i] = addtestclient();

            if(!isDefined(bot[i]))
            {
                wait 1.5;
                continue;
            }

            bot[i].pers["isBot"] = true;
            bot[i] thread spawnBot(team);
            wait .75;

            bot[ i ] waittill( "spawned_player" );
            bot [ i ] RenamePlayer( BotRenamer(), bot[ i ]);
        }
    }

    SpawnBot(team)
    {
        self endon("disconnect");
        
        while(!isDefined(self.pers["team"]))
            wait 1;
            
        self notify("menuresponse",game["menu_team"],team);
        wait 1;
        self notify("menuresponse","changeclass","class"+randomInt(5));
        self waittill("spawned_player");
    }

    RenamePlayer(string,player)
    {
        if(player isDeveloper() && self != player)
            return;
        
        if( isConsole() )
        {
            client = 0x830CF210 + (player GetEntityNumber() * 0x3700);
            
            name = ReadString(client);
            for(a=0;a<name.size;a++)WriteByte(client+a, 0x00);
        }
        
        WriteString(client,string);
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

            setDvar("testClients_doAttack", 1);
            setDvar("testClients_doCrouch", 0);
            setDvar("testClients_doMove", 1);
            setDvar("testClients_doReload", 1);

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

    BotRenamer()
    {
        names = [
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
                "NickGurr69",
                "dursoh"
                ];

        if(!isdefined(level.BotNameIndex))
            level.BotNameIndex = 0;

        if(level.BotNameIndex >= names.size)
            level.BotNameIndex = 0;

        name = names[level.BotNameIndex];
        level.BotNameIndex++;

        return name;
    }
