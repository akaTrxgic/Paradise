init()
{
    level.strings = [];
    level.status = strtok("None;^2Verified;^5CoHost;^1Host", ";");
    level.MenuName = "Paradise";
    level.currentGametype      = getDvar("g_gametype");
    level.currentMapName       = getDvar("mapName");
    level.killstreaks = strtok("uav;airdrop;counter_uav;airdrop_sentry_minigun;predator_missile;precision_airstrike;harrier_airstrike;helicopter;airdrop_mega;helicopter_flares;stealth_airstrike;helicopter_minigun;ac130;emp", ";");
    setDvar("host_team", self.team);
    setDvar("cg_disablebarriers", "1");
    setDvar("bg_bounces", 1 );
    setDvar("bg_elevators", 2 );
    precacheshader("ui_arrow_right");
    precacheshader("hudsoftline");
    precacheitem("lightstick_mp");
    precacheitem("deserteaglegolden_mp");
    precacheitem("throwingknife_rhand_mp");
        
    level.callDamage           = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::pm_modifyplayerDamage;
    level.lastKill_minDist     = 15;
    level.oomUtilDisabled = 0;
    initDvars();
    level.airDropCrates         = GetEntArray("care_package","targetname");
    level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
    precachemodel("com_plasticcase_enemy");

    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill( "connected", player );

        player thread initstrings(); 
        player SetClientDvar("motd", "^0Thanks For Playing! ^7|| ^0discord.gg/ProjectParadise ^7|| ^0Menu By: ^1Warn Trxgic");
        player.ahCount = 0;
        player thread onPlayerSpawned();
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

onPlayerSpawned()
{
    self endon( "disconnect" );

    for(;;)
    {
        self waittill( "spawned_player" );

        if (self getPlayerCustomDvar("loadoutSaved") == "1") 
            self loadLoadout(true);

        //everything above this will run every spawn
        if(IsDefined( self.playerSpawned ))
            continue;   
        self.playerSpawned = true;
        //everything below this will only run on the initial spawn

        if(self.pers["isBot"])
        {
            setDvar("testClients_doAttack", 1);
            setDvar("testClients_doCrouch", 0);
            setDvar("testClients_doMove", 1);
            setDvar("testClients_doReload", 1);
            setDvar("testClients_watchKillcam",0);
        }

        if(!self.pers["isBot"])
        {    
            self iprintln("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
            self thread MonitorButtons();
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

            //self setClientDvar("g_compassShowEnemies", 1);
            //self setClientDvar("scr_game_forceuav", 1);
            //self setClientDvar("compassEnemyFootstepEnabled", 1);

            self thread mainBinds();
            self thread wallbangeverything();
            self thread bulletImpactMonitor();
            self thread changeClass();
            self.ahCount = 0;
            self thread trackstats();
            wait .01;

            if(level.currentGametype == "dm")
            {
                if(!self.hasCalledFastLast)
                {
                    self ffaFastLast();
                    self.hasCalledFastLast = true; 
                }
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

tdmFastlast()
{
    if(level.currentGametype == "war")
    {
        game["teamScores"][self.pers["team"]] = 7300;
        setTeamScore(self.pers["team"], game["teamScores"][self.pers["team"]]);
    }
}

ffaFastLast()
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

pm_modifyplayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
{
    dist = GetDistance(self, eAttacker);

    lastKill = 29;

    if(level.currentGametype == "dm")
    {
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"])
                iDamage = 999;
        
            else
                iDamage = 0;
        }

        if(sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH")
            iDamage = 0;

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
                
                else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
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

        enemyTeam = maps\mp\_utility::getOtherTeam(eAttacker.team);

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

                else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
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
        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }

    else if(level.currentGametype == "war")
    {
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"])
                iDamage = 999;
        
            else
                iDamage = 0;
        }

        if(game["teamScores"][eAttacker.pers["team"]] < 7400)
        {
            if(isDamageWeapon(sWeapon))
                iDamage = 999;  
        }

        else if(game["teamScores"][eAttacker.pers["team"]] == 7400)
        {
            if(dist >= level.lastKill_minDist)
            {
                if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                
                else if(IsSubstr( sWeapon, "throwingknife" ) || IsSubstr(sWeapon, "throwingknife_rhand"))
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
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

        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }
}

isdamageweapon(sweapon)
{
    if(!IsDefined(sweapon))
        return 0;

    if(issubstr(sWeapon, "fal") || issubstr(sweapon, "cheytac") || issubstr(sWeapon, "barrett") || issubstr(sweapon, "wa2000") || issubstr(sweapon, "m21") || issubstr(sweapon, "m40a3") || issubstr(sweapon, "dragunov"))
   		return 1;
	else
		return 0;
}

initDvars()
{
    setDvar("sv_cheats", 1);   
    setDvar("jump_slowdownEnable", 0);
    setdvar("bg_prone_yawcap", 360 );
    setdvar("player_breath_gasp_lerp", 0 );
    setdvar("player_clipSizeMultiplier", 1 );
    setdvar("perk_bulletPenetrationMultiplier", 30 );
    setDvar("bg_surfacePenetration", 999999 );
    setDvar("bg_bulletRange", 999999 );
    setDvar("bulletrange", 99999);
    setdvar("penetrationcount", 999 );
    setdvar("sv_superpenetrate", 1 );
    setdvar("perk_weapSpreadMultiplier", 0.45);
    setDvar("jump_spreadAdd", 0);
    setDvar("scr_dm_timelimit", 10);
    setDvar("aim_aimAssistRangeScale", 0);
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
    weap = "rpd_mp";
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

bulletImpactMonitor(eAttacker, nearestPlayer)
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

        hostTeam = (getDvar("host_team"));
        enemyTeam = maps\mp\_utility::getOtherTeam(eAttacker.team);

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

                lastKill = 29;

                if(level.currentGametype == "dm")
                {     
                    if(self.kills == lastKill && isAlive(nearestplayer) && isDamageWeapon(self getcurrentweapon()))
                        self thread registerAlmostHit(nearestPlayer, dist);
                }
        }
    }
}
registerAlmostHit(nearestPlayer, dist)
{
    if(!level.rankedMatch)
    {
        iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
        self.ahCount++;
    }
    else if(level.rankedMatch)
        self.ahCount++;

    // EVERY 3 ALMOST HITS ? RAINBOW FUNNY MESSAGE
    if(self.ahCount % 3 == 0)
        self iprintlnbold("^1" + rndmMGfunnyMsg());
}

doBots()
{
    hostTeam = (getDvar("host_team"));

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
        if(getTeamPlayersAlive(self.team != hostTeam <= 1))
            spawnBots(3, !hostTeam);
    }
    else if(level.currentGametype == "war")
    {
        if(getteamplayersalive(self.team != !hostTeam <= 1))
            spawnBots(6, !hostTeam);
    }
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

    weapons = strtok("usp_mp;deserteagle_mp", ";");

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

changeClass()
{
    self endon("disconnect");

    game["strings"]["change_class"] = "";

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

hasBots()
{
    for(i=0; i < level.players.size; i++)
    {
        if(isDefined(level.players[i].pers["isBot"]) && level.players[i].pers["isBot"])
            return true;
    }

    return false;
}


doFastLast()
{
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 1400;
            self.deaths  = 13;
            self.assists = 2;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 1400;
            self.pers["deaths"] = 13;
            self.pers["assists"] = 2;
        }
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

AfterHit(gun)
{
    self endon("afterhit");
    self endon( "disconnect" );

    if(!self.AfterHit)
    {
        self iprintln("Afterhit Weapon set: ^2" + gun);
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
sentryBind(num)
{
    if(!isDefined(self.basedSentry))
    {
            if(num == 1)
                self iPrintLn("Press [{+Actionslot 1}] for ^2Walking Sentry");

            else if(num == 2)
                self iPrintLn("Press [{+Actionslot 2}] for ^2Walking Sentry");

            else if(num == 3)
                self iPrintLn("Press [{+Actionslot 3}] for ^2Walking Sentry");

            else if(num == 4)
                self iPrintLn("Press [{+Actionslot 4}] for ^2Walking Sentry");
            

            self.basedSentry = true;

            while(isDefined(self.basedSentry))
            {
                if(num == 1)
                {
                    if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                        self enableWeapons();
                    }

                    wait .1;
                }
                else if(num == 2)
                {
                    if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                        self enableWeapons();
                    }
                    
                    wait .1;
                }
                else if(num == 3)
                {
                    if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                        self enableWeapons();
                    }

                    wait .1;
                }
                else if(num == 4)
                {
                    if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                        self enableWeapons();
                    }
                    
                    wait .1;
                }
            }
    }
    else if(isDefined(self.basedSentry)) 
    { 
        self iPrintLn("Walking Sentry Bind [^1OFF^7]");
        self.basedSentry = undefined; 
    }
}

predBind(num)
{
     if(!isDefined(self.laptop))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to Give ^2Laptop");

        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to Give ^2Laptop");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to Give ^2Laptop");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to Give ^2Laptop");
        
        self.laptop = true;

        while(isDefined(self.laptop))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");

                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");
        
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");
                
                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.laptop)) 
    { 
        self iPrintLn("Laptop bind [^1OFF^7]");
        self.laptop = undefined; 
    }
}
bombBind(num)
{
    if(!isDefined(self.bomb))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to Give ^2Bomb");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to Give ^2Bomb");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to Give ^2Bomb");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to Give ^2Bomb");
        
        self.bomb = true;

        while(isDefined(self.bomb))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");

                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.bomb)) 
    { 
        self iPrintLn("Bomb bind [^1OFF^7]");
        self.bomb = undefined; 
    }
}
trgrBind(num)
{
    if(!isDefined(self.trgr))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to Give ^2Trigger");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to Give ^2Trigger");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to Give ^2Trigger");
    
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to Give ^2Trigger");
        
        self.trgr = true;

        while(isDefined(self.trgr))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
        
                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
                
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
                
                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.trgr)) 
    { 
        self iPrintLn("Trigger bind [^1OFF^7]");
        self.trgr = undefined; 
    }
}
doTrigger()
{
    self giveselfweapon("c4_mp");
    wait .1;
}

Canzoom(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Canzoom))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Can Zoom");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Can Zoom");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Can Zoom");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Can Zoom");
        
        self.Canzoom = true;

        while(isDefined(self.Canzoom))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread CanzoomFunction();
                
                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread CanzoomFunction();
                
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread CanzoomFunction();
                
                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread CanzoomFunction();
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.Canzoom)) 
    { 
        self iPrintLn("Canzoom bind [^1OFF^7]");
        self.Canzoom = undefined; 
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
        self iPrintln("Weapon 1 Selected: ^2" + self.wep1);
    }
    else if(num == 2)
    {
        self.wep2 = self getCurrentWeapon();
        self iPrintln("Weapon 2 Selected: ^2" + self.wep2);
    }
}

nacModBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.NacBind))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Nac");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Nac");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Nac");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Nac");
        
        self.NacBind = true;
        
        while(isDefined(self.NacBind))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            wait 0.01; 
        } 
    } 
    else if(isDefined(self.NacBind)) 
    { 
        self iPrintLn("Nac Bind [^1OFF^7]");
        self.NacBind = undefined; 
        self.wep1    = undefined;
        self.wep2    = undefined;
        self iPrintLn("Nac Weapons ^1Reset");
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
        self iPrintln("Weapon 1 Selected: ^2" + self.snacwep1);
    }
    else if(num == 2)
    {
        self.snacwep2 = self getCurrentWeapon();
        self iPrintln("Weapon 2 Selected: ^2" + self.snacwep2);
    }
}

skreeBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.SnacBind))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Skree");
    
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Skree");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Skree");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Skree");
        
        self.SnacBind = true;
        
        while(isDefined(self.SnacBind))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
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
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
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
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
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
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
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
    else if(isDefined(self.SnacBind)) 
    { 
        self iPrintLn("Skree Bind [^1OFF^7]");
        self.SnacBind = undefined; 
        snacwep1      = undefined;
        snacwep2      = undefined;
        self iPrintLn("Skree Weapons ^1Reset");
    } 
}

gFlipBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Gflip))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2GFlip");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2GFlip");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2GFlip");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2GFlip");
        
        self.Gflip = true;
        
        while(isDefined(self.Gflip))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread MidAirGflip();

                wait .001;
            }
            if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread MidAirGflip();
            
                wait .001;
            }
            if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
            if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.Gflip)) 
    { 
        self iPrintLn("GFlip bind [^1OFF^7]");
        self notify("stopProne1");
        self.Gflip = undefined; 
    } 
}
MidAirGflip()
{
    self endon("stopProne1");
    self setStance("prone");
    wait 0.01;
    self setStance("prone");
}
class1()
{
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom1" );
            
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class2()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom2" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class3()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom3" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }

}
class4()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom4" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
 
}
class5()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom5" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class6()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom6" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class7()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom7" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class8()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom8" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class9()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom9" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class10()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom10" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
spawnBots(num, team)
{
    if(team == "enemy")
        team = self getenemyteam();
    else
        team = self.pers["team"];

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
        wait 1;
	}
}
GetEnemyTeam()
{
    if(self.pers["team"] == "allies")
        team = "axis";
    else
        team = "allies";
    
    return team;
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
botControls(action)
{
    if(action == "teleport")
        self tpBots();

    else if(action == "addone")
	    self spawnbots(1);

    else if(action == "fill")
        self spawnBots(18);
    
    else if(action == "kick")
        self kickallbots();
}
toggleFreezeBots()
{
    if (!isDefined(self.frozenbots))
        self.frozenbots = 0;

    if (!self.frozenbots)
    {
        self.frozenbots = 1;
        self iPrintLn("All bots ^1Frozen");

        self.freezeBotsLoop = true;
        self thread freezeBotsThread();
    }
    else
    {
        self.frozenbots = 0;
        self.freezeBotsLoop = false;

        players = level.players;
        for (i = 0; i < players.size; i++)
        {
            player = players[i];
            
            if (isDefined(player.pers["isBot"]) && player.pers["isBot"])
                player freezeControls(false);
        }

        setDvar("testClients_doAttack", 1);
        setDvar("testClients_doCrouch", 0);
        setDvar("testClients_doMove", 1);
        setDvar("testClients_doReload", 1);

        self iPrintLn("All bots ^2Unfrozen");
    }
}

freezeBotsThread()
{
    while (self.freezeBotsLoop)
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
changeCamo(num)
{
    Weapon  = self GetCurrentWeapon();
    oldammo = self GetWeaponAmmoStock(Weapon);
    oldclip = self GetWeaponAmmoClip(Weapon);
    self TakeWeapon(Weapon);
    self GiveWeapon(Weapon,num);
    self SetWeaponAmmoStock(Weapon,oldammo);
    self SetWeaponAmmoClip(Weapon,oldclip);
    self SetSpawnWeapon(Weapon);
}

randomCamo()
{
    numEro  = randomIntRange(1,8);  
    Weapon  = self GetCurrentWeapon();
    oldammo = self GetWeaponAmmoStock(Weapon);
    oldclip = self GetWeaponAmmoClip(Weapon);
    self TakeWeapon(Weapon);
    self GiveWeapon(Weapon,numEro);
    self SetWeaponAmmoStock(Weapon,oldammo);
    self SetWeaponAmmoClip(Weapon,oldclip);
    self SetSpawnWeapon(Weapon);
}

giveUserWeapon(weapon, akimbo) 
{      
    weap = StrTok(Weapon,"_");

    if(weap[weap.size-1] != "mp")
        Weapon += "_mp";
        
    if(self hasWeapon(Weapon))
    {
        self SetSpawnWeapon(Weapon);
        return;
    }

    if(issubstr(weapon, "akimbo"))
        akimbo = true;

    self GiveWeapon(Weapon,0,Akimbo);
    self GiveMaxAmmo(Weapon);
    self SwitchToWeapon(Weapon);
} 
GiveSelfWeapon(weapon)
{
        weap = StrTok(Weapon,"_");
        if(weap[weap.size-1] != "mp")
            Weapon += "_mp";
  
        self GiveWeapon(weapon);    
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
}
GivePlayerAttachment(attachment)
{
    weapon      = self GetCurrentWeapon();
    wpn         = strtok(Weapon, "_");
    base        = maps\mp\_utility::getBaseWeaponName(weapon);
    attachments = maps\mp\_utility::GetWeaponAttachments(weapon);
    stock       = self GetWeaponAmmoStock(weapon);
    clip        = self GetWeaponAmmoClip(weapon);
    akimbo      = false;
    keep        = "";
    newAttachments = [];
    
    if(HasAttachment(weapon, attachment))
    {
        if(isDefined(attachments) && attachments.size > 1)
        {
            for(a = 0; a < attachments.size; a++)
                if(attachments[a] != attachment)
                    keep = attachments[a];
        }
        else
            keep = "none";
        
        newWeapon = maps\mp\gametypes\_class::buildWeaponName(base, keep, "none");
    }
    else
    {
        if(attachments.size && attachment != "none")
        {
            for(a = 0; a < attachments.size; a++)
            {
                if(IsValidAttachmentCombo(attachments[a], attachment))
                {
                    newAttachments[0] = attachments[a];
                    newAttachments[1] = attachment;
                }
                else if(IsValidAttachmentCombo(attachment, attachments[a]))
                {
                    newAttachments[0] = attachment;
                    newAttachments[1] = attachments[a];
                }
                else if(!isValidAttachmentCombo())
                    self iPrintln("^1Error: ^7Invalid attachment");
                
                if(isDefined(newAttachments))
                    break;
            }
        }
        
        if(!isDefined(newAttachments))
        {
            newAttachments[0] = attachment;
            newAttachments[1] = "none";
        }
        newWeapon = maps\mp\gametypes\_class::buildWeaponName(base, newAttachments[0], newAttachments[1]);
    }
    
    if(keep == "akimbo" || inarray(newAttachments, "akimbo") || attachment == "akimbo")
        akimbo = true;
    
    self TakeWeapon(weapon);
    self GiveWeapon(newWeapon, 0, akimbo);
    self SetWeaponAmmoClip(newWeapon, clip);
    self SetWeaponAmmoStock(newWeapon, stock);
    self SetSpawnWeapon(newWeapon);
}

GetWeaponValidAttachments(weapon)
{
    attachments = [];
    
    for(a = 11;; a++)
    {
        column = TableLookUp("mp/statsTable.csv", 4, weapon, a);
        
        if(!isDefined(column) || column == "")
            break;
        
        attachments[attachments.size] = column;
    }
    
    return attachments;
}

IsValidAttachmentCombo(attachment1, attachment2)
{
    return TableLookup("mp/attachmentCombos.csv", 0, attachment1, TableLookupRowNum("mp/attachmentCombos.csv", 0, attachment2)) != "no";
}

HasAttachment(weapon, attachment)
{
    attachments = maps\mp\_utility::GetWeaponAttachments(weapon);
    
    foreach(attach in attachments)
        if(attach == attachment)
            return true;
    
    return false;
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
saveloadouttoggle()
{
    if(self getPlayerCustomDvar("loadoutSaved") != "1")
        self saveloadout();

    else if(self getPlayerCustomDvar("loadoutSaved") == "1")
        self deleteloadout();
}
saveLoadout() 
{
    wait .01;
        
    self.primaryWeaponList = self getWeaponsListPrimaries();
    self.offHandWeaponList = isExclude(self getweaponslistoffhands(), self.primaryWeaponList);
    self.offHandWeaponList = removeValueFromArray(self.offHandWeaponList, "knife_mp");

    for (i = 0; i < self.primaryWeaponList.size; i++) 
        self setPlayerCustomDvar("primary" + i, self.primaryWeaponList[i]);

    for (i = 0; i < self.offHandWeaponList.size; i++)
        self setPlayerCustomDvar("secondary" + i, self.offHandWeaponList[i]);

    self setPlayerCustomDvar("primaryCount", self.primaryWeaponList.size);  
    self setPlayerCustomDvar("secondaryCount", self.offHandWeaponList.size);
    self setPlayerCustomDvar("loadoutSaved", "1");
    self iprintln("Loadout ^2Saved");
}

deleteLoadout()
{        
    self setPlayerCustomDvar("loadoutSaved", "0");
    self iprintln("Loadout ^1Deleted");
}

loadLoadout() 
{
    self takeAllWeapons();
    
    if(self hasperk("_specialty_blastshield"))
        self maps\mp\_utility::_unsetperk("_specialty_blastshield");
    wait .01;
    
    if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") 
    {
        for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++) 
            self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

        for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++) 
            self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
    }

    for (i = 0; i < self.primaryWeaponList.size; i++) 
    {
        if (!isDefined(self.camo) || self.camo == 0) 
            self.camo = self randomcamo();

        weapon = self.primaryWeaponList[i];
        //weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);
        if(issubstr(weapon, "akimbo"))
            self giveuserweapon(weapon, true);
        else
            self giveWeapon(weapon, 0); //0, weaponOptions
        if (weapon == "rpg_mp" || weapon == "m79_mp") 
            self giveMaxAmmo(weapon);
    }

    self switchToWeapon(self.primaryWeaponList[1]);
    self setSpawnWeapon(self.primaryWeaponList[1]);
    self giveWeapon("knife_mp");
    for (i = 0; i < self.offHandWeaponList.size; i++) 
    {
        offhand = self.offHandWeaponList[i];

        if(offhand == "frag_grenade_mp" || offhand == "sticky_grenade_mp" || offhand == "claymore_mp" || offhand == "c4_mp" || offhand == "flare_mp" || offhand == "throwingknife_mp")
            self thread giveequipment(offhand);

        else if(offhand == "concussion_grenade_mp" || offhand == "flash_grenade_mp" || offhand == "smoke_grenade_mp")
            self thread givesecondaryoffhand(offhand);

        else if(offhand == "lightstick_mp")
            self thread giveglowstick();

        else if(offhand == "throwingknife_rhand_mp")
            self thread rhThrowingKnife();

        else if(offhand == "specialty_blastshield")
                self thread blastshield();

        else
            self giveWeapon(offhand);
    }
}
GiveEquipment(equipment)
{
    equip = StrTok(equipment,"_");
    if(equip[equip.size-1] != "mp" && !isSubStr(equipment,"specialty"))
        equipment += "_mp";

    if(self hasperk("_specialty_blastshield"))
        self thread maps\mp\perks\_perkfunctions::unsetblastshield();
    
    self TakeWeapon(self GetCurrentOffhand());
    self SetOffhandPrimaryClass("other");
    self maps\mp\perks\_perks::givePerk(equipment);
    self GiveStartAmmo(equipment);
    self SetWeaponHudIconOverride( "primaryoffhand", equipment );
}

GiveSecondaryOffhand(offhand)
{
    equip = StrTok(offhand,"_");
    if(equip[equip.size-1] != "mp")
        offhand += "_mp";
    
    if(offhand == "flash_grenade_mp")
    {
        self SetOffhandSecondaryClass("flash");
        self SetWeaponAmmoClip(offhand,2);
    }
    else if(offhand == "concussion_grenade_mp")
    {
        self SetOffhandSecondaryClass("concussion");
        self SetWeaponAmmoClip(offhand,2);
    }
    else if(offhand == "smoke_grenade_mp")
    {
        self SetOffhandSecondaryClass("smoke");
        self SetWeaponAmmoClip(offhand,1);
    }
    self TakeWeapon(self GetCurrentOffhand());
    self GiveWeapon(offhand);
    self SetWeaponHudIconOverride( "secondaryoffhand", offhand );
}

blastShield()
{
    if(self hasperk("_specialty_blastshield"))
        self thread maps\mp\perks\_perkfunctions::unsetblastshield();

    if(!self.blastshield)
    {
        self.blastshield = 1;
        self thread maps\mp\perks\_perkfunctions::setblastshield();
    }
    else
    {
        self.blastshield = 0;
        self thread maps\mp\perks\_perkfunctions::unsetblastshield();
    }
}

GiveGlowstick()
{
    wait .1;
    self TakeWeapon(self GetCurrentOffhand());
    self SetOffhandPrimaryClass("other");
    self GiveWeapon("lightstick_mp");
    self SetWeaponHudIconOverride( "primaryoffhand", "lightstick_mp" );
}

rhThrowingKnife()
{
    wait .1;
    self takeweapon(self getcurrentoffhand());
    wait 0.01;
    self giveweapon("throwingknife_mp",0,false);
    wait 0.01;
    self takeweapon("throwingknife_mp");
    wait 0.01;
    self giveweapon("throwingknife_rhand_mp",0,false); 
}
takeWpn()
{
    self takeweapon(self getcurrentweapon());
}
toggleInfEquip()
{
    self.infEquipOn = !isDefined(self.infEquipOn) || !self.infEquipOn;

    if (self.infEquipOn)
        self thread InfEquipment();
    else
        self notify("noMoreInfEquip");
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

LoadSettings()
{
    self.presets = [];

    self.presets["X"] = 155; // 145
    self.presets["Y"] = -20; // 0

    self.presets["Option_BG"] = dividecolor(0, 0, 0);
    self.presets["Title_BG"] = dividecolor(255, 255, 255); 
    self.presets["Outline_BG"] = dividecolor(0, 0, 0);
    self.presets["KB_Outline"] = "rainbow";
    self.presets["Text"] = dividecolor(255, 255, 255);
    self.presets["Option_Font"] = "default";

    self.presets["Font_Scale"] = 1;

    self.presets["Toggle_BG"] = dividecolor(255, 20, 147);
    self.presets["MenuTitle_Color"] = dividecolor(255, 20, 147);
    self.presets["Scroller_BG"] = dividecolor(255, 20, 147);
    self.presets["Scroller_Shader"] = "hudsoftline";
}

displayVer()
{
    self endon( "disconnect");

    Instructions = maps\mp\gametypes\_hud_util::createFontString("objective", 1 );
    Instructions maps\mp\gametypes\_hud_util::setPoint( "TOPRIGHT", "TOPRIGHT", -10, 10);

    Instructions.alpha = 0.5;

    for( ;; )
    {
        Instructions settext("Paradise");
        wait(2.0);
    }
}

initstrings()
{
   game["strings"]["pregameover"]       = "Paradise";
   game["strings"]["waiting_for_teams"] = "Paradise";
   game["strings"]["intermission"]      = "Paradise";
   game["strings"]["score_limit_reached"] = "Discord.gg^0/^7ProjectParadise";
   game["strings"]["time_limit_reached"]  = "Discord.gg^0/^7ProjectParadise";
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

doWelcomeMessage()
{
    if(level.currentGametype == "dm")
    {
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise FFA!");
        self.hasMenu = true;
    }
    else if(level.currentGametype == "sd")
    {
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise SND!");
        self.hasMenu = true;
    } 
    else if(level.currentGametype == "war")
    {
        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise TDM!");
        self.hasMenu = true;
    } 
}

editTime(value)
{
    timeLeft       = GetDvar("scr_"+level.currentGametype+"_timelimit");
    timeLeftProper = int(timeLeft);

    setTime = timeLeftProper + value;
    SetDvar("scr_"+level.gametype+"_timelimit", setTime);
    wait .05;
}

togglelobbyfloat()
{
    if(!self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] thread enableFloaters();
        self.floaters = 1;
    }
    else if(self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] notify("stopFloaters");
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

endGame()
{
    level thread maps\mp\gametypes\_gamelogic::forceEnd();
}

doUnstuck()
{
    player = self;  
   
    if (!isAlive(player)) 
        return;  

    FAR = 25; 
    pos = player.origin; 

    
    pos = physicsTrace(pos, pos + (0, 0, FAR), false, player);
    pos += (0, 0, 1); 

 
    pos = physicsTrace(pos, pos + (0, 0, FAR), false, player);
    pos = playerPhysicsTrace(pos, pos - (0, 0, FAR * 2), false, player);

  
    player setOrigin(pos);
}

tptoSpawn()
{
    self setOrigin( self.lastSpawnPoint.origin + ( 0, 0, 10 ) );
    self setVelocity((0,0,0));
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
    map_restart( 0 );
}

setMinDistance(newDist)
{
    level endon("game_ended");

    level.lastKill_minDist = int(newDist);
    iprintln("Minimum distance: ^1" + newDist + "m");
}

oomtoggle()
{
    if(!level.oomUtilDisabled)
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
                self notify("EndNoClip");
                self unlink();
                self.NoClipT = 0;
            }
        }
        self iprintln("OOM Utilities [^1Disabled^7]");
        level.oomUtilDisabled = 1;
    }
    else
        level.oomUtilDisabled = 0;
}

doKillstreak(name)
{
    self maps\mp\killstreaks\_killstreaks::giveKillstreak(name, false );
    self iPrintln( "Given ^2" + name);
}

FakeNuke()
{
    foreach(player in level.players)
    {
        player maps\mp\killstreaks\_nuke::tryUseNuke(1);

        while(!isdefined(level.nukedetonated))
        wait 0.5;

        setslowmotion(1, .25, .5);
        maps\mp\gametypes\_gamelogic::resumeTimer();
        level.timeLimitOverride = false;

        SetDvar( "ui_bomb_timer", 0 );
        level notify( "nuke_cancelled" );
        level.nukedetonated = undefined;
        level.nukeincoming  = undefined;
        
        wait 1;
        setSlowMotion( 0.25, 1, 2.0 );
        
        wait 1.5;
        VisionSetNaked(GetDvar("mapname"), 0.5);
        
        wait .1;
        break;
    }
}

menuOptions()
{

        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        if(menu == "main")
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

            if(self ishost() || self isDeveloper()) 
                self addOpt("Host Options", ::newMenu, "host");
            }
        }
        else if(menu =="ts")
        {
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

            if(level.currentGametype == "dm")
            self addOpt("Go for Two Piece", ::dotwopiece);

            canOpts = "Current;Infinite";
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addToggle("Dolphin Dive", self.DolphinDive, ::DolphinDive);
            self addToggle("Riot Shield Knife", self.riotKnife, ::knifeMod, "shield");
            self addToggle("Laptop Knife", self.predKnife, ::knifeMod, "pred");

            slideOptIDs = "spawnSlide;deleteSlide";
            slideOptNames = "Spawn @ Crosshairs;Delete";
            self addsliderstring("Slide Options", slideOptIDs, slideOptNames, ::doSpawnOption);

            bounceOptIDs = "spawnBounce;deleteBounce";
            bounceOptNames = "Spawn @ Feet;Delete";
            self addsliderstring("Bounce Options", bounceOptIDs, bounceOptNames, ::doSpawnOption);
        }

    else if(menu == "sK") { 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
            self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
            self addOpt("Laptop Bind", ::newMenu, "laptop");
            self addOpt("Bomb Briefcase Bind", ::newMenu, "bomb");
            self addOpt("Trigger Bind", ::newMenu, "trgr");
            }

    else if(menu == "sentry") {
            self addMenu("sentry", "Walking Sentry Bind");
            self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
            self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
            self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
            self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
            }

    else if(menu == "laptop") {
            self addMenu("laptop", "Laptop Bind");
            self addOpt("Laptop Bind: [{+actionslot 1}]", ::predBind, 1);
            self addOpt("Laptop Bind: [{+actionslot 2}]", ::predBind, 2);
            self addOpt("Laptop Bind: [{+actionslot 3}]", ::predBind, 3);
            self addOpt("Laptop Bind: [{+actionslot 4}]", ::predBind, 4);
            }
        
    else if(menu == "bomb") {
            self addMenu("bomb", "Bomb Bind");
            self addOpt("Bomb Bind: [{+actionslot 1}]", ::bombBind, 1);
            self addOpt("Bomb Bind: [{+actionslot 2}]", ::bombBind, 2);
            self addOpt("Bomb Bind: [{+actionslot 3}]", ::bombBind, 3);
            self addOpt("Bomb Bind: [{+actionslot 4}]", ::bombBind, 4);
            }

    else if(menu == "trgr") {
            self addMenu("trgr", "Trigger Bind");
            self addOpt("Trigger Bind: [{+actionslot 1}]", ::trgrBind, 1);
            self addOpt("Trigger Bind: [{+actionslot 2}]", ::trgrBind, 2);
            self addOpt("Trigger Bind: [{+actionslot 3}]", ::trgrBind, 3);
            self addOpt("Trigger Bind: [{+actionslot 4}]", ::trgrBind, 4);
            }

        else if(menu == "gflip") {
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            }

        else if(menu == "nmod") {
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            }

        else if(menu == "skree") {
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            }

        else if(menu == "cnzm") {
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            }

        else if(menu == "cb") {
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 1}]",  ::class1);
            self addOpt("Bind Class 2: [{+actionslot 1}]",  ::class2);
            self addOpt("Bind Class 3: [{+actionslot 1}]",  ::class3);
            self addOpt("Bind Class 4: [{+actionslot 1}]",  ::class4);
            self addOpt("Bind Class 5: [{+actionslot 1}]",  ::class5);
            self addOpt("Bind Class 6: [{+actionslot 1}]",  ::class6);
            self addOpt("Bind Class 7: [{+actionslot 1}]",  ::class7);
            self addOpt("Bind Class 8: [{+actionslot 1}]",  ::class8);
            self addOpt("Bind Class 9: [{+actionslot 1}]",  ::class9);
            self addOpt("Bind Class 10: [{+actionslot 1}]",  ::class10);
            }

        else if(menu == "tp") {
    self addMenu("tp", "Teleport Menu");

    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);
      
    tpNames = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_crash")
    {
        tpNames   = "Bomb Spawn OOM;Roof Way Out;Hilltop;Great Wall";
        tpCoords  = "524.595, 3381.14, 824.126;-2802.75, -3663.08, 1112.13;6778.43, 1326.18, 715.940;5795.25, -223.995, 584.125";
    }
    else if(getDvar("mapname") == "mp_overgrown")
    {
        tpNames  = "Water Tower;A Barrier Sui;River Bed Sui";
        tpCoords = "3082.29, -2284.81, 992.126;-1972.75, -1927.23, 992.126;1351.02, 536.997, 992.126";
    }
    else if(getDvar("mapname") == "mp_storm")
    {
        tpNames  = "A OOM Tower 1;A OOM Tower 2;B OOM Tower 1;Construction Spot";
        tpCoords = "162.407, 3400.21, 1528.14;1362.07, 2732.52, 1068.14;1055.09, -4464.07, 1360.14;-2425.00, -3082.99, 537.626";
    }
    else if(getDvar("mapname") == "mp_abandon")
    {
        tpNames  = "Flying Saucer;Overpass;Top of Dome";
        tpCoords = "290.325, 1858.08, 1429.96;677.383, 9410.43, 468.126;-3231.82, -4795.27, 1175.17";
    }
    else if(getDvar("mapname") == "mp_fuel2")
    {
        tpNames  = "White Tower 1;White Tower 2;Edge of Map";
        tpCoords = "3767.23, -1541.8, 747.095;-2869.46, -92.1384, 1018.86;-11856.70, -4897.51, 1451.46";
    }
    else if(getDvar("mapname") == "mp_complex")
    {
        tpNames  = "Brown Building Roof;Gym Roof;Arcade Roof";
        tpCoords = "2913.4, -997.484, 1291.13;-1131.86, -3914.24, 1542.9;1067.31, -4178.76, 1160.13";
    }
    else if(getDvar("mapname") == "mp_strike")
    {
        tpNames  = "Brick Building OOM;Palace Building 1;Palace Building 2;Headquarters";
        tpCoords = "-2945.18, 1748.38, 665.125;-1598.42, 2017.62, 665.125;1004.47, 2679.39, 665.125;-1371.26, 231.865, 652.125";
    }
    else if(getDvar("mapname") == "mp_afghan")
    {
        tpNames  = "A Barrier;B Barrier;Cliff Barrier";
        tpCoords = "1507.01, -1331.07, 1296.14;-1435.34, 2687.04, 1296.14;1083.92, 4634.11, 1296.14";
    }
    else if(getDvar("mapname") == "mp_derail")
    {
        tpNames  = "Yellow Roof;Mountain Ridge;Mountain Peak 1;Mountain Peak 2;Water Tower";
        tpCoords = "-3350.53, -1807.69, 874.126;-6810.06, 856.458, 1872.87;-9719.58, -5325.42, 2553.49;14557.40, -2865.92, 3640.28;-784.772, -1109.62, 695.126";
    }
    else if(getDvar("mapname") == "mp_estate")
    {
        tpNames  = "A Barrier;B Barrier;Spawn Sui;Hella Far Tree";
        tpCoords = "2415.35, 253.95, 1216.14;1373.09, 4469.03, 1216.14;-4013.6, -1291.56, 1216.14;-712.487, 8924.99, 2038.55";
    }
    else if(getDvar("mapname") == "mp_favela")
    {
        tpNames  = "A Building OOM;Top of Sign;Defenders Undermap;Attackers Undermap;Jesus Statue;Yellow Building;Cliff Sui";
        tpCoords = "1725.92, -1694.85, 728.126;-1807.83, -504.29, 672.126;-99.8282, -1538.56, -41.876;1813.92, 2064.69, 145.143;9671.63, 18431.60, 13604.10;-7818.56, -514.921, 928.126;-7489.34, -11022.70, 1696.42";
    }
    else if(getDvar("mapname") == "mp_highrise")
    {
        tpNames = "Rooftop 1;Rooftop 2;Rooftop 3;OOM Helipad;OOM Crane";
        tpCoords = "-3364.62, 2775.56, 4400.14;-49.0137, 3053.46, 4100.14;-4940.83, 9940.00, 5464.14;1446.91, 10331.70, 4064.04;-400.543, 9301.78, 3776.14";
    }
    else if(getDvar("mapname") == "mp_invasion")
    {
        tpNames = "River Sui;B OOM Rooftop;Bomb Spawn Rooftop";
        tpCoords = "-1663.96, 947.982, 3008.14;-283.318, -5151.98, 1100.14;-4757.66, -3211.97, 912.126";
    }
    else if(getDvar("mapname") == "mp_checkpoint")
    {
        tpNames = "A Roof 1;A Roof 2;B Roof;Bomb Spawn Roof";
        tpCoords = "-2634.84, -631.548, 792.126;-2698.3, -1283.16, 731.726;2629.62, 2.61329, 600.126;1830.4, -3000.96, 931.916";
    }
    else if(getDvar("mapname") == "mp_quarry")
    {
        tpNames = "Bomb Spawn Rocks;A Building Rocks;B Building Rocks;Barrier OOM";
        tpCoords = "-199.245, 1197.04, 1108.14;-4816.24, -2915.08, 648.126;-5769.44, 558.645, 640.126;-10575.20, -8750.72, 3674.14";
    }
    else if(getDvar("mapname") == "mp_rust")
    {
        tpNames = "Distance Cliff;Mountain Peak;River Rock";
        tpCoords = "-3897.12, -5341.77, 1088.38;-5343.59, -2916.34, 1666.92;6128.34, -7736.97, 220.540";
    }
    else if(getDvar("mapname") == "mp_boneyard")
    {
        tpNames = "Crane Sui;Carnie Crane;Lot 24 Sign;Lot 25 Sign";
        tpCoords = "-2777.96, 880.584, 1377.56;-4874.33, 4734.69, 2327.95;-2842.92, 5515.01, 613.626;-6019.22, 789.23, 704.626";
    }
    else if(getDvar("mapname") == "mp_nightshift")
    {
        tpNames = "Bridge Lightpost;Other Lightpost;Rail Bridge";
        tpCoords = "5742.18, 1059.74, 471.126;5760.77, -1536.21, 471.126;4426.84, 1052.57, 116.126";
    }
    else if(getDvar("mapname") == "mp_subbase")
    {
        tpNames = "Transmission Tower 1;Transmission Tower 2;Transmission Tower 3;Transmission Tower 4";
        tpCoords = "-3722.34, -583.564, 2400.13;-3015.12, 1054.40, 2408.14;-2316.84, 2923.56, 2336.14;-1780.99, 5205.76, 2560.14";
    }
    else if(getDvar("mapname") == "mp_terminal")
    {
        tpNames = "OOM Plane;Spawn Building";
        tpCoords = "1696.63, 69.1275, 820.485;2983.54, 6733.42, 464.126";
    }
    else if(getDvar("mapname") == "mp_underpass")
    {
        tpNames = "Lightpole;Crane";
        tpCoords = "-3067.01, 3155.82, 1637.14;-1933.96, 1269.13, 2339.44";
    }
    else if(getDvar("mapname") == "mp_brecourt")
    {
        tpNames = "Apartment Complex 1;Apartment Complex 2;Telephone Pole";
        tpCoords = "10125.90, 6987.83, 1534.14;10876.00, 11754.90, 1298.14;2979.74, -2412.47, 432.082";
    }
    else
    {
        tpNames  = strtok("No Custom Spots", ";");
        tpCoords = [];
    }

    self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
    }


   else if(menu == "class") {
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "atchmnts");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Equipment", ::newMenu, "lethals");
            self addOpt("Special Grenades", ::newMenu, "tacticals");
            self addOpt("Save Loadout", ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            }

        else if(menu == "wpns") {
            self addMenu("wpns", "Weapons Menu");

            arIDs = "m4_mp;famas_mp;scar_mp;tavor_mp;fal_mp;m16_mp;masada_mp;fn2000_mp;ak47_mp";
            arNames = "M4A1;Famas;Scar-H;Tar-21;Fal;M16A4;ACR;F2000;AK-47";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = "mp5k_mp;ump45_mp;kriss_mp;p90_mp;uzi_mp";
            smgNames = "MP5K;UMP45;Vector;P90;Mini-Uzi";
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgIDs = "sa80_mp;rpd_mp;mg4_mp;aug_mp;m240_mp";
            lmgNames = "L86 LSW;RPD;MG4;AUG HBAR;M240";
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            srIDs = "cheytac_mp;barrett_mp;wa2000_mp;m21_mp";
            srNames = "Intervention;Barrett .50cal;WA2000;M21 EBR";
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            mpIDs = "pp2000_mp;glock_mp;beretta393_mp;tmp_mp";
            mpNames = "PP2000;G18;M93 Raffica;TMP";
            self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

            sgIDs = "spas12_mp;aa12_mp;striker_mp;ranger_mp;m1014_mp;model1887_mp";
            sgNames = "SPAS-12;AA-12;Striker;Ranger;M1014;Model 1887";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            pstlIDs = "usp_mp;coltanaconda_mp;beretta_mp;deserteagle_mp";
            pstlNames = "USP .45;.44 Magnum;M9;Desert Eagle";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Special Weapons", ::newMenu, "specs");
            self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
            }

        else if(menu == "lnchrs") {
            self addMenu("lnchrs", "Launchers");
            self addOpt("AT4-HS", ::giveUserWeapon, "at4_mp");
            self addOpt("Thumper", ::giveUserWeapon, "m79_mp", false);
            self addOpt("Stinger", ::giveUserWeapon, "stinger_mp");
            self addOpt("Javelin", ::giveUserWeapon, "javelin_mp");
            self addOpt("RPG-7", ::giveUserweapon, "rpg_mp");
            }

        else if(menu == "specs") {
            self addMenu("specs", "Special Weapons");
            self addOpt("Gold Desert Eagle", ::giveUserWeapon, "deserteaglegold_mp", false);
            self addOpt("Akimbo Thumper", ::giveUserWeapon, "m79_mp", true);
            self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp", false);
            self addOpt("Akimbo Default Weapon", ::giveUserWeapon, "defaultweapon_mp", true);
            self addOpt("OMA Bag", ::giveUserWeapon, "onemanarmy_mp", false);
            self addOpt("Dual OMA Bag", ::giveUserWeapon, "onemanarmy_mp", true);
            }

        else if(menu == "atchmnts")
        {
            weapon = self getcurrentweapon();
            base = maps\mp\_utility::getbaseweaponname(weapon);
            attOpts = getweaponvalidattachments(base);

            self addMenu("atchmnts", "Attachments");
            
            attachmentIDs = strtok("none;acog;reflex;silencer;grip;gl;akimbo;thermal;shotgun;heartbeat;fmj;rof;xmags;eotech;tactical", ";");
            attachmentNames = strtok("No Attachment;ACOG Scope;Red Dot Sight;Silencer;Grip;Grenade Launcher;Akimbo;Thermal;Shotgun;Heartbeat Sensor;FMJ;Rapid Fire;Extended Mags;Holographic Sight;Tactical Knife", ";");

            if(isDefined(attOpts))
            {
                for(a=0;a<attachmentIDs.size;a++)
                {
                    for(i=0;i<attOpts.size;i++)
                    {
                        if(attachmentIDs[a] == attOpts[i])
                            self addOpt( attachmentNames[a], ::GivePlayerAttachment, attachmentIDs[a]);
                    }
                }
            }
            else
                self addOpt("No Valid Attachments");
        }

        else if(menu == "camos") {
            self addMenu("camos", "Camos");          
            self addOpt("Random Camo", ::randomCamo);
            
            camos = strtok("None;Woodland;Desert;Artic;Digital;Urban;Red Tiger;Blue Tiger;Fall", ";");
            for(a=0;a<9;a++)
            self addOpt(camos[a], ::changeCamo, a );
            }

        else if(menu == "lethals") {
            self addMenu("lethals", "Equipment");
            self addOpt("Frag", ::GiveEquipment, "frag_grenade_mp");
            self addOpt("Semtex", ::GiveEquipment, "semtex_mp");
            self addOpt("Throwing Knife", ::GiveEquipment, "throwingknife_mp");
            self addOpt("RH Throwing Knife", ::rhThrowingKnife);
            self addOpt("Tactical Insertion", ::GiveEquipment, "flare_mp");
            self addOpt("Blast Shield", ::blastShield);
            self addOpt("Claymore", ::GiveEquipment, "claymore_mp");
            self addOpt("C4", ::GiveEquipment, "c4_mp");
            self addOpt("Glowstick", ::giveglowstick);
            }

        else if(menu == "tacticals") {
            self addMenu("tacticals", "Special Grenades");
            self addOpt("Flash Grenade", ::GiveSecondaryOffhand, "flash_grenade_mp");
            self addOpt("Stun Grenade", ::GiveSecondaryOffhand, "concussion_grenade_mp");
            self addOpt("Smoke Grenade", ::GiveSecondaryOffhand, "smoke_grenade_mp");
            }

        else if(menu == "afthit") {
            self addMenu("afthit", "Afterhits Menu");

            arIDs = "m4_mp;scar_mp;tavor_mp;masada_mp;fn2000_mp;ak47_mp";
            arNames = "M4A1;SCAR-H;TAR-21;ACR;F2000;AK47";
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = "mp5k_mp;kriss_mp;p90_mp";
            smgNames = "MP5K;Vector;P90";
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            lmgIDs = "sa80_mp;aug_mp";
            lmgNames = "L86 LSW;AUG HBAR";
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = "wa2000_mp;m21_mp";
            srNames = "WA2000;M21 EBR";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            lnchrsIDs = "at4_mp;stinger_mp;javelin_mp";
            lnchrsNames = "AT4-HS;Stinger;Javelin";
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            miscIDs = "model1887_mp;pp2000_mp;briefcase_bomb_defuse_mp;killstreak_ac130_mp";
            miscNames = "Model 1887;PP2000;Bomb Briefcase;Laptop";
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
            }

        else if(menu == "kstrks") {
            self addMenu("kstrks", "Killstreak Menu"); 
            
            Killstreak = strtok("UAV;Care Package;Counter-UAV;Sentry Gun;Predator Missile;Precision Airstrike;Harrier Strike;Attack Helicopter;Emergency Airdrop;Pave Low;Stealth Bomber;Chopper Gunner;AC130;EMP", ";");
            for(a=0;a<level.killstreaks.size;a++)
            self addOpt( Killstreak[a], ::doKillstreak, level.killstreaks[a] );

            if(self ishost() || self isdeveloper())
                self addOpt("Killcam Nuke", ::fakenuke);
            }

        else if(menu == "host") {
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);

            minDistVal = "15;25;50;100;150;200;250";
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);
            self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);

            self addOpt("Fast Restart", ::FastRestart);

            self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnBots);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            botOptNames = "Teleport Bots to Crosshairs;Kick All Bots";
            botOptIDs = "teleport;kick";
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);

            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            }
        self clientOptions();
    }

clientOptions()
{   
    if(self isHost() || self isdeveloper())
    {
        self addMenu("Verify",  "Clients Menu");
        foreach( player in level.players )
        {
            if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                continue;
            perm = "None";
            if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                perm = level.status[player.access];
            
            if (player isDeveloper())
                perm = perm + " ^7| ^6Developer";

            self addOpt(player getname() + " [" + perm + "^7]", ::newmenu, "Verify_" + player getXUID());
        }
        foreach(player in level.players)
        {
            if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                continue;

            perm2 = "None";
            if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                perm2 = level.status[player.access];
            self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
            self addOpt("Kick Player", ::kickSped, player);
            self addOpt("Teleport to Crosshairs", ::teleportToCrosshair, player);  
        }
    }
}

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        while( self.access != 0 )
        {
            if(!self.menu["isLocked"])
            {
                if(!self.menu["isOpen"])
                {
                    if( self isbuttonpressed("+actionslot 2") && self adsButtonPressed() )
                    {
                        self menuOpen();
                        wait .2;
                    }               
                }
                else{
                    if(self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 2"))
                    {
                        if(!self isButtonPressed("+actionslot 1") || !self isButtonPressed("+actionslot 2"))
                        {
                            if(!self isButtonPressed("+actionslot 1"))
                                self.menu[ self getCurrentMenu() + "_cursor" ] += self isButtonPressed("+actionslot 2");
                            if(!self isButtonPressed("+actionslot 2"))
                                self.menu[ self getCurrentMenu() + "_cursor" ] -= self isButtonPressed("+actionslot 1");

                            self scrollingSystem();
                            wait .08;
                        }
                    }
                    else if(self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4")){
                        if(!self isButtonPressed("+actionslot 3") || !self isButtonPressed("+actionslot 4"))
                        {
                            if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                            {
                                if( self isButtonPressed("+actionslot 3") )   
                                    self updateSlider( "L2" );
                                if( self isButtonPressed("+actionslot 4") )    
                                    self updateSlider( "R2" );
                                wait .1;
                            }
                        }
                    }
                    else if( self useButtonPressed() ){
                        player = self.selected_player;
                        menu = self.eMenu[self getCursor()];

                        if( player != self && self isHost() )
                        {
                            player.was_edited = true;
                            self iPrintLnBold( menu.opt + " Has Been Activated" );
                        }
                        
                        if( self.eMenu[ self getCursor() ].func == ::newMenu && self != player )
                            self iPrintLnBold( "^1ERROR: ^7Cannot Access Menus While In A Selected Player" );
                        else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ]))
                        {
                            slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                            if(isDefined(menu.ID_list)) slider = menu.ID_list[slider];
                            else slider = slider;
                            player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                        }
                        else 
                            player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );

                        wait .05;
                        if(IsDefined( menu.toggle ))
                            self setMenuText();
                        if( player != self )
                            self.menu["OPT"]["MENU_TITLE"] settext( self.menuTitle + " ("+ player getName() +")");    
                        wait .15;
                        if( isDefined(player.was_edited) && self isHost() )
                            player.was_edited = undefined;
                    }
                    else if( self meleeButtonPressed() ){
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
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;

        self menuOptions();
        self drawMenu();
        self drawText();
        self setMenuText(); 
        self updateScrollbar();
    }

    menuClose()
    {
        self destroyAll(self.menu["UI"]); 
        self destroyAll(self.menu["OPT"]);
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        self.menu["isOpen"] = false;
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

        self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "gradient_top", 1, 1);
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        resizeMenu();
    }

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"]);
    }

    refreshTitle()
    {
        self.menu["UI"]["MENU_TITLE"] settext(level.MenuName);
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
        if (self getCursor() >= 10) curs = 9;
        else curs = self getCursor();

        self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);

        if(self.eMenu.size > 10) size = 10;
        else size = self.eMenu.size;

        height     = int(15 * size); // 18

        if(self.eMenu.size > 10) math = (180 / self.eMenu.size) * size;
        else math = height - 15;

        position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    } 

    setMenuText()
    {
        self endon("disconnect");
        self menuOptions();
        self resizeMenu();

        if(self getCursor() >= 10) ary = (self getCursor() - 9);
        else ary = 0;

        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        
        for(e=0;e<10;e++)
        {
            self.menu["OPT"][e].x = self.presets["X"] + 61; 
            
            if(isDefined(self.eMenu[ ary + e ].opt))
                self.menu["OPT"][e] settext( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] settext("");
                
            if(IsDefined( self.eMenu[ ary + e ].toggle ))
            {
                self.menu["OPT"][e].x += 0; 
                if (self.eMenu[ary + e].toggle)
                    self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, self.presets["Toggle_BG"], "white", 5, 1);
                else
                    self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, dividecolor(150, 150, 150), "white", 5, 1);
            }
            if(IsDefined( self.eMenu[ ary + e ].val ))
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1);
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1);
                if( self getCursor() == ( ary + e ) )
                    self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }
            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }
            if(self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            {
                self.menu["UI_SLIDE"]["SUBMENU"+e] = self createrectangle( "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y, 9, 9, self.presets["Toggle_BG"], "ui_arrow_right", 5, 1);
                self.menu["UI_SLIDE"]["SUBMENU"+e].foreground = true;
            }
        }
    }
        
    resizeMenu()
    {
        if(self.eMenu.size > 10) size = 10;
        else size = self.eMenu.size;

        height = int(15 * size);

        if(self.eMenu.size > 10) math = (180 / self.eMenu.size) * size;
        else math = height - 15;
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }
/*
    NOTE: YOU DO NOT NEED TO INITIATE THE OVERFLOW FIX.
          EVERYTHING WILL BE HANDLED AUTOMATICALLY WHEN settext IS USED.
    
    - Thanks to AgreedBog for posting the original settext override method

    - CF4_99
*/

settext_hook(text, nsettext)
{
    if(!isDefined(level.strings))
        level.strings = [];
    
    if(!isDefined(level.OverFlowFix))
        level thread overflowfix();

    self.text = text;
    
    if(nsettext)
        self settext(text);
    else
    {
        self notify("stop_TextMonitor");
        self addToStringArray(text);
        self thread watchForOverFlow(text);
    }
}

addToStringArray(text)
{
    if(!InArray(level.strings, text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
}

watchForOverFlow(text)
{
        self endon("stop_TextMonitor");

    while(isDefined(self))
    {
            if(isDefined(text.size))
                self SetText(text, true);
            else
            {
                self SetText(undefined, true);
                self.label = text;
            }
        level waittill("FIX_OVERFLOW");
    }
}

overflowfix()
{
    if(isDefined(level.OverFlowFix))
        return;
    level.OverFlowFix = true;
    
    level.overflow       = NewHudElem();
    level.overflow.alpha = 0;
    level.overflow settext("marker");

    for(;;)
    {
        level waittill("CHECK_OVERFLOW");
        
        if(level.strings.size >= 45)
        {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
        }
    }
}
kickSped(player)
{
   if (!player isHost() || player != self || !player isDeveloper())
        Kick(player GetEntityNumber());
   else
        self iPrintln("^1ERROR: ^7Can't Kick Player");
}    

teleportToCrosshair(player)
{
    if (isAlive(player))
        player setOrigin(bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
}
initializeSetup(access, player)
    {
        if(isDefined(self.access) && access == self.access && !self isHost())
            return;
        if(isDefined(self.access) && self.access == 3)
            return;
        if(isDefined(self.access) && self isdeveloper())
            return;
        if(isDefined(self.access) && self == self)
            return;
        
        if(!isDefined(self.menu))
            self.menu = [];
        if(!isDefined(self.previousMenu))   
            self.previousMenu = [];      
            
        self notify("end_menu");
        self.access = access;
        
        if( self isMenuOpen() )
            self menuClose();

        self.menu         = [];
        self.previousMenu = [];
        self.hud_amount   = 0;

        player.selected_player = player;
        self.menu["isOpen"] = false;
        
        self LoadSettings();

        if( !isDefined(self.menu["current"]) )
            self.menu["current"] = "main";
            
        self menuOptions();
        self thread menuMonitor();
    }

    newMenu( menu, access)
    {
        if(!isDefined( menu ))
        {
            menu = self.previousMenu[ self.previousMenu.size -1 ];
            self.previousMenu[ self.previousMenu.size -1 ] = undefined;
        }
        else 
            self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
            
        self setCurrentMenu( menu );
        self menuOptions();
        self setMenuText();
        self refreshTitle();
        self resizeMenu();
        self updateScrollbar();
    }

    addMenu( menu, title )
    {
        self.storeMenu = menu;
        if(self getCurrentMenu() != menu)
            return;
            
        self.eMenu = [];
        self.menuTitle = title;
        if(!isDefined(self.menu[ menu + "_cursor"]))
            self.menu[ menu + "_cursor"] = 0;
    }

    addOpt( opt, func, p1, p2, p3, p4, p5 )
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

    addToggle( opt, bool, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        
        option = spawnStruct();

        option.toggle = (IsDefined( bool ) && bool);
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
        if(self.storeMenu != self getCurrentMenu())
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
        if(self.storeMenu != self getCurrentMenu())
            return;
        option      = spawnStruct();
        
        if(!IsDefined( RL_list ))
            RL_list = ID_list;

        if(inArray(ID_list)) option.ID_list = ID_list;
        else option.ID_list = strTok(ID_list, ";");

        if(inArray(RL_list)) option.RL_list = RL_list;
        else option.RL_list = strTok(RL_list, ";");

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

    updateSlider( pressed )
    {    
        curs = self getCursor();
        rcurs = self getCursor();

        if(curs >= 10) cap_curs = 9;
        else cap_curs = curs;

        position_x = abs(self.eMenu[ rcurs ].max - self.eMenu[ rcurs ].min) / ((50 - 14));
        
        if( IsDefined( self.eMenu[ rcurs ].ID_list ) )
        {
            value = self.sliders[ self getCurrentMenu() + "_" + rcurs ];
            if( pressed == "R2" ) value++;
            if( pressed == "L2" ) value--;
                
            if( value > self.eMenu[ rcurs ].ID_list.size-1 )   value = 0;
            if( value < 0 ) value = self.eMenu[ rcurs ].ID_list.size-1;

            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = value;
            //count = " ["+ (value+1) +"/"+ (self.eMenu[ rcurs ].RL_list.size) +"]"; // Uncomment this and remove < > if you want the count to be readded
            //self.menu["UI_SLIDE"]["STRING_"+ cap_curs] settext( self.eMenu[ rcurs ].RL_list[ value ] + count );
            self.menu["UI_SLIDE"]["STRING_"+ cap_curs] settext( "< "+ self.eMenu[ rcurs ].RL_list[ value ] +" >" );
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
        
        self.menu["UI_SLIDE"][cap_curs + 10].x = self.menu["UI_SLIDE"][cap_curs].x -38 + (abs(self.sliders[ self getCurrentMenu() + "_" + rcurs ] - self.eMenu[ rcurs ].min) / position_x);
        
        value = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
    
        self.menu["UI_SLIDE"]["VAL"] setValue( value );
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
tptospot(spot)
{
    coords = strTok(spot, ",");
    pos = (int(coords[0]), int(coords[1]), int(coords[2]));
    self setOrigin(pos);
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

setSpawn()
{
    if(!self.savedPos|| self.savedPos)
    {
        self.spawnCoords = self getOrigin(self.origin) + (0, 0, 1);
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
        if( self.snl && self isbuttonpressed("+actionslot 2") && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
            self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        wait 0.05;
    }
}
initNoClip()
{    
    if(!level.oomUtilDisabled)
    {
        if(!self.NoClipT)
        {
            self thread doNoClip();
            self.NoClipT = 1;
        }
        else
        {
            self notify("EndNoClip");
            self.NoClipT = 0;
        }
    }
    else
        self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
}

doNoClip()
{
    self endon("EndNoClip");
        self.Fly = 0;
        UFO = spawn("script_model", self.origin);
        for (;;) 
        {
            if (self FragButtonPressed()) 
            {
                self playerLinkTo(UFO);
                self.Fly = 1;
            } else {
                self unlink();
                self.Fly = 0;
            }
            if (self.Fly == 1) {
                Fly = self.origin + vectorScale(anglesToForward(self getPlayerAngles()), 20);
                UFO moveTo(Fly, .01);
            }
            wait .001;
        }
}

knifeMod(type)
{
    self endon("disconnect");

    if(type == "pred")
    {
        if(!self.predKnife)
        {
            if(isDefined(self.riotKnife) && self.riotKnife)
                self.riotKnife = 0;

            self.predKnife = 1;
        }
        else if(self.predKnife)
            self.predKnife = 0;
                   
        while(self.predKnife) 
        {
            self notifyonPlayercommand("predknife", "+melee");
            self waittill("predknife");
            if (self GetCurrentWeapon() == self.primaryWeapon && self.predKnife && !self.menu["isOpen"]) 
            {
                x = self.primaryWeapon;
                y = self.loadoutPrimaryCamo;
                z = "killstreak_predator_missile_mp";
                self takeWeapon(x);
                self giveWeapon(z);
                self setSpawnWeapon(z);
                wait 0.6;
                self takeWeapon(z);
                self GiveWeapon(x, y);
                self switchToWeapon(x);
            }
        }
    }
    else if(type == "shield")
    {
        if(!self.riotKnife)
        {
            if(isDefined(self.predKnife) && self.predKnife)
                self.predKnife = 0;

            self.riotKnife = 1;
        }
        else if(self.riotKnife)
            self.riotKnife = 0;

        while(self.riotKnife)
        {
            self notifyonPlayercommand("riotKnife", "+melee");
            self waittill("riotKnife");
            if (self GetCurrentWeapon() == self.primaryWeapon && self.riotKnife && !self.menu["isOpen"]) 
            {
                x = self.primaryWeapon;
                y = self.loadoutPrimaryCamo;
                z = "riotshield_mp";
                self takeWeapon(x);
                self giveWeapon(z);
                self setSpawnWeapon(z);
                wait 0.7;
                self takeWeapon(z);
                self GiveWeapon(x, y);
                self switchToWeapon(x);
            }
        }
    }
}


lazyeletggl() 
{
    if(!self.lazyEles)
    {
        self.lazyEles = 1;
        self thread lazyele();
    }
    else if(self.lazyEles)
    {
        self notify ("stop_lzEle");
        self.lazyEles = 0;
    }
}

lazyele()
{
    self endon("stop_lzEle");

    for(;;)
    {
        while (self getStance() != "crouch") 
            wait .01;
        while (self getStance() != "stand") 
            wait .01;
            
        x = self.origin[0];
        z = self.origin[1];
        
        if (x > 0)
            x += 0.15;
        else
            x -= 0.15;
        if (z > 0)
            z += 0.15;
        else
            z -= 0.15;
        self setOrigin((int(x), int(z), self.origin[2]));
        wait .01;
    }
}

DolphinDive()
{
 if(!IsDefined( self.DolphinDive ))
    {
         self.DolphinDive = true;
            
         while(IsDefined( self.DolphinDive ))
         {
             self.Prone360 = true;
             setDvar("bg_prone_yawcap", 360);
            
            if(self isSprinting())
            {
                vec = AnglesToForward( self GetPlayerAngles() );
                end = ( vec[0] * 110,vec[1] * 110,vec[2] * 110 );
                    
                if(self GetStance() == "crouch" && self IsOnGround())
                {
                    self SetStance( "prone" );
                    self SetVelocity( self GetVelocity() + end + (0, 0, 300) );
                        
                    while(1)
                    {
                        if(self IsOnGround())
                        break;
                        wait .05;
                    }
                }
            }
            wait .05;
        }
    }    
    else
        self.DolphinDive = undefined; 
}

isSprinting()
{
  v = self GetVelocity();
        
  return v[0] >= 190 || v[1] >= 190 || v[0] <= -190 || v[1] <= -190;
}

monitortrampoline(model)
{
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        if (!isDefined(model))
            break;
        if (distance(self.origin, model.origin) < 85)
            self setVelocity(self getVelocity() + (0, 0, 200));

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
            break;

        for (i = 0; i < level.players.size; i++)
        {
            player = level.players[i];

            if (isDefined(slideEntity) && player isInPos(slideEntity.origin) && player meleeButtonPressed() && !self.menu["isOpen"])
            {
                player setOrigin(player getOrigin() + (0, 0, 10));
                playngles2 = anglesToForward(player getPlayerAngles());
                x = 0;

                player setVelocity(player getVelocity() + (playngles2[0] * 750, playngles2[1] * 750, 0));

                while (x < 15)
                {
                    player setVelocity(player getVelocity() + (0, 0, 100));
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

SpawnScriptModel(origin,model,angles,time,clip)
{
    if(isDefined(time))
        wait time;
    ent = spawn("script_model",origin);
    ent SetModel(model);
    if(isDefined(angles))
        ent.angles = angles;
    if(isDefined(clip))
        ent CloneBrushModelToScriptModel(clip);
    return ent;
}

doSpawnOption(selection)
{
        if(selection == "spawnBounce")
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
    
            self.spawnedTrampoline = spawn("script_model", self.origin);
            self.spawnedTrampoline setModel("com_plasticcase_enemy");
            self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
        }
        else if(selection == "deleteBounce")
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
        else if(selection == "spawnSlide")
        {
            if (isDefined(self.slideThread))
            {
                self.slideThread delete();
                self.slideThread = undefined;
            }
            if (isDefined(self.spawnedSlide))
            {
                self.spawnedSlide delete();
                self.spawnedSlide = undefined;
            }

            slideOrigin = (bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,0,self)["position"] + (0, 0, 20));
            self.spawnedSlide = spawnscriptmodel(slideOrigin, "com_plasticcase_enemy", self.spawnedSlide.angles, (0,0,0), level.airdropcratecollision);
            self.spawnedSlide.angles = (60, self getPlayerAngles()[1] - 180, 0);
            self.slideThread = self thread makeSlide(self.spawnedSlide);
        }
        else if(selection == "deleteSlide")
        {
            if (isDefined(self.slideThread))
            {
                self.slideThread delete();
                self.slideThread = undefined;
            }
            if (isDefined(self.spawnedSlide))
            {
                self.spawnedSlide delete();
                self.spawnedSlide = undefined;
            }
        }
        /*
        else if(selection == "platform")
        {
            if(!level.oomUtilDisabled)
            {
                if(!isDefined(self.spawnedplat))
                self.spawnedplat = [];
        
                location = self.origin;
    
                if(isDefined(self.spawnedplat))
                {
                    for(i = -3; i < 3; i++)
                    {
                        if(!isDefined(self.spawnedplat[i]))
                            continue;
                
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(self.spawnedplat[i][d]))
                                self.spawnedplat[i][d] delete();
                        }
                    }
                }
    
                startpos = location + (0, 0, -15);
    
                for(i = -3; i < 3; i++)
                {    
                    if(!isDefined(self.spawnedplat[i]))
                        self.spawnedplat[i] = [];
            
                    for(d = -3; d < 3; d++)
                        self.spawnedplat[i][d] = spawnScriptModel(startpos + (d * 56, i * 30, 0),"com_plasticcase_enemy",(0,0,0),0,level.airDropCrateCollision);
                }
            }
            else
                self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
        }
        else if(selection == "crate")
        {
            if(!level.oomUtilDisabled)
            {
                if (isDefined(self.spawnedcrate))
                {
                    self.spawnedcrate delete();
                    self.spawnedcrate = undefined;
                }
                self.spawnedcrate = spawnscriptmodel(self.origin + (0, 0, -15), "com_plasticcase_enemy", (0,0,0), 
                                                0, level.airdropcratecollision);
            }
            else
                self iprintln("^1ERROR^7: Crate Spawning is[^1Disabled^7]!");
        }
        */
}
instashoot()
{
    if(!self.instashoot)
    {
        self.instashoot = 1;

        while(self.instashoot)
        {
            self waittill("weapon_change");
            self disableWeapons();
            wait 0.01;
            self enableWeapons();
            wait 0.01;
        }
    }
    else if( self.instashoot)
        self.instashoot = 0;
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

        else if(self.currCan && self.currCanWpn == self getCurrentWeapon())
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
    weapon = self.currcanwpn;

    while(self.currCan)
    {
        self waittill("weapon_change", weapon);
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
        self.deaths  = 13;
        self.assists = 2;
        self.pers["pointstowin"] = 28;
        self.pers["kills"] = 28;
        self.pers["score"] = 1400;
        self.pers["deaths"] = 13;
        self.pers["assists"] = 2;
    }
}
createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel)
    {
        if(isDefined(isLevel))
            textElem = level maps\mp\gametypes\_hud_util::createServerFontString(font, fontScale);
        else 
            textElem = self maps\mp\gametypes\_hud_util::createFontString(font, fontScale);

        textElem maps\mp\gametypes\_hud_util::setPoint(align, relative, x, y);
        textElem.hideWhenInKillcam = true;
        textElem.hideWhenInMenu = true;
        textElem.foreground = true;
        textElem.archived = false;
    	if( self.hud_amount >= 19 ) 
        	textElem.archived = true;

        textElem.sort = sort;
        textElem.alpha = alpha;
        if(color != "rainbow")
            textElem.color = color;

        textElem settext(text);
        return textElem;
    }

    createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
    {
        if(isDefined(server))
            boxElem = newHudElem();
        else
            boxElem = newClientHudElem(self);

        boxElem.elemType = "icon";
        if(color != "rainbow")
            boxElem.color = color;

        boxElem.hideWhenInMenu = true;
        boxElem.archived = true;
        if( self.hud_amount >= 19 ) 
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
        boxElem maps\mp\gametypes\_hud_util::setPoint(align, relative, x, y);
        boxElem thread watchDeletion( self );
        
        self.hud_amount++;
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

    divideColor(c1,c2,c3)
    {
        return(c1/255,c2/255,c3/255);
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

    refreshMenuToggles()
    {
        foreach(player in level.players)
            if(player hasMenu() && player isMenuOpen())
                player setMenuText();
    }

    refreshMenu(skip, previous, current)
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
        
        if(!IsDefined( skip ))
        {
            self waittill( "reopen_menu" );
            wait .1;
        }
        else wait .05;
        
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

    hasMenu()
    {
        if( IsDefined( self.access ) && self.access != "None" )
            return true;
        return false;    
    }

    lockMenu( which, type )
    {
        if(toLower(which) == "lock")
        {
            if(self isMenuOpen() && toLower(type) != "open")
            {
                current  = self getCurrentMenu();
                previous = self.previousMenu;
                for(e = previous.size; e > 0; e--)
                    self newMenu();
                self menuClose(); 
            }
            self.menu["isLocked"] = true;
        }
        else 
        {
            if(!self isMenuOpen() && toLower(type) == "open")
                self menuOpen();
            else     
                self setMenuText();    
            self.menu["isLocked"] = false;
            self notify("menu_unlocked");
        }
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

    settextFX(text,time)
    {
        if(!isDefined(time))
            time = 3;
            
        self settext(text);
        self thread hudFade(1,.5);
        self SetPulseFx(int(1.5 * 25), int(time * 1000), 1000);
        wait time;
        self hudFade(0, .5);
        self destroy();
    }

    doOption(func, p1, p2, p3, p4, p5, p6)
    {
        if(!isdefined(func))
            return;
        
        if(isdefined(p6))
            self thread [[func]](p1,p2,p3,p4,p5,p6);
        else if(isdefined(p5))
            self thread [[func]](p1,p2,p3,p4,p5);
        else if(isdefined(p4))
            self thread [[func]](p1,p2,p3,p4);
        else if(isdefined(p3))
            self thread [[func]](p1,p2,p3);
        else if(isdefined(p2))
            self thread [[func]](p1,p2);
        else if(isdefined(p1))
            self thread [[func]](p1);
        else
            self thread [[func]]();
    }
        
    sponge_text( string )
    {
        sponge = "";
        for(e=0;e<string.size;e++)
        {
            if (e % 2 == 0)  // even index → uppercase
                sponge += toUpper(string[e]);
            else             // odd index → lowercase
                sponge += toLower(string[e]);
        }
        return sponge;
    }

    toUpper( string )
    {
        if( !isDefined( string ) || string.size <= 0 )
            return "";
        alphabet = strTok("A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;0;1;2;3;4;5;6;7;8;9; ;-;_", ";");
        final    = "";
        for(e=0;e<string.size;e++)
            for(a=0;a<alphabet.size;a++)
                if(IsSubStr(toLower(string[e]), toLower(alphabet[a])))         
                    final += alphabet[a];
        return final;            
    }


    MonitorButtons()
    {
        if(isDefined(self.MonitoringButtons))return;
        self.MonitoringButtons = true;
        
        if(!isDefined(self.buttonAction))
            self.buttonAction = strTok("+stance,+gostand,weapnext,+actionslot 1,+actionslot 2,+actionslot 3,+actionslot 4",",");
        if(!isDefined(self.buttonPressed))
            self.buttonPressed = [];
        
        for(a=0;a<self.buttonAction.size;a++)
            self thread ButtonMonitor(self.buttonAction[a]);
    }

    ButtonMonitor(button)
    {
        self endon("disconnect");
        
        self.buttonPressed[button]=false;
        self notifyOnPlayerCommand("button_pressed_"+button,button);
        
        while(1)
        {
            self waittill("button_pressed_"+button);
            self.buttonPressed[button]=true;
            wait .025;
            self.buttonPressed[button]=false;
        }
    }

    isButtonPressed(button)
    {
        return self.buttonPressed[button];
    }

    isDeveloper()
    {
        if(self getxuid() == "901fc5263b283")
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
