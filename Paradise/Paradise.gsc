#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\killstreaks\_killstreaks;
#include maps\mp\gametypes\_globallogic;

init()
{
	level.status[0] = "None";
	level.status[1] = "^2Verified";
	level.status[2] = "^5CoHost";
	level.status[3] = "^1Host";
    level.MenuName = "Paradise";
    level.currentGametype      = getDvar("g_gametype");
    level.currentMapName       = getDvar("mapName");
    level.callDamage           = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::modifyPlayerDamage;
    level.lastKill_minDist     = 15;
    init_Dvars();
    setDvar("host_team", self.team);
    precacheshader("ui_arrow_right");
    precacheshader("line_horizontal");
    precacheshader("rank_prestige09");
    lower_barriers();
    removehighbarrier();
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
            self loadLoadout();
        self thread botsGetKnives();

        //everything above this will run every spawn
        if(IsDefined( self.playerSpawned ))
            continue;   
        self.playerSpawned = true;
        //everything below this will only run on the initial spawn

        if(!self.pers["isBot"])
        {
            self thread watermark();
            self dowelcomemessage();

            if(self isHost())
            {
                self thread initializesetup(4, self); //Host

		        if(level.currentGametype == "sd")
                    setDvar("host_team", self.team);
            }
            else if(self isDeveloper() && !self isHost())
                self thread initializesetup(3, self); //CoHost
            else
                self thread initializesetup(1, self); //Verified

            self FreezeControls(false);
            self setclientuivisibilityflag("g_compassShowEnemies", 1);
            self.uav = false;
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
            if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"])
                iDamage = 999;
            
            else
                iDamage = 0;
        }
        // Handle sniper kills for players with less than 29 kills
        else if(eAttacker.kills < 29)
        {
            if(isDamageWeapon(sWeapon))
                iDamage = 999;  
        }
        // Special handling for the 29th kill
        else if(eAttacker.kills == 29)
        {
            if(dist >= level.lastKill_minDist)
            {
                if(isDamageWeapon(sWeapon) && !eAttacker isOnGround())
                {
                    iprintln("^2" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                    iDamage = 999;
                }
                else if(IsSubstr( sWeapon, "hatchet" ) || IsSubstr( sWeapon, "knife_ballistic" ))
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
        if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
        {
            if(isAlive(self) && !self.pers["isBot"] && (issubstr(sWeapon, "frag_grenade_mp") || issubstr(sWeapon, "sticky_grenade_mp")))
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
            if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"])
                iDamage = 999;
            
            else
                iDamage = 0;
        }

        hostTeam  = getdvar("host_team");
        enemyTeam = getOtherTeam(eAttacker.team);

        if(getTeamPlayersAlive(enemyTeam) > 1)
        {
            if(isDamageWeapon(sWeapon))
                iDamage = 999;
        }
        else if(getTeamPlayersAlive(enemyTeam) == 1)
        {
            if(dist >= level.lastKill_minDist && !eAttacker isOnGround() && isDamageWeapon(sWeapon))
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
                self thread semtex_bounce_physics(vDir);
                iDamage = 1;
            }
        }
        return [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
    }
}
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
	case "as50":
   		return 1;
	default:
		return 0;
    }
}

init_Dvars()
{
    setDvar("sv_cheats", 1);   
    setDvar("jump_slowdownEnable", 0);
    setdvar("bg_ladder_yawcap", 360 );
    setdvar("bg_prone_yawcap", 360 );
    setdvar("player_breath_gasp_lerp", 0 );
    setdvar("player_clipSizeMultiplier", 1 );
    setdvar("perk_bulletPenetrationMultiplier", 100 );
    setDvar("bg_surfacePenetration", 9999 );
    setDvar("bg_bulletRange", 99999 );
    setdvar("penetrationcount",999 );
    setdvar("sv_superpenetrate", 1 );
    setdvar("perk_weapSpreadMultiplier", 0.45);
}

mainBinds()
{
    self endon("disconnect");
    
    for(;;)
    {
        if(self getStance() == "prone" && self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
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
    weap = "hamr_mp";
    self giveweapon(weap);
    self dropitem(weap);
}

refillAmmo()
{
    self givemaxammo(self getprimary());
    self givemaxammo(self getsecondary());
    self givestartammo(self getcurrentoffhand());
    self givestartammo(self getoffhandsecondaryclass());
    wait .4;
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
                if(self.kills == 29 && isAlive(nearestplayer) && isDamageWeapon(self getcurrentweapon()))
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
    weapons[0] = "fiveseven_mp";
    weapons[1] = "fnp45_mp";
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
        self waittill("changed_class");
        self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
        wait .1;
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

    if(level.currentGametype == "dm")
    {
        while(level.players.size < 18)
            spawnBots(1);
    }
    else if(level.currentGametype == "sd")
    {
        if(GetAliveCountForTeam(!hostTeam) <= 1)
            spawnBots(3, !hostTeam);
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
LoadSettings()
{
    self.presets = [];

    self.presets["X"] = 155; // 145
    self.presets["Y"] = -20; // 0

    self.presets["Option_BG"] = dividecolor(0, 0, 0);
    self.presets["Title_BG"] = dividecolor(255, 255, 255); 
    self.presets["ScrollerIcon_BG"] = dividecolor(255, 255, 255);
    self.presets["Outline_BG"] = dividecolor(0, 0, 0);
    self.presets["KB_Outline"] = "rainbow";
    self.presets["Text"] = dividecolor(255, 255, 255);
    self.presets["Option_Font"] = "default";
    
    self.presets["Font_Scale"] = 1;

    self.presets["Toggle_BG"] = dividecolor(26, 148, 49);
    self.presets["MenuTitle_Color"] = dividecolor(26, 148, 49);
    self.presets["Scroller_BG"] = dividecolor(26, 148, 49);
    self.presets["Scroller_Shader"] = "line_horizontal";
    self.presets["Scroller_ShaderIcon"] = "rank_prestige09";
}

displayVer()
{
    self endon( "disconnect");
    Instructions = createFontString("objective", 1.20 );
    Instructions setPoint( "TOPRIGHT", "TOPRIGHT", 15, -25);

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
    else
        self iprintlnbold("^1Paradise does not support this gamemode!");
}
watermark()
{
    self endon("disconnect");
    self endon("game_ended");

    wm = self createFontString("objective", 1);

    wm.x = -340;
    wm.y = 430;

    wm.alpha = 1; 
    wm settext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
    self thread monitorMenuState(wm);
    
    return wm;
}

monitorMenuState(wm)
{
    self endon("disconnect");
    self endon("game_ended");
    for(;;)
    {
        wait 0.05; 

        if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
            wm settext("[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
        else
            wm settext("[{+speed_throw}] + [{+actionslot 2}] = Paradise");
    }
}
 menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        switch(menu)
{
    case "main":
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
        break;

    // TRICKSHOT MENU
    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+smoke}]", self.NoClipT, ::initNoClip);

			canOpts = [];
			canOpts[0] = "Current";
			canOpts[1] = "Infinite";
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);

			spawnOptionsActions = [];
			spawnOptionsActions[0] = "Bounce";
			spawnOptionsActions[1] = "Platform";
			spawnOptionsActions[2] = "Crate";
            
            spawnOptionsIDs = [];
            spawnOptionsIDs[0] = "bounce";
            spawnOptionsIDs[1] = "platform";
            spawnOptionsIDs[2] = "crate";
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

    // BINDS MENU
    case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
            self addOpt("Third Eye Bind", ::newMenu, "tEye");
            break;

    case "tEye":
            self addMenu("tEye", "Third Eye Bind");
            self addOpt("Third Eye Bind: [{+actionslot 1}]", ::empbind, 1);
            self addOpt("Third Eye Bind: [{+actionslot 2}]", ::empbind, 2);
            self addOpt("Third Eye Bind: [{+actionslot 3}]", ::empbind, 3);
            self addOpt("Third Eye Bind: [{+actionslot 4}]", ::empbind, 4);
            break;

        case "gflip":  // Mid Air GFlip Bind submenu
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            break;

        case "nmod":  // Nac Mod Bind submenu
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            break;

        case "skree":  // Skree Bind submenu
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            break;

        case "cnzm":  // Can Zoom Bind submenu
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            break;

        case "cb":  // Change Class Bind submenu
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 1}]",  ::class1);
            self addOpt("Bind Class 2: [{+actionslot 1}]",  ::class2);
            self addOpt("Bind Class 3: [{+actionslot 1}]",  ::class3);
            self addOpt("Bind Class 4: [{+actionslot 1}]",  ::class4);
            self addOpt("Bind Class 5: [{+actionslot 1}]",  ::class5);
            break;

    // TELEPORT MENU
    case "tp": 
            self addMenu("tp", "Teleport Menu");
            self addOpt("Set Spawn",::setSpawn);
            self addOpt("Unset Spawn", ::unsetSpawn);
            self addToggle("Save & Load", self.snl, ::saveandload);
            
            tpNames = [];
            tpCoords = [];
            if(getDvar("mapname") == "mp_la")
            {       
            	tpNames[0] = "Garage Rooftop";
            	tpNames[1] = "Inside Garage";
            	tpNames[2] = "Plaza Building";
            	tpNames[3] = "Undermap Sui";
            	tpNames[4] = "Agora Ledge";
            	
            	tpCoords[0] = (-670.031, -1063.55, 111.657);
            	tpCoords[1] = (1112.69, 76.0562, 115.125);
            	tpCoords[2] = (1496.2, 3863.82, 133.125);
            	tpCoords[3] = (-634.048, 7441.26, -463.887);
            	tpCoords[4] = (-1778.4, 5631.22, 51.3185);
            }
            if(getDvar("mapname") == "mp_dockside")
            {
                tpNames[0] = "Out of Map Building";
                tpNames[1] = "Out of Map Ledge";

                tpCoords[0] = (-624.898, 5597.46, 231.779);
                tpCoords[1] = (-10606.7, 2978.56, -54.2118);
            }
            else if(getDvar("mapname") == "mp_carrier")
            {       
                tpNames[0] = "Undermap Sui";
                tpNames[1] = "Way Out Net";
                tpNames[2] = "Helipad";

                tpCoords[0] = (-4941.43, -1153.81, -163.875);
                tpCoords[1] = (2040.76, 836.045, 70.5574);
                tpCoords[2] = (-177.286, -1350.64, -267.875);
            }
            else if(getDvar("mapname") == "mp_drone")
            {
                tpNames[0] = "Hill Top Sui";
                tpNames[1] = "End of Tunnel Sui";
                tpNames[2] = "Inside Rock Sui";

                tpCoords[0] = (-19462.7, -2026.44, -1809.66);
                tpCoords[1] = (-347.772, 8793.04, 316.212);
                tpCoords[2] = (15425.4, -3109.07, 4333.52);
            }   
            else if(getDvar("mapname") == "mp_express")
            {
                tpNames[0] = "Bomb Spawn Roof";
                tpNames[1] = "Defenders Spawn Roof";
                tpNames[2] = "Powerlines";
                tpNames[3] = "Powerlines 2";
                tpNames[4] = "Powerlines 3";
                tpNames[5] = "Top Roof 1";
                tpNames[6] = "Top Roof 2";
                tpNames[7] = "Drop Off Sui";
                tpNames[8] = "End of Tunnel 1";
                tpNames[9] = "End of Tunnel 2";

                tpCoords[0] = (-10.5211, 2375.24, 150.793);
                tpCoords[1] = (-24.6459, -2331.52, 155.49);
                tpCoords[2] = (-3948.26, 4425.08, 1220.14);
                tpCoords[3] = (-6756.28, -2024.63, 1392.56);
                tpCoords[4] = (-7042.23, -7373.21, 1392.85);
                tpCoords[5] = (4073.33, -2969.08, 92.2084);
                tpCoords[6] = (3637.17, 2872.82, 170.579);
                tpCoords[7] = (4675.43, 5027.02, 678.605);
                tpCoords[8] = (5612.52, 3459.54, -793.319);
                tpCoords[9] = (5551.98, -3458.61, -777.233);
            }
            else if(getDvar("mapname") == "mp_hijacked")
            {
                tpNames[0] = "Top of Barrier";
                tpNames[1] = "Top of Barrier 2";

                tpCoords[0] = (6336.61, -45.2595, 16137.9);
                tpCoords[1] = (-6175.68, 808.258, 16131.3);
            }
            else if(getDvar("mapname") == "mp_overflow")
            {
                tpNames[0] = "Impossible Shot";

                tpCoords[0] = (28568, 7357.5, 1873.19);
            }
else if(getDvar("mapname") == "mp_nightclub")
{
    tpNames[0] = "Top of Barrier";

    tpCoords[0] = (-19462.7,-2026.44, -1809.66);
}
else if(getDvar("mapname") == "mp_raid")
{
    tpNames[0] = "Sui Roof";
    tpNames[1] = "Basketball Court Roof";
    tpNames[2] = "Sui Tree Spot";
    tpNames[3] = "Other Tree Spot";

    tpCoords[0] = (2852.81, 4544.64, 265.129);
    tpCoords[1] = (-104.969, 3769.45, 240.125);
    tpCoords[2] = (1814.13, 957.054, 432.095);
    tpCoords[3] = (2721.5, 4763.77, 137.625);
}
else if(getDvar("mapname") == "mp_slums")
{
    tpNames[0] = "Bomb Spawn Roof";
    tpNames[1] = "B Roof";
    tpNames[2] = "Soccer Field Roof";
    tpNames[3] = "Out of Map Roof";
    tpNames[4] = "Edge of Map Sui";

    tpCoords[0] = (-2499.07, 4351.68, 1297.82);
    tpCoords[1] = (1732.51, -1828.43, 896.125);
    tpCoords[2] = (145.815, -6037.59, 991.738);
    tpCoords[3] = (-2850.07,-3227.78, 1175.54);
    tpCoords[4] = (-7128.08, -548.743, 1192.19);
}
else if(getDvar("mapname") == "mp_village")
{
    tpNames[0] = "Hill Top 1";
    tpNames[1] = "Hill Top 2";
    tpNames[2] = "Hill Top 3";
    tpNames[3] = "Out of Map Roof";
    tpNames[4] = "Top of Barrier";
    tpNames[5] = "Barn Ledge";

    tpCoords[0] = (-1411.22, 16745.9, 4101.9);
    tpCoords[1] = (-10215.6, 15513.1, 3895.12);
    tpCoords[2] = (-1356.28, 3736.36, 288.111);
    tpCoords[3] = (2075.27, -1293.44, 913.854);
    tpCoords[4] = (26799.9, 8815.1,2471.32);
    tpCoords[5] = (856.266, 1548.07, 222.173);
}
else if(getDvar("mapname") == "mp_turbine")
{
    tpNames[0] = "Inside Turbine";
    tpNames[1] = "Stone Path";
    tpNames[2] = "Top of Bridge";
    tpNames[3] = "Out of Map Cliff";

    tpCoords[0] = (-864.64, 1384.38, 832.125);
    tpCoords[1] = (-1234.51, -3150.97, 440.166);
    tpCoords[2] = (-200.276, 3195.93, 607.911);
    tpCoords[3] = (-207.78, -633.604, -562.192);
}
else if(getDvar("mapname") == "mp_socotra")
{
    tpNames[0] = "Defenders Spawn Roof";
    tpNames[1] = "A Barrier";
    tpNames[2] = "Staircase Spot";
    tpNames[3] = "Out of Map Roof";
    tpNames[4] = "Out of Map Sui";

    tpCoords[0] = (818.847, 2835.1, 1165.13);
    tpCoords[1] = (2466.79, 1417.62, 1132.13);
    tpCoords[2] = (1448.92, 2711.74, 481.618);
    tpCoords[3] = (-2136.67,-458.23, 623.151);
    tpCoords[4] = (-2806.68, 4511.62, 124.697);
}
else if(getDvar("mapname") == "mp_nuketown_2020")
{
    tpNames[0] = "Defenders Spawn Roof";
    tpNames[1] = "Purple House Sui";
    tpNames[2] = "RC-XD Track Barrier";
    tpNames[3] = "Under Map Sui";
    tpNames[4] = "Greenhouse Sui";

    tpCoords[0] = (-1544.37, -1190.4, 66.425);
    tpCoords[1] = (2313.04, 1383.95, 123.136);
    tpCoords[2] = (65.946, 2442.77, 332.652);
    tpCoords[3] = (51.3779, -1670.54, 186.523);
    tpCoords[4] = (-1786.16, 1227.62, 91.9677);
}
else if(getDvar("mapname") == "mp_downhill")
{
    tpNames[0] = "Top Half Pipe";
    tpNames[1] = "Top Half Pipe 2";
    tpNames[2] = "Barrier";
    tpNames[3] = "Barrier 2";
    tpNames[4] = "Mountain Sui";

    tpCoords[0] = (-445.155, -6253.96, 1875.99);
    tpCoords[1] = (618.708, -6218.16, 1882.27);
    tpCoords[2] = (3109.17, 656.519, 1536.13);
    tpCoords[3] = (-1430.35, 9408.64, 2597.38);
    tpCoords[4] = (-8987.19, 327.561, 2942.54);
}
else if(getDvar("mapname") == "mp_mirage")
{
    tpNames[0] = "Under Map Sui";

    tpCoords[0] = (299.493, 3580.54, -288.084);
}
else if(getDvar("mapname") == "mp_hydro")
{
    tpNames[0] = "Bomb Spawn Sui";
    tpNames[1] = "Bomb Spawn Bridge";
    tpNames[2] = "Defenders Spawn Sui";
    tpNames[3] = "Defenders Spawn Bridge";

    tpCoords[0] = (3379.91, 3255.91, 216.125);
    tpCoords[1] = (7962.86, 22554.8, 8040.13);
    tpCoords[2] = (-3333.74, 4064.11, 216.125);
    tpCoords[3] = (-11819.2, 22546.4, 8040.13);
}
else if(getDvar("mapname") == "mp_skate")
{
    tpNames[0] = "Undermap Sui";

    tpCoords[0] = (3317.06, -58.111, -19.875);
}
else if(getDvar("mapname") == "mp_concert")
{
    tpNames[0] = "Center Stadium Barrier";
    tpNames[1] = "A Stadium Barrier";
    tpNames[2] = "Defenders Undermap";

    tpCoords[0] = (63.2687, 3551.01, 448.125);
    tpCoords[1] = (-2913.65, 1931.51, 448.125);
    tpCoords[2] = (-1849.62, 527.147, -419.875);
}
else if(getDvar("mapname") == "mp_magma")
{
    tpNames[0] = "Lava Barrier";
    tpNames[1] = "Undermap Sui";
    tpNames[2] = "OOM Barrier";

    tpCoords[0] = (112.567, -1921.86, -305.969);
    tpCoords[1] = (3614.09, 1368.04, -831.875);
    tpCoords[2] = (-1248.7, -3339.31, 14.125);
}
else if(getDvar("mapname") == "mp_vertigo")
{
    tpNames[0] = "Skyscraper Sui";
    tpNames[1] = "Helipade Barrier";
    tpNames[2] = "OOM Helipad 1";
    tpNames[3] = "OOM Helipad 2";
    tpNames[4] = "Building Ledge";

    tpCoords[0] = (4223.33, 401.677, 1856.13);
    tpCoords[1] = (-2816.21, -75.111, 624.125);
    tpCoords[2] = (4227.99, -2380.09, -319.875);
    tpCoords[3] = (4052.68, 3363.54, -319.875);
    tpCoords[4] = (-14.5213,-2853.14,-2440.15);
}
else if(getDvar("mapname") == "mp_studio")
{
    tpNames[0] = "Defenders Spawn OOM";
    tpNames[1] = "Mid Map Sui";

    tpCoords[0] = (538.681, -1569.16, 220.093);
    tpCoords[1] = (558.137, 846.333, 145.502);
}
else if(getDvar("mapname") == "mp_detour")
{
    tpNames[0] = "Bomb Spawn Bus Sui";
    tpNames[1] = "OOM Sui";

    tpCoords[0] = (-3585.75, -735.356, 223.125);
    tpCoords[1] = (3951.57, 447.974, -13.8756);
}
else if(getDvar("mapname") == "mp_castaway")
{
    tpNames[0] = "Top of Barrier 1";
    tpNames[1] = "Top of Barrier 2";

    tpCoords[0] = (707.339,5926.26, 1604.02);
    tpCoords[1] = (2099.6, -4079.84, 1604.26);
}
else if(getDvar("mapname") == "mp_dig")
{
    tpNames[0] = "Ledge";
    tpNames[1] = "Undermap Sui";
    tpNames[2] = "Top of Tower";

    tpCoords[0] = (-1230.85, 2097.92, 514.771);
    tpCoords[1] = (-2150.26, -373.214, -229.744);
    tpCoords[2] = (383.11, 1591.54, 738.638);
}
else if(getDvar("mapname") == "mp_pod")
{
    tpNames[0] = "Top of Pod";
    tpNames[1] = "Top of Pod 2";

    tpCoords[0] = (-3585.75, -735.356, 223.125);
    tpCoords[1] = (-332.219, 3108.55, 1553.93);
}
            
            else
            {
                self addOpt("tp", "No Custom Teleports");
            }
            self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            break;

   case "class":  // Class Menu
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "attach");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Lethals", ::newMenu, "lethals");
            self addOpt("Tacticals", ::newMenu, "tacticals");
            self addToggle("Save Current Loadout", self.saveLoadoutEnabled, ::saveloadouttoggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons Classes");

arIDs[0] = "tar21_mp";
arIDs[1] = "type95_mp";
arIDs[2] = "sig556_mp";
arIDs[3] = "sa58_mp";
arIDs[4] = "hk416_mp";
arIDs[5] = "scar_mp";
arIDs[6] = "saritch_mp";
arIDs[7] = "xm8_mp";
arIDs[8] = "an94_mp";

arNames[0] = "MTAR";
arNames[1] = "Type 95";
arNames[2] = "Swat 556";
arNames[3] = "FAL OSW";
arNames[4] = "M27";
arNames[5] = "Scar-H";
arNames[6] = "SMR";
arNames[7] = "M8A1";
arNames[8] = "AN-94";

self addSliderString("Assault Rifles", arIDs, arNames, ::giveuserweapon);

smgIDs[0] = "mp7_mp";
smgIDs[1] = "pdw57_mp";
smgIDs[2] = "vector_mp";
smgIDs[3] = "insas_mp";
smgIDs[4] = "qcw05_mp";
smgIDs[5] = "evoskorpion_mp";
smgIDs[6] = "peacekeeper_mp";

smgNames[0] = "MP7";
smgNames[1] = "PDW-57";
smgNames[2] = "Vector K10";
smgNames[3] = "MSMC";
smgNames[4] = "Chicom CQB";
smgNames[5] = "Skorpion EVO";
smgNames[6] = "Peackeeper";

self addSliderString("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

lmgIDs[0] = "mk48_mp";
lmgIDs[1] = "qbb95_mp";
lmgIDs[2] = "lsat_mp";
lmgIDs[3] = "hamr_mp";

lmgNames[0] = "MK48";
lmgNames[1] = "QBB LSW";
lmgNames[2] = "LSAT";
lmgNames[3] = "HAMR";

self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);

sgIDs[0] = "870mcs_mp";
sgIDs[1] = "saiga12_mp";
sgIDs[2] = "ksg_mp";
sgIDs[3] = "srm1216_mp";

sgNames[0] = "Remington 870 MCS";
sgNames[1] = "S12";
sgNames[2] = "KSG";
sgNames[3] = "M1216";

self addSliderString("Shotguns", sgIDs, sgNames, ::giveuserweapon);

srIDs[0] = "svu_mp";
srIDs[1] = "dsr50_mp";
srIDs[2] = "ballista_mp";
srIDs[3] = "as50_mp";

srNames[0] = "SVU-AS";
srNames[1] = "DSR-50";
srNames[2] = "Ballista";
srNames[3] = "XPR-50";

self addSliderString("Sniper Rifles", srIDs, srNames, ::giveuserweapon);

pstlsIDs[0] = "fiveseven_mp";
pstlsIDs[1] = "fnp45_mp";
pstlsIDs[2] = "beretta93r_mp";
pstlsIDs[3] = "judge_mp";
pstlsIDs[4] = "kard_mp";

pstlsNames[0] = "Five Seven";
pstlsNames[1] = "Tac-45";
pstlsNames[2] = "B23R";
pstlsNames[3] = "Executioner";
pstlsNames[4] = "Kap-40";

self addSliderString("Pistols", pstlsIDs, pstlsNames, ::giveuserweapon);

            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Specials", ::newMenu, "specs");
            self addOpt("Miscellaneous", ::newMenu, "misc");
            self addOpt("Assault Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "attach":
            self addMenu("attach", "Attachments");

            //smh -- CF4
            attachIDs[0] = "reflex";
            attachIDs[1] = "fastads";
            attachIDs[2] = "dualclip";
            attachIDs[3] = "acog";
            attachIDs[4] = "grip";
            attachIDs[5] = "stalker";
            attachIDs[6] = "rangefinder";
            attachIDs[7] = "steadyaim";
            attachIDs[8] = "sf";
            attachIDs[9] = "holo";
            attachIDs[10] = "silencer";
            attachIDs[11] = "fmj";
            attachIDs[12] = "dualoptic";
            attachIDs[13] = "extclip";
            attachIDs[14] = "gl";
            attachIDs[15] = "mms";
            attachIDs[16] = "extbarrel";
            attachIDs[17] = "rf";
            attachIDs[18] = "vzoom";
            attachIDs[19] = "ir";
            attachIDs[20] = "is";
            attachIDs[21] = "tacknife";
            attachIDs[22] = "dw";
            attachIDs[23] = "stackfire";

            attachNames[0] = "Reflex";
            attachNames[1] = "Quickdraw";
            attachNames[2] = "Fast Mag";
            attachNames[3] = "ACOG";
            attachNames[4] = "Fore Grip";
            attachNames[5] = "Stock";
            attachNames[6] = "Target Finder";
            attachNames[7] = "Laser Sight";
            attachNames[8] = "Select Fire";
            attachNames[9] = "EO Tech";
            attachNames[10] = "Suppressor";
            attachNames[11] = "FMJ";
            attachNames[12] = "Hybrid Optic";
            attachNames[13] = "Extended Clip";
            attachNames[14] = "Launcher";
            attachNames[15] = "MMS";
            attachNames[16] = "Long Barrel";
            attachNames[17] = "Rapid Fire";
            attachNames[18] = "Variable Zoom";
            attachNames[19] = "Dual Band";
            attachNames[20] = "Iron Sight";
            attachNames[21] = "Knife";
            attachNames[22] = "Dual Wield";
            attachNames[23] = "Tri-Bolt";
            for(a=0;a<attachNames.size;a++)
                self addOpt(attachNames[a], ::giveplayerattachment, attachIDs[a]);
            break;
                                   
        case "lnchrs":
            self addMenu("lnchrs", "Launchers");
            self addOpt("SMAW", ::giveUserWeapon, "smaw_mp");
            self addOpt("FHJ-18 AA", ::giveUserWeapon, "fhj18_mp");
            self addOpt("RPG", ::giveUserWeapon, "usrpg_mp");
            break;

        case "specs":
            self addMenu("specs", "Specials");

			cbowIDs[0] = "crossbow_mp";
			cbowIDs[1] = "crossbow_mp+stackfire";
			cbowIDs[2] = "crossbow_mp+reflex";

			cbowNames[0] = "None";
			cbowNames[1] = "Tri-Bolt";
			cbowNames[2] = "Reflex";
            self addSliderString("Crossbow", cbowIDs, cbowNames, ::giveUserWeapon);

            self addOpt("Ballistic Knife", ::giveUserWeapon, "knife_ballistic_mp");
            break;

            case "misc":
            self addMenu("misc", "Miscellaneous");

            self addOpt("Bomb Briefcase", ::giveUserWeapon, "briefcase_bomb_defuse_mp");
            self addOpt("Shield Knife", ::giveUserWeapon, "knife_held_mp");
            self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp");
            break;

                case "camos":
            self addMenu("camos", "Camos");
            self addOpt("Remove Camo", ::changeCamo, 0);
            self addOpt("Random Camo", ::randomCamo);
            self addOpt("Base Camos", ::newMenu, "baseCamos");
            self addOpt("DLC Camos", ::newMenu, "dlcCamos");
            self addOpt("Secret Camos", ::newMenu, "secretCamos");
            break;

        case "baseCamos":
            self addMenu("baseCamos", "Base Camos");
            baseCamoNames[0] = " ";
            baseCamoNames[1] = "DEVGRU";
            baseCamoNames[2] = "A-TACS AU";
            baseCamoNames[3] = "ERDL";
            baseCamoNames[4] = "Siberia";
            baseCamoNames[5] = "Choco";
            baseCamoNames[6] = "Blue Tiger";
            baseCamoNames[7] = "Bloodshot";
            baseCamoNames[8] = "Ghostex: Delta 6";
            baseCamoNames[9] = "Kryptek: Typhon";
            baseCamoNames[10] = "Carbon Fiber";
            baseCamoNames[11] = "Cherry Blossom";
            baseCamoNames[12] = "Art of War";
            baseCamoNames[13] = "Ronin";
            baseCamoNames[14] = "Skulls";
            baseCamoNames[15] = "Gold";
            baseCamoNames[16] = "Diamond";
            for(a=1;a<baseCamoNames.size;a++)
            self addOpt(baseCamoNames[a], ::changeCamo, a);
            break;

        case "dlcCamos":
            self addMenu("dlcCamos", "DLC Camos");
            dlcCamosNames[17] = "Elite Member";
            dlcCamosNames[19] = "Jungle Warfare";
            dlcCamosNames[20] = "UK Punk";
            dlcCamosNames[21] = "Benjamins";
            dlcCamosNames[22] = "Dia De Muertos";
            dlcCamosNames[23] = "Graffiti";
            dlcCamosNames[24] = "Kawaii";
            dlcCamosNames[25] = "Party Rock";
            dlcCamosNames[26] = "Zombies";
            dlcCamosNames[27] = "Viper";
            dlcCamosNames[28] = "Bacon";
            dlcCamosNames[30] = "Paladin";
            dlcCamosNames[31] = "Cyborg";
            dlcCamosNames[32] = "Dragon";
            dlcCamosNames[33] = "Comics";
            dlcCamosNames[34] = "Aqua";
            dlcCamosNames[35] = "Breach";
            dlcCamosNames[36] = "Coyote";
            dlcCamosNames[37] = "Glam";
            dlcCamosNames[38] = "Rogue";
            dlcCamosNames[39] = "Pack-a-Punch";
            dlcCamosNames[40] = "Dead Mans Hand";
            dlcCamosNames[41] = "Beast";
            dlcCamosNames[42] = "Octane";
            dlcCamosNames[43] = "Weaponized 115";
            dlcCamosNames[44] = "Afterlife";
            for(a=17;a<dlcCamosNames.size;a++)
            self addOpt(dlcCamosNames[a], ::changeCamo, a);
            break;

        case "secretCamos":
            self addMenu("secretCamos", "Secret Camos");
            self addOpt("Digital", ::changeCamo, 18);
            self addOpt("Ghosts", ::changeCamo, 29);
            self addOpt("Advanced Warfare", ::changeCamo, 45);
            break;

        case "lethals":
            self addMenu("lethals", "Lethals");
            self addOpt("Frag", ::GivePlayerEquipment, "frag_grenade");
            self addOpt("Semtex", ::GivePlayerEquipment, "sticky_grenade");
            self addOpt("Combat Axe", ::GivePlayerEquipment, "hatchet");
            self addOpt("Bouncing Betty", ::GivePlayerEquipment, "bouncingbetty");
            self addOpt("C4", ::GivePlayerEquipment, "satchel_charge");
            self addOpt("Claymore", ::GivePlayerEquipment, "claymore");
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            self addOpt("Concussion Grenade", ::GivePlayerEquipment, "concussion_grenade");
            self addOpt("Smoke Grenade", ::GivePlayerEquipment, "willy_pete");
            self addOpt("Sensor Grenade", ::GivePlayerEquipment, "sensor_grenade");
            self addOpt("EMP Grenade", ::GivePlayerEquipment, "emp_grenade");
            self addOpt("Shock Charge", ::GivePlayerEquipment, "proximity_grenade");
            self addOpt("Black Hat", ::GivePlayerEquipment, "pda_hack");
            self addOpt("Flashbang", ::GivePlayerEquipment, "flash_grenade");
            self addOpt("Trophy System", ::GivePlayerEquipment, "trophy_system");
            self addOpt("Tactical Insertion", ::GivePlayerEquipment, "tactical_insertion");
            break;

        case "afthit":  // Afterhits Menu
            self addMenu("afthit", "Afterhits Menu");

            arIDs = strTok("tar21_mp;type95_mp;sig556_mp;sa58_mp;hk416_mp;scar_mp;saritch_mp;xm8_mp;an94_mp", ";");
            arNames = strTok("MTAR;Type 95;Swat 556;FAL OSW;M27;Scar-H;SMR;M8A1;AN-94", ";");
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = strTok("mp7_mp;pdw57_mp;vector_mp;insas_mp;qcw05_mp;evoskorpion_mp;peacekeeper_mp", ";");
            smgNames = strTok("MP7;PDW-57;Vecto K10;MSMC;Chicom CQB;Skorpion EVO;Peackeeper", ";");
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            sgIDs = strTok("870mcs_mp;saiga12_mp;ksg_mp;srm1216_mp", ";");
            sgNames = strTok("Remington 870 MCS;S12;KSG;M1216", ";");
            self addSliderString("Shotguns", sgIDs, sgNames, ::afterhit);

            lmgIDs = strTok("mk48_mp;qbb95_mp;lsat_mp;hamr_mp", ";");
            lmgNames = strTok("MK48;QBB LSW;LSAT;HAMR", ";");
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = strTok("svu_mp;dsr50_mp;ballista_mp;as50_mp", ";");
            srNames = strTok("SVU-AS;DSR-50;Ballista;XPR-50", ";");
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            pstlsIDs = strTok("kard_dw_mp;fnp45_dw_mp;fiveseven_dw_mp;judge_dw_mp;beretta93r_dw_mp;fiveseven_mp;fnp45_mp;beretta93r_mp;judge_mp;kard_mp", ";");
            pstlsNames = strTok("Dual Kap-40;Dual Tac-45;Dual Five Seven;Dual Executioner;Dual B23R;Five Seven;Tac-45;B23R;Executioner;Kap-40", ";");
            self addSliderString("Pistols", pstlsIDs, pstlsNames, ::afterhit);

            lnchrsIDs = strTok("m32_mp;smaw_mp;fhj18_mp;usrpg_mp", ";");
            lnchrsNames = strTok("War Machine;SMAW;FHJ-18;RPG", ";");
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            specIDs = strTok("knife_held_mp;defaultweapon_mp;minigun_mp;riotshield_mp;crossbow_mp;knife_ballistic_mp;briefcase_bomb_mp;claymore_mp;destructible_car_mp", ";");
            specNames = strTok("CSGO Knife;Default Weapon;Death Machine;Riot Shield;Crossbow;Ballistic Knife;Bomb;Claymore;Car", ";");
            self addSliderString("Special Weapons", specIDs, specNames, ::afterhit);
            break;

        case "kstrks": //Killstreak Menu
            self addMenu("kstrks", "Killstreak Menu");
            self addOpt("Fill Streaks", ::fillStreaks); 

            streakIDs = strTok("radar_mp;rcbomb_mp;inventory_missile_drone_mp;inventory_supply_drop_mp;counteruav_mp;microwaveturret_mp;remote_missile_mp;planemortar_mp;autoturret_mp;inventory_minigun_mp;inventory_m32_mp;qrdrone_mp;inventory_ai_tank_drop_mp;helicopter_comlink_mp;radardirection_mp;helicopter_guard_mp;emp_mp;straferun_mp;remote_mortar_mp;helicopter_player_gunner_mp;dogs_mp;missile_swarm_mp", ";");
            streakNames = strTok("UAV;RC-XD;Hunter Killer;Care Package;Counter-UAV;Guardian;Hellstorm;Lightning Strike;Sentry Gun;Death Machine;War Machine;Dragonfire;AGR;Stealth Chopper;VSAT;Escort Drone;EMP Systems;Warthog;Lodestar;VTOL Warship;K9 Unit;Swarm", ";");
            for(a=0;a<streakIDs.size;a++)
            self addOpt(streakNames[a], ::dokillstreak, streakIDs[a]);

            break;

        case "host":  // Host Options (host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);

			minDistVal[0] = "15";
			minDistVal[1] = "25";
			minDistVal[2] = "50";
			minDistVal[3] = "100";
			minDistVal[4] = "150";
			minDistVal[5] = "200";
			minDistVal[6] = "250";
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);

			timerIDs[0] = "add";
			timerIDs[1] = "subtract";
            
            timerNames[0] = "Add 1 Minute";
            timerNames[1] = "Remove 1 Minute";
            self addsliderstring("Game Timer", timerIDs, timerNames, ::editTime);
            
            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            
            botOptNames[0] = "Teleport Bots to Crosshairs";
            botOptNames[1] = "Spawn 18 Bots";
            botOptNames[2] = "Kick All Bots";
            
            botOptIDs[0] = "teleport";
            botOptIDs[1] = "fill";
            botOptIDs[2] = "kick";

            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);

            self addToggle("Disable Slide Spawning", level.slidesAllowed, ::spawnablesToggle, "slide");
            self addToggle("Disable Bounce Spawning", level.bouncesAllowed, ::spawnablesToggle, "bounce");
            self addToggle("Disable Platform Spawning", level.platsAllowed, ::spawnablesToggle, "platform");
            self addToggle("Disable Crate Spawning", level.cratesAllowed, ::spawnablesToggle, "crate");
            break;
        }
        self clientOptions();
    }

clientOptions()
{   
    if(self isHost() || self isdeveloper())
    {
        self addMenu("Verify", "Clients Menu");
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
            self addOpt("Ban Player", ::banSped, player);  
            self addOpt("Teleport to Croshairs", ::teleportToCrosshair, player);  

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
                    if( self actionslottwobuttonpressed() && self adsButtonPressed() )
                    {
                        self menuOpen();
                        wait .2;
                    }               
                }
                else{
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
                    else if(self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed()){
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
                    else if( self useButtonPressed() ){
                        player = self.selected_player;
                        menu = self.eMenu[self getCursor()];

                        if( player != self && self isHost() )
                        {
                            player.was_edited = true;
                        }
                        if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ])){
                            slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                            slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                            player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                        }
                        else 
                            player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );

                        wait .05;
                        if(IsDefined( menu.toggle ))
                            self setMenuText();
                        if( player != self )
                            self.menu["OPT"]["MENU_TITLE"] settext(self.menuTitle + "("+ player getName() +")");    
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
        self thread menudeath();
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
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2.0, "TOPLEFT", "CENTER", self.presets["X"] + 125, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
        self resizeMenu();
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
        curs = (self getCursor() >= 10) ? 9 : self getCursor();  
        self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
        self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);
        
        size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height     = int(15 * size); // 18
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    } 

    setMenuText()
    {
        self endon("disconnect");
        self menuOptions();
        self resizeMenu();

        ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;  
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
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ ary + e ].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1);
            }
            if(IsDefined( self.eMenu[ ary + e ].val )) 
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1); //BG
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1); //INNER
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
        size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height = int(15 * size);
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }

settext_hook(text, nsettext = false)
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
    if(!isInArray(level.strings, text))
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

GetLocalizedString(type, name)
{
    switch(type)
    {
        case "weapon":
            return TableLookupIString("mp/statsTable.csv", 3, name, 3);

        case "attachment":
            return TableLookupIString("mp/attachmentTable.csv", 3, name, 3);
        
        case "camo":
            return TableLookupIString("mp/camoTable.csv", 2, name, 2);
        
        case "splash":
            return TableLookupIString("mp/splashTable.csv", 1, name, 1);
        
        case "killstreak":
            return TableLookupIString("mp/killstreakTable.csv", 2, name, 2);
        
        case "gametype":
            return TableLookupIString("mp/gametypestable.csv", 1, name, 1);
        
        default:
            return "^1LOCALIZE ERROR: ^7" + type + " -> " + name;
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
initializeSetup(access, player)
    {
        if(isDefined(self.access) && access == self.access && !self isHost())
            return;
        if(isDefined(self.access) && self.access == 4)
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

    newMenu( menu, access = 0)
    {
        if( access >= self.access )
            return self IPrintLn( "Access: ^1Denied" );
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
        option.ID_list = (isArray(ID_list)) ? ID_list : strTok(ID_list, ";");
        option.RL_list = (isArray(RL_list)) ? RL_list : strTok(RL_list, ";");
        
        option.opt  = opt;
        option.func = func;
        option.p1   = p1;
        option.p2   = p2;
        option.p3   = p3;
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    IsArray(arry)
    {
        if(!isDefined(arry) || IsString(arry))
            return false;

        if(arry.size)
            return true;
        
        return false;
    }

   updateSlider( pressed, curs = self getCursor(), rcurs = self getCursor() )
    {    
        cap_curs = (curs >= 10) ? 9 : curs;
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
            //self.menu["UI_SLIDE"]["STRING_"+ cap_curs] setText( self.eMenu[ rcurs ].RL_list[ value ] + count );
            self.menu["UI_SLIDE"]["STRING_"+ cap_curs] setText( "< "+ self.eMenu[ rcurs ].RL_list[ value ] +" >" );
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
        if( IsFloat( value ) )
            self.menu["UI_SLIDE"]["VAL"] setText( value );
        else 
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
createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel)
    {
        if(isDefined(isLevel))
            textElem = level createServerFontString(font, fontScale);
        else 
            textElem = self createFontString(font, fontScale);

        textElem setPoint(align, relative, x, y);
        textElem.hideWhenInKillcam = true;
        textElem.hideWhenInMenu = true;
        textElem.foreground = true;
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
        boxElem setPoint(align, relative, x, y);
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

    refreshMenu(skip)
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
            sponge += ( (e % 2) ? toUpper( string[e] ) : toLower( string[e] ) );
        return sponge;
    }

    MonitorButtons()
    {
        if(isDefined(self.MonitoringButtons))
            return;
        self.MonitoringButtons = true;
        
        if(!isDefined(self.buttonAction))
        	self.buttonAction[0] = "+stance";
        	self.buttonAction[1] = "+gostand";
        	self.buttonAction[2] = "weapnext";
        	self.buttonAction[3] = "+actionslot 1";
        	self.buttonAction[4] = "+actionslot 2";
        	self.buttonAction[5] = "+actionslot 3";
        	self.buttonAction[6] = "+actionslot 4";

        if(!isDefined(self.buttonPressed))
            self.buttonPressed = [];
        
        for(a=0;a<self.buttonAction.size;a++)
            self thread ButtonMonitor(self.buttonAction[a]);
    }

    ButtonMonitor(button)
    {
        self endon("disconnect");
        
        self.buttonPressed[button] = false;
        while(1)
        {
            self waittill("button_pressed_"+button);
            self.buttonPressed[button] = true;
            wait .025;
            self.buttonPressed[button] = false;
        }
    }

    isButtonPressed(button)
    {
        return self.buttonPressed[button];
    }

    isDeveloper()
{
        xuid = self getXUID();
        name = self getName();

        alias = getDevAlias(xuid, name);

        if(alias != undefined)
            return true;

        return false;
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
    AfterHit(gun)
{
    self endon("afterhit");
    self endon( "disconnect" );
    if(self.AfterHit == 0)
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
empBind(num)
{
    if(!isDefined(self.thirdEye))
    {
            if(num == 1)
                self iPrintLn("Press [{+Actionslot 1}] to ^2Third Eye");

            else if(num == 2)
                self iPrintLn("Press [{+Actionslot 2}] to ^2Third Eye");

            else if(num == 3)
                self iPrintLn("Press [{+Actionslot 3}] to ^2Third Eye");

            else if(num == 4)
                self iPrintLn("Press [{+Actionslot 4}] to ^2Third Eye");

            self.thirdEye = true;

            while(isDefined(self.thirdEye))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread empExplosion();

                    wait .1;
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread empExplosion();

                    wait .1;
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread empExplosion();

                    wait .1;
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread empExplosion();

                    wait .1;
                }
            }
    }
    else if(isDefined(self.thirdEye)) 
    { 
        self iPrintLn("Third Eye Bind [^1OFF^7]");
        self.thirdEye = undefined; 
    }
}
empExplosion()
{
    origin = self.origin;
    owner = self;
    weaponname = "emp_grenade_mp";

    self shellshock("flashbang", 2);
    ents = getdamageableentarray( origin, 512 );

    foreach ( ent in ents )
        ent dodamage( 1, origin, owner, owner, "none", "MOD_GRENADE_SPLASH", 0, weaponname );
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
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self thread CanzoomFunction();
    
                wait .001;
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self thread CanzoomFunction();
            
                wait .001;
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                      self thread CanzoomFunction();

                wait .001;
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
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
                if(self ActionSlotOneButtonPressed() && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 2)
            {
                if(self ActionSlotTwoButtonPressed() && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 3)
            {
                if(self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 4)
            {
                if(self ActionSlotFourButtonPressed() && !self.menu["isOpen"])
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
                if(self ActionSlotOneButtonPressed() && !self.menu["isOpen"])
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
                if(self ActionSlotTwoButtonPressed() && !self.menu["isOpen"])
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
                if(self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
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
                if(self ActionSlotFourButtonPressed() && !self.menu["isOpen"])
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
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
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
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM1");

            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM2");
            
            wait .001;
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM3");
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM4");
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM5");
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
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
toggleFreezeBots()
{
    if (!isDefined(self.frozenbots))
        self.frozenbots = 0;

    if (!self.frozenbots)
    {
        self.frozenbots = 1;
        self iPrintLn("All bots ^1Frozen");

        self.freezeBotsLoop = true;
        self thread freezeBotsThread(); // Start loop in thread
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
            {
                player freezeControls(false);
            }
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
            {
                player freezeControls(true);
            }
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
        {
            player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"]);

        }
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
        {   
            kick( player getEntityNumber());
        }
    }
    self iprintln("All bots ^1kicked");     
}
takeWpn()
{
    self takeweapon(self getcurrentweapon());
}
toggleInfEquip()
{
    self.infEquipOn = !self.infEquipOn;

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

changeCamo(num)
{
    weap=self getCurrentWeapon();
    myclip=self getWeaponAmmoClip(weap);
    mystock=self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  
    weaponOptions=self calcWeaponOptions(num,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo=num;  
}

randomCamo()
{
    numEro=randomIntRange(1,44);  
    weap=self getCurrentWeapon();  
    myclip=self getWeaponAmmoClip(weap);  
    mystock=self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  
    weaponOptions=self calcWeaponOptions(numEro,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo=numEro;  
}

giveUserWeapon(weapon) 
{
    //if (self GetWeaponsList().size >= 3)
        //self takeweapon(self GetWeaponsList()[0]);
    
    self giveWeapon(weapon);
    self giveStartAmmo(weapon);
    self switchToWeapon(weapon);

    if (weapon == "m32_mp" || weapon == "usrpg_mp" || weapon == "smaw_mp" || weapon == "fhj18_mp")
        self giveMaxAmmo(weapon);
    
    self iprintln("Given: ^2" + weapon);
}

GetPlayerEquipment(type)
{
    equipment = [];
    
    for(a = 63; a < 79; a++)
    {
        class = TableLookup("mp/statstable.csv", 0, a, 2);
        
        if(class != "weapon_grenade" || isDefined(type) && TableLookup("mp/statstable.csv", 0, a, 13) != type)
            continue;
        
        weapon = TableLookup("mp/statstable.csv", 0, a, 4);
        
        if(self HasWeapon1(weapon))
            equipment[equipment.size] = GetWeapon1(weapon);
    }
    
    return equipment;
}

GivePlayerEquipment(equipment)
{
    if(self HasWeapon1(equipment))
    {
        self GiveStartAmmo(self GetWeapon1(equipment));
        return;
    }
    
    type  = TableLookup("mp/statstable.csv", 4, equipment, 13);
    equip = StrTok(equipment, "_");
    
    if(equip[(equip.size - 1)] != "mp")
        equipment += "_mp";
    
    currentEquipment = GetPlayerEquipment(type);
    
    foreach(curEquip in currentEquipment)
        self TakeWeapon(curEquip);
    
    self GiveWeapon(equipment);
    self GiveStartAmmo(equipment);
}

HasWeapon1(weapon)
{
    foreach(weap in self GetWeaponsList())
        if(IsSubStr(weap, weapon) || weapon == weap)
            return true;
    
    return false;
}

GetWeapon1(weapon)
{
    foreach(weap in self GetWeaponsList())
        if(IsSubStr(weap, weapon) || weapon == weap)
            return weap;
    
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

    if (IsArray(array_exclude))
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
saveLoadoutToggle()
{
    if(!self.saveLoadoutEnabled)
    {
        self saveloadout();
        self.saveLoadoutEnabled = 1;
    }
    else if(self.saveLoadoutEnabled)
    {
        self deleteloadout();
        self.saveLoadoutEnabled = 0;
    }
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
        if (!isDefined(self.camo) || self.camo == 0)
            self.camo = randomcamo();

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

        switch (weapon) 
        {
            case "flash_grenade_mp":
            case "concussion_grenade_mp":
            case "bouncingbetty_mp":
            case "sensor_grenade_mp":
            case "emp_grenade_mp":
            case "proximity_grenade_aoe_mp":
            case "pda_hack_mp":
            case "trophy_system_mp":
                self giveWeapon(weapon);
                self setWeaponAmmoStock(weapon, self getWeaponAmmoStock(weapon) + 1);
                break;

            case "willy_pete_mp":
            case "claymore_mp":
            case "hatchet_mp":
            case "frag_grenade_mp":
            case "sticky_grenade_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                ammo = stock + 1;
                self setWeaponAmmoStock(weapon, ammo);
                break;

            case "tactical_insertion_mp":
            case "satchel_charge_mp":
                self giveWeapon(weapon);
                self giveStartAmmo(weapon);
                break;
            
            default:
                self giveWeapon(weapon);
                break;
        }
    }
}

getBaseName(weapon)
{
    prefix = strtok(weapon, "+");
    base = prefix[0];
    return base;
}
HasAttachment(weapon, attachment)
{
    attachments = getattachments(weapon);
    
    for(a=0;a<attachments.size;a++)
        if(attachments[a] == attachment)
            return true;
    
    return false;
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
givePlayerAttachment(attachment)
{
    weapon      = self GetCurrentWeapon(); 
    prefix      = strtok(weapon, "+");
    baseName    = prefix[0];
    attachments[0] = prefix[1];
    attachments[1] = prefix[2];
    stock       = self GetWeaponAmmoStock(weapon);
    clip        = self GetWeaponAmmoClip(weapon);

    if(attachment == "dw")
    {
        switch(baseName)
        {
            case "fiveseven_mp":
                newWeapon = "fiveseven_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon);
                self switchtoweapon(newWeapon);
                break;

            case "fnp45_mp":
                newWeapon = "fnp45_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon); 
                self switchtoweapon(newWeapon);
                break;

            case "beretta93r_mp":
                newWeapon = "beretta93r_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon);
                self switchtoweapon(newWeapon);
                break;

            case "judge_mp":
                newWeapon = "judge_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon);
                self switchtoweapon(newWeapon);
                break;

            case "kard_mp":
                newWeapon = "kard_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon);
                self switchtoweapon(newWeapon);
                break;

            default:
                self iprintln("^1ERROR^7: Cannot apply attachment to this weapon");
                break;
        }
        self iprintln(newWeapon + " ^2Given");
    }
    else
    {
        if(HasAttachment(weapon, attachment))
        {
            for(a = 0; a < attachments.size; a++)
            {
                if(attachments[a] != attachment && attachments[a] != "mp")
                {
                    keep = attachments[a];
                    newWeapon = baseName + "+" + keep;
                }
                else
                {
                    keep = "";
                    newWeapon = baseName;
                }
            }
        }
        else
        {
            if(attachment != "none")
            {
                for(a = 0; a < attachments.size; a++)
                {
                    if(attachments[a] != "mp")
                    {
                    	newAttachments[0] = attachment;
                    	newAttachments[1] = attachments[a];
                    }
                    
                    if(isDefined(newAttachments))
                        break;
                }
            }
        
            if(!isDefined(newAttachments) && newAttachments != "mp")
            {
            	newAttachments[0] = attachment;
            	newAttachments[1] = "";
            }
        
            if(newAttachments[1] == "")
                newWeapon = baseName + "+" + newAttachments[0];
            else
                newWeapon = baseName + "+" + newAttachments[0] + "+" + newAttachments[1];
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
    for(i = 0; i < level.players.size; i++)
    {
        if (isDefined( level.players[i].pers["isBot"])) 
            kick ( level.players[i] getEntityNumber() );
    }
    wait 1;
    map_restart( 0 );
}
setMinDistance(newDist)
{
    level endon("game_ended");

    switch(newDist)
    {
        case "15":
        level.lastKill_minDist = 15;
        break;

        case "25":
        level.lastKill_minDist = 25;
        break;

        case "50":
        level.lastKill_minDist = 50;
        break;

        case "100":
        level.lastKill_minDist = 100;
        break;

        case "150":
        level.lastKill_minDist = 150;
        break;

        case "200":
        level.lastKill_minDist = 200;
        break;

        case "250":
        level.lastKill_minDist = 250;
        break;

        default:
        level.lastKill_minDist = 15;
        break;
    }

    iprintln("Minimum distance: ^2" + newDist + "m");
}
editTime(type)
{
    if(type == "add")
    {
        setgametypesetting( "timelimit", getgametypesetting( "timelimit" ) + 1);
        self iPrintln("^2Added 1 Minute");
    }
    else if(type == "subtract")
    {
        setgametypesetting( "timelimit", getgametypesetting( "timelimit" ) - 1);
        self iPrintln("^1Subtracted 1 Minute");
    }
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
   if (!player isHost() || player != self || !player isDeveloper())
        Kick(player GetEntityNumber());
   else
        self iPrintln("^1ERROR: ^7Can't Kick Player");
}    
banSped(player)
{
    if(player isHost() || player isdeveloper())
    {
        self iPrintln("^1ERROR: ^7Can't Ban Player");
        return;
    }
    
    SetDvar("Paradise_"+player GetXUID(),"Banned");
    Kick(player GetEntityNumber());
    self iPrintln(player getName()+" Has Been ^1Banned");
}

teleportToCrosshair(player)
{
    if (isAlive(player))
        player setOrigin(bullettrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles()) * 1000000, 0, self)["position"]);
}
tpToSpot(coords)
{
    self setorigin(coords);
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
        self.spawnCoords = (self.origin + (0, 0, 1));
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
        if( self.snl && self actionslottwobuttonpressed() && self GetStance() == "crouch")
        {
            self setplayerangles(self.a);
            self setOrigin(self.pers["savedLocation"]);
            wait 2;
        }
        wait 0.05;
    }
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
    {
        self.instashoot = 0;
    }
}

SetCanswapMode()
{
    value = self.sliders[self getCurrentMenu() + "_" + self getCursor()]; 

    if(value == 0) 
    {
        if(!self.currCan)
        {
            self.currCan = 1;
            self.InfiniteCan = 0;
            self.currCanWpn = self getcurrentweapon();
            self iprintln("Canswap Weapon: (^2" + self.currCanWpn + "^7)");
            self thread CurrCanswapLoop();
        }

        else if(self.currCan && self.currCanWpn == self getCurrentWeapon())
        {
            self.currCan = 0;
            self iprintln("Canswap Mode: [^1OFF^7]");
            return;
        }
    }
    else if(value == 1) 
    {
        if(!self.InfiniteCan)
        {
            self.InfiniteCan = 1;
            self.currCan     = 0;       
            self iprintln("Canswap Mode: ^2Infinite^7");
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
        self waittill("weapon_change");
        self.currCanWpn = self getCurrentWeapon();
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
initNoClip()
{
    if(self.NoClipT == 0)
    {
        self thread Noclip();
        self.NoClipT = 1;
    }
    else
    {
        self.NoClipT = 0;
        self notify("stop_noclip");
    }
}

Noclip()
{
    self endon("stop_noclip");
    if(!isDefined(self.noClipSpeed)) self.noClipSpeed = 50;

    for(;;)
    {
        if( self secondaryoffhandbuttonpressed() && self.specNadeActive == 0)
        {
            if(self.NoClipOBJ == 0)
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

getprimary()
{
    class = self.class;
    class_num      = int( class[class.size-1] )-1; 
    primaryweapon  = self getloadoutweapon( class_num, "primary" );
    return primaryweapon;
}

getsecondary()
{
    class = self.class;
    class_num      = int( class[class.size-1] )-1; 
    secondaryweapon = self getloadoutweapon( class_num, "secondary" );
    return secondaryweapon;
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
            self setvelocity( self getvelocity() + ( 0, 0, 999 ) );

        wait 0.01;
    }
}

slide()
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
    self.spawnedSlide = spawn("script_model",
        bullettrace(
            self gettagorigin("j_head"),
            self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,
            0,
            self
        )["position"] + (0, 0, 20)
    );

    self.spawnedSlide.angles = (0, self getPlayerAngles()[1] - 90, 60);
    self.spawnedSlide setModel("t6_wpn_supply_drop_ally");
    self.slideThread = self thread makeSlide(self.spawnedSlide);
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

            if (isDefined(slideEntity) && player isInPos(slideEntity.origin) && player meleeButtonPressed())
            {
                player setOrigin(player.origin + (0, 0, 10));
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

doSpawnOption(selection)
{
    switch(selection)
    {
        case "bounce":
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
        break;

        case "platform":
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
                {
                    self.spawnedplat[i][d] = spawn("script_model", startpos + (d * 35, i * 70, 0));
                    self.spawnedplat[i][d] setModel("t6_wpn_supply_drop_ally");
                    self.spawnedplat[i][d].angles = (0, 0, 0);
                }
            }
        break;

        case "crate":
            if (isDefined(self.spawnedcrate))
            {
                self.spawnedcrate delete();
                self.spawnedcrate = undefined;
            }
            cratePos = self.origin + (0, 0, -15); 
            self.spawnedcrate = spawn("script_model", cratePos);
            self.spawnedcrate setModel("t6_wpn_supply_drop_ally");
            self.spawnedcrate.angles = (0, 0, 0);
        break;
    }
}
spawnablesToggle(type)
{
    if(type == "slide")
    {
        if(level.slidesAllowed)
        {
            level.slidesAllowed = 0;
            foreach(player in level.players)
            {
                if (isDefined(player.slideThread))
                {
                    player.slideThread delete();
                    player.slideThread = undefined;
                }
                if (isDefined(player.spawnedSlide))
                {
                    player.spawnedSlide delete();
                    player.spawnedSlide = undefined;
                }
            }
            self iprintln("All Spawned Slides ^1Deleted");
        }
        else if(!level.slidesAllowed)
            level.slidesAllowed = 1;
    }
    else if(type == "bounce")
    {
        if(level.bouncesAllowed)
        {
            level.bouncesAllowed = 0;
            foreach(player in level.players)
            {
                if (isDefined(player.trampolineThread))
                {
                    player.trampolineThread delete();
                    player.trampolineThread = undefined;
                }
                if (isDefined(player.spawnedTrampoline))
                {
                    player.spawnedTrampoline delete();
                    player.spawnedTrampoline = undefined;
                }
            }
            self iprintln("All Spawned Bounces ^1Deleted");
        }
        else if(!level.bouncesAllowed)
            level.bouncesAllowed = 1;
    }
    else if(type == "platform")
    {
        if(level.platsAllowed)
        {
            level.platsAllowed = 0;
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
            }
            self iprintln("All Spawned Platforms ^1Deleted");
        }
        else if(!level.platsAllowed)
            level.platsAllowed = 1;
    }
    else if(type == "crate")
    {
        if(level.cratesAllowed)
        {
            level.cratesAllowed = 0;
            foreach(player in level.players)
            {
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
            }
            self iprintln("All Spawned Crates ^1Deleted");
        }
        else if(!level.cratesAllowed)
            level.cratesAllowed = 1;
    }
}
botControls(action)
{
    if(action == "teleport")
        self tpBots();

    else if(action == "fill")
        self spawnBots(18);
    
    else if(action == "kick")
        self kickallbots();
}


