 #include common_scripts\utility;
    #include maps\mp\_utility;
    #include maps\mp\gametypes\_hud_util;

    init()
    {
        level.strings  = [];
        level.status = [ "None","^2Verified","^3VIP","^5CoHost","^1Host" ];
		level.MenuName = "Paradise";
        precacheshader("hudsoftline");
        precacheshader("rank_prestige8");
        level.strings  = [];
        level thread mw2precache();
        level thread onPlayerConnect();
        level thread ServerSettings();
        level.currentGametype      = getDvar("g_gametype");
        level.currentMapName       = getDvar("mapName");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        self setorigin(self.spawn_origin);
        self.angles = self.spawn_angles;
        setDvar("host_team", self.team);
        init_Dvars();
        level thread onPlayerConnect();
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );
            player thread MonitorButtons();
            SetDvar("Paradise_" + player GetXUID(),"Banned");   
            player thread onPlayerSpawned();   
            player thread displayVer();
		    player thread initstrings();
            player thread devConnected();
            player thread isButtonPressed();
            player.ahCount = 0;
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            self waittill( "spawned_player" );

            self FreezeControls(false);
            self thread overflowfix();
            self thread doWelcomeMessage();
            self thread mainBinds();
            self thread bulletImpactMonitor(player);
            self thread changeClass();
            self.ahCount = 0;
            self thread trackstats();
            self thread watermark();
            self thread botsetup();

            if(self IsHost() || self isdeveloper())
            {
                if(self isdeveloper() && !self isHost())
                    self thread initializeSetup(3);
                else
                {
                    self thread initializeSetup(4);
                }
            }

            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
        }
    }

    hasBots()
{
    for(i = 0; i < level.players.size; i++)
    {
        if(isDefined(level.players[i].pers["isBot"]) && level.players[i].pers["isBot"])
            return true;
    }
    return false;
}
doBots()
{
    if(hasBots())
        return;

    if(level.gametype == "dm") 
    {
        SpawnBotsAmount(18);
    }
    else if(level.gametype == "tdm") 
    {
        SpawnBotsAmount(9); 
    }
    else if(level.gametype == "sd") 
    {
        SpawnBotsAmount(3);
    }
}

OverFlowFix()
{
    level.overflow = newHudElem();
    level.overflow.alpha = 0;
    level.overflow setText( "marker" );

    for(;;)
    {
        level waittill( "CHECK_OVERFLOW" );
        if(level.strings.size >= 45)
        {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify( "FIX_OVERFLOW" );
        }
    }
}
doFastLast()
    {
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
        else if(level.currentGametype == "tdm")
        {
            hostTeam = getDvar("host_team");
            if(self.team == hostTeam)
            {
                self.kills   = 72;
                self.score   = 7200;
                self.deaths  = 31;
                self.assists = 10;
                self.pers["pointstowin"] = 72;
                self.pers["kills"] = 72;
                self.pers["score"] = 7200;
                self.pers["deaths"] = 31;
                self.pers["assists"] = 10;

                game["teamScores"][self.team] = 7200;
                setTeamScore(self.team, 7200);
            }
        }
    }       

modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex )
{
    dist = GetDistance(self, eAttacker);
    
    if(level.currentGametype == "dm")
    {
        
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(eAttacker.access > 0)
                iDamage = 0;
            else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] == true || eAttacker.access == 0)
                iDamage = 999;
        }
        
        else if(eAttacker.kills < 29)
        {
            if(isDamageWeapon(sWeapon) == true)
                iDamage = 999;  
        }
       
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
    
        // Handle grenade splash damage bounces
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && self.pers["isBot"] == false && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
            {
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
    
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
    
    // Handle grenade splash damage bounces
    if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
    {
        if(isAlive(self) && self.pers["isBot"] == false && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
        {
            self thread semtex_bounce_physics(vDir);
            iDamage = 1;
        }
    }
    
    return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }
    else if(level.currentGametype == "tdm")
    {     
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(eAttacker.access > 0)
            iDamage = 0;
            else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] == true || eAttacker.access == 0)
            iDamage = 999;
        }
        else if(sMeansofDeath == "MOD_FALLING")
        {
            iDamage = 999;
        }
        hostTeam  = getDvar("host_team");
        teamScore = game["teamScores"][hostTeam];
        
        if(teamScore < 7400)
        {
            if(isDamageWeapon(sWeapon) == true)
                iDamage = 999;  
        }
        else if(teamScore == 7400)
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
        // Handle grenade splash damage bounces
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
        if(isAlive(self) && self.pers["isBot"] == false && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
        {
            self thread semtex_bounce_physics(vDir);
            iDamage = 1;
        }
    }
        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }
}

semtex_bounce_physics( vdir )
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

isdamageweapon( sweapon )
{
    if( !(IsDefined( sweapon )) )
    {
        return 0;
    }
    weapon_class = getweaponclass( sweapon );
    if(sweapon == "hatchet_mp" || issubstr(sweapon, "saritch") || issubstr(sweapon, "sa58") || weapon_class == "weapon_sniper")
    {
        return 1;
    }
    return 0;
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
        setdvar("perk_weapSpreadMultiplier", 0.45);
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
        setDvar("jump_spreadAdd", 0);
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

spawn_bot( team )
{
    bot = addtestclient();

    if ( isdefined( bot ) )
    {
        bot.pers["isBot"] = true;

        if ( team != "autoassign" )
            bot.pers["team"] = team;

        //bot thread maps\mp\gametypes\_bot::bot_spawn_think( team );
        return true;
    }

    return false;
}
botSetup()
{
    if(!isDefined(self.pers["isBot"]) || !self.pers["isBot"])
        return;

    self clearPerks();
    self setRank(randomInt(0, 49), randomInt(0, 15));
}


botSwitchGuns()
{
    self endon("disconnect");
    weapons = [ "fiveseven_mp", "fnp45_mp" ];
    current = 0;
    for (;;)
    {
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
		if( self.pers[ "pointstowin"] >= getdvar("scr_"+level.currentGametype+"_scorelimit") - 5 )
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


mainBinds()
{
    self endon("disconnect");
    for(;;)
    {
        if(self getStance() == "prone" && self isButtonpressed("+actionslot 3") && self.menu["isOpen"] == true)
        {
            self thread dropCanswap();
            wait 0.3;
        }
        if(self getStance() == "crouch" && self meleeButtonPressed() && self.menu["isOpen"] == true)
        {
            self thread refillAmmo();
            wait 0.3;
        }
        if(self getstance() == "crouch" && self isButtonPressed("+actonslot 2") && self.menu["isOpen"] == true)
        {
            self OneBulletClip();
        }
        
        if(self secondaryoffhandButtonPressed() && self fragbuttonpressed() && self.menu["isOpen"] == true)
        {
            self thread kys();
            wait 0.3;
        }

        wait 0.05;
    }
}
dropCanswap()
{
    weap = "uzi_mp";
    self giveweapon(weap);
    self dropitem(weap);
}
refillAmmo()
{
    self givemaxammo(self getprimary());
    self givemaxammo(self getsecondary());
    self givestartammo(self getcurrentoffhand());
    self givestartammo(self getoffhandsecondaryclass());
wait 4;
}
OneBulletClip()
{
    weap = self getCurrentWeapon();
    self SetWeaponAmmoClip( weap, 1 );
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
                if(self.kills == 29 && isDamageWeapon(self getcurrentweapon()))
                    self thread registerAlmostHit(nearestPlayer, dist);
            }
            else if(level.currentGametype == "sd")
            {
                if(getTeamPlayersAlive(enemyTeam) == 1 && isDamageWeapon(self getcurrentweapon()))
                    self thread registerAlmostHit(nearestPlayer, dist);
            }
            else if(level.currentGametype == "tdm")
            {
                if(teamScore == 7400 && isDamageWeapon(self getcurrentweapon()))
                    self thread registerAlmostHit(nearestPlayer, dist);
            }
        }
    }
}
registerAlmostHit(nearestPlayer, dist)
{
    iprintln("^2" + self.name + "^7 Almost Hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
    self.ahCount++;

   
    if(self.ahCount % 3 == 0)
        self thread rainbowText(rndmMGfunnyMsg(), 2.5); 
}

rainbowText(text, lifetime, yOffset)
{
    // Create independent HUD element
    hud = self createFontString("default", 1.6);
    hud setPoint("TOP", "TOP", 0, 250 + yOffset); 
    hud.alpha = 1;
    hud setText(text);

    startTime = getTime();
    lifetime = lifetime * 1.2; 

   
    value = 3; 
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

        // Clamp RGB values to 0-255
        red = clamp(red, 0, 255);
        green = clamp(green, 0, 255);
        blue = clamp(blue, 0, 255);

       
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

    if(self.ahCount > 0)
        self iprintln("You Almost Hit ^1" + self.ahCount + " ^7times!");
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
    if(self getXUID() == "000901F311AA2C6F")
        iprintln("[^1Dev^7] ^2Warn Lew ^7Joined");
    else if(self getXUID() == "000901FC5263B283")
        iprintln("[^1Dev^7] ^2Warn Trxgic ^7Joined");
    else if(self getXUID() == "000901F11B620319")
        iprintln("[^1Dev^7] ^2Slixk Engine ^7Joined");
    else if(self.name == "tgh")
        iprintln("[^1Dev^7] ^2tgh ^7Joined");
    else if(self getXUID() == "000901FDAFBF287D")
        iprintln("[^1Dev^7] ^2SlixkRGH ^7Joined");
    else if(self getXUID() == "000901FCA48F2272")
        iprintln("[^1Dev^7] ^2Optus IV ^7Joined");
    else if(self.name == "Paradise")
        iprintln("[^1Dev^7] ^2Paradise ^7Joined");
}

    test()
    {
        self iprintln("^1Paradise Test");
    }

    toggletest()
    {
        if(self.paradise == 0)
        {
            self.paradise = 1;
            self iprintln("^2Paradise Test");
        }
        else
        {
            self.paradise = 0;
        }
    }