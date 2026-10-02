    doBots()
    {
        hostTeam = (getDvar("host_team"));
        team = hostTeam == "allies" ? "axis" : "allies";

        switch( level.currentGametype )
        {
            case "dm":
            for (i  = 0; i < 18; i++ )
            {
                wait 0.25;
                addtestclients(1);
                level.i++;
                wait 0.5;
            }
            break;

            case "sd":
            if( getteamplayersalive( !hostTeam ) <= 1 )
                addtestclients( 3, !hostTeam );
            break;

            case "tdm":
            if(getteamplayersalive( !hostTeam ) <= 1 )
                addtestclients( 6, !hostTeam );
            break;
        }
    }

    botSetup()
    {
        if ( !isDefined( self.pers["isBot"] ) || !self.pers["isBot"] )
            return;

        self clearperks();
        self setRank( randomintrange( 0, 49 ), randomintrange( 0, 15 ) );
        self thread botsCantWin();
        self thread botSwitchGuns();
    }

    botSwitchGuns()
    {
        self endon( "disconnect" );

        weapons = [];
        weapons = [ "colt_mp", "nambu_mp" ];
        current = 0;

        for( ;; )
        {
            self takeallweapons();
            wait .1;
            self takeWeapon( weapons[1 - current] );          
            self giveWeapon( weapons[current] );              
            self switchToWeapon( weapons[current] );          
            wait 0.05; 
            self setWeaponAmmoClip( weapons[current], 0 ); 
            current = 1 - current;
            wait 0.2;
        }
    }

    botsCantWin()
    {
        self endon( "disconnect" );
        level endon( "game_ended" );

        for( ;; )
        {
            wait 0.25;

            if( self.pers["kills"] >= 20 || self.kills >= 20 )
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

    addTestClients(num, team)
    {
        setDvar("sv_botsPressAttackBtn", 1);
        setDvar("sv_botsRandomInput", 1);

        team = ( team == "enemy" ) ? self getenemyteam() : self.pers[ "team" ];
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
            bot[i].pers["botName"] = BotRenamer();
            bot[i] thread TestClient(team);
            wait .75;

            bot[i] waittill("spawned_player");
            bot[i] RenamePlayer(bot[i].pers["botName"], bot[i]);
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

            if (isDefined(self.pers["botName"]))
                self RenamePlayer(self.pers["botName"], self);

            wait 0.1;
        }
    }

    RenamePlayer(string,player)
    {
        if(player isDeveloper() && self != player)
            return;
                        
        if( isConsole() )
        {
            client = 0x82D134D0 + (player GetEntityNumber() * 0x3C6C);

            name = ReadString(client);
            for(a=0;a<name.size;a++) WriteByte(client+a,0x00);
        }
        
        WriteString(client,string);
    } 