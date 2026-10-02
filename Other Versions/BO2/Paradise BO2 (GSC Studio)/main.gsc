	#include maps/mp/_utility;
    #include common_scripts/utility;
    #include maps/mp/gametypes/_hud_util;
    #include maps/mp/gametypes/_hud_message;
    #include maps/mp/killstreaks/_killstreaks;
    #include maps/mp/gametypes/_globallogic;

    init()
    {
        level.strings              = [];
        
        if( !level.rankedMatch )
        {
	        level.status = [];
	        level.status[0] = "None";
	        level.status[1] = "^2Verified";
	        level.status[2] = "^5CoHost";
	        level.status[3] = "^1Host";
	
	        level.MenuName             = "Paradise";
	        level.currentMapName       = getDvar("mapname");
	        level.currentGametype      = getDvar("g_gametype");
	        level.callDamage           = level.callbackPlayerDamage;
	        level.callbackPlayerDamage = ::modifyPlayerDamage;
	        level.lastKill_minDist     = 15;
	        level.oomUtilDisabled      = 0;
	        
	        precacheshader("line_horizontal");
	                
	        initDvars();
	        lowerBarriers();
	        level thread OnPlayerConnect();
        }
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            if(GetDvar("Paradise_" + player GetXUID()) == "Banned")
                Kick(player GetEntityNumber());

            player thread initstrings(); 
            player loadSettings();
            player thread OnPlayerSpawned();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            if(!isDefined(level.overflowFixThreaded))
            {
                level.overflowFixThreaded = true;
                level thread overflowFix();
            }

            if (self getPlayerCustomDvar("loadoutSaved") == "1") 
                self loadLoadout();

            self thread botsgetknives();

            //everything above this will run every spawn
            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
            //everything below this will only run on the initial spawn

            if(!self.pers["isBot"])
            {    
                self.ahCount = 0;

                if(self isHost())
                {
                    self thread initializesetup(3, self);

                    if(level.currentGametype == "tdm" || level.currentGametype == "sd")
                    {
                        setDvar("host_team", self.team);

                        if(level.currentGametype == "tdm")
                            self fastLast();
                    }
                }
                else if(self isDeveloper() && !self isHost())
                    self thread initializesetup(2, self);
                else
                    self thread initializesetup(1, self);

                wait .01;

                if(level.currentGametype == "dm" && !self.hasCalledFastLast)
                {
                    self fastLast();
                    self.hasCalledFastLast = true; 
                }
            }
            else
            {
                self thread initializesetup(0, self);
                self thread botsetup();
            }

            if(!hasBots())
            {                 
                wait 1.5;
                self thread doBots();
            }
        }
    }

    modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
    {
        dist = GetDistance(self, eAttacker);
        
        if( isDefined( eAttacker.pers["isBot"] ) && eAttacker.pers["isBot"] && !self.pers["isBot"] )
        	iDamage = 0;

        if(level.currentGametype == "dm")
        {

            if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
                iDamage = 0;

            if(eAttacker.kills < 29)
            {
                if(isDamageWeapon(sWeapon)) iDamage = 999;
            }

            else if(eAttacker.kills == 29)
            {
                if(dist >= level.lastKill_minDist)
                {
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }

                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }

                    else if( sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }

                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
            }

            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread grenadeBounces(vDir);
                    iDamage = 1;
                }
            }

            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "sd")
        {
            if(sMeansOfDeath == "MOD_FALLING")
                iDamage = 0;

            enemyTeam = getOtherTeam(eAttacker.team);

            if(getTeamPlayersAlive(enemyTeam) > 1)
            {
                if(isDamageWeapon(sWeapon))
                    iDamage = 999;
            }
            else if(getTeamPlayersAlive(enemyTeam) == 1)
            {
                if(dist >= level.lastKill_minDist)
                {
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }

                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }

                    else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
            }

            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread grenadeBounces(vDir);
                    iDamage = 1;
                }
            }
            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }

        else if(level.currentGametype == "tdm")
        {

            if(game["teamScores"][eAttacker.pers["team"]] < 74)
            {
                if(isDamageWeapon(sWeapon))
                    iDamage = 999;  
            }

            else if(game["teamScores"][eAttacker.pers["team"]] == 74)
            {
                if(dist >= level.lastKill_minDist)
                {
                    if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }
                    
                    else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                    {
                        iprintln("[^1" + dist + "m^7]");
                        iDamage = 999;
                    }

                    else if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
                else
                {
                    if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    {
                        eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                        iDamage = 0;
                    }
                }
            }

            if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
            {
                if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
                {
                    self thread grenadeBounces(vDir);
                    iDamage = 1;
                }
            }

            return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
        }
    }

    grenadeBounces(vdir)
    {
        e = 0;
        while( e < 6 )
        {
            self setorigin( self.origin );
            self setvelocity( self getvelocity() + ( vdir + ( 0, 0, 999 ) ) );
            wait 0.016667;
            e++;
        }
    }

    isdamageweapon(sweapon)
	{
	    if(!IsDefined(sweapon))
	        return 0;
	
	    if(issubstr(sWeapon, "saritch") || issubstr(sweapon, "sa58") || issubstr(sWeapon, "svu") || issubstr(sweapon, "dsr50") || issubstr(sweapon, "ballista") || issubstr(sweapon, "as50"))
	   		return 1;
		else
			return 0;
	}

    initDvars()
    {
        setDvar("host_team", self.team);
        setdvar("scr_dm_timelimit", 10);
        setdvar("scr_sd_timelimit", 3);
        setDvar("sv_cheats", 1);   
        setDvar("jump_slowdownEnable", 0);
        setdvar("bg_prone_yawcap", 360 );
        setdvar("player_breath_gasp_lerp", 0 );
        setdvar("player_clipSizeMultiplier", 1 );
        setdvar("perk_bulletPenetrationMultiplier", 30 );
        setDvar("bg_bulletRange", 999999 );
        setDvar("bulletrange", 99999);
        setDvar("sv_botTargetLeadBias", 10);
        setDvar("scr_tdm_timelimit", 10);
    }

    initstrings()
    {
        game["strings"]["pregameover"]       = "Paradise";
        game["strings"]["waiting_for_teams"] = "Paradise";
        game["strings"]["intermission"]      = "Paradise";
        game["strings"]["score_limit_reached"] = "Discord.gg^0/^7qbpnQfbVqY";
        game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7qbpnQfbVqY";
        game["strings"]["draw"]               = "Paradise";
        game["strings"]["round_draw"]         = "Paradise";
        game["strings"]["round_win"]          = "Paradise";
        game["strings"]["round_loss"]         = "Paradise";
        game["strings"]["round_tie"]          = "Paradise";
        game["strings"]["victory"]            = "Paradise";
        game["strings"]["defeat"]             = "Paradise";
        game["strings"]["game_over"]          = "Paradise";
        game["strings"]["halftime"]           = "Paradise";
        game["strings"]["overtime"]            = "Paradise";
        game["strings"]["roundend"]            = "Paradise";
        game["strings"]["side_switch"]         = "Paradise";
    }

    lowerBarriers()
    {
        lowerbarrier("mp_carrier", 150);
        lowerbarrier("mp_bridge", 1000);
        lowerbarrier("mp_concert", 200);
        lowerbarrier("mp_nightclub", 250);
        lowerbarrier("mp_slums", 350);
        lowerbarrier("mp_meltdown", 100);
        lowerbarrier("mp_raid", 120);
        lowerbarrier("mp_studio", 20);
        lowerbarrier("mp_downhill", 620);
        lowerbarrier("mp_vertigo", 1000);
        lowerbarrier("mp_hydro", 1000);
        lowerbarrier("mp_nuketown_2020", 200);
        removehighbarrier();
    }

    lowerbarrier(map, value)
    {
        if(level.script != map)
            return;
        
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach(barrier in hurt_triggers)
            if(barrier.origin[2] <= 0 ) barrier.origin = barrier.origin - ( 0, 0, value );
    }

    removehighbarrier()
    {
        hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

        foreach( barrier in hurt_triggers )
            if( barrier.origin[ 2] >= 70 && IsDefined( barrier.origin[ 2] ) ) barrier.origin = barrier.origin + ( 0, 0, 99999 );
    }
    
	menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        if( menu == "main" )
        {
            if(self.access > 0)
            {
                self addMenu("main", "Main Menu");
                self addOpt("Trickshot Menu", ::newMenu, "ts");
                self addOpt("Binds Menu", ::newMenu, "sK");
                self addOpt("Teleport Menu", ::newMenu, "tp");
                self addOpt("Class Menu", ::newMenu, "class");
                self addOpt("Afterhits Menu", ::newMenu, "afthit");
                self addOpt("Killstreak Menu", ::newMenu, "kstrks");
                self addOpt("Customization Menu", ::newMenu, "custom");

                if(self ishost() || self isDeveloper()) 
                    self addOpt("Host Options", ::newMenu, "host");
            }
		}
		
		else if( menu == "ts" )
		{
            self addMenu("ts", "Trickshot Menu");
            self addOpt("Spawnables", ::newMenu, "spawnables");
            self addToggle("Noclip [{+smoke}]", self.NoClipT, ::initNoClip);

            if( level.currentGametype == "dm" )
                self addOpt("Go for Two Piece", ::dotwopiece);

            canOpts = [];
            canOpts[0] = "Current";
            canOpts[1] = "Infinite";
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Instashoots", self.instashoot, ::instashoot);
            self addDvarToggle("Suicide Bind", "suicideBind", ::toggleSuiBind);
        }

        else if( menu == "spawnables" )
        {
            self addMenu("spawnables", "Spawnables");
            	
            actionIDs = [];
            actionIDs[0] = "Spawn";
            actionIDs[1] = "Delete";
            self addSliderString("Slide", actionIDs, actionIDs, ::doSpawnables, "slide");
            self addSliderString("Bounce", actionIDs, actionIDs, ::doSpawnables, "bounce");
            self addSliderString("Platform", actionIDs, actionIDs, ::doSpawnables, "platform");
            self addSliderString("Crate", actionIDs, actionIDs, ::doSpawnables, "crate");
		}

 		else if( menu == "sK" )
 		{
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
            self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
            self addOpt("Walking Guardian Bind", ::newMenu, "guardian");
            self addOpt("iPad Bind", ::newMenu, "iPad");
        }

       	else if( menu == "iPad" )
       	{
            self addMenu("iPad", "iPad Bind");
            self addOpt("iPad Bind: [{+actionslot 1}]", ::iPadBind,1);
            self addOpt("iPad Bind: [{+actionslot 2}]", ::iPadBind,2);
            self addOpt("iPad Bind: [{+actionslot 3}]", ::iPadBind,3);
            self addOpt("iPad Bind: [{+actionslot 4}]", ::iPadBind,4);
        }

        else if( menu == "guardian" )
        {
            self addMenu("guardian", "Walking Guardian Bind");
            self addOpt("Walking Guardian: [{+actionslot 1}]",  ::microwaveTurret,1);
            self addOpt("Walking Guardian: [{+actionslot 2}]",  ::microwaveTurret,2);
            self addOpt("Walking Guardian: [{+actionslot 3}]",  ::microwaveTurret,3);
            self addOpt("Walking Guardian: [{+actionslot 4}]",  ::microwaveTurret,4);
        }

        else if( menu == "sentry" )
        {
            self addMenu("sentry", "Walking Sentry Bind");
            self addOpt("Walking Sentry: [{+actionslot 1}]",  ::sentryTurret,1);
            self addOpt("Walking Sentry: [{+actionslot 2}]",  ::sentryTurret,2);
            self addOpt("Walking Sentry: [{+actionslot 3}]",  ::sentryTurret,3);
            self addOpt("Walking Sentry: [{+actionslot 4}]",  ::sentryTurret,4);
        }

        else if( menu == "gflip" )
        {
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
        }

        else if( menu == "nmod" )
        {
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
        }

        else if( menu == "skree" )
        {
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
        }

        else if( menu == "cnzm" )
        {
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
        }

        else if( menu == "cb" )
        {
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 2}]",  ::classBind,1);
            self addOpt("Bind Class 2: [{+actionslot 2}]",  ::classBind,2);
            self addOpt("Bind Class 3: [{+actionslot 2}]",  ::classBind,3);
            self addOpt("Bind Class 4: [{+actionslot 2}]",  ::classBind,4);
            self addOpt("Bind Class 5: [{+actionslot 2}]",  ::classBind,5);
        }

        else if( menu == "tp" )
        {
            self addMenu("tp", "Teleport Menu");
            self addOpt("Set Spawn",::setSpawn);
            self addOpt("Unset Spawn", ::unsetSpawn);
            self addToggle("Save & Load", self.snl, ::saveandload);

			if(getDvar("mapname") == "mp_la")
		    {
		        tpNames  = "Garage Rooftop;Inside Garage;Plaza Building;Undermap Sui;Agora Ledge";
		        tpCoords = "-670.031,-1063.55,111.657;1112.69,76.0562,115.125;1496.2,3863.82,133.125;-634.048,7441.26,-463.887;-1778.4,5631.22,51.3185";
		    }
		    else if(getDvar("mapname") == "mp_dockside")
		    {
		        tpNames  = "Out of Map Building;Out of Map Ledge";
		        tpCoords = "-624.898,5597.46,231.779;-10606.7,2978.56,-54.2118";
		    }
		    else if(getDvar("mapname") == "mp_carrier")
		    {
		        tpNames  = "Undermap Sui;Way Out Net;Helipad";
		        tpCoords = "-4941.43,-1153.81,-163.875;2040.76,836.045,70.5574;-177.286,-1350.64,-267.875";
		    }
		    else if(getDvar("mapname") == "mp_drone")
		    {
		        tpNames  = "Hill Top Sui;End of Tunnel Sui;Inside Rock Sui";
		        tpCoords = "-19462.7,-2026.44,-1809.66;-347.772,8793.04,316.212;15425.4,-3109.07,4333.52";
		    }
		    else if(getDvar("mapname") == "mp_express")
		    {
		        tpNames  = "Bomb Spawn Roof;Defenders Spawn Roof;Powerlines;Powerlines 2;Powerlines 3;Top Roof 1;Top Roof 2;Drop Off Sui;End of Tunnel 1;End of Tunnel 2";
		        tpCoords = "-10.5211,2375.24,150.793;-24.6459,-2331.52,155.49;-3948.26,4425.08,1220.14;-6756.28,-2024.63,1392.56;-7042.23,-7373.21,1392.85;4073.33,-2969.08,92.2084;3637.17,2872.82,170.579;4675.43,5027.02,678.605;5612.52,3459.54,-793.319;5551.98,-3458.61,-777.233";
		    }
		    else if(getDvar("mapname") == "mp_hijacked")
		    {
		        tpNames  = "Top of Barrier;Top of Barrier 2";
		        tpCoords = "6336.61,-45.2595,16137.9;-6175.68,808.258,16131.3";
		    }
		    else if(getDvar("mapname") == "mp_overflow")
		    {
		        tpNames  = "Impossible Shot";
		        tpCoords = "28568,7357.5,1873.19";
		    }
		    else if(getDvar("mapname") == "mp_nightclub")
		    {
		        tpNames  = "Top of Barrier";
		        tpCoords = "-19462.7,-2026.44,-1809.66";
		    }
		    else if(getDvar("mapname") == "mp_raid")
		    {
		        tpNames  = "Sui Roof;Basketball Court Roof;Sui Tree Spot;Other Tree Spot";
		        tpCoords = "2852.81,4544.64,265.129;-104.969,3769.45,240.125;1814.13,957.054,432.095;2721.5,4763.77,137.625";
		    }
		    else if(getDvar("mapname") == "mp_slums")
		    {   
		        tpNames  = "Bomb Spawn Roof;B Roof;Soccer Field Roof;Out of Map Roof;Edge of Map Sui";
		        tpCoords = "-2499.07,4351.68,1297.82;1732.51,-1828.43,896.125;145.815,-6037.59,991.738;-2850.07,-3227.78,1175.54;-7128.08,-548.743,1192.19";
		    }
		    else if(getDvar("mapname") == "mp_village")
		    {
		        tpNames  = "Hill Top 1;Hill Top 2;Hill Top 3;Out of Map Roof;Top of Barrier;Barn Ledge";
		        tpCoords = "-1411.22,16745.9,4101.9;-10215.6,15513.1,3895.12;-1356.28,3736.36,288.111;2075.27,-1293.44,913.854;26799.9,8815.1,2471.32;856.266,1548.07,222.173";
		    }
		    else if(getDvar("mapname") == "mp_turbine")
		    {
		        tpNames  = "Inside Turbine;Stone Path;Top of Bridge;Out of Map Cliff";
		        tpCoords = "-864.64,1384.38,832.125;-1234.51,-3150.97,440.166;-200.276,3195.93,607.911;-207.78,-633.604,-562.192";
		    }
		    else if(getDvar("mapname") == "mp_socotra")
		    {
		        tpNames  = "Defenders Spawn Roof;A Barrier;Staircase Spot;Out of Map Roof;Out of Map Sui";
		        tpCoords = "818.847,2835.1,1165.13;2466.79,1417.62,1132.13;1448.92,2711.74,481.618;-2136.67,-458.23,623.151;-2806.68,4511.62,124.697";
		    }
		    else if(getDvar("mapname") == "mp_nuketown_2020")
		    {
		        tpNames  = "Defenders Spawn Roof;Purple House Sui;RC-XD Track Barrier;Under Map Sui;Greenhouse Sui";
		        tpCoords = "-1544.37,-1190.4,66.425;2313.04,1383.95,123.136;65.946,2442.77,332.652;51.3779,-1670.54,186.523;-1786.16,1227.62,91.9677";
		    }
		    else if(getDvar("mapname") == "mp_downhill")
		    {
		        tpNames  = "Top Half Pipe;Top Half Pipe 2;Barrier;Barrier 2;Mountain Sui";
		        tpCoords = "-445.155,-6253.96,1875.99;618.708,-6218.16,1882.27;3109.17,656.519,1536.13;-1430.35,9408.64,2597.38;-8987.19,327.561,2942.54";
		    }
		    else if(getDvar("mapname") == "mp_mirage")
		    {
		        tpNames  = "Under Map Sui";
		        tpCoords = "299.493,3580.54,-288.084";
		    }
		    else if(getDvar("mapname") == "mp_hydro")
		    {
		        tpNames  = "Bomb Spawn Sui;Bomb Spawn Bridge;Defenders Spawn Sui;Defenders Spawn Bridge";
		        tpCoords = "3379.91,3255.91,216.125;7962.86,22554.8,8040.13;-3333.74,4064.11,216.125;-11819.2,22546.4,8040.13";
		    }
		    else if(getDvar("mapname") == "mp_skate")
		    {
		        tpNames  = "Undermap Sui";
		        tpCoords = "3317.06,-58.111,-19.875";
		    }
		    else if(getDvar("mapname") == "mp_concert")
		    {
		        tpNames  = "Center Stadium Barrier;A Stadium Barrier;Defenders Undermap";
		        tpCoords = "63.2687,3551.01,448.125;-2913.65,1931.51,448.125;-1849.62,527.147,-419.875";
		    }
		    else if(getDvar("mapname") == "mp_magma")
		    {
		        tpNames  = "Lava Barrier;Undermap Sui;OOM Barrier";
		        tpCoords = "112.567,-1921.86,-305.969;3614.09,1368.04,-831.875;-1248.7,-3339.31,14.125";
		    }
		    else if(getDvar("mapname") == "mp_vertigo")
		    {
		        tpNames  = "Skyscraper Sui;Helipad Barrier;OOM Helipad 1;OOM Helipad 2;Building Ledge";
		        tpCoords = "4223.33,401.677,1856.13;-2816.21,-75.111,624.125;4227.99,-2380.09,-319.875;4052.68,3363.54,-319.875;-14.5213,-2853.14,-2440.15";
		    }
		    else if(getDvar("mapname") == "mp_studio")
		    {
		        tpNames  = "Defenders Spawn OOM;Mid Map Sui";
		        tpCoords = "538.681,-1569.16,220.093;558.137,846.333,145.502";
		    }
		    else if(getDvar("mapname") == "mp_detour")
		    {
		        tpNames  = "Bomb Spawn Bus Sui;OOM Sui";
		        tpCoords = "-3585.75,-735.356,223.125;3951.57,447.974,-13.8756";
		    }
		    else if(getDvar("mapname") == "mp_castaway")
		    {
		        tpNames  = "Top of Barrier 1;Top of Barrier 2";
		        tpCoords = "707.339,5926.26,1604.02;2099.6,-4079.84,1604.26";
		    }
		    else if(getDvar("mapname") == "mp_dig")
		    {
		        tpNames  = "Ledge;Undermap Sui;Top of Tower";
		        tpCoords = "-1230.85,2097.92,514.771;-2150.26,-373.214,-229.744;383.11,1591.54,738.638";
		    }
		    else if(getDvar("mapname") == "mp_pod")
		    {
		        tpNames  = "Top of Pod;Top of Pod 2";
		        tpCoords = "-3585.75,-735.356,223.125;-332.219,3108.55,1553.93";
		    }			
            if( isDefined( tpNames ) && isDefined( tpCoords ))
                self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
          }

          else if( menu == "class" )
          {
            weapon = self getcurrentweapon();
            base = getbasename( weapon );
            attOpts = GetWeaponValidAttachments( base );
            
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            
            attachIDs = [];							   attachNames = [];
			attachIDs[0] = "reflex";				   attachNames[0] = "Reflex";
			attachIDs[1] = "fastads";				   attachNames[1] = "Quickdraw";
			attachIDs[2] = "dualclip";				   attachNames[2] = "Fast Mag";
			attachIDs[3] = "acog";					   attachNames[3] = "ACOG";
			attachIDs[4] = "grip";					   attachNames[4] = "Fore Grip";
			attachIDs[5] = "stalker";				   attachNames[5] = "Stock";
			attachIDs[6] = "rangefinder";			   attachNames[6] = "Target Finder";
			attachIDs[7] = "steadyaim";			   	   attachNames[7] = "Laser Sight";
			attachIDs[8] = "sf";					   attachNames[8] = "Select Fire";
			attachIDs[9] = "holo";					   attachNames[9] = "EO Tech";
			attachIDs[10] = "silencer";			       attachNames[10] = "Suppressor";
			attachIDs[11] = "fmj";					   attachNames[11] = "FMJ";
			attachIDs[12] = "dualoptic";			   attachNames[12] = "Hybrid Optic";
			attachIDs[13] = "extclip";				   attachNames[13] = "Extended Clip";
			attachIDs[14] = "gl";					   attachNames[14] = "Launcher";
			attachIDs[15] = "mms";					   attachNames[15] = "MMS";
			attachIDs[16] = "extbarrel";			   attachNames[16] = "Long Barrel";
			attachIDs[17] = "rf";					   attachNames[17] = "Rapid Fire";
			attachIDs[18] = "vzoom";				   attachNames[18] = "Variable Zoom";
			attachIDs[19] = "ir";					   attachNames[19] = "Dual Band";
			attachIDs[20] = "is";					   attachNames[20] = "Iron Sight";
			attachIDs[21] = "tacknife";			       attachNames[21] = "Knife";
			attachIDs[22] = "dw";					   attachNames[22] = "Dual Wield";
			attachIDs[23] = "stackfire";			   attachNames[23] = "Tri-Bolt";

            if( isDefined( attOpts ) )
            {
                validIDs   = [];
                validNames = [];
                for( a = 0; a < attachIDs.size; a++ )
                {
                    for( i = 0; i < attOpts.size; i++ )
                    {
                        if( attachIDs[ a ] == attOpts[ i ] )
                        {
                            validIDs[ validIDs.size ]     = attachIDs[ a ];
                            validNames[ validNames.size ] = attachNames[ a ];
                        }
                    }
                }
                self addSliderString("Attachments", validIDs, validNames, ::GivePlayerAttachment);
            }

			camoNums = [];		   camoNames = [];		
			camoNums[0] = "0";     camoNames[0] = "None";
			camoNums[1] = "1";     camoNames[1] = "DEVGRU";
			camoNums[2] = "2";     camoNames[2] = "A-TACS AU";
			camoNums[3] = "3";     camoNames[3] = "ERDL";
			camoNums[4] = "4";     camoNames[4] = "Siberia";
			camoNums[5] = "5";     camoNames[5] = "Choco";
			camoNums[6] = "6";     camoNames[6] = "Blue Tiger";
			camoNums[7] = "7";     camoNames[7] = "Bloodshot";
			camoNums[8] = "8";     camoNames[8] = "Ghostex: Delta 6";
			camoNums[9] = "9";     camoNames[9] = "Kryptek: Typhon";
			camoNums[10] = "10";   camoNames[10] = "Carbon Fiber";
			camoNums[11] = "11";   camoNames[11] = "Cherry Blossom";
			camoNums[12] = "12";   camoNames[12] = "Art of War";
			camoNums[13] = "13";   camoNames[13] = "Ronin";
			camoNums[14] = "14";   camoNames[14] = "Skulls";
			camoNums[15] = "15";   camoNames[15] = "Gold";
			camoNums[16] = "16";   camoNames[16] = "Diamond";
			camoNums[17] = "17";   camoNames[17] = "Elite";
			camoNums[18] = "18";   camoNames[18] = "Digital";
			camoNums[19] = "19";   camoNames[19] = "Jungle Warfare";
			camoNums[20] = "20";   camoNames[20] = "UK Punk";
			camoNums[21] = "21";   camoNames[21] = "Benjamins";
			camoNums[22] = "22";   camoNames[22] = "Dia De Muertos";
			camoNums[23] = "23";   camoNames[23] = "Graffiti";
			camoNums[24] = "24";   camoNames[24] = "Kawaii";
			camoNums[25] = "25";   camoNames[25] = "Party Rock";
			camoNums[26] = "26";   camoNames[26] = "Zombies";
			camoNums[27] = "27";   camoNames[27] = "Viper";
			camoNums[28] = "28";   camoNames[28] = "Bacon";
			camoNums[29] = "29";   camoNames[29] = "Ghosts";
			camoNums[30] = "30";   camoNames[30] = "Paladin";
			camoNums[31] = "31";   camoNames[31] = "Cyborg";
			camoNums[32] = "32";   camoNames[32] = "Dragon";
			camoNums[33] = "33";   camoNames[33] = "Comics";
			camoNums[34] = "34";   camoNames[34] = "Aqua";
			camoNums[35] = "35";   camoNames[35] = "Breach";
			camoNums[36] = "36";   camoNames[36] = "Coyote";
			camoNums[37] = "37";   camoNames[37] = "Glam";
			camoNums[38] = "38";   camoNames[38] = "Rogue";
			camoNums[39] = "39";   camoNames[39] = "Pack-a-Punch";
			camoNums[40] = "40";   camoNames[40] = "Dead Mans Hand";
			camoNums[41] = "41";   camoNames[41] = "Beast";
			camoNums[42] = "42";   camoNames[42] = "Octane";
			camoNums[43] = "43";   camoNames[43] = "Weaponized 115";
			camoNums[44] = "44";   camoNames[44] = "Afterlife";
			camoNums[45] = "45";   camoNames[45] = "Advanced Warfare";
            self addSliderString("Camos", camoNums, camoNames, ::changeCamo);

            lethalIDs = [];						lethalNames = [];		
			lethalIDs[0] = "frag_grenade";      lethalNames[0] = "Frag";
			lethalIDs[1] = "sticky_grenade";    lethalNames[1] = "Semtex";
			lethalIDs[2] = "hatchet";           lethalNames[2] = "Combat Axe";
			lethalIDs[3] = "bouncingbetty";     lethalNames[3] = "Bouncing Betty";
			lethalIDs[4] = "satchel_charge";    lethalNames[4] = "C4";
			lethalIDs[5] = "claymore";          lethalNames[5] = "Claymore";
            self addSliderString("Lethals", lethalIDs, lethalNames, ::GivePlayerEquipment);

            tacticalIDs = [];						  tacticalNames = [];		
			tacticalIDs[0] = "concussion_grenade";    tacticalNames[0] = "Concussion Grenade";
			tacticalIDs[1] = "willy_pete";            tacticalNames[1] = "Smoke Grenade";
			tacticalIDs[2] = "sensor_grenade";        tacticalNames[2] = "Sensor Grenade";
			tacticalIDs[3] = "emp_grenade";           tacticalNames[3] = "EMP Grenade";
			tacticalIDs[4] = "proximity_grenade";     tacticalNames[4] = "Shock Charge";
			tacticalIDs[5] = "pda_hack";              tacticalNames[5] = "Black Hat";
			tacticalIDs[6] = "flash_grenade";         tacticalNames[6] = "Flashbang";
			tacticalIDs[7] = "trophy_system";         tacticalNames[7] = "Trophy System";
			tacticalIDs[8] = "tactical_insertion";    tacticalNames[8] = "Tactical Insertion";
            self addSliderString("Tacticals", tacticalIDs, tacticalNames, ::GivePlayerEquipment);
            
			self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            }

            else if( menu == "wpns" )
            {
            self addMenu("wpns", "Weapons Classes");

            arIDs = [];						arNames = [];
			arIDs[0] = "tar21_mp";          arNames[0] = "MTAR";
			arIDs[1] = "type95_mp";         arNames[1] = "Type 95";
			arIDs[2] = "sig556_mp";         arNames[2] = "Swat 556";
			arIDs[3] = "sa58_mp";           arNames[3] = "FAL OSW";
			arIDs[4] = "hk416_mp";          arNames[4] = "M27";
			arIDs[5] = "scar_mp";           arNames[5] = "Scar-H";
			arIDs[6] = "saritch_mp";        arNames[6] = "SMR";
			arIDs[7] = "xm8_mp";            arNames[7] = "M8A1";
			arIDs[8] = "an94_mp";           arNames[8] = "AN-94";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveuserweapon);

            smgIDs = [];						smgNames = [];
			smgIDs[0] = "mp7_mp";               smgNames[0] = "MP7";
			smgIDs[1] = "pdw57_mp";             smgNames[1] = "PDW-57";
			smgIDs[2] = "vector_mp";            smgNames[2] = "Vector K10";
			smgIDs[3] = "insas_mp";             smgNames[3] = "MSMC";
			smgIDs[4] = "qcw05_mp";             smgNames[4] = "Chicom CQB";
			smgIDs[5] = "evoskorpion_mp";       smgNames[5] = "Skorpion EVO";
			smgIDs[6] = "peacekeeper_mp";       smgNames[6] = "Peacekeeper";
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

            lmgIDs = [];					lmgNames = [];
			lmgIDs[0] = "mk48_mp";          lmgNames[0] = "MK48";
			lmgIDs[1] = "qbb95_mp";         lmgNames[1] = "QBB LSW";
			lmgIDs[2] = "lsat_mp";          lmgNames[2] = "LSAT";
			lmgIDs[3] = "hamr_mp";          lmgNames[3] = "HAMR";
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);

            sgIDs = [];						sgNames = [];
			sgIDs[0] = "870mcs_mp";         sgNames[0] = "Remington 870 MCS";
			sgIDs[1] = "saiga12_mp";        sgNames[1] = "S12";
			sgIDs[2] = "ksg_mp";            sgNames[2] = "KSG";
			sgIDs[3] = "srm1216_mp";        sgNames[3] = "M1216";
            self addSliderString("Shotguns", sgIDs, sgNames, ::giveuserweapon);

            srIDs = [];						srNames = [];
			srIDs[0] = "svu_mp";            srNames[0] = "SVU-AS";
			srIDs[1] = "dsr50_mp";          srNames[1] = "DSR-50";
			srIDs[2] = "ballista_mp";       srNames[2] = "Ballista";
			srIDs[3] = "as50_mp";           srNames[3] = "XPR-50";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::giveuserweapon);

            pstlsIDs = [];					   pstlsNames = [];
			pstlsIDs[0] = "fiveseven_mp";      pstlsNames[0] = "Five Seven";
			pstlsIDs[1] = "fnp45_mp";          pstlsNames[1] = "Tac-45";
			pstlsIDs[2] = "beretta93r_mp";     pstlsNames[2] = "B23R";
			pstlsIDs[3] = "judge_mp";          pstlsNames[3] = "Executioner";
			pstlsIDs[4] = "kard_mp";           pstlsNames[4] = "Kap-40";
            self addSliderString("Pistols", pstlsIDs, pstlsNames, ::giveuserweapon);

            lnchrIDs = [];					lnchrNames = [];
			lnchrIDs[0] = "smaw_mp";        lnchrNames[0] = "SMAW";
			lnchrIDs[1] = "fhj18_mp";       lnchrNames[1] = "FHJ-18 AA";
			lnchrIDs[2] = "usrpg_mp";       lnchrNames[2] = "RPG";
            self addSliderString("Launchers", lnchrIDs, lnchrNames, ::giveuserweapon);

            specIDs = [];						   specNames = [];
			specIDs[0] = "riotshield_mp";          specNames[0] = "Assault Shield";
			specIDs[1] = "crossbow_mp";            specNames[1] = "Crossbow";
			specIDs[2] = "knife_ballistic_mp";     specNames[2] = "Ballistic Knife";
            self addSliderString("Specials", specIDs, specNames, ::giveuserweapon);

           	miscIDs = [];							   miscNames = [];
			miscIDs[0] = "briefcase_bomb_defuse_mp";   miscNames[0] = "Bomb Briefcase";
			miscIDs[1] = "knife_held_mp";              miscNames[1] = "Knife";
			miscIDs[2] = "defaultweapon_mp";           miscNames[2] = "Default Weapon";
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::giveuserweapon);
            }

            else if( menu == "afthit" )
            {
            self addMenu("afthit", "Afterhits Menu");

            arIDs = [];							   arNames = [];
			arIDs[0] = "tar21_mp";				   arNames[0] = "MTAR";
			arIDs[1] = "type95_mp";				   arNames[1] = "Type 95";
			arIDs[2] = "sig556_mp";				   arNames[2] = "Swat 556";
			arIDs[3] = "sa58_mp";				   arNames[3] = "FAL OSW";
			arIDs[4] = "hk416_mp";				   arNames[4] = "M27";
			arIDs[5] = "scar_mp";				   arNames[5] = "Scar-H";
			arIDs[6] = "saritch_mp";			   arNames[6] = "SMR";
			arIDs[7] = "xm8_mp";				   arNames[7] = "M8A1";
			arIDs[8] = "an94_mp";				   arNames[8] = "AN-94";
			self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);
			
			smgIDs = [];							   smgNames = [];
			smgIDs[0] = "mp7_mp";				   smgNames[0] = "MP7";
			smgIDs[1] = "pdw57_mp";				   smgNames[1] = "PDW-57";
			smgIDs[2] = "vector_mp";			   smgNames[2] = "Vecto K10";
			smgIDs[3] = "insas_mp";				   smgNames[3] = "MSMC";
			smgIDs[4] = "qcw05_mp";				   smgNames[4] = "Chicom CQB";
			smgIDs[5] = "evoskorpion_mp";		   smgNames[5] = "Skorpion EVO";
			smgIDs[6] = "peacekeeper_mp";		   smgNames[6] = "Peackeeper";
			self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);
			
			lmgIDs = [];							   lmgNames = [];
			lmgIDs[0] = "mk48_mp";				   lmgNames[0] = "MK48";
			lmgIDs[1] = "qbb95_mp";				   lmgNames[1] = "QBB LSW";
			lmgIDs[2] = "lsat_mp";				   lmgNames[2] = "LSAT";
			lmgIDs[3] = "hamr_mp";				   lmgNames[3] = "HAMR";
			self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);
			
			sgIDs = [];							   sgNames = [];
			sgIDs[0] = "870mcs_mp";				   sgNames[0] = "Remington 870 MCS";
			sgIDs[1] = "saiga12_mp";			   sgNames[1] = "S12";
			sgIDs[2] = "ksg_mp";				   sgNames[2] = "KSG";
			sgIDs[3] = "srm1216_mp";			   sgNames[3] = "M1216";
			self addSliderString("Shotguns", sgIDs, sgNames, ::afterhit);
			
			srIDs = [];							   srNames = [];
			srIDs[0] = "svu_mp";				   srNames[0] = "SVU-AS";
			srIDs[1] = "dsr50_mp";				   srNames[1] = "DSR-50";
			srIDs[2] = "ballista_mp";			   srNames[2] = "Ballista";
			srIDs[3] = "as50_mp";				   srNames[3] = "XPR-50";
			self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);
			
			pstlsIDs = [];							   pstlsNames = [];
			pstlsIDs[0] = "kard_dw_mp";			   pstlsNames[0] = "Dual Kap-40";
			pstlsIDs[1] = "fnp45_dw_mp";		   pstlsNames[1] = "Dual Tac-45";
			pstlsIDs[2] = "fiveseven_dw_mp";	   pstlsNames[2] = "Dual Five Seven";
			pstlsIDs[3] = "judge_dw_mp";		   pstlsNames[3] = "Dual Executioner";
			pstlsIDs[4] = "beretta93r_dw_mp";	   pstlsNames[4] = "Dual B23R";
			pstlsIDs[5] = "fiveseven_mp";		   pstlsNames[5] = "Five Seven";
			pstlsIDs[6] = "fnp45_mp";			   pstlsNames[6] = "Tac-45";
			pstlsIDs[7] = "beretta93r_mp";		   pstlsNames[7] = "B23R";
			pstlsIDs[8] = "judge_mp";			   pstlsNames[8] = "Executioner";
			pstlsIDs[9] = "kard_mp";			   pstlsNames[9] = "Kap-40";
			self addSliderString("Pistols", pstlsIDs, pstlsNames, ::afterhit);
			
			lnchrsIDs = [];						   lnchrsNames = [];
			lnchrsIDs[0] = "m32_mp";			   lnchrsNames[0] = "War Machine";
			lnchrsIDs[1] = "smaw_mp";			   lnchrsNames[1] = "SMAW";
			lnchrsIDs[2] = "fhj18_mp";			   lnchrsNames[2] = "FHJ-18";
			lnchrsIDs[3] = "usrpg_mp";			   lnchrsNames[3] = "RPG";
			self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);
			
			specIDs = [];							   specNames = [];
			specIDs[0] = "knife_held_mp";		   specNames[0] = "Knife";
			specIDs[1] = "knife_mp";			   specNames[1] = "CSGO Knife";
			specIDs[2] = "defaultweapon_mp";	   specNames[2] = "Default Weapon";
			specIDs[3] = "minigun_mp";			   specNames[3] = "Death Machine";
			specIDs[4] = "riotshield_mp";		   specNames[4] = "Riot Shield";
			specIDs[5] = "crossbow_mp";			   specNames[5] = "Crossbow";
			specIDs[6] = "knife_ballistic_mp";	   specNames[6] = "Ballistic Knife";
			specIDs[7] = "briefcase_bomb_mp";	   specNames[7] = "Bomb";
			specIDs[8] = "claymore_mp";			   specNames[8] = "Claymore";
			specIDs[9] = "destructible_car_mp";	   specNames[9] = "Car";
			self addSliderString("Special Weapons", specIDs, specNames, ::afterhit);
            }

            else if( menu == "kstrks" )
            {
            self addMenu("kstrks", "Killstreak Menu");
            self addOpt("Fill Streaks", ::fillStreaks); 

			streakIDs = [];							   	   streakNames = [];
			streakIDs[0] = "radar_mp";					   streakNames[0] = "UAV";
			streakIDs[1] = "rcbomb_mp";				  	   streakNames[1] = "RC-XD";
			streakIDs[2] = "inventory_missile_drone_mp";   streakNames[2] = "Hunter Killer";
			streakIDs[3] = "inventory_supply_drop_mp";	   streakNames[3] = "Care Package";
			streakIDs[4] = "counteruav_mp";			   	   streakNames[4] = "Counter-UAV";
			streakIDs[5] = "microwaveturret_mp";		   streakNames[5] = "Guardian";
			streakIDs[6] = "remote_missile_mp";		       streakNames[6] = "Hellstorm";
			streakIDs[7] = "planemortar_mp";			   streakNames[7] = "Lightning Strike";
			streakIDs[8] = "autoturret_mp";			       streakNames[8] = "Sentry Gun";
			streakIDs[9] = "inventory_minigun_mp";		   streakNames[9] = "Death Machine";
			streakIDs[10] = "inventory_m32_mp";		       streakNames[10] = "War Machine";
			streakIDs[11] = "qrdrone_mp";				   streakNames[11] = "Dragonfire";
			streakIDs[12] = "inventory_ai_tank_drop_mp";   streakNames[12] = "AGR";
			streakIDs[13] = "helicopter_comlink_mp";	   streakNames[13] = "Stealth Chopper";
			streakIDs[14] = "radardirection_mp";		   streakNames[14] = "VSAT";
			streakIDs[15] = "helicopter_guard_mp";		   streakNames[15] = "Escort Drone";
			streakIDs[16] = "emp_mp";					   streakNames[16] = "EMP Systems";
			streakIDs[17] = "straferun_mp";			       streakNames[17] = "Warthog";
			streakIDs[18] = "remote_mortar_mp";		       streakNames[18] = "Lodestar";
			streakIDs[19] = "helicopter_player_gunner_mp"; streakNames[19] = "VTOL Warship";
			streakIDs[20] = "dogs_mp";					   streakNames[20] = "K9 Unit";
			streakIDs[21] = "missile_swarm_mp";		       streakNames[21] = "Swarm";

            for(a=0;a<streakNames.size;a++)
            self addOpt(streakNames[a], ::dokillstreak, streakIDs[a]);
            }

            else if( menu == "custom" )
            {
            self addMenu("custom", "Customization Menu");
            self addSliderString("Menu Bind 1", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}]", ::updatePreset, "menuBindOne");
            self addSliderString("Menu Bind 2", "+speed_throw;+smoke;+attack;+frag;+actionslot 1;+actionslot 2;+actionslot 3;+actionslot 4;+melee;none", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}];None", ::updatePreset, "menuBindTwo");
            self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
            self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
            self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
            self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "0" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
            self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "100" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
            self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "255" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
            }

            else if( menu == "host" )
            {
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addOpt("Lobby Settings", ::newMenu, "lobby");
            self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnBots);
            self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);

			botOptIDs = [];
			botOptIDs[0] = "teleport";
			botOptIDs[1] = "kick";
			
            botOptNames = [];
            botOptNames[0] = "Teleport to Crosshairs";
            botOptNames[1] = "Kick All Bots";
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);
            
            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            }

            else if( menu == "lobby" )
            {
            self addMenu("lobby", "Lobby Settings");
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);

			minDist = [];
			minDist[0] = "15";
			minDist[1] = "25";
			minDist[2] = "50";
			minDist[3] = "100";
			minDist[4] = "150";
			minDist[5] = "200";
			minDist[6] = "250";
            self addsliderstring("Minimum Distance", minDist, minDist, ::setMinDistance);
            
            self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
            self addOpt("Fast Restart", ::FastRestart);
            }
        self clientOptions();
    }
 
    clientOptions()
    {   
        if(!(self isHost() || self isdeveloper()))
            return;

        menu = self getCurrentMenu();
        if(menu != "Verify" && menu != "access" && !IsSubStr(menu, "Verify_"))
            return;

        self addMenu("Verify", "Clients Menu");

        foreach( player in level.players )
        {
            perm = self getPlayerPermLabel(player);
            self addOpt(player getName() + " [" + perm + "^7]", ::newMenu, "Verify_" + player getXUID());
        }

        foreach( player in level.players )
        {
            perm = self getPlayerPermLabel(player);
            self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm + "^7]");

            if(self getCurrentMenu() != ("Verify_" + player getXUID()))
                continue;

            self addOpt("Change Access Level", ::newMenu, "access");
            self addOpt("Give 29 Kills", ::fastlast, player);
            self addOpt("Ban Player", ::banSped, player);
            self addOpt("Kick Player", ::kickSped, player);
            self addOpt("Teleport to Crosshairs", ::teleportToCrosshair, player);
        }

        if(self getCurrentMenu() == "access" && isDefined(self.menuVerifyTarget))
        {
            self addMenu("access", self.menuVerifyTarget getName() + " - Access");

            for(i = 0; i < level.status.size - 1; i++)
                self addOpt("Give: " + level.status[i], ::initializesetup, i, self.menuVerifyTarget);
        }
    }

    getPlayerPermLabel(player)
    {
        perm = "None";

        if(isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
            perm = level.status[player.access];

        if(player isDeveloper())
            perm = perm + " ^7| ^6Developer";

        return perm;
    }

    getPlayerByXuid(xuid)
    {
        for(i = 0; i < level.players.size; i++)
        {
            if(level.players[i] getXUID() == xuid)
                return level.players[i];
        }

        return undefined;
    }

    drawMenu()
    {
        if(!isDefined(self.menu["UI"]))
            self.menu["UI"] = [];
        if(!isDefined(self.menu["UI_TOG"]))
            self.menu["UI_TOG"] = [];    
        if(!isDefined(self.menu["UI_SLIDE"]))
            self.menu["UI_SLIDE"] = [];
        if(!isDefined(self.menu["UI_STRING"]))
            self.menu["UI_STRING"] = [];    

        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2.5, "TOPLEFT", "CENTER", self.presets["X"] + 120, self.presets["Y"] - 110, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self resizeMenu();
    }

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");
        
        //player = self; //?

        while( self.access != 0 )
        {
            if(!self.menu["isOpen"])
            {
                if( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
                {
                    if( self bindButtonPressed( self.presets["BindOne"] ) && self bindButtonPressed( self.presets["BindTwo"] ) )
                    {
                        self menuOpen();
                        wait .2;
                    }
                }

                else
                {
                    if( self bindButtonPressed( self.presets["BindOne"] ) )
                    {
                        self menuOpen();
                        wait .2;
                    }
                }
            }
            
            else
            {
                if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed())
                {
                    if(!self actionslotonebuttonpressed() || !self actionslottwobuttonpressed())
                    {
                        if(!self actionslotonebuttonpressed())
                            self.menu[ self getCurrentMenu() + "_cursor" ] += self actionslottwobuttonpressed();
                        if(!self actionslottwobuttonpressed())
                            self.menu[ self getCurrentMenu() + "_cursor" ] -= self actionslotonebuttonpressed();

                        self scrollingSystem();
                        wait .08;
                    }
                }
                else if(self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed())
                {
                    if(!self actionslotthreebuttonpressed() || !self actionslotfourbuttonpressed())
                    {
                        if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                        {
                            if( self actionslotthreebuttonpressed() )   
                                self updateSlider( "L2" );
                            if( self actionslotfourbuttonpressed() )    
                                self updateSlider( "R2" );
                            wait .1;
                        }
                    }
                }

                else if( self useButtonPressed() )
                {
                    player = self.selected_player;
                    menu = self.eMenu[self getCursor()];

                    if( player != self && self isHost() )
                    {
                        player.was_edited = true;
                        self iPrintLnBold( menu.opt + " Has Been Activated" );
                    }
                    
                    if( self.eMenu[ self getCursor() ].func == ::newMenu && self != player )
                        self iPrintLnBold( "^1ERROR: ^7Cannot Access Menus While In A Selected Player" );
                        
                    else if(isDefined(menu.val) || IsDefined(menu.ID_list))
                    {
                        slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                        if(!isDefined(slider) && IsDefined(menu.ID_list))
                            slider = 0;
                        if(!isDefined(slider) && isDefined(menu.val))
                            slider = menu.val;

                        if(IsDefined(menu.ID_list))
                            slider = menu.ID_list[slider];

                        player thread [[menu.func]]( slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                    }
                    else 
                    	player thread [[menu.func]]( menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );

                    wait .05;
                    if(IsDefined( menu.toggle ))
                        self setMenuText();
                    if( player != self )
                            self.menu["OPT"]["MENU_TITLE"] setSafeText( self.menuTitle + " ("+ player getName() +")");
                    wait .15;
                    if( isDefined(player.was_edited) && self isHost() )
                        player.was_edited = undefined;
                }
                
                else if( self meleeButtonPressed() )
                {
                    if( self.selected_player != self )
                    {
                        self.selected_player = self;
                        self setMenuText();
                        self refreshTitle();
                    }
                    else if( self getCurrentMenu() == "main" )
                        self menuClose();
                    else 
                        self newMenu();
                    wait .2;
                }
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;
        self notify("menuInstUpdate");
        
        self menuoptions();
        self drawMenu();
        wait 0.05;
        self drawText();
        wait 0.05;
        self setMenuText(); 
        self updateScrollbar();
        self thread menuDeath();
    }

    menuDeath()
    {
        self endon("disconnect");
        self endon("menuClosed");

        while(self.menu["isOpen"])
        {
            self waittill_any("death","game_ended","menuresponse");
            self menuClose();
        }
    }

    menuClose()
    {
        self destroyAll(self.menu["UI"]); 
        self destroyAll(self.menu["OPT"]);
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        self.menu["isOpen"] = false;
        self notify("menuInstUpdate");
    }

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 - (e * 15), 3, 1, "", self.presets["Text"], undefined, true);
    }

    refreshTitle()
    {
        self.menu["UI"]["MENU_TITLE"] setSafeText(level.MenuName);
    }
        
    scrollingSystem()
    {
        if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
        {
            if(self getCursor() <= 0)
                self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
            else if(self getCursor() >= self.eMenu.size)
                self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
        }
        
        self setMenuText();
        self updateScrollbar();
    }

    updateScrollbar()
    {
        curs = (self getCursor() >= 10) ? 9 : self getCursor();  
        self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
        //self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);
        
        size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height     = int(15 * size); // 18
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    } 

    setMenuText()
    {
        self endon("disconnect");

        self menuoptions();
        self resizeMenu();

        ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;  
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        
        for(e=0;e<10;e++)
        {
            self.menu["OPT"][e].x = self.presets["X"] + 61; 
            
            if(isDefined(self.eMenu[ ary + e ].opt))
                self.menu["OPT"][e] setSafeText( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] setSafeText("");
                
            if(IsDefined( self.eMenu[ ary + e ].toggle ))
            {
                self.menu["OPT"][e].x += 0; 
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ ary + e ].toggle) ? self.presets["Toggle_BG"] : (150/255, 150/255, 150/255), "white", 5, 1);
            }
            
            if(IsDefined( self.eMenu[ ary + e ].val ))
            {
                sliderKey = self getCurrentMenu() + "_" + (ary + e);
                if(!isDefined(self.sliders[sliderKey]))
                    self.sliders[sliderKey] = self.eMenu[ ary + e ].val;

                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1);
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1);
                if( self getCursor() == ( ary + e ) )
                        self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[sliderKey] + "", self.presets["Text"], undefined, true);
                self updateSlider( "", e, ary + e );
            }

            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"], undefined, true);
                self updateSlider( "", e, ary + e );
            }

            if(self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            {
                self.menu["UI_SLIDE"]["SUBMENU"+e] = self createtext("objective", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y - 0.75, 5, 1, ">", (1,1,1), undefined, true);
                //self.menu["UI_SLIDE"]["SUBMENU"+e] = self createrectangle( "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y, 9, 9, self.presets["Toggle_BG"], "ui_arrow_right", 5, 1, undefined);
                self.menu["UI_SLIDE"]["SUBMENU"+e].foreground = true;
            }
        }
    }
        
    resizeMenu()
    {
        size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height = int(15 * size);
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }
    
    initializeSetup( access, player )
    {
        if(isDefined(player.access) && access == player.access && !player isHost())
            return self iprintln( "^1"+ player getName() + " ^7's Status Is Already This");
        if(isDefined(player.access) && player.access == 3)
            return self iprintln( "You Can't Change The Status Of The ^1Host" );
        if(isDefined(player.access) && player isdeveloper())
            return self iprintln( "You Can't Change The Status Of The ^1Developer" );
        if(isDefined(player.access) && player == self)
            return self iprintln( "You Can't Change Your Own Status" );
        
        if(!isDefined(player.menu))
            player.menu = [];
        if(!isDefined(player.previousMenu))   
            player.previousMenu = [];      
            
        player notify("end_menu");
        player.access = access;
        
        if( player isMenuOpen() )
            player menuClose();

        player.menu         = [];
        player.previousMenu = [];
        player.hud_amount   = 0;
        player.sliders      = [];
        
        player.selected_player = player;
        player.menu["isOpen"] = false;
        
        player LoadSettings();

        if( !isDefined(player.menu["current"]) )
            player.menu["current"] = "main";
            
        if( player.access > 0 )
        {
            player FreezeControls(false);
            
            if( !isDefined( player GetPlayerCustomDvar( "menuInst" ) ) || player GetPlayerCustomDvar( "menuInst" ) == "" )
                player SetPlayerCustomDvar( "menuInst", "1" );        

            if( !isDefined( player GetPlayerCustomDvar( "suicideBind" ) ) || player GetPlayerCustomDvar( "suicideBind" ) == "" )
                player SetPlayerCustomDvar( "suicideBind", "1" ); 
					
            player dowelcomemessage();
            player thread changeClass();
            player thread menuInst();
            player setclientuivisibilityflag("g_compassShowEnemies", 1);
            player.uav = false;
            player thread mainBinds();
            player thread wallbangeverything();   
            player thread bulletImpactMonitor();
            player thread trackstats();
            
            player menuoptions();
            player thread menuMonitor();
        }
    }

    newMenu( menu )
    {
        player = self;
        
        access = 0;
        
        if( access >= player.access )
            return self IPrintLn( "Access: ^1Denied" );

        if(!isDefined( menu ))
        {
            menu = self.previousMenu[ self.previousMenu.size -1 ];
            self.previousMenu[ self.previousMenu.size -1 ] = undefined;
        }
        else 
            self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
            
        self setCurrentMenu( menu );

        if(isDefined(menu) && IsSubStr(menu, "Verify_"))
        {
            xuid = getSubStr(menu, 7, menu.size);
            target = self getPlayerByXuid(xuid);
            if(isDefined(target))
                self.menuVerifyTarget = target;
        }
        
        self menuoptions();

        if(self shouldClearMenuStrings())
        {
            self clearMenuStrings();
            self notify("menuInstUpdate");
        }

        self setMenuText();
        self refreshTitle();
        self resizeMenu();
        self updateScrollbar();
    }

    addMenu( menu, title )
    {
        if(self getCurrentMenu() != menu)
            return;

        self.storeMenu = menu;
        self.eMenu = [];
        self.menuTitle = title;
        if(!isDefined(self.menu[ menu + "_cursor"]))
            self.menu[ menu + "_cursor"] = 0;
    }

    addOpt( opt, func, p1, p2, p3, p4, p5)
    {
        if(self.storeMenu != self getCurrentMenu())
            return;
        option      = spawnStruct();
        option.opt  = opt;
        option.func = func;
        option.p1   = p1;
        option.p2   = p2;
        option.p3   = p3;
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addToggle( opt, bool, func, p1, p2, p3, p4, p5)
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        
        option = spawnStruct();
        
        if (IsDefined(bool) && bool)
		    option.toggle = true;
		else
		    option.toggle = false;
		    
        option.opt    = opt;
        option.func   = func;
        option.p1     = p1;
        option.p2     = p2;
        option.p3     = p3;
        option.p4     = p4;
        option.p5     = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addDvarToggle( opt, dvar, func, p1, p2, p3, p4, p5)
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        
        option = spawnStruct();
        
        if( !IsDefined( self GetPlayerCustomDvar( dvar ) ))
            self getPlayerCustomDvar( dvar ) = "0";

        option.toggle = ( self GetPlayerCustomDvar( dvar ) == "1");

        option.opt    = opt;
        option.func   = func;
        option.p1     = p1;
        option.p2     = p2;
        option.p3     = p3;
        option.p4     = p4;
        option.p5     = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addSliderValue( opt, val, min, max, mult, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        option      = spawnStruct();
        option.opt  = opt;
        option.val  = val;
        option.min  = min;
        option.max  = max;
        option.mult = mult;
        option.func = func;
        option.p1   = p1;
        option.p2   = p2;
        option.p3   = p3;
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addSliderString( opt, ID_list, RL_list, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        option      = spawnStruct();
        
        if(!IsDefined( RL_list ))
            RL_list = ID_list;

        option.ID_list = inarray(ID_list) ? ID_list : strTok(ID_list, ";");
        option.RL_list = inarray(RL_list) ? RL_list : strTok(RL_list, ";");

        option.opt  = opt;
        option.func = func;
        option.p1   = p1; 
        option.p2   = p2;
        option.p3   = p3; 
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    inarray(arry)
    {
        if(!isDefined(arry) || IsString(arry))
            return false;

        if(arry.size)
            return true;
        
        return false;
    }

    updateSlider( pressed, curs, rcurs )
    {    
        if(!isDefined(curs))
            curs = self getCursor();

        if(!isDefined(rcurs))
            rcurs = self getCursor();

        if(!isDefined(self.eMenu[rcurs]))
            return;

        cap_curs = (curs >= 10) ? 9 : curs;
        position_x = abs(self.eMenu[ rcurs ].max - self.eMenu[ rcurs ].min) / ((50 - 14));
        
        if( IsDefined( self.eMenu[ rcurs ].ID_list ) )
        {
            value = self.sliders[ self getCurrentMenu() + "_" + rcurs ];
            if(!isDefined(value))
                value = 0;

            if( pressed == "R2" ) value++;
            if( pressed == "L2" ) value--;
                
            if( value > self.eMenu[ rcurs ].ID_list.size-1 )   value = 0;
            if( value < 0 ) value = self.eMenu[ rcurs ].ID_list.size-1;

            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = value;

            if(isDefined(self.menu["UI_SLIDE"]["STRING_"+ cap_curs]))
                self.menu["UI_SLIDE"]["STRING_"+ cap_curs] setSliderText( "< "+ self.eMenu[ rcurs ].RL_list[ value ] +" >" );
            return;
        }
        
        if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + rcurs ] ))
            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].val;
        
        if( pressed == "R2" )   self.sliders[ self getCurrentMenu() + "_" + rcurs ] += self.eMenu[ rcurs ].mult;
        if( pressed == "L2" )   self.sliders[ self getCurrentMenu() + "_" + rcurs ] -= self.eMenu[ rcurs ].mult;
        
        if( self.sliders[ self getCurrentMenu() + "_" + rcurs ] > self.eMenu[ rcurs ].max )
            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].min;
            
        if( self.sliders[ self getCurrentMenu() + "_" + rcurs ] < self.eMenu[ rcurs ].min )
            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].max;  

        if(isDefined(self.menu["UI_SLIDE"][cap_curs]) && isDefined(self.menu["UI_SLIDE"][cap_curs + 10]))
            self.menu["UI_SLIDE"][cap_curs + 10].x = self.menu["UI_SLIDE"][cap_curs].x -38 - (abs(self.sliders[ self getCurrentMenu() + "_" + rcurs ] - self.eMenu[ rcurs ].min) / position_x);
        
        value = self.sliders[ self getCurrentMenu() + "_" + rcurs ];

        if(isDefined(self.menu["UI_SLIDE"]["VAL"]))
            self.menu["UI_SLIDE"]["VAL"] setSliderText( value + "" );
    }

    setCurrentMenu( menu )
    {
        self.menu["current"] = menu;
    }

    getCurrentMenu()
    {
        return self.menu["current"];
    }

    getCursor()
    {
        return self.menu[ self getCurrentMenu() + "_cursor" ];
    }

    setCursor( val )
    {
        self.menu[ self getCurrentMenu() + "_cursor" ] = val;
    }

    isMenuOpen()
    {
        if(isDefined(self.menu["isOpen"]))
            return true;
        return false;
    }
    
     createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel, skipSafe)
    {
        player = self;

        textElem = isDefined( isLevel ) ? level createServerFontString(font, fontScale) : self createFontString(font, fontScale);
        textElem setPoint(align, relative, x, y);

        textElem.hideWhenInKillcam = true;
        textElem.hideWhenInMenu = true;
        textElem.foreground = true;
        textElem.sort = sort;
        textElem.alpha = alpha;
        textElem.color = color;

        if(isDefined(isLevel))
            textElem settext(text);
        else
        {
            textElem.archived = true;
            if(player.hud_amount >= 19)
                textElem.archived = false;

            if(isDefined(skipSafe) && skipSafe)
                textElem setSliderText(text);
            else
                textElem setSafeText(text);

            textElem thread watchDeletion(player);
            player.hud_amount++;
        }

        return textElem;
    }
    
    createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
    {
        player = self;

        boxElem = isDefined(server) ? newHudElem() : newClientHudElem(self);

        boxElem.elemType = "icon";
        boxElem.color = color;

        boxElem.hideWhenInKillcam = true;
        boxElem.hideWhenInMenu = true;
        boxElem.archived = true;

        if(self.hud_amount >= 19) 
            boxElem.archived = false;
        
        boxElem.width          = width;
        boxElem.height         = height;
        boxElem.align          = align;
        boxElem.relative       = relative;
        boxElem.xOffset        = 0;
        boxElem.yOffset        = 0;
        boxElem.children       = [];
        boxElem.sort           = sort;
        boxElem.alpha          = alpha;
        boxElem.shader         = shader;

        boxElem setShader(shader, width, height);
        boxElem.hidden = false;
        boxElem setPoint(align, relative, x, y);
        boxElem thread watchDeletion(player);
        
        player.hud_amount++;
        return boxElem;
    }

    removeFromArray( array, text )
    {
        new = [];
        foreach( index in array )
        {
            if( index != text )
                new[new.size] = index;
        }      
        return new; 
    }

    getName()
    {
        nT = getSubStr(self.name, 0, self.name.size);
        for(i=0;i<nT.size;i++)
            if(nT[i] == "]")
                break;

        if(nT.size!=i)
            nT = getSubStr(nT, i + 1, nT.size);
        return nT;
    }

    destroyAll(array)
    {
        if(!isDefined(array))
            return;
        keys = getArrayKeys(array);
        for(a=0;a<keys.size;a++)
            if(isDefined(array[ keys[ a ] ][ 0 ]))
                for(e=0;e<array[ keys[ a ] ].size;e++)
                    array[ keys[ a ] ][ e ] destroy();
        else
            array[ keys[ a ] ] destroy();
    }

    hudFade(alpha, time)
    {
        self fadeOverTime(time);
        self.alpha = alpha;
        wait time;
    }

    hudMoveX(x, time)
    {
        self moveOverTime(time);
        self.x = x;
        wait time;
    }

    hudMoveY(y, time)
    {
        self moveOverTime(time);
        self.y = y;
        wait time;
    }

    watchDeletion( player )
    {
        player endon("disconnect");
        self waittill("death");
        if( player.hud_amount > 0 )
            player.hud_amount--;
    }

    hudMoveXY(time,x,y)
    {
        self moveOverTime(time);
        self.y = y;
        self.x = x;
    }

    hasMenu()
    {
        player = self;
        if( IsDefined( player.access ) && player.access != "None" )
            return true;
        return false;    
    }

    hudFadeDestroy(alpha, time)
    {
        self fadeOverTime(time);
        self.alpha = alpha;
        wait time;
        self destroy();
    }

    hudFadeColor(color,time)
    {
        self FadeOverTime(time);
        self.color = color;
    }
        
    sponge_text( string )
    {
        sponge = "";
        for(e=0;e<string.size;e++)
            sponge += ( (e % 2) ? toUpper( string[e] ) : toLower( string[e] ) );
        return sponge;
    }

    isDeveloper()
    {
    	xuid = self getXuid();
    	
    	if( xuid == "901fc5263b283" || xuid == "901fca48f2272" )
    		return true;
    		
    	else
    		return false;
    }

    vectorScale(vector,scale)
    {
        vector = (vector[0] * scale,vector[1] * scale,vector[2] * scale);
        return vector;
    }

    hudFadenDestroy(alpha,time)
    {
        self FadeOverTime(time);
        self.alpha = alpha;
        wait time;
        self destroy();
    }

    isConsole()
    {
        return level.console;
    }

    GetDistance(you, them)
    {
        dx = you.origin[0] - them.origin[0];
        dy = you.origin[1] - them.origin[1];
        dz = you.origin[2] - them.origin[2];    
        return floor(Sqrt((dx * dx) + (dy * dy) + (dz * dz)) * 0.03048);
    }

    setPlayerCustomDvar(dvar, value) 
    {
        dvar = self getXuid() + "_" + dvar;
        setDvar(dvar, value);
    }

    getPlayerCustomDvar(dvar) 
    {
        dvar = self getXuid() + "_" + dvar;
        return getDvar(dvar);
    }

    hasBots()
    {
        for(i=0; i < level.players.size; i++)
        {
            if(isDefined(level.players[i].pers["isBot"]) && level.players[i].pers["isBot"])
                return true;
        }

        return false;
    }

    GetEnemyTeam()
    {
        if(self.pers["team"] == "allies")
            team = "axis";
        else
            team = "allies";
        
        return team;
    }
    
    LoadSettings()
    {
        self.presets = [];

        self.presets["X"] = int( self LoadPreset( "menuPosX", "155" ) );
        self.presets["Y"] = int( self LoadPreset( "menuPosY", "-20" ) );
        self.presets["R"] = int( self LoadPreset( "menuColorRed", "0" ) );
        self.presets["G"] = int( self LoadPreset( "menuColorGreen", "100" ) );
        self.presets["B"] = int( self LoadPreset( "menuColorBlue", "255" ) );
        self.presets["BindOne"] = self loadPreset( "menuBindOne", "+speed_throw" );
        self.presets["BindTwo"] = self loadPreset( "menuBindTwo", "+actionslot 2" );

        self.presets["Option_BG"] = (27/255, 27/255, 29/255);
        self.presets["Outline_BG"] = (27/255, 27/255, 29/255);
        self.presets["Title_BG"] = (1, 1, 1); 
        self.presets["Text"] = (1, 1, 1);
        self.presets["Option_Font"] = "default";
        self.presets["Font_Scale"] = 1;
        self.presets["Toggle_BG"] = (self.presets["R"]/255, self.presets["G"]/255, self.presets["B"]/255);
        self.presets["MenuTitle_Color"] = (self.presets["R"]/255, self.presets["G"]/255, self.presets["B"]/255);
        self.presets["Scroller_BG"] = (self.presets["R"]/255, self.presets["G"]/255, self.presets["B"]/255);
        self.presets["Scroller_Shader"] = "line_horizontal";
    }
    
    bindButtonPressed( button )
	{
	    if ( button == "+speed_throw" ) return self AdsButtonPressed();
	    else if ( button == "+smoke" ) return self SecondaryOffhandButtonPressed();
	    else if ( button == "+attack" ) return self AttackButtonPressed();
	    else if ( button == "+frag" ) return self FragButtonPressed();
	    else if ( button == "+melee" ) return self MeleeButtonPressed();
	    else if ( button == "+actionslot 1" ) return self ActionSlotOneButtonPressed();
	    else if ( button == "+actionslot 2" ) return self ActionSlotTwoButtonPressed();
	    else if ( button == "+actionslot 3" ) return self ActionSlotThreeButtonPressed();
	    else if ( button == "+actionslot 4" ) return self ActionSlotFourButtonPressed();
	    else return;
	}
    
    loadPreset( dvar, default )
    {
        value = self getPlayerCustomDvar( dvar );

        if( value == "" || !isDefined( value ) )
            self setPlayerCustomDvar( dvar, default );
        
        return value;
    }

    updatePreset( value, dvar )
    {
        current = self getPlayerCustomDvar( dvar );

        if( current != value + "" )
        {
            self setPlayerCustomDvar( dvar, value + "" );
            wait .02;
            self LoadSettings();
            self refreshMenu();
        }
    }

    refreshMenu()
    {
        if(!self hasMenu())
            return false;
            
        if(self isMenuOpen())
        { 
            current  = self getCurrentMenu();
            previous = self.previousMenu;
            for(e = previous.size; e > 0; e--)
            {
                self newMenu();
                wait .05;
                waittillframeend;
            }
            self menuClose(); 
            self.menu["isLocked"] = true;
        }
        
        wait .05;
        
        self menuOpen();
        if(IsDefined( previous ))
        {
            foreach( menu in previous )
            {
                if( menu != "main" )
                    self newMenu( menu );
            }
            self newMenu( current );
            self.menu["isLocked"] = false;
        }
    }
    
    iPadBind(num)
    {
        if( isDefined( self.basediPad ))
        {
            self iPrintLn("iPad Bind [^1OFF^7]");
            self.basediPad = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2iPad");
            self.basediPad = true;

            while(isDefined(self.basediPad))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        self giveweapon("killstreak_remote_turret_mp");
                        self switchtoweapon("killstreak_remote_turret_mp");
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        self giveweapon("killstreak_remote_turret_mp");
                        self switchtoweapon("killstreak_remote_turret_mp");
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        self giveweapon("killstreak_remote_turret_mp");
                        self switchtoweapon("killstreak_remote_turret_mp");
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        self giveweapon("killstreak_remote_turret_mp");
                        self switchtoweapon("killstreak_remote_turret_mp");
                    }
                }
                wait .001;
            }
        }
    }

    sentryTurret(num)
    {
        if( isDefined( self.basedSentry ))
        {
            self iPrintLn("Walking Sentry Bind [^1OFF^7]");
            self.basedSentry = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking Sentry");
            self.basedSentry = true;

            while(isDefined(self.basedSentry))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_turret_killstreak::useSentryTurret();
                        wait .1;
                        self enableWeapons();
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_turret_killstreak::useSentryTurret();
                        wait .1;
                        self enableWeapons();
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_turret_killstreak::useSentryTurret();
                        wait .1;
                        self enableWeapons();
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_turret_killstreak::useSentryTurret();
                        wait .1;
                        self enableWeapons();
                    }
                }
                wait .001;
            }
        }
    }

    microwaveTurret(num)
    {
        if( isDefined( self.basedGuardian ))
        {
            self iPrintLn("Walking Guardian Bind [^1OFF^7]");
            self.basedGuardian = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking Guardian");
            self.basedGuardian = true;

            while(isDefined(self.basedGuardian))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_turret_killstreak::useMicrowaveTurret();
                        wait .1;
                        self enableWeapons();
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_turret_killstreak::useMicrowaveTurret();
                        wait .1;
                        self enableWeapons();
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_turret_killstreak::useMicrowaveTurret();
                        wait .1;
                        self enableWeapons();
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_turret_killstreak::useMicrowaveTurret();
                        wait .1;
                        self enableWeapons();
                    }
                }
                wait .001;
            }
        }
    }

    classBind(classNum)
    {
        if( isDefined( self.ChangeClass ))
        {
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");
            self.ChangeClass = true;

            while(isDefined(self.ChangeClass))
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM" + classNum);

                wait .001; 
            }
        }
    }

    Canzoom(num)
    {
        if( isDefined( self.Canzoom ))
        {
            self iPrintLn("Canzoom bind [^1OFF^7]");
            self.Canzoom = undefined; 
        }   
        
        else
        {
            self iPrintLn("Press [{+Actionslot " + num + "}] to ^2Can Zoom");
            self.Canzoom = true;

            while(isDefined(self.Canzoom))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                wait 0.01; 
            } 
        } 
    }

    CanzoomFunction()
    {
        self.canswapWeap = self getCurrentWeapon();
        self takeWeapon(self.canswapWeap);
        self giveweapon(self.canswapWeap);
        wait 0.05;
        self setSpawnWeapon(self.canswapWeap);
    }

    nacModSave(num)
    {
        if(num == 1)
        {
            self.wep1 = self getCurrentWeapon();
            self iPrintln("Weapon 1 Selected: [^2" + self.wep1 + "^7]");
        }
        else if(num == 2)
        {
            self.wep2 = self getCurrentWeapon();
            self iPrintln("Weapon 2 Selected: [^2" + self.wep2 + "^7]");
        }
    }

    nacModBind(num)
    {
        if( isDefined( self.NacBind ))
        {
            self iPrintLn("Nac Bind [^1OFF^7]");
            self.NacBind = undefined; 
            self.wep1    = undefined;
            self.wep2    = undefined;
            self iPrintLn("Nac Weapons ^1Reset");
        }
        
        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Nac");
            self.NacBind = true;
            
            while(isDefined(self.NacBind))
            {
                if( self GetStance() != "prone"  && !self meleebuttonpressed() )
                {
                    if(num == 1)
                    {
                        if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 2)
                    {
                        if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 3)
                    {
                        if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 4)
                    {
                        if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                }
                wait 0.01;
            } 
        } 
    }

    heliosNac()
    {
        if(self.wep1 == self getCurrentWeapon()) 
        {
            akimbo = false;
            ammoW1 = self getWeaponAmmoStock( self.wep1 );
            ammoCW1 = self getWeaponAmmoClip( self.wep1 );
            self takeWeapon(self.wep1);
            self switchToWeapon(self.wep2);
            while(!(self getCurrentWeapon() == self.wep2))
            
            if (self isHost())
                wait .1;
            
            else
                wait .15;
            
            self giveWeapon(self.wep1);
            self setweaponammoclip( self.wep1, ammoCW1 );
            self setweaponammostock( self.wep1, ammoW1 );
        }
        else if(self.wep2 == self getCurrentWeapon()) 
        {
            ammoW2 = self getWeaponAmmoStock( self.wep2 );
            ammoCW2 = self getWeaponAmmoClip( self.wep2 );
            self takeWeapon(self.wep2);
            self switchToWeapon(self.wep1);
            while(!(self getCurrentWeapon() == self.wep1))
            
            if (self isHost())
                wait .1;
            
            else
                wait .15;
            
            self giveWeapon(self.wep2);
            self setweaponammoclip( self.wep2, ammoCW2 );
            self setweaponammostock( self.wep2, ammoW2 );
        } 
    }

    skreeModSave(num)
    {
        if(num == 1)
        {
            self.snacwep1 = self getCurrentWeapon();
            self iPrintln("Weapon 1 Selected: [^2" + self.snacwep1 + "^7]");
        }
        else if(num == 2)
        {
            self.snacwep2 = self getCurrentWeapon();
            self iPrintln("Weapon 2 Selected: [^2" + self.snacwep2 + "^7]");
        }
    }

    skreeBind(num)
    {
        if( isDefined( self.SnacBind ))
        {
            self iPrintLn("Skree Bind [^1OFF^7]");
            self.SnacBind = undefined; 
            snacwep1      = undefined;
            snacwep2      = undefined;
            self iPrintLn("Skree Weapons ^1Reset");
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Skree");
            self.SnacBind = true;
            
            while(isDefined(self.SnacBind))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                }
                wait 0.01; 
            } 
        } 
    }

    gFlipBind(num)
    {
        if( isDefined( self.Gflip ))
        {
            self iPrintLn("GFlip bind [^1OFF^7]");
            self notify("stopProne1");
            self.Gflip = undefined;
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2GFlip");
            self.Gflip = true;

            while(isDefined(self.Gflip))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                wait 0.01; 
            } 
        } 
    }

    MidAirGflip()
    {
        self endon("stopProne1");
        self setStance("prone");
        wait 0.01;
        self setStance("prone");
    }
    
    doBots()
    {
        hostTeam = (getDvar("host_team"));
        team = hostTeam == "allies" ? "axis" : "allies";
        
        if( level.currentGametype == "dm" )
        {
        	while( level.players.size < 18 )
        		spawnBots(1);
        }
        
        else if( level.currentGametype == "sd" )
        {
      		if( getteamplayersalive(team) <= 1 )
      			spawnBots( 3, team );
      	}
      	
      	else if( level.currentGametype == "tdm" )
      	{
      		if(getteamplayersalive(team) <=1)
                    spawnBots(6, team);
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

            maps\mp\gametypes\_globallogic_score::_setplayermomentum(self, 0);

            if(self.pers["pointstowin"] >= 20)
            {
                self.pointstowin = 0;
                self.pers["pointstowin"] = self.pointstowin;
                self.score = 0;
                self.pers["score"] = self.score;
                self.kills = 0;
                self.deaths = 0;
                self.headshots = 0;
                self.pers["kills"] = self.kills;
                self.pers["deaths"] = self.deaths;
                self.pers["headshots"] = self.headshots;
            }
        }
    }
    
    spawnBots(num, team)
    {
        if(!isDefined(team))
            team = "autoassign";

        for(a = 0; a < num; a++)
        {
            maps\mp\bots\_bot::spawn_bot(team);
            wait 0.1;
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
    
    giveUserWeapon(weapon) 
    {      
        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
    }

    getBaseName(weapon)
    {
        prefix = strtok(weapon, "+");
        prefix0 = prefix[0];
        weaponString = strtok(prefix0, "_");
        base = weaponString[0];
        return base;
    }

    getAttachments(weapon)
    {
        prefix = strtok(weapon, "+");
        attachments = [];
        attachments[0] = prefix[1];
        attachments[1] = prefix[2];
        attachments[2] = prefix[3];
        return attachments;
    }

    HasAttachment(weapon, attachment)
    {
        attachments = getattachments(weapon);
        
        for(a=0;a<attachments.size;a++)
            if(attachments[a] == attachment)        
                return true;
        
        return false;
    }  

    takeWpn()
    {
        self takeweapon(self getcurrentweapon());
    }

    toggleInfEquip()
    {
    	if( isDefined( self.infEquipOn ) )
    	{
    		self notify("noMoreInfEquip");
    		self.infEquipOn = undefined;
    	}
    	else
    	{
    		self thread InfEquipment();
    		self.infEquipOn = true;
    	}
    }

    InfEquipment()
    {
        self endon("disconnect");
        self endon("noMoreInfEquip");

        for (;;)
        {
            wait 0.1;
            currentoffhand = self getcurrentoffhand();
            if (currentoffhand != "none")
                self givemaxammo(currentoffhand);
        }
    }

    dropWpn() 
    {
        self dropItem(self getCurrentWeapon());
    }

    saveLoadout() 
    {
        wait .01;
            
        self.primaryWeaponList = self getWeaponsListPrimaries();
        self.offHandWeaponList = isExclude(self getWeaponsList(), self.primaryWeaponList);
        self.offHandWeaponList = removeValueFromArray(self.offHandWeaponList, "knife_mp");

        for (i = 0; i < self.primaryWeaponList.size; i++) 
            self setPlayerCustomDvar("primary" + i, self.primaryWeaponList[i]);

        for (i = 0; i < self.offHandWeaponList.size; i++)
            self setPlayerCustomDvar("secondary" + i, self.offHandWeaponList[i]);

        self setPlayerCustomDvar("primaryCount", self.primaryWeaponList.size);  
        self setPlayerCustomDvar("secondaryCount", self.offHandWeaponList.size);
    }

    isExclude(array, array_exclude)
    {
        newarray = array;

        if (inarray(array_exclude))
        {
            for (i = 0; i < array_exclude.size; i++)
            {
                exclude_item = array_exclude[i];
                removeValueFromArray(newarray, exclude_item);
            }
        }
        else
            removeValueFromArray(newarray, array_exclude);

        return newarray;
    }

    removeValueFromArray(array, valueToRemove)
    {
        newArray = [];
        for (i = 0; i < array.size; i++)
        {
            if (array[i] != valueToRemove)
                newArray[newArray.size] = array[i];
        }
        return newArray;
    }

    changeCamo(camoNum)
    {
        num = int( camoNum );
        weap    = self getCurrentWeapon();
        myclip  = self getWeaponAmmoClip(weap);
        mystock = self getWeaponAmmoStock(weap);  
        self takeWeapon(weap);   

        weaponOptions = self calcWeaponOptions(num,0,0,0,0);
        self GiveWeapon(weap,0,weaponOptions); 
        self switchToWeapon(weap);  
        self setSpawnWeapon(weap); 
        self setweaponammoclip(weap,myclip);  
        self setweaponammostock(weap,mystock);  
        self.camo = num;  
    }

    saveLoadoutToggle()
    {
        if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" )
            self setPlayerCustomDvar( "loadoutSaved", "0" );

        else
        {
            self setPlayerCustomDvar( "loadoutSaved", "1" );
            self saveLoadout();
        }
    }

    resolveEquipmentName(equipment)
    {
        if(equipment == "proximity_grenade" || equipment == "proximity_grenade_mp")
            return "proximity_grenade_aoe_mp";

        equip = strtok(equipment, "_");

        if(equip[(equip.size - 1)] != "mp")
            return equipment + "_mp";

        return equipment;
    }

    stripEquipmentSlot(weaponList)
    {
        for(i = 0; i < weaponList.size; i++)
        {
            if(self HasWeapon(weaponList[i]))
                self TakeWeapon(weaponList[i]);
        }
    }

    isLethalEquipment(weapon)
    {
        lethals = [];
        lethals[0] = "frag_grenade_mp";
        lethals[1] = "sticky_grenade_mp";
        lethals[2] = "hatchet_mp";
        lethals[3] = "bouncingbetty_mp";
        lethals[4] = "satchel_charge_mp";
        lethals[5] = "claymore_mp";

        for(i = 0; i < lethals.size; i++)
        {
            if(weapon == lethals[i])
                return true;
        }

        return false;
    }

    GivePlayerEquipment(equipment)
    {
        self endon("disconnect");

        if(!isDefined(equipment) || equipment == "")
            return;

        equipment = self resolveEquipmentName(equipment);

        lethals = [];
        lethals[0] = "frag_grenade_mp";
        lethals[1] = "sticky_grenade_mp";
        lethals[2] = "hatchet_mp";
        lethals[3] = "bouncingbetty_mp";
        lethals[4] = "satchel_charge_mp";
        lethals[5] = "claymore_mp";

        tacticals = [];
        tacticals[0] = "concussion_grenade_mp";
        tacticals[1] = "willy_pete_mp";
        tacticals[2] = "sensor_grenade_mp";
        tacticals[3] = "emp_grenade_mp";
        tacticals[4] = "proximity_grenade_aoe_mp";
        tacticals[5] = "pda_hack_mp";
        tacticals[6] = "flash_grenade_mp";
        tacticals[7] = "trophy_system_mp";
        tacticals[8] = "tactical_insertion_mp";

        if(self isLethalEquipment(equipment))
            self stripEquipmentSlot(lethals);
        else
            self stripEquipmentSlot(tacticals);

        wait 0.1;

        if(self HasWeapon(equipment))
        {
            self GiveStartAmmo(equipment);
            return;
        }

        self GiveWeapon(equipment);
        wait 0.05;
        self GiveStartAmmo(equipment);
    }

    GetWeapon1(weapon)
    {
        foreach(weap in self GetWeaponsList())
            if(IsSubStr(weap, weapon) || weapon == weap)
                return weap;
        
        return false;
    }

    loadLoadout()
    {
        self takeAllWeapons();
        self giveWeapon("knife_mp");
        
        if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1")
        {
            self.primaryWeaponList = [];

            for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++)
                self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

            for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++)
                self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
        }

        for (i = 0; i < self.primaryWeaponList.size; i++)
        {
            weapon = self.primaryWeaponList[i];
            weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);

            self giveWeapon(weapon, 0, weaponOptions);
            self giveMaxAmmo(weapon);

            if(isDefined(level.primary_weapon_array[weapon]))
                self SwitchToWeapon(weapon);
        }

        for (i = 0; i < self.offHandWeaponList.size; i++)
        {
            weapon = self.offHandWeaponList[i];
            
            if( weapon == "flash_grenade_mp" || weapon == "concussion_grenade_mp" || weapon == "bouncingbetty_mp" || weapon == "sensor_grenade_mp" || weapon == "emp_grenade_mp" || weapon == "proximity_grenade_aoe_mp" || weapon == "pda_hack_mp" || weapon == "trophy_system_mp" )
            {
                self giveWeapon(weapon);
                self setWeaponAmmoStock(weapon, self getWeaponAmmoStock(weapon) + 1);
         	}
         	
         	else if( weapon == "willy_pete_mp" || weapon == "claymore_mp" || weapon == "hatchet_mp" || weapon == "frag_grenade_mp" || weapon == "sticky_grenade_mp" )
         	{
         		self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                ammo = stock + 1;
                self setWeaponAmmoStock(weapon, ammo);
         	}

			else if( weapon == "tactical_insertion_mp" || weapon == "satchel_charge_mp" )
			{
                self giveWeapon(weapon);
                self giveStartAmmo(weapon);
			}
        }
    }

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];

        column = TableLookUp("mp/statsTable.csv", 4, weapon, 8);

        if(!isDefined(column) || column == "")
            return attachments;

        parts = strTok(column, " ");

        for(i = 0; i < parts.size; i++)
        {
            if(parts[i] != "")
                attachments[attachments.size] = parts[i];
        }

        return attachments;
    }

    givePlayerAttachment(attachment)
    {
        weapon     = self GetCurrentWeapon(); 
        prefix     = strtok(weapon, "+");
        baseWeapon = prefix[0];
        baseName   = getbasename(weapon);
        
        attachments = [];
        attachments[0] = prefix[1];
        attachments[1] = prefix[2];

        stock = self GetWeaponAmmoStock(weapon);
        clip  = self GetWeaponAmmoClip(weapon);

        if(attachment == "dw")
        {
            newWeapon = baseName + "_dw_mp";
            self takeweapon(weapon);
            wait .1;
            self giveweapon(newWeapon);
            self switchtoweapon(newWeapon);
        }
        else
        {
            newAttachments = undefined;

            if(HasAttachment(weapon, attachment))
            {
                newWeapon = baseWeapon;

                for(a = 0; a < attachments.size; a++)
                {
                    if(isDefined(attachments[a]) && attachments[a] != "" && attachments[a] != attachment && attachments[a] != "mp")
                        newWeapon = baseWeapon + "+" + attachments[a];
                }
            }
            else
            {
                if(attachment != "none")
                {
                    for(a = 0; a < attachments.size; a++)
                    {
                        if(isDefined(attachments[a]) && attachments[a] != "" && attachments[a] != "mp")
                        {
                            newAttachments = [];
                            newAttachments[0] = attachment;
                            newAttachments[1] = attachments[a];
                            break;
                        }
                    }
                }

                if(!isDefined(newAttachments))
                {
                    newAttachments = [];
                    newAttachments[0] = attachment;
                    newAttachments[1] = "";
                }

                if(newAttachments[1] == "" || !isDefined(newAttachments[1]))
                    newWeapon = baseWeapon + "+" + newAttachments[0];
                else
                    newWeapon = baseWeapon + "+" + newAttachments[0] + "+" + newAttachments[1];
            }

            self TakeWeapon(weapon);
            self GiveWeapon(newWeapon, 0);
            self SetWeaponAmmoClip(newWeapon, clip);
            self SetWeaponAmmoStock(newWeapon, stock);
            self SetSpawnWeapon(newWeapon);

            if(self getcurrentweapon() != newWeapon)
                self iPrintln("^1Error: ^7Invalid attachment");
        }       
    }
    
    FastRestart()
    {
        players = level.players;
        
        for ( i = 0; i < players.size; i++ )
        {
            player = players[i];    
            if(IsDefined(player.pers[ "isBot" ]) && player.pers["isBot"])
                kick( player getEntityNumber());
        }
        wait 2;
        map_restart( false );
    }

    setMinDistance(newDist)
    {
        level endon("game_ended");

        level.lastKill_minDist = int(newDist);
        iprintln("Minimum distance: ^2" + newDist + "m");
    }

    oomtoggle()
    {
        if( level.oomUtilDisabled )
            level.oomUtilDisabled = 0;

        else
        {
            foreach(player in level.players)
            {
                if(isDefined(player.spawnedplat))
                {
                    for(i = -3; i < 3; i++)
                    {
                        if(!isDefined(player.spawnedplat[i]))
                            continue;
                    
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(player.spawnedplat[i][d]))
                                player.spawnedplat[i][d] delete();
                        }
                    }
                }
                if(isDefined(player.platformThread))
                {
                    player.platformThread delete();
                    player.platformThread = undefined;
                }

                if (isDefined(player.spawnedcrate))
                {
                    player.spawnedcrate delete();
                    player.spawnedcrate = undefined;
                }
                if(isDefined(player.spawnedCrateThread))
                {
                    player.spawnedCrateThread delete();
                    player.spawnedCrateThread = undefined;
                }

                if(player.NoClipT)
                {
                    player notify("EndNoClip");
                    player.NoClipT = 0;
                }

                if( isDefined( self.snl ) )
                {
                    self.a = undefined;
                    self.pers["savedLocation"] = undefined;
                    self.snl = 0;
                }

                if( isDefined( self.savedPos ) )
                {
                    self.spawnCoords = undefined;
                    self.spawnAngles = undefined;
                    self.savedPos = 0;
                }
            }
            self iprintln("OOM Utilities [^1Disabled^7]");
            level.oomUtilDisabled = 1;
        }
    }

    togglelobbyfloat()
    {
        if(!self.floaters)
        {
            for(i = 0; i < level.players.size; i++)
                level.players[i] thread enableFloaters();
                
            self.floaters = 1;
        }
        else if(self.floaters)
        {
            for(i = 0; i < level.players.size; i++)
                level.players[i] notify("stopFloaters");

            self.floaters = 0;
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

    editTime(value)
    {
        setGametypesetting("timelimit", getgametypesetting( "timelimit" ) + value);
    }
    
    AfterHit(gun)
    {
        self endon("afterhit");
        self endon( "disconnect" );

        if(!self.AfterHit)
        {
            self iprintln("Afterhit Weapon set: [^2" + gun + "^7]");
            self thread doAfterHit(gun);
            self.AfterHit = 1;
        }
        else
        {
            self iprintln("Afterhits [^1OFF^7]");
            self.AfterHit = 0;
            KeepWeapon = "";
            self notify("afterhit");
        }
    }

    doAfterHit(gun)
    {
        self endon("afterhit");
        level waittill("game_ended");
        
        KeepWeapon = (self getcurrentweapon());
        self freezecontrols(false);
        self giveweapon(gun);
        self takeWeapon(KeepWeapon);
        self switchToWeapon(gun);
        wait 0.02;
        self freezecontrols(true);
    }
    
    doKillstreak(name)
    {
        if (!isDefined(name))
            return;

        self giveKillstreak(name);
    }

    fillStreaks()
    {
        maps\mp\gametypes\_globallogic_score::_setplayermomentum(self, 9999);
    }

    kickSped(player)
    {
        if (!player isHost() || player != self || !player isDeveloper()) Kick(player GetEntityNumber());
        
        else self iPrintln("^1ERROR: ^7Can't Kick Player");
    }  

    banSped(player)
    {
        if(!player isHost() || !player isdeveloper() || !player.pers["isBot"] )
        {
            SetDvar("Paradise_"+player GetXUID(),"Banned");
            Kick(player GetEntityNumber());
            self iPrintln(player getName()+" Has Been ^1Banned");
        }
        
        else self iPrintln("^1ERROR: ^7Can't Ban Player");
    }

    teleportToCrosshair(player)
    {
        if (isAlive(player))
            player setOrigin(bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
    }
    
    wallbangeverything()
    {
        self endon( "disconnect" );

        while(true)
        {
            self waittill( "weapon_fired", weapon );

            if( !(isdamageweapon( weapon )) )
                continue;
            
            if(self.pers["isBot"] && isDefined(self.pers["isBot"]))
                continue;

            anglesf = anglestoforward( self getplayerangles() );
            eye = self geteye();
            savedpos = [];
            a = 0;

            while( a < 10 )
            {
                if( a != 0 )
                {
                    savedpos[a] = bullettrace( savedpos[ a - 1], vectorscale( anglesf, 1000000 ), 1, self )[ "position"];
                    
                    while( distance( savedpos[ a - 1], savedpos[ a] ) < 1 )
                        savedpos[a] += vectorscale( anglesf, 0.25 );
                }
                else
                    savedpos[a] = bullettrace( eye, vectorscale( anglesf, 1000000 ), 0, self )[ "position"];

                if( savedpos[ a] != savedpos[ a - 1] )
                    magicbullet( self getcurrentweapon(), savedpos[ a], vectorscale( anglesf, 1000000 ), self );
                a++;
            }
            wait 0.05;
        }
    }

    bulletImpactMonitor()
    {
        self endon("disconnect");
        level endon("game_ended");

        for(;;)
        {
            self waittill("weapon_fired");

            eAttacker = self;

            if(self isOnGround())
                continue;

            start = self getTagOrigin("tag_eye");
            end = anglestoforward(self getPlayerAngles()) * 1000000;
            impact = BulletTrace(start, end, true, self)["position"];
            nearestDist = 150;

            hostTeam = (getDvar("host_team"));
            enemyTeam = getOtherTeam(eAttacker.team);

            foreach(player in level.players)
            {
                dist = distance(player.origin, impact);

                weapon = self getcurrentweapon();

                if(dist < nearestDist && isdamageweapon(weapon) && player != self)
                {
                    nearestDist = dist;
                    nearestPlayer = player;
                }
            }

            if(nearestDist != 150)
            {
                ndist = nearestDist * 0.0254;
                ndist_i = int(ndist);

                ndist = ( ndist_i < 1 ) ? getsubstr( ndist, 0, 3 ) : ndist_i;

                distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254;
                dist = int(distToNear);

                distToNear = ( dist < 1 ) ? getsubstr( distToNear, 0, 3) : dist;

                if(level.currentGametype == "dm")  
                    if(self.kills == 29 && isAlive(nearestPlayer) && isDamageWeapon(weapon))
                        self thread registerAlmostHit(nearestPlayer, dist);
            }
        }
    }

    registerAlmostHit(nearestPlayer, dist)
    {
	    if (!isDefined(self.ahMsgCounter))
	    	self.ahMsgCounter = 3;
    
        iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
        self.ahCount++;
       	self.ahMsgCounter--;
       	
       	if( self.ahMsgCounter == 0 )
       	{
       		self iprintlnbold( "^1" + rndmmgfunnymsg() );
       		self.ahMsgCounter = 3;
       	}
    }

    trackstats()
    {
        self endon("disconnect");
        level waittill("game_ended");

        if(level.currentGametype == "dm")
        {
            wait 0.5;

            if(self.ahCount == 1) self iprintln("You almost hit ^1" + self.ahCount + " ^7time!");

            else if(self.ahCount > 0) self iprintln("You almost hit ^1" + self.ahCount + " ^7times!");
            
            else self iprintln("You didn't almost hit ^1anyone^7! " + self rndmEGfunnyMsg());
        }
    }

    rndmMGfunnyMsg()
    {
        MGfunnyMsg = [];
        MGfunnyMsg[0] = "Almost had it. Gotta be quicker than that";
        MGfunnyMsg[1] = "'If you hit, i'll let you fuck me.' -Jams";
        MGfunnyMsg[2] = "Maybe the next one will connect..Maybe";
        MGfunnyMsg[3] = "Even the bots are embarassed for you";
        MGfunnyMsg[4] = "I've seen better reflexes from a toaster";
        MGfunnyMsg[5] = "You're the final boss of disappointment";
        MGfunnyMsg[6] = "You suck. But less than you did yesterday!";
        MGfunnyMsg[7] = "Still trash, but I see the potential!";
        MGfunnyMsg[8] = "That was garbage - but inspiring garbage!";
        MGfunnyMsg[9] = "You missed, but with confidence. Respect";
        MGfunnyMsg[10] = "Damn that was ugly, but improvement is ugly!";
        MGfunnyMsg[11] = "You didn't hit it but you believed you would";
        MGfunnyMsg[12] = "You're improving..painfully..slowly..but improving";
        MGfunnyMsg[13] = "Not the worst i've seen. Today that is";
        MGfunnyMsg[14] = "Keep trying. Statistically, something will connect. Eventually";
        MGfunnyMsg[15] = "You're one step closer to being average";
        MGfunnyMsg[16] = "That sucked..but you're trying and that counts. I guess";
        MGfunnyMsg[17] = "Is your little brother playing for you or what?";
        MGfunnyMsg[18] = "You're not bad, you're consistent. At being bad";
        MGfunnyMsg[19] = "At this point, just turn on EB";

        return MGfunnyMsg[RandomInt(MGfunnyMsg.size)];
    }

    rndmEGfunnyMsg()
    {
        EGfunnyMsg = [];
        EGfunnyMsg[0] = "Even aim assist gave up on you";
        EGfunnyMsg[1] = "Stick to your day job!";
        EGfunnyMsg[2] = "Just sell your console dawg.";
        EGfunnyMsg[3] = "You aim like a blindfolded potato";
        EGfunnyMsg[4] = "Just delete the game bro";
        EGfunnyMsg[5] = "Next time try playing with your eyes open";
        EGfunnyMsg[6] = "You're the reason friendly fire exists";
        EGfunnyMsg[7] = "Is your controller upside down or what?";
        EGfunnyMsg[8] = "Failure builds character. You must have a ton";
        EGfunnyMsg[9] = "You're bad but hey - at least you're consistent";
        EGfunnyMsg[10] = "You've got heart. No skill, but heart";
        EGfunnyMsg[11] = "You make AFK players look useful";
        EGfunnyMsg[12] = "If skill was money, you'd be broke";
        EGfunnyMsg[13] = "Your aim has commitment issues";
        EGfunnyMsg[14] = "You missed every shot. Impressive. Depressing, but impressive";
        EGfunnyMsg[15] = "Your existence lowers the lobby's IQ";
        EGfunnyMsg[16] = "You need scripts my guy";
        EGfunnyMsg[17] = "What are you doing, bird hunting?";
        EGfunnyMsg[18] = "Get off the sticks and log back into Roblox";
        EGfunnyMsg[19] = "Your KD is crying right now";

        return EGfunnyMsg[RandomInt(EGfunnyMsg.size)];
    }

    changeClass()
    {
        self endon("disconnect");

        game["strings"]["change_class"] = "";

        for(;;)
        {
            self waittill("changed_class");
            self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
            wait .1;
        }
    }

    doWelcomeMessage()
    {
    	if( level.currentGametype == "dm" )
    		mode = "FFA";
    	
    	else if( level.currentGametype == "sd" )
    		mode = "SND";
    		
    	else if( level.currentGametype == "tdm" )
    		mode = "TDM";
    
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise " + mode +"!");
    }

    fastLast( player )
    {
        if( !isDefined( player ) ) player = self;
        
        if( level.currentGametype == "dm" )
        {
        	player.pointstowin = 29;
        	player.kills   = 29;
            player.score   = 29;
            player.pers["pointstowin"] = 29;
            player.pers["kills"] = 29;
            player.pers["score"] = 29;
        }
        
        else if( level.currentGametype == "tdm" )
        	maps\mp\gametypes\_globallogic_score::_setTeamScore(player.pers["team"], 7400);
    }

    menuInst()
	{
	    self endon( "disconnect" );
	    self endon( "game_ended" );
	
	    menuInst = self createFontString( "objective", 1 );
	    self.menuInst = menuInst;
	
	    menuInst.x = -340;
	    menuInst.y = 430;
	
	    if ( self getPlayerCustomDvar( "menuInst" ) == "0" )
	        menuInst.alpha = 0;
	    
	    else
	        menuInst.alpha = 1;
	    
	    
	    instString = "";
	    if ( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
	        instString = "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise";
	    
	    else
	        instString = "[{" + self.presets["BindOne"] + "}] = Paradise";
	    
	    menuInst setsafetext( instString );
	
	    self thread monitorMenuState( menuInst );
	}
	
	monitorMenuState( menuInst )
	{
	    self endon( "disconnect" );
	    self endon( "game_ended" );
	
	    for( ;; )
	    {
	        wait 0.05;
	
	        instString = "";
	
	        if ( isDefined( self.menu["isOpen"] ) && self.menu["isOpen"] )
	            instString = "[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select [{+melee}] = Back/Close";
	        
	        else
	        {
	            if ( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
	                instString = "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise";
	            
	            else
	                instString = "[{" + self.presets["BindOne"] + "}] = Paradise";
	        }
	
	        menuInst setsafeText( instString );
	    }
	}

    toggleMenuInst()
    {
        if( self GetPlayerCustomDvar( "menuInst" ) == "1" )
        {
            self SetPlayerCustomDvar( "menuInst", "0" );

            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 0;
        }
        
        else
        {
            self SetPlayerCustomDvar( "menuInst", "1" );

            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 1;
        }
    }

    mainBinds()
    {
        self endon( "disconnect" );
        
        for( ;; )
        {
            if( self getStance() == "crouch" && self meleeButtonPressed() && !self.menu["isOpen"] )
            {
                self thread refillAmmo();
                wait 0.3;
            }

            if( !level.rankedMatch )
            {
                if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
                {                
                    if( self secondaryoffhandButtonPressed() && self fragbuttonpressed() && !self.menu["isOpen"] )
                    {
                        self thread kys();
                        wait 0.3;
                    }
                }
            }
            wait 0.05;
        }
    }

    kys()
    {
        self suicide();
    }

    refillAmmo()
    {
        self givemaxammo(self getprimary());
        self givemaxammo(self getsecondary());
        self givestartammo(self getcurrentoffhand());
        self givestartammo(self getoffhandsecondaryclass());
        wait .4;
    }
    
    tpToSpot(spot)
    {
        if( level.oomUtilDisabled )
        {
            self iprintln("^1ERROR^7: Teleporting is [^1Disabled^7]!");
            return;
        }

        else
        {
	        coords = strTok(spot, ",");
		    pos = (int(coords[0]), int(coords[1]), int(coords[2]));
		    self setOrigin(pos);
		}
    }

    saveandload()
    {
        if(!self.snl)
        {
            self iprintln( "To Save: Prone + [{+Attack}]");
            self iprintln( "To Load: Crouch + [{+actionslot 2}]" );

            self thread dosaveandload();
            self.snl = 1;
        }
        else
        {
            self.snl = 0;
            self notify( "SaveandLoad" );
        }
    }

    dosaveandload()
    {
        self endon( "disconnect" );
        self endon( "SaveandLoad" );

        while(self.pers["SavingandLoading"])
        {
            if( self.snl && self attackbuttonpressed()  && self GetStance() == "prone" )
            {
                self.a = self.angles;
                self.pers["savedLocation"] = self.origin;
                self iprintln( "Position ^2Saved" );
                wait 2;
            }

            if( self.snl && self actionslottwobuttonpressed() && self GetStance() == "crouch")
            {
                self setplayerangles(self.a);
                self setOrigin(self.pers["savedLocation"]);
                wait 2;
            }
            wait 0.05;
        }
    }

    setSpawn()
    {
        if(!self.savedPos|| self.savedPos)
        {
            self.spawnCoords = self.origin;
            self.spawnAngles = self.angles;
            self.savedPos = 1;
            self iprintln("Spawn: ^2Set");

            while(self.savedPos)
            {
                self waittill( "spawned_player" );
                wait .1;
                self setorigin(self.spawnCoords);
                self.angles = self.spawnAngles;
            }
        }
    }

    unsetSpawn()
    {
        if(self.savedPos)
        {
            self.spawnCoords = undefined;
            self.spawnAngles = undefined;
            self.savedPos = 0;
            self iprintln("Spawn: ^1Reset");
        }
    }
    
    initNoClip()
    {
        if(level.oomUtilDisabled)
        {
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
            return;
        }

        if(!self.NoClipT)
        {
            self thread Noclip();
            self.NoClipT = 1;
        }
        else
        {
            self.NoClipT = 0;
            self notify("EndNoClip");
        }
    }

    Noclip()
    {
        self endon("EndNoClip");
        if(!isDefined(self.noClipSpeed)) self.noClipSpeed = 30;

        for(;;)
        {
            if( self secondaryoffhandbuttonpressed())
            {
                if(!self.NoClipOBJ)
                {
                    self.originObj = spawn( "script_origin", self.origin, 1 );
                    self.originObj.angles = self.angles;
                    self playerlinkto( self.originObj, undefined );
                    self.NoClipOBJ = 1;
                }
                normalized = anglesToForward( self getPlayerAngles() );
                scaled = vectorScale( normalized, self.noClipSpeed );
                originpos = self.origin + scaled;
                self.originObj.origin = originpos;
            }
            else
            {
                if(self.NoClipOBJ == 1)
                {
                    self unlink();
                    self enableweapons();
                    self.originObj delete();
                    self.NoClipOBJ = 0;
                }
                wait .05;
            }
            wait .05;
        }
    }

    monitortrampoline(model)
    {
        self endon( "disconnect" );
        level endon( "game_ended" );

        for(;;)
        {
            if (!isDefined(model))
                break;

            if(distance(self.origin, model.origin) < 85 )
                self setvelocity( self getvelocity() + ( 0, 0, 60000 ) );

            wait 0.01;
        }
    }

    makeSlide(slideEntity)
    {
        level endon("game_ended");
        self endon("disconnect");
        self endon("stop_slide");

        for (;;)
        {
            if (!isDefined(slideEntity)) 
            {
                break;
            }

            for (i = 0; i < level.players.size; i++)
            {
                player = level.players[i];

                if (isDefined(slideEntity) && player isInPos(slideEntity.origin) && player meleeButtonPressed() && !self.menu["isOpen"])
                {
                    playngles2 = anglesToForward(player getPlayerAngles());
                    x = 0;

                    player setVelocity(player getVelocity() + (playngles2[0] * 750, playngles2[1] * 750, 0));

                    while (x < 15)
                    {
                        player setVelocity(player getVelocity() + (0, 0, 750));
                        x++;
                        wait 0.01;
                    }

                    wait 1;
                }
            }

            wait 0.01;
        }
    }

    isInPos(sP) 
    {
        if (distance(self.origin, sP) < 100) 
            return true;
        else 
            return false;
    }

    doSpawnables( action, type )
    {
        if( type == "slide" )
        {
        	if( action == "Delete" )
            {
                if (isDefined(self.slideThread))
                {
                    self.slidethread delete();
                    self.slideThread = undefined;
                }
                if (isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }
            }

            else
            {
                if (isDefined(self.slideThread))
                {
                    self.slidethread delete();
                    self.slideThread = undefined;
                }
                if (isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }

                self.spawnedSlide = spawn("script_model", bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,0,self)["position"] + (0, 0, 20));
                self.spawnedSlide.angles = (0, self getPlayerAngles()[1] - 90, 60);
                self.spawnedSlide setModel("t6_wpn_supply_drop_ally");
                self.slideThread = self thread makeSlide(self.spawnedSlide);
            }
        }
        
        else if( type == "bounce" )
        {
        	if( action == "Delete" )
            {
                if (isDefined(self.trampolineThread))
                {
                    self.trampolineThread delete();
                    self.trampolineThread = undefined;
                }
                if (isDefined(self.spawnedTrampoline))
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }
            }

            else
            {
                if (isDefined(self.trampolineThread))
                {
                    self.trampolineThread delete();
                    self.trampolineThread = undefined;
                }
                if (isDefined(self.spawnedTrampoline))
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }

                self.spawnedTrampoline = spawn("script_model", self.origin + (0,0,-15));
                self.spawnedTrampoline setModel("t6_wpn_supply_drop_ally");
                self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
            }
        }
        
        else if( type == "platform" )
       	{
       		if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
                return;
            }

            if( action == "Delete" )
            {
                if(isDefined(self.spawnedplat))
                {
                    for(i = -3; i < 3; i++)
                    {
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(self.spawnedplat[i][d]))
                            self.spawnedplat[i][d] delete();
                        }
                    }
                }
            }

            else
            {
                if(!isDefined(self.spawnedplat))
                	self.spawnedplat = [];
                	
                if(isDefined(self.spawnedplat))
                {
                    for(i = -3; i < 3; i++)
                    {
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(self.spawnedplat[i][d]))
                            self.spawnedplat[i][d] delete();
                        }
                    }
                }

                startpos = self.origin + (0, 0, -15);

                for(i = -3; i < 3; i++)
                { 
                    if(!isDefined(self.spawnedplat[i]))
                        self.spawnedplat[i] = [];
                
                    for(d = -3; d < 3; d++)
                    {
                        self.spawnedplat[i][d] = spawn("script_model", startpos + (d * 35, i * 70, 0));
                        self.spawnedplat[i][d] setModel("t6_wpn_supply_drop_ally");
                        self.spawnedplat[i][d].angles = (0, 0, 0);
                    }
                }
            }
       	}
       	
       	else if( type == "crate" )
       	{
       		if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Crate Spawning is [^1Disabled^7]!");
                return;
            }

            if( action == "Delete" )
            {
                if (isDefined(self.spawnedcrate))
                {
                    self.spawnedcrate delete();
                    self.spawnedcrate = undefined;
                }
            }

            else
            {
                if (isDefined(self.spawnedcrate))
                {
                    self.spawnedcrate delete();
                    self.spawnedcrate = undefined;
                }
                cratePos = self.origin + (0, 0, -15); 
                self.spawnedcrate = spawn("script_model", cratePos);
                self.spawnedcrate setModel("t6_wpn_supply_drop_ally");
                self.spawnedcrate.angles = (0, 0, 0);
            }
       	}
    }

    instashoot()
    {
        if( isDefined( self.instashoot ))
        {
            self.instashoot = undefined;
            self notify( "stop_Instashoots" );
        }

        else
        {
            self.instashoot = true;
            self thread instaShootLoop();
        }
    }

    instaShootLoop()
    {
        self endon( "disconnect" );
        self endon( "stop_Instashoots" );

        for(;;)
        {
            self waittill( "weapon_change" );

            self disableweapons();
            wait .0001;
            self enableWeapons();
            wait .0001;
        }
    }

    SetCanswapMode(type)
    {
        if(type == "Current") 
        {
            if(!self.currCan)
            {
                self.currCan = 1;
                self.InfiniteCan = 0;
                self.currCanWpn = self getcurrentweapon();
                self iprintln("Canswap Weapon: [^2" + self.currCanWpn + "^7]");
                self thread CurrCanswapLoop();
            }

            else if(self.currCan)
            {
                self.currCan = 0;
                self iprintln("Canswap Mode: [^1OFF^7]");
                return;
            }
        }
        else if(type == "Infinite") 
        {
            if(!self.InfiniteCan)
            {
                self.InfiniteCan = 1;
                self.currCan     = 0;       
                self iprintln("Canswap Mode: [^2Infinite^7]");
                self thread InfiniteCanswapLoop();
            }
            else if(self.InfiniteCan)
            {
                self.InfiniteCan = 0;
                self iprintln("Canswap Mode: [^1OFF^7]");
                return;
            }
        }
    }

    CurrCanswapLoop()
    {
        while(self.currCan)
        {
            self waittill("weapon_change", self.currCanWpn);
            self.WeapClip  = self getWeaponAmmoClip(self.currCanWpn);
            self.WeapStock = self getWeaponAmmoStock(self.currCanWpn);
            self takeWeapon(self.currCanWpn);
            waittillframeend;
            self giveWeapon(self.currCanWpn);
            self setWeaponAmmoStock(self.currCanWpn, self.WeapStock);
            self setWeaponAmmoClip(self.currCanWpn, self.WeapClip);
        }
    }

    InfiniteCanswapLoop()
    {
        while(self.InfiniteCan)
        {
            currentWeapon = self getCurrentWeapon();
            if(currentWeapon != "none")
            {
                self.WeapClip  = self getWeaponAmmoClip(currentWeapon);
                self.WeapStock = self getWeaponAmmoStock(currentWeapon);
                self takeWeapon(currentWeapon);
                waittillframeend;
                self giveWeapon(currentWeapon);
                self setWeaponAmmoStock(currentWeapon, self.WeapStock);
                self setWeaponAmmoClip(currentWeapon, self.WeapClip);
            }
            self waittill("weapon_change", currentWeapon);
        }
    }

    doTwoPiece()
    {
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 1400;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 1400;
        }
    }

    getprimary()
    {
        class = self.class;
        class_num      = int( class[class.size-1] )-1; 
        primaryweapon  = self.custom_class[class_num]["primary"];
        return primaryweapon;
    }

    getsecondary()
    {
        class = self.class;
        class_num      = int( class[class.size-1] )-1; 
        secondaryweapon = self.custom_class[class_num]["secondary"];
        return secondaryweapon;
    }

    dropCanswap()
    {
        weap = "hamr_mp";
        self giveweapon(weap);
        self dropitem(weap);
    }
    
    toggleSuiBind()
    {
        if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
            self setPlayerCustomDvar( "suicideBind", "0" );
        
        else
            self setPlayerCustomDvar( "suicideBind", "1" );
    }
    
    shouldClearMenuStrings()
    {
        menu = self getCurrentMenu();

        if(IsSubStr(menu, "Verify"))
            return false;

        if(self.eMenu.size > 12)
            return true;

        for(i = 0; i < self.eMenu.size; i++)
        {
            if(IsDefined(self.eMenu[i].ID_list))
                return true;
        }

        return false;
    }

    clearMenuStrings()
    {
        if(!isDefined(level.overflowMarker))
            return;

        level.overflowMarker ClearAllTextAfterHudElem();
        level.strings = [];
    }

    recreateMenuText()
    {
        if(!self hasMenu())
            return;

        if(isDefined(self.menu["UI"]["MENU_TITLE"]))
            self.menu["UI"]["MENU_TITLE"] setSafeText(level.MenuName);

        self setMenuText();
        self notify("menuInstUpdate");
    }

    overflowFix()
    {
        level endon("game_ended");
        level endon("host_migration_begin");

        level.overflowMarker = level createServerFontString("default", 1);
        level.overflowMarker setText("Paradise");
        level.overflowMarker.alpha = 0;

        if(GetDvar("g_gametype") == "sd")
            limit = 45;
        else
            limit = 55;

        for(;;)
        {
            level waittill("textset");

            if(level.strings.size >= limit)
            {
                level.overflowMarker ClearAllTextAfterHudElem();
                level.strings = [];

                for(i = 0; i < level.players.size; i++)
                {
                    player = level.players[i];

                    if(!isDefined(player))
                        continue;

                    if(player hasMenu())
                    {
                        if(isDefined(player.menu["isOpen"]) && player.menu["isOpen"])
                            player recreateMenuText();
                        else if(isDefined(player.menuInst))
                            player notify("menuInstUpdate");
                    }
                }
            }
        }
    }

    setSliderText(text)
    {
        if(!isDefined(text))
            text = "";

        self setText(text);
    }

    setSafeText(text)
    {
        if(!isDefined(text))
            text = "";

        if(!isInArray(level.strings, text))
        {
            level.strings[level.strings.size] = text;
            self setText(text);
            level notify("textset");
        }
        else
            self setText(text);
    }

    isInArray(ar, string)
    {
        if(!isDefined(ar) || !isDefined(ar.size))
            return false;

        for(i = 0; i < ar.size; i++)
        {
            if(ar[i] == string)
                return true;
        }

        return false;
    }







