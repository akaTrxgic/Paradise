    #include maps\mp\_utility;
    #include common_scripts\utility;

#ifdef MP
        #include maps\mp\gametypes\_hud_util;

    #ifdef WAW
        #include maps\mp\gametypes\_globallogic_score;
    #endif

    #ifdef MW2 || MW3 || BO1 || BO2
        #include maps\mp\gametypes\_hud_message;
        #include maps\mp\killstreaks\_killstreaks;
    #endif

    #ifdef BO1 || BO2
        #include maps\mp\gametypes\_globallogic;
    #endif

#endif

#ifdef ZM

    #ifdef BO2
        #include maps\mp\zombies\_zm;
        #include maps\mp\gametypes_zm\_hud_util;
        #include maps\mp\zombies\_zm_utility;
        #include maps\mp\gametypes_zm\_hud_message;
        #include maps\mp\zombies\_zm_perks;
    #endif

#endif

init()
{
    level.strings = [];
    level.status = ["None","^2Verified","^5CoHost","^1Host"];
    level.MenuName = "Paradise";
    level.currentMapName       = getDvar("mapName");
    precacheshader("ui_arrow_right");

    #ifdef MP
    level.currentGametype      = getDvar("g_gametype");
    setDvar("host_team", self.team);

    #ifdef BO2
    level.onlineGame = SessionModeIsOnlineGame();
	level.rankedMatch = ( GameModeIsUsingXP() && !isPreGame() );
    #else
    level.onlineGame = getDvarInt("onlinegame");
    level.rankedMatch = ( !level.onlineGame || !getDvarInt( "xblive_privatematch" ) );
    #endif

    #ifdef WAW
    precacheshader("hudsoftline");
    //precacheshader("rank_prestige9");
    level.onPlayerKilled = ::onPlayerKilled;
    level.killcam_style = 0;
    level.fk = false;
    level.showFinalKillcam = false;
    level.waypoint = false;
    level.doFK["axis"] = false;
    level.doFK["allies"] = false;
    level.slowmotstart = undefined;
    #endif

    #ifdef BO1
    precacheshader("hudsoftline");
    //precacheshader("rank_prestige15");
    #endif

    #ifdef BO2
    precacheshader("line_horizontal");
    precacheshader("rank_prestige09");
    #endif

    #ifdef MW1
    level thread init_overFlowFix();
    precacheshader("hudsoftline");
    //precacheshader("rank_prestige4");
    level.onPlayerKilled = ::onPlayerKilled;
    level.killcam_style = 0;
    level.fk = false;
    level.showFinalKillcam = false;
    level.waypoint = false;
    level.doFK["axis"] = false;
    level.doFK["allies"] = false;
    level.slowmotstart = undefined;
    #endif

    #ifdef MW2
    level.killstreaks = ["uav", "airdrop", "counter_uav", "airdrop_sentry_minigun", "predator_missile", "precision_airstrike", "harrier_airstrike", "helicopter", "airdrop_mega", "helicopter_flares", "stealth_airstrike", "helicopter_minigun", "ac130", "emp"];
    precacheshader("hudsoftline");
    //precacheshader("rank_prestige8");
    precacheitem("lightstick_mp");
    precacheitem("deserteaglegolden_mp");
    precacheitem("throwingknife_rhand_mp");
    #endif

    #ifdef MW3
    level.killstreaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];
    precacheshader("hudsoftline");
    //precacheshader("cardicon_prestige_classic9");
    precacheitem("at4_mp");
    precacheitem("lightstick_mp");
    #endif

    #ifdef Ghosts
    //precacheshader("rank_prestige10");
    precacheshader("hudsoftline");
    #endif

    #ifdef MWR
    precacheshader("line_horizontal");
    //precacheshader("rank_prestige4");
    #endif

    if(level.rankedMatch)
    {
        level.isOnlineMatch = true;

        #ifdef WAW || BO1 || BO2
        level thread tarc_pub_init();
        #endif

        #ifdef MW1 || MW2 || MW3 || Ghosts || MWR
        level thread iw_pub_init();
        #endif
    }

    else if(!level.rankedMatch)
    {
        level.isOnlineMatch = false;
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::pm_modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        level.oomUtilDisabled      = 0;
        initDvars();

        #ifdef WAW || BO1 || BO2
        level thread tarc_pm_init();
        #endif

        #ifdef MW1 || MW2 || MW3 || MWR
        level thread iw_pm_init();
        #endif
    }

    #else

    level thread sp_zm_init();
    #endif
}

pm_modifyplayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
{
    dist = GetDistance(self, eAttacker);

    #ifdef MWR
    lastKill = 24;
    #else
    lastKill = 29;
    #endif

    if(level.currentGametype == "dm")
    {
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"])
                iDamage = 999;
        
            else
                iDamage = 0;
        }

        if(eAttacker.kills < lastKill)
        {
            if(isDamageWeapon(sWeapon))
                iDamage = 999;  
        }

        else if(eAttacker.kills == lastKill)
        {
            if(dist >= level.lastKill_minDist)
            {
                if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                
                #ifdef MW2 || MW3
                else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                #endif

                #ifdef BO1 || BO2
                else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                #endif

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

        #ifdef BO1 || BO2
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
            {
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
        #endif

        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }

    else if(level.currentGametype == "sd")
    {
        if(sMeansOfDeath == "MOD_FALLING")
            iDamage = 0;

        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"])
                iDamage = 999;
        
            else
                iDamage = 0;
        }

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
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }

                #ifdef MW2 || MW3
                else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                #endif

                #ifdef BO1 || BO2
                else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                #endif

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

        #ifdef BO1 || BO2
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
            {
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
        #endif
        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }

    #ifdef WAW || BO1 || BO2
    else if(level.currentGametype == "tdm")
    #endif

    #ifdef MW1 || MW2 || MW3 || Ghosts || MWR
    else if(level.currentGametype == "war")
    #endif
    {
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"])
                iDamage = 999;
        
            else
                iDamage = 0;
        }

        #ifdef MW1 || WAW
        if(game["teamScores"][eAttacker.pers["team"]] < 740)
        #endif

        #ifdef MW2 || MW3 || BO1
        if(game["teamScores"][eAttacker.pers["team"]] < 7400)
        #endif

        #ifdef BO2
        if(game["teamScores"][eAttacker.pers["team"]] < 74)
        #endif
        {
            if(isDamageWeapon(sWeapon))
                iDamage = 999;  
        }

        #ifdef MW1 || WAW
        else if(game["teamScores"][eAttacker.pers["team"]] == 740)
        #endif

        #ifdef MW2 || MW3 || BO1
        else if(game["teamScores"][eAttacker.pers["team"]] == 7400)
        #endif

        #ifdef BO2
        else if(game["teamScores"][eAttacker.pers["team"]] == 74)
        #endif
        {
            if(dist >= level.lastKill_minDist)
            {
                if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                
                #ifdef MW2 || MW3
                else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                #endif

                #ifdef BO1 || BO2
                else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                #endif

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

        #ifdef BO1 || BO2
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
            {
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
        #endif

        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }
}
#ifdef BO1 || BO2
semtex_bounce_physics(vdir)
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
#endif

pub_modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex)
{             
    if(level.currentGametype == "sd")
        if(sMeansOfDeath == "MOD_FALLING") 
            iDamage = 0;

    if(IsDamageWeapon(sWeapon)) 
        iDamage = 999;

    #ifdef MW1 || WAW
    thread maps\mp\gametypes\_globallogic::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
    #endif

    #ifdef MW2 || MW3
    thread maps\mp\gametypes\_damage::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
    #endif

    #ifdef BO1
    thread maps\mp\gametypes\_globallogic_player::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
    #endif

    #ifdef BO2
    thread maps\mp\gametypes\_globallogic_player::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex);
    #endif

    dist = GetDistance(self, eAttacker);

    if(level.currentGametype == "dm")
    {
        if(eAttacker.kills == 29 && isdamageweapon(sweapon))
            eAttacker iprintln("[^1" + dist + "m^7]");
    }
    
    else if(level.currentGametype == "sd")
    {
        if(self.team != getDvar("host_team"))
        {
            enemyCount = 0;

            foreach(player in level.players) 
                if(player != self && IsAlive(player)) 
                    enemyCount++;

            if(enemyCount == 1 && isDamageWeapon(sWeapon)) 
                foreach(player in level.players) 
                    if(player.team == getDvar("host_team")) 
                        player iprintln("[^1" + dist + "m^7]");
        }
    }

    else if(level.currentGametype == "war")
    {
        if(self.team != getDvar("host_team"))
        {
            #ifdef MW1
            if(game["teamScores"][eAttacker.pers["team"]] == 740)
            #endif

            #ifdef MW2 || MW3
            if(game["teamScores"][eAttacker.pers["team"]] == 7400)
            #endif
                if(isDamageWeapon(sWeapon)) 
                    foreach(player in level.players) 
                        if(player.team == getDvar("host_team")) 
                            player iprintln("[^1" + dist + "m^7]");
        }
    }
}

pm_OnPlayerConnect()
{
    for(;;)
    {
        level waittill( "connected", player );

        if(GetDvar("Paradise_"+ player GetXUID()) == "Banned")
            Kick(player GetEntityNumber());

        #ifdef MP
        player thread initstrings(); 
        player thread MonitorButtons();

        #ifdef WAW || MW1
            #ifdef WAW
            if(level.currentGametype != "sd")
                player thread beginFK();
            #endif
            player thread beginFK();
        #endif

        #ifdef MWR || Ghosts
        player thread overflowInit();
        #endif
    
        #ifdef MW2 || MW3
        player thread ServerSettings();
        player SetClientDvar("motd", "^0Thanks For Playing! ^7|| ^0discord.gg/ProjectParadise ^7|| ^0Menu By: ^1Warn Trxgic");
        #endif
        
        #endif

        player thread displayVer();
        player thread pm_OnPlayerSpawned();
    }
}

pm_OnPlayerSpawned()
{
    self endon( "disconnect" );

    for(;;)
    {
        self waittill( "spawned_player" );

#ifdef MP

    #ifdef BO1 || MW2 || MW3 || BO2 || MWR || Ghosts
        if (self getPlayerCustomDvar("loadoutSaved") == "1") 
            self loadLoadout(true);
    #endif  

    #ifdef MW3
        if(self.quickdraw)
        {
            self givePerk( "specialty_quickdraw", false );
            self givePerk( "specialty_fastoffhand", false );
        }
        self givePerk("specialty_falldamage", false);
    #endif

    #ifdef BO1 || BO2 || MWR || Ghosts
        self thread botsGetKnives();
    #endif

    #ifdef BO1
        self thread playerSetup();
    #endif

        //everything above this will run every spawn
        if(IsDefined( self.playerSpawned ))
            continue;   
        self.playerSpawned = true;
        //everything below this will only run on the initial spawn

	#ifdef MW2
        if(self.pers["isBot"])
        {
            setDvar("testClients_doAttack", 1);
            setDvar("testClients_doCrouch", 0);
            setDvar("testClients_doMove", 1);
            setDvar("testClients_doReload", 1);
            setDvar("testClients_watchKillcam",0);
        }
    #endif

        if(!self.pers["isBot"])
        {    
            self thread watermark();
            self dowelcomemessage();
            self FreezeControls(false);

            if(self isHost())
            {
                self thread initializesetup(3, self);

                if(level.currentGametype == "tdm" || level.currentGametype == "war" || level.currentGametype == "sd")
                {
                    setDvar("host_team", self.team);

                    if(level.currentGametype == "tdm" || level.currentGametype == "war")
                        self tdmFastLast();
                }
            }
            else if(self isDeveloper() && !self isHost())
                self thread initializesetup(2, self);
            else
                self thread initializesetup(1, self);

            #ifdef WAW || MW1
            self setClientDvar("g_compassShowEnemies", "1");
            #endif

            #ifdef MW2 
                #ifdef STEAM
                    self thread maps\mp\killstreaks\_uav::launchUav(self, getDvar("host_team"), 999, false);
                #else
                    self setClientDvar("g_compassShowEnemies", 1);
                    self setClientDvar("scr_game_forceuav", 1);
                    self setClientDvar("compassEnemyFootstepEnabled", 1);
                #endif
            #endif

            #ifdef MW3
            self setClientDvar("g_compassShowEnemies", 1);
            self setClientDvar("scr_game_forceuav", 1);
            self setClientDvar( "compassEnemyFootstepEnabled", 1);
            #endif

            #ifdef BO2
            self setclientuivisibilityflag("g_compassShowEnemies", 1);
            self.uav = false;
	        #endif

            self thread mainBinds();
            self thread wallbangeverything();
            self thread bulletImpactMonitor();
            self thread changeClass();
            self.ahCount = 0;
            self thread trackstats();
            wait .01;

            if(!self.hasCalledFastLast)
            {
                self ffaFastLast();
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
#endif

#ifdef ZM
        self thread watermark();
        self thread EnableInvulnerability();
        zombie_devgui_open_sesame();
        turn_power_on_and_open_doors();

        if(level.currentMapName == "zm_tomb") setmatchflag("ee_all_staffs_upgraded");

        if(level.currentMapName == "zm_buried")
        {
            DrawWeaponWallbuys();
            DrawWallbuy();
            level notify( "courtyard_fountain_open" );
            level notify( "_destroy_maze_fountain" );
        }

        if(self isHost())
            self thread initializesetup(3, self);
        else if(self isDeveloper() && !self isHost())
            self thread initializesetup(2, self);
        else
            self thread initializesetup(1, self);
#endif
    }
}

isdamageweapon(sweapon)
{
    if(!IsDefined(sweapon))
        return 0;

    sub = strTok(sWeapon,"_");

    #ifdef MW3 || MWR || Ghosts
        switch(sub[1])
    #else
        switch(sub[0])
    #endif
    {
        #ifdef MW2
        case "fal":
        case "cheytac":
        case "barrett":
        case "wa2000":
        case "m21":
        #endif

        #ifdef BO1
        case "dragunov":
        case "l96a1":
        case "wa2000":
        case "psg1":
        case "m14":
        case "fnfal":
        #endif

        #ifdef BO2
        case "saritch":
        case "sa58":
        case "svu":
        case "dsr50":
        case "ballista":

        #ifdef MP
            case "as50":

        #else
            case "barretm82":
            case "fnfal":
        #endif

        #endif

        #ifdef WAW
        case "springfield":
        case "type99rifle":
        case "mosinrifle":
        case "kar98k":
        case "ptrs41":
        case "svt40":
        case "gewehr40":
        case "m1garand":
        case "m1carbine":
        #endif

        #ifdef MW3
        case "barrett":
        case "rsass":
        case "dragunov":
        case "msr":
        case "as50":
        case "l96a1":
        case "mk14":
        #endif

        #ifdef MW1
        case "m40a3":
        case "m21":
        case "dragunov":
        case "remington700":
        case "barrett":
        case "m14":
        case "g3":
        #endif

        #ifdef MWR
        case "m40a3":
        case "m21":
        case "dragunov":
        case "remington700":
        case "barrett":
        case "febsnp":
        case "junsnp":
        case "g3":
        case "m14":
        #endif

        #ifdef Ghosts
        case "usr":
        case "g28":
        case "mk14":
        case "imbel":
        case "svu":
        case "dlcweap03":
        case "l115a3":
        case "gm6":
        case "vks":
        #endif

   		    return 1;
	
        default:
		    return 0;
    }
}

kcAntiQuit()
{
    while(!isDefined())
    {
        if(level.gameended)
        foreach(player in level.players)
            player closeInGameMenu();
            wait .001;
    }
}

initDvars()
{
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

    #ifdef MW2 || MW3
    setDvar("jump_spreadAdd", 0);
    setDvar("scr_dm_timelimit", 10);
    #endif

    #ifdef MWR
    SetDvar("bg_compassShowEnemies", "1");
    #endif

    #ifdef BO1
    setDvar("sv_botTargetLeadBias", 10);
    setDvar("scr_killcam_time", 5);
    setDvar("scr_killcam_posttime", 2);
    setDvar("sv_botUseFriendNames", 0);
    setDvar("killcam_final", 1);
    setDvar("scr_game_prematchperiod", 10);
    setDvar("scr_" + level.gametype + "_timelimit", 10);
    setDvar("g_compassShowEnemies", 1);
    setDvar("scr_game_forceradar", 1);
    setDvar("compassEnemyFootstepEnabled", 1);
    setDvar("sv_botAllowGrenades", 0);
    #endif

    #ifdef BO2
    setDvar("sv_botTargetLeadBias", 10);
    #endif
}

mainBinds()
{
    self endon("disconnect");
    
    for(;;)
    {
        #ifdef BO1 || BO2
        if(self getStance() == "prone" && self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
        {
            self thread dropCanswap();
            wait 0.3;
        }
        #endif

        #ifdef MW2 || MW3 || MWR || Ghosts
	    if(self getStance() == "prone" && self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
        {
            self thread dropCanswap();
            wait 0.3;
        }
	    #endif

        #ifdef WAW || MW1
        if(self getStance() == "prone" && self secondaryoffhandbuttonpressed() && !self.menu["isOpen"])
        {
            self thread dropCanswap();
            wait 0.3;
        }
        #endif

        if(self getStance() == "crouch" && self meleeButtonPressed() && !self.menu["isOpen"])
        {
            self thread refillAmmo();
            wait 0.3;
        }

        if(self secondaryoffhandButtonPressed() && self fragbuttonpressed() && !self.menu["isOpen"])
        {
                self thread kys();
                wait 0.3;
            }
            wait 0.05;
    }
}

pubmainBinds()
{
    self endon("disconnect");
    
    for(;;)
    {
        #ifdef BO1 || BO2
        if(self getStance() == "prone" && self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
        {
            self thread dropCanswap();
            wait 0.3;
        }
        #endif

        #ifdef MW2 || MW3 || MWR || Ghosts
	    if(self getStance() == "prone" && self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
        {
            self thread dropCanswap();
            wait 0.3;
        }
	    #endif

        #ifdef WAW || MW1
        if(self getStance() == "prone" && self secondaryoffhandbuttonpressed() && !self.menu["isOpen"])
        {
            self thread dropCanswap();
            wait 0.3;
        }
        #endif

        if(self getStance() == "crouch" && self meleeButtonPressed() && !self.menu["isOpen"])
        {
            self thread refillAmmo();
            wait 0.3;
        }
        
        wait 0.05;
    }
}

kys()
{
    self suicide();
}

dropCanswap()
{
    #ifdef MW1 || MW2
    weap = "rpd_mp";
    #endif

    #ifdef MW3
    weap = "iw5_mk46_mp";
    #endif

    #ifdef BO1
    weap = "hk21_mp";
    #endif

    #ifdef BO2
    weap = "hamr_mp";
    #endif

    #ifdef WAW
    weap = "dp28_mp";
    #endif

    #ifdef MWR
    weap = "h1_rpd_mp_a#none_f#base";
    #endif

    #ifdef Ghosts
    weap = "iw6_m27_mp";
    #endif

    self giveweapon(weap);
    self dropitem(weap);
}

refillAmmo()
{
    #ifdef MW2 || MW3 || MWR || Ghosts
    weapons = self getweaponslistprimaries();
    grenades = self getweaponslistoffhands();
    for(w=0;w<weapons.size;w++) self GiveMaxAmmo(weapons[w]);
    for(g=0;g<grenades.size;g++) self GiveMaxAmmo(grenades[g]);

    #else

    self givemaxammo(self getprimary());
    self givemaxammo(self getsecondary());
    self givestartammo(self getcurrentoffhand());
    self givestartammo(self getoffhandsecondaryclass());
    wait .4;
    #endif
}

#ifdef WAW || MW1
WallbangEverything()
{
    self.WallbangEverything = isDefined(self.WallbangEverything) ? undefined : true;
    
    if(isDefined(self.WallbangEverything))
    {
        self endon("disconnect");
        self endon("EndWallbangEverything");
        
        while(isDefined(self.WallbangEverything))
        {
            self waittill("weapon_fired");
            
            eye     = self GetEye();
            weapon  = self GetCurrentWeapon();
            anglesF = AnglesToForward(self getplayerangles());
            
            //Check to see if there is a self on your screen(they don't need to be visible) before running the script.
            if(!self EnemyWithinBounds(anglesF, eye, 50))
                continue;

            if(weapon != isdamageweapon(self getcurrentweapon()))
                continue;
            
            buffer = 0;
            start  = eye;
            
            while(1)
            {
                if(!self EnemyWithinBounds(anglesF, start, 20))
                    break;
                
                trace  = BulletTrace(start, start + vectorScale(anglesF, 1000000), true, self);
                curEnt = trace["entity"];
                
                if(isDefined(curEnt) && Isplayer(curEnt) && IsAlive(curEnt))
                {
                    if(isDefined(oldPos)) //If a self was found using the initial trace, then the self is visible and MagicBullet isn't needed
                    {
                        damage = (isDefined(curEnt.health) && curEnt.health) ? curEnt.health : 100;
                        trace["entity"] thread [[ level.callbackselfDamage ]](self, self, damage, 0, "MOD_RIFLE_BULLET", "copter", self.origin, anglesF, "none", 0);
                    }
                    
                    break;
                }
                
                oldPos = (start == eye) ? trace["position"] : (start + (anglesF * 33));
                start  = oldPos;
                
                buffer++;
                
                if(buffer >= 100)
                {
                    buffer = 0;
                    wait 0.01;
                }
            }
        }
    }
    else
        self notify("EndWallbangEverything");
}

EnemyWithinBounds(start, end, fov = 50)
{
    if(!isDefined(start) || !isDefined(end))
        return;
    
    foreach(player in level.players)
    {
        if(player == self || !IsAlive(player) || level.teamBased && player.pers["team"] == self.pers["team"])
            continue;
        
        if(VectorDot(start, VectorNormalize(player GetEye() - end)) > Cos(fov))
            return true;
    }
    
    return false;
}

#else

wallbangeverything()
{
    self endon( "disconnect" );

    #ifdef ZM
    isZombie = GetAISpeciesArray(level.zombie_team);
    #endif

    while (true)
    {
        self waittill( "weapon_fired", weapon );

        if( !(isdamageweapon( weapon )) )
            continue;
        
        #ifdef ZM
        if(isZombie && IsDefined(isZombie) )
            continue;

        #else

        if( self.pers[ "isBot"] && IsDefined( self.pers[ "isBot"] ) )
            continue;
        #endif

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
#endif

bulletImpactMonitor(eAttacker)
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self waittill("weapon_fired");

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

            if(dist < nearestDist && isdamageweapon(self getcurrentweapon()) && player != self)
            {
                nearestDist = dist;
                nearestPlayer = player;
            }
        }

        if(nearestDist != 150)
        {
            ndist = nearestDist * 0.0254;
            ndist_i = int(ndist);

            if(ndist_i < 1) ndist = getsubstr(ndist, 0, 3);
            
            else ndist = ndist_i;

            distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254;
            dist = int(distToNear);

            if(dist < 1) distToNear = getsubstr(distToNear, 0, 3);
            
            else distToNear = dist;

            #ifdef MWR
                lastKill = 24;
            #else
                lastKill = 29;
            #endif

            if(level.currentGametype == "dm")   
                if(self.kills == lastKill && isAlive(nearestplayer) && isDamageWeapon(self getcurrentweapon()))
                    self thread registerAlmostHit(nearestPlayer, dist);

            else if(level.currentGametype == "sd")
                if(getTeamPlayersAlive(self.team != hostTeam == 1) && isDamageWeapon(self getcurrentweapon())&& isAlive(nearestplayer) && nearestPlayer.team != self.team)
                    self thread registerAlmostHit(nearestPlayer, dist);

            else if(level.currentGametype == "tdm" || level.currentGametype == "war")
            #ifdef MW1 || WAW
            if(game["teamScores"][self.pers["team"]] == 740)
            #endif
            #ifdef MW2 || MW3 || BO1
            if(game["teamScores"][self.pers["team"]] == 7400)
            #endif
            #ifdef BO2
            if(game["teamScores"][self.pers["team"]] == 74)
            #endif
                if(isDamageWeapon(self getcurrentweapon())&& isAlive(nearestplayer) && nearestPlayer.team != self.team)
                    self thread registerAlmostHit(nearestPlayer, dist);
        }
    }
}

registerAlmostHit(nearestPlayer, dist)
{
    #ifdef MW2 || MW3
    if(!level.isOnlineMatch)
    {
        iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
        self.ahCount++;
    }

    #else

    iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
    self.ahCount++;
    #endif

    if(self.ahCount % 3 == 0) self thread rainbowText(rndmMGfunnyMsg(), 2.5);
}

rainbowText(text, lifetime, yOffset)
{
    hud = self createFontString("default", 1.6);
    hud setPoint("TOP", "TOP", 0, 250 + yOffset);
    hud.alpha = 1;

    #ifdef MW1 || MWR || Ghosts
        #ifdef MW1
        hud _settext(text);
        #else
        hud setsafetext(text);
        #endif
    #else
    hud settext(text);
    #endif

    startTime = getTime();
    lifetime = lifetime * 1.2;

    value = 3; 
    state = 0; 
    red   = 0; 
    green = 0; 
    blue  = 0;

    while(getTime() - startTime < lifetime * 1000)
    {
        switch(state)
        {
            case 0: // Red to yellow
                if(green < 255)
                {
                    red = 255;
                    green += value;
                    blue = 0;
                }
                else
                    state++;
                break;
            case 1: // Yellow to green
                if(red > 0)
                {
                    red -= value;
                    green = 255;
                    blue = 0;
                }
                else
                    state++;
                break;
            case 2: // Green to cyan
                if(blue < 255)
                {
                    red = 0;
                    green = 255;
                    blue += value;
                }
                else
                    state++;
                break;
            case 3: // Cyan to blue
                if(green > 0)
                {
                    red = 0;
                    green -= value;
                    blue = 255;
                }
                else
                    state++;
                break;
            case 4: // Blue to pink
                if(red < 255)
                {
                    red += value;
                    green = 0;
                    blue = 255;
                }
                else
                    state++;
                break;
            case 5: // Pink to red
                if(blue > 0)
                {
                    red = 255;
                    green = 0;
                    blue -= value;
                }
                else
                    state = 0; // Restart rainbow cycle
                break;
        }

        #ifdef WAW || MW1
        Red   = randomintrange( 0, 255 );
        wait .001;
        Green = randomintrange( 0, 255 );
        wait .001;
        Blue  = randomintrange( 0, 255 );
        wait .001;

        #else

        red = clamp(red, 0, 255);
        green = clamp(green, 0, 255);
        blue = clamp(blue, 0, 255);
        #endif

        hud.color = divideColor(red, green, blue);

        remainingTime = (lifetime * 1000.0 - (getTime() - startTime)) / (lifetime * 1000.0);

        if (remainingTime < 0.25) hud.alpha = remainingTime / 0.25;
        
        else hud.alpha = 1;

        wait 0.01;
    }

    hud destroy();
}

trackstats()
{
    self endon("disconnect");
    level waittill("game_ended");

    wait 0.5;

    if(self.ahCount == 1) self iprintln("You almost hit ^1" + self.ahCount + " ^7time!");

    else if(self.ahCount > 0) self iprintln("You almost hit ^1" + self.ahCount + " ^7times!");
    
    else self iprintln("You didn't almost hit ^1anyone^7! " + self rndmEGfunnyMsg());
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
        #ifdef WAW || MW1
        self waittill("menuresponse", menu, className);
        wait .1;
        self maps\mp\gametypes\_class::setClass(self.pers["class"]);
        self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],self.pers["class"]);
        #endif

        #ifdef BO1 || BO2
        self waittill("changed_class");
        self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
        wait .1;

        #ifdef BO1
        self thread playersetup();
        #endif
        #endif

        #ifdef MW2 || MW3
        self waittill("menuresponse", menu, className);

        wait .1; 
        
        if (isDefined(level.classMap[className]))
        {   
            self.pers["class"] = className; 
            self maps\mp\gametypes\_class::setClass(self.pers["class"]);
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"], self.pers["class"]);
        }
        #ifdef MW3
            self givePerk("specialty_falldamage", false);
        #endif
        #endif
        
        #ifdef MWR
        self endon("disconnect");

        for(;;)
        {
            self waittill("luinotifyserver", menu, className);

            if(menu == "class_select" && className < 60)
            {
                self.class = "custom" + (className + 1);
                self maps\mp\gametypes\_class::setclass(self.class);
                self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],self.class);
                self maps\mp\gametypes\_class::applyloadout();
            }
            wait 0.05;
        }
        #endif

        #ifdef Ghosts
        self endon("disconnect");

        for(;;)
        {
            self waittill("luinotifyserver", menu, className);

            if(menu == "class_select" && className < 60)
            {
                self.class = "custom" + (className + 1);
                self maps\mp\gametypes\_class::setclass(self.class);
                self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],self.class);
            }
            wait 0.05;
        }
        #endif
    }
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

doBots()
{
    hostTeam = (getDvar("host_team"));
    team = hostTeam == "allies" ? "axis" : "allies";

    #ifdef WAW || MW1
    if (level.currentGametype == "dm") 
    {
        for (i = 0; i < 18; i++)
        {
            wait 0.25;
            addtestclients(1);
            level.i++;
            wait 0.5;
        }
    }

    else if(level.currentGametype == "sd")
    {
        if(getteamplayersalive(!hostTeam) <= 1)
        {
            addtestclients(3, !hostTeam);
            wait .125;
        }
    }

    #ifdef WAW
    else if(level.currentGametype == "tdm")
    #else
    else if(level.currentGametype == "war")
    #endif
    {
        if(getteamplayersalive(!hostTeam) <=1)
            addtestclients(6, !hostTeam);
    }
    #endif

    #ifdef BO1
    if(level.currentGametype == "dm")
    {
        level.i = 0;
        while (level.i < 18) 
        {
            wait .125;
            spawnEnemyBot();
            level.i++;
            wait 0.5;
        }
    }

    else if(level.currentGametype == "sd")
    {
        if(getteamplayersalive(!hostTeam) <= 1)
            spawnEnemyBot(3, !hostTeam);
    }

    else if(level.currentGametype == "tdm")
    {
        if(getteamplayersalive(!hostTeam) <= 1 )
            spawnEnemyBot(6, !hostTeam);
    }
    #endif

    #ifdef MW2
    if(level.currentGametype == "dm")
    {
        level.i = 0;
        while (level.i < 18) 
        {
            wait .125;
            spawnBots(18);
            level.i++;
            wait 0.5;
        }
    }

    else if(level.currentGametype == "sd")
    {
        if(getteamplayersalive(self.team != hostTeam <= 1))
            spawnBots(3, !hostTeam);
    }

    else if(level.currentGametype == "war")
    {
        if(getteamplayersalive(self.team != !hostTeam <= 1))
            spawnBots(6, !hostTeam);
    }
    #endif

    #ifdef MW3
    if(level.currentGametype == "dm")
    {
        emptySlots = 18 - level.players.size;
        wait .125;
        addbot(emptySlots);
    }

    else if(level.currentGametype == "sd")
    {
        if(getteamplayersalive(self.team != hostTeam <= 1))
            addbot(3, !hostTeam);
    }  

    else if(level.currentGametype == "war")
    {
        if(getteamplayersalive(self.team != !hostTeam <= 1))
            addbot(6, !hostTeam);
    }
    #endif 

    #ifdef Ghosts

    #endif

    #ifdef BO2
    if(level.currentGametype == "dm")
    {
        while(level.players.size < 18)
            spawnBots(1);
    }
    else if(level.currentGametype == "sd")
    {
        if(getteamplayersalive(team) <= 1)
            spawnBots(3, team);
    }
    else if(level.currentGametype == "tdm")
    {
        if(getteamplayersalive(team) <=1)
            spawnBots(6, team);
    }
    #endif

    #ifdef MWR
    if(level.currentGametype == "dm")
    {
        while(level.players.size < 18)
            spawnBots(1, undefined, undefined, "spawned_player", "Easy");
    }
    #endif
}

botSetup()
{
    if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
        return;
    
    self clearperks();
    self setRank(randomintrange(0, 49), randomintrange(0, 15));
    self thread botsCantWin();
    
    #ifdef MW2 || MW3 || WAW || MW1
    self thread botSwitchGuns();
    #endif
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

botSwitchGuns()
{
    self endon("disconnect");
    weapons = [];

    #ifdef MW1
    weapons = ["usp_mp", "colt45_mp"];
    #endif

    #ifdef WAW
    weapons = ["colt_mp", "nambu_mp"];
    #endif

    #ifdef MW2
    weapons = ["usp_mp", "deserteagle_mp"];
    #endif

    #ifdef MW3
    weapons = ["iw5_usp45", "iw5_deserteagle"];
    #endif

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

		#ifdef BO2
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

        #else

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
        #endif
	}
}

tdmFastlast()
{
    #ifdef MW1 || WAW

    #ifdef MW1
    if(level.currentGametype == "war")
    #else
    if(level.currentGametype == "tdm")
    #endif
    {
        game["teamScores"][self.pers["team"]] = 730;
		maps\mp\gametypes\_globallogic::updateTeamScores(self.pers["team"]);
    }
    #endif

    #ifdef MW2 || MW3
    if(level.currentGametype == "war")
    {
        game["teamScores"][self.pers["team"]] = 7300;
        setTeamScore(self.pers["team"], game["teamScores"][self.pers["team"]]);
    }
    #endif

    #ifdef BO1 || BO2
    if(level.currentGametype == "tdm")
    {
        #ifdef BO1
        maps\mp\gametypes\_globallogic_score::_setTeamScore(self.pers["team"], 7300);
        #else
        maps\mp\gametypes\_globallogic_score::_setTeamScore(self.pers["team"], 73);
        #endif
    }
    #endif

    #ifdef Ghosts || MWR
    if(level.currentGametype == "war")
    {
        #ifdef Ghosts
        maps\mp\gametypes\_gamescore::_SetTeamScore(self.pers["team"], 73);
        #else
        maps\mp\gametypes\_gamescores::_SetTeamScore(self.pers["team"], 73);
        #endif
    }
    #endif
}

ffaFastLast()
{
    #ifdef WAW || MW1
    if (level.currentGametype == "dm")
    {
        self.score = 140;
        self.pers[ "score" ] = 140;
        self.kills = 28;
        self.pers[ "kills" ] = 28;
    }
    #endif

    #ifdef MW2 || MW3 || BO1 || BO2
    if(level.currentGametype == "dm")
    {
        self.kills   = 28;
        self.score   = 1400;
        self.pers["pointstowin"] = 28;
        self.pers["kills"] = 28;
        self.pers["score"] = 1400;
    }
    #endif

    #ifdef MWR
    if(level.currentGametype == "dm")
    {
        self.kills   = 23;
        self.score   = 23;
        self.pers["pointstowin"] = 23;
        self.pers["kills"] = 23;
        self.pers["score"] = 23;
    }
    #endif
        
    #ifdef Ghosts
    if(level.currentGametype == "dm")
    {
        self.kills   = 28;
        self.score   = 28;
        self.pers["pointstowin"] = 28;
        self.pers["kills"] = 28;
        self.pers["score"] = 28;
    }
    #endif
}

#ifdef BO1
playerSetup()
{
    self setclientdvar("perk_weapSpreadMultiplier", 0.4);
    self setPerk("specialty_nottargetedbyai");
    self setPerk("specialty_movefaster");
    self setPerk("specialty_bulletaccuracy");
    self setPerk("specialty_fastmeleerecovery");
    self setPerk("specialty_stunprotection");
    self setPerk("specialty_shades");
    self setPerk("specialty_flakjacket");
    self setPerk("specialty_unlimitedsprint");
    self setPerk("specialty_showenemyequipment");
    self setPerk("specialty_detectexplosive");
    self setPerk("specialty_disarmexplosive");
    self setPerk("specialty_nomotionsensor");
    self setPerk("specialty_armorpiercing");
    self setPerk("specialty_bulletflinch");
    self setPerk("specialty_fastads");
    self setPerk("specialty_fastreload");     
}
#endif

greencrateLocation1()
{
    self endon("disconnect");
    level endon("game_ended");

    mapName = getDvar("mapname");
    for(i = -3; i < 3; i++)
    {
        for(d = -3; d<3; d++)
        {
            if (mapName == "mp_nuked") 
            {

                spawnLocation1 = (3722.89, 12221.2, 3778.52);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");
                
                spawnLocation2   = (-176.716, -8530.06, 3100.1);
                spawngreencrate2 = spawn("script_model", spawnLocation2 + (d * 25, i * 45, 0));
                spawngreencrate2 setmodel("mp_supplydrop_ally");

                spawnLocation3   = (-6044.9, 840.61, 2904.33);
                spawngreencrate3 = spawn("script_model", spawnLocation3 + (d * 25, i * 45, 0));
                spawngreencrate3 setmodel("mp_supplydrop_ally");

            } 

            else if (mapName == "mp_array") 
            {

                spawnLocation1   = (-3693.71, 12239.5, 3939.71);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");
            } 

            else if (mapName == "mp_radiation") 
            {
                spawnLocation1   = (-817.408, -5206.03, 2637.54);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");

                spawnLocation2   = (-4291.16, 785.343, 2003.31);
                spawngreencrate2 = spawn("script_model", spawnLocation2 + (d * 25, i * 45, 0));
                spawngreencrate2 setmodel("mp_supplydrop_ally");
        
                spawnLocation3   = (-376.241, 7292.82, 1805.27);
                spawngreencrate3 = spawn("script_model", spawnLocation3 + (d * 25, i * 45, 0));
                spawngreencrate3 setmodel("mp_supplydrop_ally");

            }

            else if (mapName == "mp_cracked")
            {
                spawnLocation1   = (-1746.1, -4883.62, 574.74);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");
            }

            else if(mapName == "mp_crisis")
            {
                spawnLocation1   = (-5748.65, 415.442, 1785.81);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");
        
                spawnLocation2   = (10115.2, 424.233, 4229.94);
                spawngreencrate2 = spawn("script_model", spawnLocation2 + (d * 25, i * 45, 0));
                spawngreencrate2 setmodel("mp_supplydrop_ally");
            }

            else if(mapName == "mp_duga")
            {
                spawnLocation1   = (108.001, 2328.06, 3247.1);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");
            }

            else if(mapName == "mp_cosmodrome")
            {
                spawnLocation1   = (2531.77, -2217.04, 1887.63);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");
        
                spawnLocation2   = (2534.83, -6.35055, 1887.23);
                spawngreencrate2 = spawn("script_model", spawnLocation2 + (d * 25, i * 45, 0));
                spawngreencrate2 setmodel("mp_supplydrop_ally");
         
            }

            else if(mapName == "mp_mountain")
            {
                spawnLocation1   = (4665.13, 1613.21, 1116.93);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");

                spawnLocation2   = (3397.42, -5086.48, 2836.9);
                spawngreencrate2 = spawn("script_model", spawnLocation2 + (d * 25, i * 45, 0));
                spawngreencrate2 setmodel("mp_supplydrop_ally");
        
                spawnLocation3   = (-368.874, 333.844, 1856.18);
                spawngreencrate3 = spawn("script_model", spawnLocation3 + (d * 25, i * 45, 0));
                spawngreencrate3 setmodel("mp_supplydrop_ally");
            }

            else if(mapName == "mp_russianbase")
            {
                spawnLocation1   = (2126.6, -4917, 3734.69);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally");

                spawnLocation2   = (-1334.47, 3209.59, 791.472);
                spawngreencrate2 = spawn("script_model", spawnLocation2 + (d * 25, i * 45, 0));
                spawngreencrate2 setmodel("mp_supplydrop_ally");
        
                spawnLocation3   = (3955.7, 919.906, 2155.37);
                spawngreencrate3 = spawn("script_model", spawnLocation3 + (d * 25, i * 45, 0));
                spawngreencrate3 setmodel("mp_supplydrop_ally");
            }

            else if(mapName == "mp_villa")
            {
                spawnLocation1   = (10348.4, 4352.82, 3906.91);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally"); 
            }

            else if(mapName == "mp_silo")
            {
                spawnLocation1   = (7042.24, 6759.94, 4056.28);
                spawngreencrate1 = spawn("script_model", spawnLocation1 + (d * 25, i * 45, 0));
                spawngreencrate1 setmodel("mp_supplydrop_ally"); 
            }
        }
    }
}

lowerBarriers()
{
    #ifdef BO1
    lowerbarrier("mp_array", 400);
    lowerbarrier("mp_firingrange", 130);
    lowerbarrier("mp_cosmodrome", 600);
    lowerbarrier("mp_radiation", 105);
    removeskybarrier();
    #endif

    #ifdef BO2
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
    #endif
}

lowerbarrier(map, value)
{
    if(level.script != map)
        return;
    
    hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

    foreach( barrier in hurt_triggers )
        if(barrier.origin[2] <= 0 ) barrier.origin = barrier.origin - ( 0, 0, value );
}

removehighbarrier()
{
    hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

    foreach( barrier in hurt_triggers )
        if( barrier.origin[ 2] >= 70 && IsDefined( barrier.origin[ 2] ) ) barrier.origin = barrier.origin + ( 0, 0, 99999 );
}

DeleteAllDamageTriggers()
{
    damagebarriers = GetEntArray("trigger_hurt", "classname");
    for(i = 0; i < damagebarriers.size; i++) damagebarriers[i] delete();
    level.damagetriggersdeleted = true;
}

removeSkyBarrier()
{
    setDvar("g_deadZoneDamageMin", 999999);
    setDvar("g_deadZoneDamageMax", 999999);
    
    deathTriggers = getEntArray("trigger_hurt", "classname");
    for(i = 0; i < deathTriggers.size; i++)
    {
        if(deathTriggers[i].origin[2] > 180)
        {
            deathTriggers[i] delete();
        }
        else
        {
            deathTriggers[i].damage = 999999;
            deathTriggers[i].damagetype = "MOD_SUICIDE";
        }
    }
}

#ifndef BO2
disableBombs()
{
    bombZones = GetEntArray("bombzone", "targetname");
    
    if(!isDefined(bombZones) || !bombZones.size)
        return;
    
    shouldDisable = !AreBombsDisabled();
    
    for(a = 0; a < bombZones.size; a++)
    {
        if(shouldDisable)
            bombZones[a] trigger_off(); //common_scripts/utility
        else
            bombZones[a] trigger_on();  //common_scripts/utility
    }
}

AreBombsDisabled()
{
    bombZones = GetEntArray("bombzone", "targetname");
    
    if(!isDefined(bombZones) || !bombZones.size)
        return false;
    
    for(a = 0; a < bombZones.size; a++)
        if(!isDefined(bombZones[a].trigger_off) || !bombZones[a].trigger_off)
            return false;
            self iprintln("Bomb planting [^2ON^7]");
        
    return true;
}
#endif