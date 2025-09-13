    #include maps\mp\_utility;
    #include common_scripts\utility;
    #include maps\mp\gametypes\_hud_util;
#ifdef WAW
    #include maps\mp\gametypes\_globallogic_score;
#else
    #include maps\mp\gametypes\_hud_message;
    #include maps\mp\killstreaks\_killstreaks;
#endif
#ifdef BO1 || BO2
    #include maps\mp\gametypes\_globallogic;
#endif

init()
{
    level.status = ["None","^2Verified","^5CoHost","^1Host"];
    level.MenuName = "Paradise";
    level.currentGametype      = getDvar("g_gametype");
    level.currentMapName       = getDvar("mapName");
    level.callDamage           = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::modifyPlayerDamage;
    level.lastKill_minDist     = 15;
    init_Dvars();
    setDvar("host_team", self.team);
    precacheshader("ui_arrow_right");
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
#endif
#ifdef BO2
    precacheshader("line_horizontal");
    precacheshader("rank_prestige09");
    lower_barriers();
    removehighbarrier();
#endif
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill( "connected", player );

        SetDvar("Paradise_" + player GetXUID(),"Banned");
                
        player thread displayVer();
        player thread initstrings(); 
        player thread devConnected();
        player thread MonitorButtons();
#ifdef MW2
        player thread isButtonPressed();  
        player thread ServerSettings();
#endif
        player.ahCount = 0;
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon( "disconnect" );

    for(;;)
    {
        self waittill( "spawned_player" );
#ifndef WAW
        if (self getPlayerCustomDvar("loadoutSaved") == "1") 
            self loadLoadout(true);
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
	self setClientDvar( "cg_objectiveText", "[{+smoke}] + [{+frag}] = Suicide\nProne + [{+actionslot 3}] = Drop Canswap\nCrouch + [{+melee}] =  Refill Ammo" );
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

            if(self isHost())
            {
                self thread initializesetup(3, self); //Host

		        if(level.currentGametype == "sd")
                    setDvar("host_team", self.team);
            }
            else if(self isDeveloper() && !self isHost())
                self thread initializesetup(2, self); //CoHost
            else
                self thread initializesetup(1, self); //Verified

            self FreezeControls(false);
    #ifdef WAW
            self setClientDvar("g_compassShowEnemies", "1");
    #endif
	#ifdef MW2
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
    }
}
///////////////////////////////////////////////////////////////////////

modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex )
{
    dist = GetDistance(self, eAttacker);
    
    if(level.currentGametype == "dm")
    {
        // Handle melee attacks for verified players and bots
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(eAttacker.access > 0)
                iDamage = 0;
            else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] == true || eAttacker.access == 0)
                iDamage = 999;
        }
        // Handle sniper kills for players with less than 29 kills
        else if(eAttacker.kills < 29)
        {
            if(isDamageWeapon(sWeapon) == true)
                iDamage = 999;  
        }
        // Special handling for the 29th kill
        else if(eAttacker.kills == 29)
        {
            if(dist >= level.lastKill_minDist && eAttacker isOnGround() == false && isDamageWeapon(sWeapon))
            {
                iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                iDamage = 999;
            }
            else
            {
                if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                    iDamage = 0;
            }
        }
	#ifdef BO2
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && self.pers["isBot"] == false && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
            {
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
	#endif
    #ifdef BO1
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && self.pers["isBot"] == false && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
            {
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
	#endif
            // Apply the calculated damage
        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }
    else if(level.currentGametype == "sd")
    {
        // Handle melee attacks for verified players and bots
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(eAttacker.access > 0)
                iDamage = 0;
            else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] == true || eAttacker.access == 0)
                iDamage = 999;
        }
        hostTeam  = getdvar("host_team");
        enemyTeam = getOtherTeam(eAttacker.team);
        if(getTeamPlayersAlive(enemyTeam) > 1)
        {
            if(isDamageWeapon(sWeapon) == true)
                    iDamage = 999;
        }
        else if(getTeamPlayersAlive(enemyTeam) == 1)
        {
            if(dist >= level.lastKill_minDist && eAttacker isOnGround() == false && isDamageWeapon(sWeapon))
            {
                if(eAttacker.team == hostTeam && self.team != hostTeam)
                {
                    iDamage = 999;
                    for(i = 0; i < level.players.size; i++)
                    level.players[i] iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                }
            }
            else
            {
                if(sMeansOfDeath != "MOD_GRENADE_SPLASH")
                    eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                    iDamage = 0;
            }
        }
	#ifdef BO2
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && self.pers["isBot"] == false && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
            {
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
	#endif
    #ifdef BO1
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && self.pers["isBot"] == false && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
            {
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
	#endif
        
        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }
}
#ifndef WAW
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
    switch(sub[0])
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
   		return 1;
	default:
		return 0;
     }
}

ServerSettings()
{
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
}

init_Dvars()
{
    setDvar("sv_cheats", 1);   
    setDvar("jump_slowdownEnable", 0);
    setdvar("bulletrange", 9999);
    setdvar("bg_ladder_yawcap", 360 );
    setdvar("bg_prone_yawcap", 360 );
    setdvar("player_breath_gasp_lerp", 0 );
    setdvar("player_clipSizeMultiplier", 1 );
    setdvar("perk_bulletPenetrationMultiplier", 100 );
    setDvar("bg_surfacePenetration", 9999 );
    setDvar("bg_bulletRange", 99999 );
    setdvar("penetrationcount",100 );
    setdvar("perk_bulletpenetrationmultiplier",100 );
    setdvar("sv_superpenetrate", 1 );
#ifdef MW2
    setDvar("jump_spreadAdd", 0);
    setDvar("scr_dm_timelimit", 10);
    setDvar("aim_aimAssistRangeScale", 0);
#endif
#ifdef BO1
    setDvar("scr_killcam_time", 5);
    setDvar("scr_killcam_posttime", 2);
    setDvar("sv_botUseFriendNames", 0);
    setDvar("killcam_final", 1);
    setDvar("scr_game_prematchperiod", 10);
    setDvar("scr_" + level.gametype + "_timelimit", 10);
    setDvar("g_compassShowEnemies", 1);
    setDvar("scr_game_forceradar", 1);
    setDvar("compassEnemyFootstepEnabled", 1);
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
    #ifdef MW2
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
kys()
{
    self suicide();
}

dropCanswap()
{
    #ifdef MW2
    weap = "rpd_mp";
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
    self giveweapon(weap);
    self dropitem(weap);
}

refillAmmo()
{
    #ifdef MW2
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
        nearestDist = 250;

        enemyTeam = getOtherTeam(eAttacker.team);
        hostTeam = getdvar("host_team");
        teamScore = game["teamScores"][hostTeam];

        foreach(player in level.players)
        {
            dist = distance(player.origin, impact);

            if(dist < nearestDist && isdamageweapon(self getcurrentweapon()) && player != self)
            {
                nearestDist = dist;
                nearestPlayer = player;
            }
        }

        if(nearestDist != 250)
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

            if(level.currentGametype == "dm")
            {    
                if(self.kills == 29 && isDamageWeapon(self getcurrentweapon()) && isAlive(nearestplayer))
                    self thread registerAlmostHit(nearestPlayer, dist);
            }
            else if(level.currentGametype == "sd")
            {
                if(getTeamPlayersAlive(enemyTeam) == 1 && isDamageWeapon(self getcurrentweapon())&& isAlive(nearestplayer) && nearestPlayer.team != self.team)
                    self thread registerAlmostHit(nearestPlayer, dist);
            }
        }
    }
}
registerAlmostHit(nearestPlayer, dist)
{
    iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
    self.ahCount++;

    // EVERY 3 ALMOST HITS ? RAINBOW FUNNY MESSAGE
    if(self.ahCount % 3 == 0)
        self thread rainbowText(rndmMGfunnyMsg(), 2.5); // 2.5 SECONDS DISPLAY
}

rainbowText(text, lifetime, yOffset)
{
    // Create independent HUD element
    hud = self createFontString("default", 1.6);
    hud setPoint("TOP", "TOP", 0, 250 + yOffset); // Base offset increased to 120
    hud.alpha = 1;
    hud settext(text);

    startTime = getTime();
    lifetime = lifetime * 1.2; // Double lifetime for longer display (e.g., 5s -> 10s)

    // Initialize rainbow state

    value = 3; // Speed of color transitions
    state = 0;
    red = 0;
    green = 0;
    blue = 0;

    while(getTime() - startTime < lifetime * 1000)
    {
        // Smooth rainbow logic
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
    #ifndef WAW
        red = clamp(red, 0, 255);
        green = clamp(green, 0, 255);
        blue = clamp(blue, 0, 255);
    #else
        Red   = randomintrange( 0, 255 );
        wait .001;
        Green = randomintrange( 0, 255 );
        wait .001;
        Blue  = randomintrange( 0, 255 );
        wait .001;
    #endif

        hud.color = divideColor(red, green, blue);

        // Fade out in last 25% of lifetime
        remainingTime = (lifetime * 1000.0 - (getTime() - startTime)) / (lifetime * 1000.0);
        if (remainingTime < 0.25)
            hud.alpha = remainingTime / 0.25; // Fade out over last 25%
        else
            hud.alpha = 1; // Stay fully visible until then

        wait 0.01; // Tight loop for smooth updates
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

devConnected()
{
    xuid = self getXUID();
    name = self.name;

    alias = getDevAlias(xuid, name); // returns null if not special

    if(alias != undefined)
        self iprintln("[^1Dev^7] ^2" + alias + " ^7Joined");
    else
        self iprintln("[^1Dev^7] ^2" + name + " ^7Joined");
}

getDevAlias(xuid, name)
{
    // Name-based exceptions (optional)
    if(name == "tgh")       return "tgh";
    if(name == "Paradise")  return "Paradise";

    // XUID-based aliases
    switch(xuid)
    {
        case "000901F311AA2C6F": return "Warn Lew";
        case "000901FC5263B283": return "Warn Trxgic";
        case "000901F11B620319": return "Slixk Engine";
        case "000901FDAFBF287D": return "SlixkRGH";
        case "000901FCA48F2272": return "Optus IV";
        default: return undefined; // not special ? fall back to real name
    }
}

botSetup()
{
    if (!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
        return;
    
    self clearperks();
    self setRank(randomintrange(0, 49), randomintrange(0, 15));
    self thread bots_cant_win();
    self thread botSwitchGuns();
}

botSwitchGuns()
{
    self endon("disconnect");
#ifdef WAW
    weapons = [ "colt_mp", "nambu_mp" ];
#endif
#ifdef MW2
    weapons = [ "usp_mp", "deserteagle_mp" ];
#endif
#ifdef BO1
    weapons = [ "asp_mp", "makarov_mp" ];
#endif
#ifdef BO2
    weapons = [ "fiveseven_mp", "fnp45_mp" ];
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

	#ifdef MW2
	level.scorelimit = getDvar("scr_"+level.currentGametype+"_scorelimit");
	#endif

	for(;;)
	{
		wait 0.25;
		#ifdef BO2
		maps\mp\gametypes\_globallogic_score::_setplayermomentum( self, 0 );
		#endif
		if( self.pers[ "pointstowin"] >= level.scorelimit - 5 )
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

changeClass()
{
    self endon("disconnect");

    for(;;)
    {
#ifdef WAW
       self waittill("menuresponse",menu,className);
       wait .1;
       self maps\mp\gametypes\_class::setClass(self.pers["class"]);
       self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],self.pers["class"]);  
#endif
#ifdef BO1
        self waittill("changed_class");
        self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
        wait .1;
        self thread playersetup();
#endif
#ifdef MW2
        self waittill("menuresponse", menu, className);

        wait .1; 
        
        if (isDefined(level.classMap[className]))
        {   
            self.pers["class"] = className; 
            self maps\mp\gametypes\_class::setClass(self.pers["class"]);
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"], self.pers["class"]);
        }
#endif
#ifdef BO2
        self waittill("changed_class");
        self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
        wait .1;
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
#ifdef WAW
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
        if(getalivecountforteam(!hostTeam) <= 1)
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
        if(getteamplayersalive(self.team != getDvar("host_team")) <= 1)
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
        if(getteamplayersalive(self.team != hostTeam <= 1))
        {
            spawnBots(3, !hostTeam);
        }
    }
#endif
#ifdef BO2
    if(level.currentGametype == "dm")
    {
        while(level.players.size < 18)
            spawnBots(1);
    }
    else if(level.currentGametype == "sd")
    {
        if(GetAliveCountForTeam(team) <= 1)
            spawnBots(3, team);
    }
#endif
}

GetAliveCountForTeam(team)
{
    alive = 0;

    foreach(player in level.players)
    {
        if(!IsAlive(player) || player.team != team)
            continue;
        
        alive++;
    }

    return alive;
}

doFastLast()
{
#ifdef WAW
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
    }
#endif
#ifdef BO1
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
    }  
#endif
#ifdef MW2
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
}
#endif
#ifdef BO2
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
}
#endif

#ifdef WAW
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
#ifdef B
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
        setdvar("scr_dm_timelimit", 15);
        
    else if(level.currentGametype == "sd")
        setdvar("scr_sd_timelimit", 3);
}
#endif