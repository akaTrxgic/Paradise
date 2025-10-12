    #include maps\mp\_utility;
    #include common_scripts\utility;
    #include maps\mp\gametypes\_hud_util;
    #include maps\mp\gametypes\_hud_message;
    #include maps\mp\killstreaks\_killstreaks;

init()
{
    level.status = ["None","^2Verified","^5CoHost","^1Host"];
    level.MenuName = "Paradise";
    level.currentGametype      = getDvar("g_gametype");
    level.currentMapName       = getDvar("mapName");
    level.callDamage           = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::modifyPlayerDamage;
    precacheshader("ui_arrow_right");

#ifdef MW2
    level.killstreaks = [ "uav", "airdrop", "counter_uav", "airdrop_sentry_minigun", "predator_missile", "precision_airstrike", "harrier_airstrike", "helicopter", "airdrop_mega", "helicopter_flares", "stealth_airstrike", "helicopter_minigun", "ac130", "emp" ];
    precacheshader("hudsoftline");
    precacheshader("rank_prestige8");
    precacheitem("lightstick_mp");
    precacheitem("deserteaglegolden_mp");
    precacheitem("throwingknife_rhand_mp");
#endif
#ifdef MW3
    level.killstreaks = ["uav", "deployable_vest", "airdrop_assault", "counter_uav", "sentry", "predator_missile", "ac130", "emp"];
    precacheshader("hudsoftline");
    precacheshader("cardicon_prestige_classic9");
    precacheitem("at4_mp");
#endif
    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill( "connected", player );

        SetDvar("Paradise_" + player GetXUID(),"Banned");

        if(level.currentGametype == "sd")
            player thread disableBombs();

        player thread displayVer(); 
        player thread MonitorButtons();
        player thread isButtonPressed();  
        player thread ServerSettings();
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

        if (self getPlayerCustomDvar("loadoutSaved") == "1") 
            self loadLoadout(true); 

    #ifdef MW3
        if(self.quickdraw)
        {
            self givePerk( "specialty_quickdraw", false );
            self givePerk( "specialty_fastoffhand", false );
        }
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
                level.hostTeam = self.pers["team"];
        }
        if(level.hostTeam)
        {
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

            self thread mainBinds();
            self thread wallbangeverything();
            self thread bulletImpactMonitor();
            self thread changeClass();
            self.ahCount = 0;
            self thread trackstats();
            wait .01;
        }
        else if(!level.hostTeam)
        {
            self thread initializesetup(0, self);
            self setClientDvar( "scr_player_maxhealth", 80);
        }
    }
}
///////////////////////////////////////////////////////////////////////

modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{        
    if(sMeansOfDeath == "MOD_FALLING")
        iDamage = 0;
            
    if(IsDamageWeapon(sWeapon))
        iDamage = 999;
            
    thread maps\mp\gametypes\_damage::Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
    
    dist = GetDistance(self, eAttacker);
    
    if(!level.hostTeam)
    {
        enemyCount = 0;
        foreach(player in level.players)
        {
            if(player != self && IsAlive(player) && !level.hostTeam)
                enemyCount++;
        }

        if(enemyCount == 1 && isDamageWeapon(sWeapon))
        {
            foreach(player in level.players)
            {
                 if(level.hostTeam)
                    player iprintln("^1" + dist + "m");
            }
        }
    }
}

isdamageweapon(sweapon)
{
    if(!IsDefined(sweapon))
        return 0;

    sub = strTok(sWeapon,"_");
    #ifdef MW3
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
    #ifdef MW3
    case "barrett":
    case "rsass":
    case "dragunov":
    case "msr":
    case "as50":
    case "l96a1":
    case "mk14":
    #endif
   		return 1;
	default:
		return 0;
    }
}

ServerSettings()
{
    #ifdef MW2
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
    #endif
    #ifdef MW3
    //MW3 Bounces - Updated addresses
    WriteShort(0x820E2494, 0x4800);       //Force Bounce(PM_ProjectVelocity)
    WriteInt(0x820EB474, 0x48000018);     //Bounces(PM_StepSlideMove)
                
    //MW3 Easy Elevators
    WriteShort(0x820E8A9C, 0x4800);   //Elevators(PM_JitterPoint)
    WriteInt(0x820E8A4C, 0x60000000); //PM_JitterPoint(For Easy Elevators)
                
    //PM_CheckDuck(For Easy Elevators) - MW3 addresses
    addresses = [0x820E52CC, 0x820E5378, 0x820E5444];
                
    for(a = 0; a < addresses.size; a++)
    WriteInt(addresses[a], 0x60000000);

    //Bullet Penetration & Range
    WriteInt(0x820F6F80, 0x409A0018); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820F6F98)
    WriteByte(0x820F6F8A, 0x90);      //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)
        
    WriteShort(0x8222BA94, 0x4800); //Bullet_Fire_Internal(Default -> 0x419A || Force Branch -> 0x4800) -- Force branch to make bullet range be the same for all weapon classes
    WriteByte(0x8222BAB3, 0x04);    //Bullet_Fire_Internal(patch in float -> 0x04 || default -> 0x01) -- Patch in new float to replace the default range(8192.0) with the new float(999900.0)
    WriteShort(0x8222BABA, 0xAD20); //Bullet_Fire_Internal(patch in float -> 0xAD20 || default -> 0x1B34) -- Finish patching in the new float
            
    //PlayerProneAllowed
    WriteByte(0x820E4B43, 0x00); //PlayerProneAllowed(li(load immediate) 0 to register)
    WriteByte(0x820E4B3B, 0x01); //PlayerProneAllowed(li(load immediate) 1 to register)

    //BG_CheckProneValid
    WriteShort(0x820DFB40, 0x409A);   //BG_CheckProneValid(bne(branch if not equal) to loc_820CFC24)
    WriteInt(0x820DFBC0, 0x419A0010); //BG_CheckProneValid(beq(branch if equal) to loc_820CFC3C)
    WriteShort(0x820DFBCC, 0x419A);   //BG_CheckProneValid(beq(branch if equal) to loc_820CFDD8)
    WriteByte(0x820DFD93, 0x00);      //BG_CheckProneValid(li(load immedaite) 0 to register)
    #endif
}

mainBinds()
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

dropCanswap()
{
    #ifdef MW2
    weap = "rpd_mp";
    #endif
    #ifdef MW3
    weap = "iw5_mk46_mp";
    #endif
    self giveweapon(weap);
    self dropitem(weap);
}

refillAmmo()
{
    weapons = self getweaponslistprimaries();
    grenades = self getweaponslistoffhands();

    for(w=0;w<weapons.size;w++)
        self GiveMaxAmmo(weapons[w]);

    for(g=0;g<grenades.size;g++)
        self GiveMaxAmmo(grenades[g]);
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


            if(level.hostTeam)
            {
                if(level.currentGametype == "sd")
                {
                    if(getTeamPlayersAlive(enemyTeam) == 1 && isDamageWeapon(self getcurrentweapon())&& isAlive(nearestplayer) && nearestPlayer.team != self.team)
                        self thread registerAlmostHit(nearestPlayer, dist);
                }
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
        red = clamp(red, 0, 255);
        green = clamp(green, 0, 255);
        blue = clamp(blue, 0, 255);

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

changeClass()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("menuresponse", menu, className);

        wait .1; 
        
        if (isDefined(level.classMap[className]))
        {   
            self.pers["class"] = className; 
            self maps\mp\gametypes\_class::setClass(self.pers["class"]);
            self maps\mp\gametypes\_class::giveLoadout(self.pers["team"], self.pers["class"]);
        }
    }
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

disableBombs()
{
    bombZones = GetEntArray("bombzone", "targetname");
    
    if(!isDefined(bombZones) || !bombZones.size)
        return;
    
    shouldDisable = !AreBombsDisabled();
    
    for(a = 0; a < bombZones.size; a++)
    {
        if(shouldDisable)
        {
            bombZones[a] trigger_off(); //common_scripts/utility
        }
        /*
        else if()
        { 
            bombZones[a] trigger_on();  //common_scripts/utility
        }
        */
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
    
    return true;
} 
