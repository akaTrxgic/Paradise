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
#ifdef MW2 || MW3
    level.onlineGame = getDvarInt("onlinegame");
    level.rankedMatch = ( !level.onlineGame || !getDvarInt( "xblive_privatematch" ) );
#endif
    #ifdef MW2 || MW3
        if(level.rankedMatch)
        {
            level.isOnlineMatch = 1;
            level thread pubInit();
        }
        else if(!level.rankedMatch)
        {
            level.isOnlineMatch = 0;
            level thread pmInit();
        }
    #else
        level thread pmInit();
    #endif
#else
    level thread pmInit();
#endif
}

#ifdef MW2 || MW3
pubInit()
{
    level.callDamage           = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::pubmodifyPlayerDamage;
#ifdef MW2
    level.killstreaks = [ "uav", "airdrop", "counter_uav", "airdrop_sentry_minigun", "predator_missile", "precision_airstrike", "harrier_airstrike", "helicopter", "airdrop_mega", "helicopter_flares", "stealth_airstrike", "helicopter_minigun", "ac130", "emp" ];
    precacheshader("hudsoftline");
    precacheshader("rank_prestige8");
    precacheitem("lightstick_mp");
    precacheitem("deserteaglegolden_mp");
    precacheitem("throwingknife_rhand_mp");
#else
    level.killstreaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];
    precacheshader("hudsoftline");
    precacheshader("cardicon_prestige_classic9");
    precacheitem("at4_mp");
#endif

    level thread pubOnPlayerConnect();
}
#endif
pminit()
{
#ifdef MP
    level.callDamage           = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::modifyPlayerDamage;
    level.lastKill_minDist     = 15;
    level.oomUtilDisabled = 0;
    level.BotNameIndex = 0;
    initDvars();
#endif
#ifdef WAW  
    if(getDvar("mapname") == "mp_seelow")
        model = "dest_seelow_crate_long";
    else
        model = "static_peleliu_crate01";

    precachemodel(model);     
    precachemodel("collision_geo_32x32x32");
    precachemodel("collision_wall_128x128x10");
    precacheshader("hudsoftline");
    precacheshader("rank_prestige9");
    settimelimits();
#endif
#ifdef BO1
    precacheshader("hudsoftline");
    precacheshader("rank_prestige15");
    precachemodel("mp_supplydrop_ally");
    lowerBarriers();
    settimelimits();
    greencrateLocation1();
    level thread removeSkyBarrier();
#endif
#ifdef MW1 || MWR
    #ifdef MW1
    precacheshader("hudsoftline");
    #else
    level.BotNameIndex = 0;
    precacheshader("line_horizontal");
    #endif
    precacheshader("rank_prestige4");

#endif
#ifdef MW2
    level.killstreaks = [ "uav", "airdrop", "counter_uav", "airdrop_sentry_minigun", "predator_missile", "precision_airstrike", "harrier_airstrike", "helicopter", "airdrop_mega", "helicopter_flares", "stealth_airstrike", "helicopter_minigun", "ac130", "emp" ];
    level.airDropCrates         = GetEntArray("care_package","targetname");
    level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
    precacheshader("hudsoftline");
    precacheshader("rank_prestige8");
    precacheitem("lightstick_mp");
    precacheitem("deserteaglegolden_mp");
    precacheitem("throwingknife_rhand_mp");
    precachemodel("com_plasticcase_enemy");
    PMColour();
#endif
#ifdef MW3
    level.killstreaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];
    //level.airDropCrates         = GetEntArray("care_package","targetname");
    //level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
    precacheshader("hudsoftline");
    precacheshader("cardicon_prestige_classic9");
    precacheitem("at4_mp");
    precacheitem("lightstick_mp");
    precachemodel("com_plasticcase_enemy");
    level.BotNameIndex = 0;
#endif
#ifdef BO2
    #ifdef ZM
        precacheshader("line_horizontal");
        precacheshader("specialty_fastreload_zombies");
        precacheshader("white");
        /*
        level.actorDamage = level.callbackactordamage;
        level.callbackactordamage = ::modifyactordamage;
        level.actorkilled = level.callbackactorkilled;
        level.callbackactorkilled = ::modifyactorkilled;
        */
        level.disable_kill_thread = false;
        level.player_out_of_playable_area_monitor = false;	
	    level.player_too_many_weapons_monitor = false;
	    level.player_too_many_players_check = false;
	    level.player_too_many_players_check_func = ::player_too_many_players_check;
    #else
        precacheshader("line_horizontal");
        precacheshader("rank_prestige09");
        lower_barriers();
        removehighbarrier();
    #endif
#endif
#ifdef Ghosts
    precacheshader("rank_prestige10");
    precacheshader("hudsoftline");
    precachemodel("carepackage_friendly_iw6");
#endif
    level thread onPlayerConnect();
}
#ifdef MWR || Ghosts
overflowInit()
{
    if(!isDefined(level.anchorText))
	{
		level.stringCount = 0;
	    level.anchorText = createServerFontString("objective",1.5);
	    level.anchorText setText("anchor");
	    level.anchorText.alpha = 0;
	    level thread monitorOverflow();
	}
}
#endif

onPlayerConnect()
{
    for(;;)
    {
        level waittill( "connected", player );

        if(GetDvar("Paradise_"+ player GetXUID()) == "Banned")
            Kick(player GetEntityNumber());
#ifdef MP
        player thread initstrings(); 
        player thread MonitorButtons();
    #ifdef MWR || Ghosts
        player thread overflowInit();
    #endif
    #ifdef MW2 || MW3
        player thread ServerSettings();
        player SetClientDvar("motd", "^0Thanks For Playing! ^7|| ^0discord.gg/ProjectParadise ^7|| ^0Menu By: ^1Warn Trxgic^7, ^2tgh^7, ^7& ^3Optus IV^7");
    #endif
#endif
        player thread displayVer();
        player thread onPlayerSpawned();
    }
}
#ifdef MW2 || MW3
pubOnPlayerConnect()
{
    if(level.isOnlineMatch)
    {
    for(;;)
    {
        level waittill( "connected", player );

        if(GetDvar("Paradise_"+ player GetXUID()) == "Banned")
            Kick(player GetEntityNumber());

        if(level.currentGametype == "sd")
        {
            bombZones = GetEntArray("bombzone", "targetname");

            shouldDisable = !AreBombsDisabled();
    
            for(a = 0; a < bombZones.size; a++)
            {
                if(shouldDisable)
                    bombZones[a] trigger_off(); //common_scripts/utility
            }
        }
 
        player thread MonitorButtons();
        player thread isButtonPressed();  
        player thread ServerSettings();
        player thread kcAntiQuit();
        player thread pubOnPlayerSpawned();
    }
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
#endif

onPlayerSpawned()
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
        self thread bulletPhysics();
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

                if(level.currentGametype == "sd")
                    setDvar("host_team", self.team);
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
                self doFastLast();
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

#ifdef MW2 || MW3
pubOnPlayerSpawned()
{
    if(level.isOnlineMatch)
    {
    self endon( "disconnect" );

    for(;;)
    {
        self waittill( "spawned_player" );

        if (self getPlayerCustomDvar("loadoutSaved") == "1") 
            self loadLoadout(true); 

    #ifdef MW3
        if(self.quickdraw)
        {
            self givePerk( "specialty_quickdraw", false );
            self givePerk( "specialty_fastoffhand", false );
        }
        self givePerk("specialty_falldamage", false);
    #endif

        //everything above this will run every spawn
        if(IsDefined( self.playerSpawned ))
            continue;   
        self.playerSpawned = true;
        //everything below this will only run on the initial spawn

        if(self isHost())
        {
            self thread initializesetup(3, self);

            if(level.currentGametype == "sd")
                setDvar("host_team", self.team);
        }
        if(self.team == getDvar("host_team"))
        {
            self thread displayver();
            self thread watermark();
            self dowelcomemessage();
            self FreezeControls(false);

            if(self isdeveloper() && !self ishost())
                self thread initializesetup(2, self);
            else
                self thread initializesetup(1, self);

            self setClientDvar("scr_player_maxhealth", 125);
            self setClientDvar("g_compassShowEnemies", 1);
            self setClientDvar("scr_game_forceuav", 1);
            self setClientDvar("compassEnemyFootstepEnabled", 1); 
            self setClientDvar("player_sprintUnlimited" , 1 );
            self setClientDvar("jump_slowdownEnable", 0);
            self setClientDvar("bg_ladder_yawcap", 360 );
            self setClientDvar("bg_prone_yawcap", 360 );
            self setClientDvar("player_breath_gasp_lerp", 0 );
            self setClientDvar("player_clipSizeMultiplier", 1 );
            self setClientDvar("perk_weapSpreadMultiplier", 0.45);
            self setClientDvar("jump_spreadAdd", 0);
            self setClientDvar("aim_aimAssistRangeScale", 0);

            self thread pubMainBinds();
            //self thread wallbangeverything();
            self thread changeClass();
            wait .01;
        }
        else if(self.team != getDvar("host_team"))
        {
            self thread initializesetup(0, self);
            self setClientDvar( "scr_player_maxhealth", 50);
            self setClientDvar("g_compassShowEnemies", 0);
            self setClientDvar("scr_game_forceuav", 0);
            self setClientDvar("compassEnemyFootstepEnabled", 0); 
        }
    }
    }
}
///////////////////////////////////////////////////////////////////////
pubmodifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{        
    if(sMeansOfDeath == "MOD_FALLING")
        iDamage = 0;
            
    if(IsDamageWeapon(sWeapon))
        iDamage = 999;
            
    thread maps\mp\gametypes\_damage::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
    
    dist = GetDistance(self, eAttacker);
    
    if(self.team != getDvar("host_team"))
    {
        enemyCount = 0;
        foreach(player in level.players)
        {
            if(player != self && IsAlive(player))
                enemyCount++;
        }

        if(enemyCount == 1 && isDamageWeapon(sWeapon))
        {
            foreach(player in level.players)
            {
                 if(player.team == getDvar("host_team"))
                    player iprintln("^1" + dist + "m");
            }
        }
    }
}
#endif
#ifdef MP
modifyplayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
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
            else if(eAttacker.kills < lastKill)
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
	case "as50":
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

ServerSettings()
{
    #ifdef MW2        
        #ifdef XBOX
        //Bounces
        WriteShort(0x820D216C, 0x4800, 0x4198);       //Force Bounce(PM_ProjectVelocity)
        WriteInt(0x820DABE4, 0x48000018, 0x409AFFB0); //Bounces(PM_StepSlideMove)
        //Elevators
        WriteShort(0x820D8360, 0x4800);   //Elevators(PM_CorrectAllSolid)
        WriteInt(0x820D8310, 0x60000000); //PM_CorrectAllSolid(For Easy Elevators)
        //PM_CheckDuck(For Easy Elevators)
        addresses = [0x820D4E74, 0x820D4F34, 0x820D5020];
        for(a = 0; a < addresses.size; a++)
        WriteInt(addresses[a], 0x60000000);
        //BulletPenetration
        WriteFloat(0x82008898, 9999999.0);
        WriteInt(0x820E217C, 0x60000000); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820E218C)
        WriteInt(0x820E2184, 0xC02B8898); //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)
        //Range
        WriteInt(0x821CF3E4, 0xC3EB8898); //Bullet_Fire(lfs(load floating point single) from aF_0)
        WriteShort(0x821CF3C4, 0x4800);   //Bullet_Fire(beq(branch if equal) to loc_821CF3DC) -- Force branch to loc_821CF3DC(Allow all weapons to have max bullet range)
        WriteFloat(0x82008898, 9999999.0);
        //Prone Anywhere
        WriteByte(0x820D47CB, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
        WriteByte(0x820D47C3, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
        WriteShort(0x820CFBAC, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFC24)
        WriteInt(0x820CFC2C, 0x60000000); //BG_CheckProneValid(nop beq(branch if equal) to loc_820CFC3C)
        WriteShort(0x820CFC38, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFDD8)
        WriteByte(0x820CFDDB, 0x01);      //BG_CheckProneValid(li(load immedaite) 1 to register)
        #else
        //Bounces
        WriteByte(0x4736E3, 0x49, 0x14); //Bounces(PM_StepSlideMove)
        WriteByte(0x46BF64, 0xEB, 0x7B); //Force Bounce(PM_ProjectVelocity)
        //Elevators
        WriteByte(0x471329, 0xEB);    //Elevators(PM_CorrectAllSolid)
        WriteShort(0x4712D5, 0x9090); //PM_CorrectAllSolid(For Easy Elevators)        
        //PM_CheckDuck
        WriteShort(0x46E42D, 0x9090);
        WriteShort(0x46E4C8, 0x9090);
        WriteShort(0x46E582, 0x9090);
        //Bullet Penetration
        BG_GetSurfacePenetrationDepth = [0xD9, 0x05, 0xA8, 0x59, 0x68, 0x00, 0xC3];
        WriteBytes(0x4793EB, BG_GetSurfacePenetrationDepth); //BG_GetSurfacePenetrationDepth(fld(load floating point value) from flt_873B10)
        WriteShort(0x4793D6, 0x0375);                        //BG_GetSurfacePenetrationDepth(jnz(Jump short if not zero) to loc_4793DB)
        WriteFloat(0x6859A8, 9999999.0);
        //Range
        Bullet_Fire = [0xD9, 0x05, 0xA8, 0x59, 0x68, 0x00];
        WriteBytes(0x51B060, Bullet_Fire); //Bullet_Fire(fld(load floating point value) from flt_68F3F4)
        WriteByte(0x51B04A, 0x74);         //Bullet_Fire(jz(jump short if zero) to loc_51B060)
        WriteFloat(0x6859A8, 9999999.0);
        //Prone Anywhere
        WriteShort(0x46DE32, 0x2CEB);   //PlayerProneAllowed(patch in jump to loc_46DE60)
        WriteByte(0x46DE62, 0x01);      //PlayerProneAllowed(allows the function to return 1(when set to 0, it will never return 1))
        WriteInt(0x4698D6, 0x0009D0E9); //BG_CheckProneValid(force jump to loc_46A2AB)
        WriteInt(0x469838, 0x90909090); //BG_CheckProneValid(nop jnz(jump short if not zero) to loc_4698E0)
        WriteShort(0x46983C, 0x9090);   //BG_CheckProneValid(nop jnz(jump short if not zero) to loc_4698E0)
        #endif
    #endif
    #ifdef MW3
        #ifdef XBOX
        //Bounces
        WriteShort(0x820E2494, 0x4800, 0x4198);       //Force Bounce(PM_ProjectVelocity)
        WriteShort(0x820EB4D0, 0x4800, 0x419A);       //Force PM_ProjectVelocity(PM_StepSlideMove)
        WriteInt(0x820EB474, 0x48000018, 0x409AFFB0); //Bounces(PM_StepSlideMove)  
        //Elevators
        WriteShort(0x820E8A9C, 0x4800);   //Elevators(PM_JitterPoint)
        WriteInt(0x820E8A4C, 0x60000000); //PM_JitterPoint(For Easy Elevators)        
        //PM_CheckDuck(For Easy Elevators) - MW3 addresses
        addresses = [0x820E52CC, 0x820E5378, 0x820E5444];          
        for(a = 0; a < addresses.size; a++)
        WriteInt(addresses[a], 0x60000000);
        //Bullet Penetration
        WriteInt(0x820F6F80, 0x60000000); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820F6F98)
        WriteByte(0x820F6F8A, 0xAA);      //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)
        //Range
        WriteShort(0x8222BA94, 0x4800); //Bullet_Fire_Internal(Default -> 0x419A || Force Branch -> 0x4800) -- Force branch to make bullet range be the same for all weapon classes
        WriteByte(0x8222BAB3, 0x04);    //Bullet_Fire_Internal(patch in float -> 0x04 || default -> 0x01) -- Patch in new float to replace the default range(8192.0) with the new float(999900.0)
        WriteShort(0x8222BABA, 0xAD20); //Bullet_Fire_Internal(patch in float -> 0xAD20 || default -> 0x1B34) -- Finish patching in the new float   
        //Prone Anywhere
        WriteByte(0x820E4B43, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
        WriteByte(0x820E4B3B, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
        WriteShort(0x820DFB40, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFC24)
        WriteInt(0x820DFBC0, 0x60000000); //BG_CheckProneValid(nop beq(branch if equal) to loc_820CFC3C)
        WriteShort(0x820DFBCC, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFDD8)
        WriteByte(0x820DFD93, 0x01);      //BG_CheckProneValid(li(load immedaite) 1 to register)
        #else
        //Bounces
        WriteByte(0x424D57, 0x49, 0x14); //Bounces(PM_StepSlideMove)
        WriteByte(0x424DBF, 0xEB, 0x7B); //Force Branch To PM_ProjectVelocity(PM_StepSlideMove)
        WriteByte(0x41D17D, 0xEB, 0x7B); //Force Bounce(PM_ProjectVelocity)
        //Elevators
        WriteByte(0x4228C1, 0xEB);    //Elevators(PM_CorrectAllSolid)
        WriteShort(0x42286D, 0x9090); //PM_CorrectAllSolid(For Easy Elevators)
        //PM_CheckDuck
        WriteShort(0x41F849, 0x9090);
        WriteShort(0x41F8E5, 0x9090);
        WriteShort(0x41F9A2, 0x9090);
        //Bullet Penetration
        BG_GetSurfacePenetrationDepth = [0xD9, 0x05, 0x88, 0xF5, 0x7E, 0x00, 0x90];
        WriteBytes(0x42F55E, BG_GetSurfacePenetrationDepth); //BG_GetSurfacePenetrationDepth
        WriteShort(0x42F4DA, 0x07EB);                        //BG_GetSurfacePenetrationDepth
        //Range
        WriteByte(0x4F6C3A, 0xEB);       //Bullet_Fire_Internal
        WriteFloat(0x7F3344, 9999999.0); //Bullet_Fire_Internal
        #endif
    #endif
}


initDvars()
{
        setDvar("sv_cheats", 1);   
        setDvar("jump_slowdownEnable", 0);
        setdvar("bg_ladder_yawcap", 360 );
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
    #ifdef BO2
        if(self getStance() == "prone" && self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
        {
            self thread dropCanswap();
            wait 0.3;
        }
    #endif
    #ifdef BO1
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
    #ifdef WAW
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
	    if(self getStance() == "prone" && self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
        {
            self thread dropCanswap();
            wait 0.3;
        }
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
    weap = "";
    #endif
    #ifdef Ghosts
    weap = "test_mp";
    #endif
    self giveweapon(weap);
    self dropitem(weap);
}

refillAmmo()
{
    #ifdef MW2 || MW3 || MWR || Ghosts
    weapons = self getweaponslistprimaries();
    grenades = self getweaponslistoffhands();
    for(w=0;w<weapons.size;w++)
        self GiveMaxAmmo(weapons[w]);
    for(g=0;g<grenades.size;g++)
        self GiveMaxAmmo(grenades[g]);
    #else
    self givemaxammo(self getprimary());
    self givemaxammo(self getsecondary());
    self givestartammo(self getcurrentoffhand());
    self givestartammo(self getoffhandsecondaryclass());
    wait .4;
    #endif
}

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

            if(ndist_i < 1)
                ndist = getsubstr(ndist, 0, 3);
            else
                ndist = ndist_i;

            distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254;
            dist = int(distToNear);

            if(dist < 1)
                distToNear = getsubstr(distToNear, 0, 3);
            else
                distToNear = dist;

            #ifdef MWR
                lastKill = 24;
            #else
                lastKill = 29;
            #endif


                if(level.currentGametype == "dm")
                {     
                    if(self.kills == lastKill && isAlive(nearestplayer) && isDamageWeapon(self getcurrentweapon()))
                        self thread registerAlmostHit(nearestPlayer, dist);
                }
                else if(level.currentGametype == "sd")
                {
                    if(getTeamPlayersAlive(!hostTeam) == 1 && isDamageWeapon(self getcurrentweapon())&& isAlive(nearestplayer) && nearestPlayer.team != self.team)
                        self thread registerAlmostHit(nearestPlayer, dist);
                }
            
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
    else if(level.isOnlineMatch)
        self.ahCount++;
    #else
    iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
    self.ahCount++;
    #endif

    // EVERY 3 ALMOST HITS ? RAINBOW FUNNY MESSAGE
    if(self.ahCount % 3 == 0)
        self thread rainbowText(rndmMGfunnyMsg(), 2.5); // 2.5 SECONDS DISPLAY
}

rainbowText(text, lifetime, yOffset)
{
    hud = self createFontString("default", 1.6);
    hud setPoint("TOP", "TOP", 0, 250 + yOffset);
    hud.alpha = 1;
    #ifdef Ghosts
        hud setsafetext(text);
    #else
        hud settext(text);
    #endif
    startTime = getTime();
    lifetime = lifetime * 1.2;

    value = 3;
    state = 0;
    red = 0;
    green = 0;
    blue = 0;

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
        if (remainingTime < 0.25)
            hud.alpha = remainingTime / 0.25;
        else
            hud.alpha = 1;

        wait 0.01;
    }

    hud destroy();
}

trackstats()
{
    self endon("disconnect");
    level waittill("game_ended");

    wait 0.5;

    if(self.ahCount == 1)
        self iprintln("You almost hit ^1" + self.ahCount + " ^7time!");
    else if(self.ahCount > 0)
        self iprintln("You almost hit ^1" + self.ahCount + " ^7times!");
    else
        self iprintln("You didn't almost hit ^1anyone^7! " + self rndmEGfunnyMsg());
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

devConnected()
{
    foreach(player in level.players)
    {
        if(player getXUID() == player isdeveloper())
            thread maps\mp\gametypes\_hud_message::hintMessage("[^1Dev^7] ^2" + player.name + " ^7has joined the game!");
    }
}

getTeamCount(team) 
{
    count = 0;
    for(i=0; i < level.players.size; i++)
    {
        if(level.players[i].team == team) 
            count++;
    }
    return count;
}

botSetup()
{
    if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
        return;
    
    self clearperks();
    self setRank(randomintrange(0, 49), randomintrange(0, 15));
    self thread bots_cant_win();
    
#ifdef MW2 || MW3 || WAW
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
#ifdef WAW
    weapons = [ "colt_mp", "nambu_mp" ];
#endif
#ifdef MW2
    weapons = [ "usp_mp", "deserteagle_mp" ];
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

bots_cant_win()
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
            addtestclients(18);
            level.i++;
            wait 0.5;
        }
    }
    else if(level.currentGametype == "sd")
    {
        if(GetEnemyCountForTeam(!hostTeam) <= 1)
        {
            addtestclients(3, !hostTeam);
            wait .125;
        }
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
        if(getteamplayersalive(self.team != hostTeam) <= 1)
        {
            self spawnEnemyBot();
            wait 0.125;
            self spawnEnemyBot();
            wait 0.125;
            self spawnEnemyBot();
        }
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
        if(getteamcount(self.team != hostTeam <= 1))
            spawnBots(3, !hostTeam);
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
        if(GetEnemyCountForTeam(team) <= 1)
            spawnBots(3, team);
    }
#endif
#ifdef MWR
    if(level.currentGametype == "dm")
    {
        while(level.players.size < 18)
            spawn_bots_stub(1, undefined, undefined, "spawned_player", "Easy");
    }
    else if(level.currentGametype == "sd")
    {
        if(GetEnemyCountForTeam(team) <= 1)
            spawn_bots_stub(3, team, undefined, "spawned_player", "Easy");
    }
#endif
}

GetEnemyCountForTeam(team)
{
    enemyCount = 0;

    foreach(player in level.players)
    {
        if(player.team != team)
            continue;
        
        enemCount++;
    }

    return enemyCount;
}

doFastLast()
{
#ifdef WAW || MW1
    if (level.currentGametype == "dm")
        {
            self.score = 135;
            self.pers[ "score" ] = 135;
            self.kills = 27;
            self.deaths = 22;
            self.headshots = 7;
            self.pers[ "kills" ] = 27;
            self.pers[ "deaths" ] = 22;
            self.pers[ "headshots" ] = 7;
        }
#endif
#ifdef MW2 || MW3 || BO1 || BO2
        if(level.currentGametype == "dm")
        {
            self.kills   = 27;
            self.score   = 1350;
            self.deaths  = 13;
            self.assists = 2;
            self.pers["pointstowin"] = 27;
            self.pers["kills"] = 27;
            self.pers["score"] = 1350;
            self.pers["deaths"] = 13;
            self.pers["assists"] = 2;
        }
#endif
#ifdef MWR
        if(level.currentGametype == "dm")
        {
            self.kills   = 22;
            self.score   = 22;
            self.deaths  = 13;
            self.assists = 2;
            self.pers["pointstowin"] = 22;
            self.pers["kills"] = 22;
            self.pers["score"] = 22;
            self.pers["deaths"] = 13;
            self.pers["assists"] = 2;
        }
#endif
#ifdef Ghosts
        if(level.currentGametype == "dm")
        {
            self.kills   = 27;
            self.score   = 27;
            self.deaths  = 13;
            self.assists = 2;
            self.pers["pointstowin"] = 27;
            self.pers["kills"] = 27;
            self.pers["score"] = 27;
            self.pers["deaths"] = 13;
            self.pers["assists"] = 2;
        }
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

    while (true)
    {
        self waittill( "weapon_fired", weapon );

        if( !(isdamageweapon( weapon )) )
            continue;
        
        if( self.pers[ "isBot"] && IsDefined( self.pers[ "isBot"] ) )
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
#endif

lower_barriers()
{
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

    foreach( barrier in hurt_triggers )
    {
        if(barrier.origin[2] <= 0 )
        {
            barrier.origin = barrier.origin - ( 0, 0, value );
        }
    }
}

removehighbarrier()
{
    hurt_triggers = GetEntArray( "trigger_hurt", "classname" );

    foreach( barrier in hurt_triggers )
    {
        if( barrier.origin[ 2] >= 70 && IsDefined( barrier.origin[ 2] ) )
        {
            barrier.origin = barrier.origin + ( 0, 0, 99999 );
        }
    }
}
DeleteAllDamageTriggers()
{
    damagebarriers = GetEntArray("trigger_hurt", "classname");
    for(i = 0; i < damagebarriers.size; i++) damagebarriers[i] delete();
    level.damagetriggersdeleted = true;
}
#ifdef BO1
playerSetup()
{
    if(!self.pers["isBot"])
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
}

bulletPhysics()
{
    self endon("game_ended");
    self endon( "disconnect" );
    
    self.radiusaimbot = 1;
    self.aimbotRadius = 75;

    while(1)
    {   
        self waittill( "weapon_fired" );

        forward      = self getTagOrigin("j_head");
        end          = self thread vector_scale(anglestoforward(self getPlayerAngles()), 100000);
        bulletImpact = BulletTrace( forward, end, 0, self )[ "position" ];

        for(i=0;i<level.players.size;i++)
        {
            if(isDamageWeapon(self getcurrentweapon()) && self != player)
            {
                player       = level.players[i];
                playerorigin = player getorigin();
                if(level.teamBased && self.pers["team"] == level.players[i].pers["team"] && level.players[i] && level.players[i] == self)
                    continue;
 
                if(distance(bulletImpact, playerorigin) < self.aimbotRadius && isAlive(level.players[i]))
                {
                    if(isDefined(self.aimbotDelay))
                        wait (self.aimbotDelay);
                    level.players[i] thread [[level.callbackPlayerDamage]]( self, self, 110, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
                }
            }
        }
    wait .1;    
    }
}
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
    ents = getEntArray();

    heightAdjustment = -100; 

    currentMap = getDvar("mapname");

    if (currentMap == "mp_array") 
    {
        heightAdjustment = -300; 
    }
    else if (currentMap == "mp_firingrange") 
    {
        heightAdjustment = -30; 
    } 
    else if (currentMap == "mp_cosmodrome") 
    {
        heightAdjustment = -500; 
    } 
    else if (currentMap == "mp_radiation") 
    {
        heightAdjustment = -5; 
    }
    for(index = 0; index < ents.size; index++)
    {
        if(isSubStr(ents[index].classname, "trigger_hurt")) 
        {
            ents[index].origin = (ents[index].origin[0], ents[index].origin[1], ents[index].origin[2] + heightAdjustment);
        }
    }
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
#endif
#ifdef BO1 || WAW
settimelimits()
{
    if(level.currentGametype == "dm")
        setdvar("scr_dm_timelimit", 10);
        
    else if(level.currentGametype == "sd")
        setdvar("scr_sd_timelimit", 3);
}
#endif

PMColour() // Private Match
{
    if(!isConsole())
        return;

    #ifdef MW2
    WriteString( 0xA50D9218, "^0Project Paradise" );
    setRGB(0xA50D90AC, 1.0, 0.4, 0.8); // Private Match Text - pink
    setRGB(0xA50D9294, 0.9, 0.3, 0.9); // Recommend Players Colour - pinkish purple
    setRGB(0xA50D9920, 0.8, 0.2, 0.9); // Map Name Colour - soft pink-purple
    setRGB(0xA50DA9E4, 0.7, 0.1, 0.95); // Line 1 - pink-purple
    setRGB(0xA50DBB78, 0.6, 0.0, 1.0); // Line 2 - violet
    setRGB(0xA50DEDA8, 0.45, 0.1, 1.0); // Rank Colour - blue-purple
    setRGB(0xA50DF0CC, 0.3, 0.2, 1.0);  // Score Colour - blue
    setRGB(0xA50D878C, 0.2, 0.3, 1.0);  // PM Cloud Colour 1 - blue
    setRGB(0xA50D8964, 0.4, 0.4, 1.0);  // PM Cloud Colour 2 - bluish
    setRGB(0xA50D85C0, 0.6, 0.5, 1.0);  // PM Cloud Colour 3 - blue-pink blend
    setRGB(0xA50D8B34, 0.8, 0.6, 1.0);  // Mock Up Glow 1 - light purple
    setRGB(0xA50D8D0C, 0.9, 0.7, 1.0);  // Mock Up Glow 2 - soft pink-purple
    setRGB(0xA50D8EDC, 1.0, 0.8, 1.0);  // Left Side Colour - pale pink
    // setRGB(0xA50D9754, 1.0, 0.7, 1.0); // Map Background - magenta (uncomment for full gradient)
    setRGB(0xA50DC314, 0.9, 0.4, 1.0);  // Change Map Text - magenta end
    #endif
}
setRGB(addr, r, g, b)
{
    WriteFloat(addr,       r);
    WriteFloat(addr + 0x4, g);
    WriteFloat(addr + 0x8, b);
}
#endif
#ifdef ZM
player_too_many_players_check()
{
    //empty
}

zombie_devgui_open_sesame()
{
	setdvar( "zombie_unlock_all", 1 );
	common_scripts\utility::flag_set( "power_on" );
	players = maps\mp\_utility::get_players();
	common_scripts\utility::array_thread( players, maps\mp\zombies\_zm_devgui::zombie_devgui_give_money );
	zombie_doors = getentarray( "zombie_door", "targetname" );
	i = 0;
	while ( i < zombie_doors.size )
	{
		zombie_doors[ i ] notify( "trigger" );
		if ( is_true( zombie_doors[ i ].power_door_ignore_flag_wait ) )
		{
			zombie_doors[ i ] notify( "power_on" );
		}
		wait 0.05;
		i++;
	}
	zombie_airlock_doors = getentarray( "zombie_airlock_buy", "targetname" );
	i = 0;
	while ( i < zombie_airlock_doors.size )
	{
		zombie_airlock_doors[ i ] notify( "trigger" );
		wait 0.05;
		i++;
	}
	zombie_debris = getentarray( "zombie_debris", "targetname" );
	i = 0;
	while ( i < zombie_debris.size )
	{
		zombie_debris[ i ] notify( "trigger" );
		wait 0.05;
		i++;
	}
	zombie_devgui_build( undefined );
	level notify( "open_sesame" );
	wait 1;
	setdvar( "zombie_unlock_all", 0 );
}

zombie_devgui_build( buildable )
{

    player = common_scripts\utility::get_players()[ 0 ];
    i = 0;
    while ( i < level.buildable_stubs.size )
    {
        if ( !isDefined( buildable ) || level.buildable_stubs[ i ].equipname == buildable )
        {
            if ( isDefined( buildable ) || level.buildable_stubs[ i ].persistent != 3 )
            {
                level.buildable_stubs[ i ] maps\mp\zombies\_zm_buildables::buildablestub_finish_build( player );
            }
        }
        i++;
    }
}

isdamageweapon(sweapon)
{
    if(!IsDefined(sweapon))
        return 0;

    sub = strTok(sWeapon,"_");
    switch(sub[0])
    {
	case "saritch":
	case "sa58":
	case "svu":
	case "dsr50":
	case "ballista":
	case "barretm82":
    case "fnfal":
        return 1;
	default:
		return 0;
    }
}

wallbangeverything()
{
    self endon( "disconnect" );
    isZombie = GetAISpeciesArray(level.zombie_team);

    while (true)
    {
        self waittill( "weapon_fired", weapon );

        if( !(isdamageweapon( weapon )) )
            continue;
        
        if(isZombie && IsDefined(isZombie) )
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

turn_power_on_and_open_doors()
{
    level.local_doors_stay_open = 1;
    level.power_local_doors_globally = 1;
    flag_set( "power_on" );
    level setclientfield( "zombie_power_on", 1 );
    zombie_doors = getentarray( "zombie_door", "targetname" );
    _a144 = zombie_doors;
    _k144 = getFirstArrayKey( _a144 );
    while ( isDefined( _k144 ) )
    {
        door = _a144[ _k144 ];
        if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "electric_door" )
            door notify( "power_on" );
        
        else
        {
            if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
                door notify( "local_power_on" );
        }
        _k144 = getNextArrayKey( _a144, _k144 );
    }
}

DrawWeaponWallbuys()
{
    locations = ["bank", "bar", "church", "courthouse", "generalstore", "mansion", "morgue", "prison", "stables", "stablesroof", "toystore", "candyshop"];
    
    for(a = 0; a < level.buildable_wallbuy_weapons.size; a++)
    {
        locations = array_randomize(locations);
        
        DrawWallbuy(locations[0], level.buildable_wallbuy_weapons[a]);
        locations = ArrayRemove(locations, locations[0]);
        
        if(isDefined(level.chalk_pieces[a]))
            level.chalk_pieces[a] maps\mp\zombies\_zm_buildables::piece_unspawn();
    }
}

DrawWallbuy(location, weaponname)
{
    foreach(key in GetArrayKeys(level.chalk_builds))
    {
        stub    = level.chalk_builds[key];
        wallbuy = common_scripts\utility::GetStruct(stub.target, "targetname");
        
        if(isDefined(wallbuy.script_location) && wallbuy.script_location == location)
        {
            if(!isDefined(wallbuy.script_noteworthy) || IsSubStr(wallbuy.script_noteworthy, level.scr_zm_ui_gametype + "_" + level.scr_zm_map_start_location))
            {
                maps\mp\zombies\_zm_weapons::add_dynamic_wallbuy(weaponname, wallbuy.targetname, 1);
                thread wait_and_remove(stub, stub.buildablezone.pieces[0]);
            }
        }
    }
}

wait_and_remove(stub, piece)
{
    wait 0.1;
    self maps\mp\zombies\_zm_buildables::buildablestub_remove();
    thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
    piece maps\mp\zombies\_zm_buildables::piece_unspawn();
}

ArrayRemove(arr, value)
{
    if (!isDefined(arr) || !isDefined(value))
        return [];

    newArray = [];

    for (i = 0; i < arr.size; i++)
    {
        if (arr[i] != value)
            newArray[newArray.size] = arr[i];
    }

    return newArray;
}

modifyActorDamage(einflictor, attacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex)
{
	isZombie = GetAISpeciesArray(level.zombie_team);

	if(self == isZombie)
		attacker notify("damageFeedback", "whiteMarker", 1500);

	return [[level.actorDamage]](einflictor, attacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex);
}

modifyactorkilled(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime)
{
	if (maps\mp\gametypes_zm\_globallogic_utils::isheadshot(sweapon, shitloc, smeansofdeath, einflictor) && isplayer(attacker))
	{
		attacker playlocalsound("prj_bullet_impact_headshot_helmet_nodie_2d");
        attacker notify("damageFeedback", "redMarker", 1500);
		smeansofdeath = "MOD_HEAD_SHOT";
	}
    return [[level.actorkilled]](einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime);
}

damageFeedback()
{
	self notify("newFeedback");
	self endon("newFeedback");

	self.hitmarker destroy();
	self.hitmarker = newDamageIndicatorHudElem(self);
	self.hitmarker.horzAlign = "center";
	self.hitmarker.vertAlign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setShader("damage_feedback", 24, 48);
	self.hitsoundtracker = 1;

	while(1)
	{
		self waittill("damageFeedback", action, value);

		if(action == "whiteMarker")
			self whitemarker();
		
		if(action == "redMarker")
			self redmarker();
	}
}

redmarker(mod)
{
	self notify("red_override");
	self thread playhitsound(mod, "mpl_hit_alert");
	self.hitmarker.alpha = 1;
	self.hitmarker.color = (1,0,0);
	self.hitmarker fadeOverTime(.5);
	self.hitmarker.color = (1,1,1);
	self.hitmarker.alpha = 0;
}

whitemarker(mod)
{
	self endon("red_override");
	self thread playhitsound(mod, "mpl_hit_alert");
	self.hitmarker.alpha = 1;
	self.hitmarker fadeOverTime(.5);
	self.hitmarker.alpha = 0;
}

playhitsound(mod, alert)
{
	self endon("disconnect");
	if (self.hitsoundtracker)
	{
		self.hitsoundtracker = 0;
		self playlocalsound(alert);
		wait 0.05;
		self.hitsoundtracker = 1;
	}
}

#endif