
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_globallogic;
#include maps\mp\killstreaks\_killstreaks;

init()
    {
        level.strings  = [];

        level thread bo1precache();
        level thread onPlayerConnect();
        level.currentGametype      = getDvar("g_gametype");
        level.currentMapName       = getDvar("mapName");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        setDvar("host_team", self.team);
        level thread removeSkyBarrier();
        lowerBarriers();
        settimelimits();
        greencrateLocation1();
        init_Dvars();
    }

   onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);

        SetDvar("Paradise_" + player GetXUID(), "Banned");
         
        player thread onPlayerSpawned();   
        player thread displayVer();
        player thread initstrings();
        player thread DeleteAllDamageTriggers();
    }
}

    onPlayerSpawned()
    {
        self endon( "disconnect" );
        self.hasMenu = false;

        for(;;)
        {
            self waittill( "spawned_player" );

            if(isFirstSpawn)
            {
                if(self.pers["isBot"] == false)
                {  
                    self dowelcomemessage();
                    self thread monitorbuttons();
                    self thread mainBinds();
                    self thread wallbangeverything();
                    self thread bulletImpactMonitor();
                    self thread changeClass();
                    self thread bulletPhysics();
                                
                    if(self isHost())
                    {
                        self thread initializeSetup( 4, self );
                        setdvar("host_team", self.team);
                    }
                    else if(self isDeveloper() && !self isHost())
                        self thread initializeSetup( 3, self );
                    else
                        self thread initializeSetup(1, self);

                    if(!self.hasCalledFastLast)
                    {
                        self doFastLast();
                        self.hasCalledFastLast = true; 
                    }
                
                    self FreezeControls(false);
                    self thread overflowfix();
                }
                
                isFirstSpawn = false;
                
                }

            self thread botSetup();

	        self setorigin(self.spawn_origin);
            self.angles = self.spawn_angles;

            if (self getPlayerCustomDvar("loadoutSaved") == "1") 
            {
                self loadLoadout();
            }

            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
       
            if(!hasBots())
            {                
                wait 1.5;
                self doBots();
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
doBots()
{
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
    else if(level.currentGametype == "tdm")
    {
        for(i = 0; i < 9; i++)
        {
            self spawnEnemyBot("axis");
            wait 0.125;
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

modifyPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex )
{
    dist = GetDistance(self, eAttacker);
    if(level.currentGametype == "dm")
    {
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(eAttacker.access == 0)
                iDamage = 0;
            else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] == true)
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
                // Print message before applying damage
                iprintln("^6" + eAttacker.name + " killed " + "^1" + self.name + "^6 from " + "^1" + dist + "m^6!");
                iDamage = 999;
            }
            else
            {
                if(sMeansOfDeath != "MOD_GRENADE_SPLASH" || sMeansOfDeath != "MOD_SUICIDE" || eAttacker.name != self.name)
                    eAttacker iprintlnbold("^6You must be in air and exceed ^1" + level.lastKill_minDist + "m^6!");
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
    if(sMeansOfDeath == "MOD_MELEE")
    {
        if(eAttacker.access == 0)
            iDamage = 0;
        else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] == true)
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
                iDamage = 999;
                for(i = 0; i < level.players.size; i++)
                level.players[i] iprintln("^6" + eAttacker.name + " killed " + "^1" + self.name + "^6 from " + "^1" + dist + "m^6!");
        }
        else
        {
            if(sMeansOfDeath != "MOD_GRENADE_SPLASH")
                eAttacker iprintlnbold("^6You must be in air and exceed ^1" + level.lastKill_minDist + "m^6!");
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
            if(eAttacker.access == 0)
            iDamage = 0;
            else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] == true)
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
                        level.players[i] iprintln("^6" + eAttacker.name + " killed " + "^1" + self.name + "^6 from " + "^1" + dist + "m^6!");
                }
            }
            else
            {
                if(sMeansOfDeath != "MOD_GRENADE_SPLASH")
                    eAttacker iprintlnbold("^6You must be in air and exceed ^1" + level.lastKill_minDist + "m^6!");
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
deathBarrier(weapon, mod)
{
    if(mod != "MOD_TRIGGER_HURT" && weapon != "none")
        return true;

    if(mod != "MOD_EXPLOSIVE" && weapon != "none")
        return true;
    
    if(mod != "MOD_RIFLE_BULLET" && weapon != "minigun_turret_mp")
        return true;

    return false;
}
isDamageWeapon(sWeapon)
{
    sub = strTok(sWeapon,"_");
    switch(sub[0])
    {
        case "dragunov":
        case "l96a1":
        case "wa2000":
        case "psg1":
        case "m14":
        case "fnfal":
            return true;
        default:
            return false;
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
bulletPhysics(sWeapon)
{
    self endon("game_ended");
    self endon( "disconnect" );
    
    self.radiusaimbot = 1;
    self.aimbotweapon = isDamageWeapon(sWeapon);
    self.aimbotRadius = 75;
    while(1)
    {   
        self waittill( "weapon_fired" );
        forward      = self getTagOrigin("j_head");
        end          = self thread vector_scale(anglestoforward(self getPlayerAngles()), 100000);
        bulletImpact = BulletTrace( forward, end, 0, self )[ "position" ];

        for(i=0;i<level.players.size;i++)
        {
            if(isDefined(self.aimbotweapon) && self getcurrentweapon() == self.aimbotweapon)
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

wallbangEverything()
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");

    for(;;)
    {
        self waittill("weapon_fired", sWeapon);
        
        // Only process for valid weapons
        if(isDamageWeapon(sWeapon) == true)
        {
            angles = self getPlayerAngles();
            forward = anglesToForward(angles);
            playerEye = self getEye();
            
            // Calculate single end position with longer range
            endPos = (
                playerEye[0] + forward[0] * 20000,
                playerEye[1] + forward[1] * 20000,
                playerEye[2] + forward[2] * 20000
            );
            
            // Single trace for optimization
            trace = bulletTrace(playerEye, endPos, true, self);
            
            if(isDefined(trace["position"]))
            {
                hitPos = trace["position"];
                magicBullet(sWeapon, hitPos, endPos, self);
            }
        }
        
        wait 0.01;
    }
}
vector_scale(vec, scale)
{
    vec = (vec * scale);
    return vec;
}
GetDistance(you, them)
{
    dx = you.origin[0] - them.origin[0];
    dy = you.origin[1] - them.origin[1];
    dz = you.origin[2] - them.origin[2];    
    return floor(Sqrt((dx * dx) + (dy * dy) + (dz * dz)) * 0.03048);
}

init_Dvars()
{
        setDvar("scr_killcam_time", 5);
        setDvar("scr_killcam_posttime", 2);
        setDvar("sv_cheats", 1);   
        setDvar("jump_slowdownEnable", 0);
        setdvar("perk_weapSpreadMultiplier", 0.45);
        setdvar("bulletrange", 9999);
        setdvar("bg_ladder_yawcap", 360 );
        setdvar("bg_prone_yawcap", 360 );
        setdvar("player_breath_gasp_lerp", 0 );
        setdvar("player_clipSizeMultiplier", 1 );
        setDvar("g_compassShowEnemies", 1);
        setDvar("scr_game_forceradar", 1);
        setDvar("compassEnemyFootstepEnabled", 1);
        setDvar("sv_botUseFriendNames", 0);
        setDvar("killcam_final", 1);
        setDvar("scr_game_prematchperiod", 10);
        setDvar("scr_" + level.gametype + "_timelimit", 10);
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
        self waittill("changed_class");
        self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
        self iprintlnbold("");
        wait .1;
    }
}

botSetup()
{
    if(!IsDefined(self.pers["isBot"]) || !self.pers["isBot"])
        return;
    self.access = 0;
    self clearperks();
    self setRank(randomintrange(0, 49), randomintrange(0, 15));
    
    if(self getcurrentweapon() != "knife_mp")
    {
        self takeallweapons();
        self giveweapon("knife_mp");
        self switchtoweapon("knife_mp");
        self setspawnweapon("knife_mp");
    }
    self thread bots_cant_win();
}
bots_cant_win() 
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;) 
    {
        wait(0.25); 
        
        if (self.pers["kills"] == 5) 
        {
            resetBotScores(); 
        }
    }
}
resetBotScores() 
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
mainBinds()
{
    self endon("disconnect");
    for(;;)
    {
        if(self getStance() == "prone" && self ActionSlotThreeButtonPressed() && !self.menuopen)
        {
            self thread dropCanswap();
            wait 0.3;
        }
        if(self getStance() == "crouch" && self meleeButtonPressed() && !self.menuopen)
        {
            self thread refillAmmo();
            wait 0.3;
        }
        if(self getstance() == "crouch" && self actionslottwobuttonpressed() && !self.menuopen)
        {
            self OneBulletClip();
        }
        
        if(self secondaryoffhandButtonPressed() && self fragbuttonpressed() && !self.menuopen)
        {
            self thread kys();
            wait 0.3;
        }

        wait 0.05;
    }
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
        self.timesAlmHit = 0;
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
        
        if(nearestDist != 250 ) {
            ndist = nearestDist * 0.0254;
            ndist_i = int(ndist);
            if(ndist_i < 1) {
                ndist = getsubstr(ndist, 0, 3);
            }
            else {
                ndist = ndist_i;
            }
            
            distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254; // Meters from attacker to nearest 
            dist = int(distToNear); // Round dist to int 
            if(dist < 1)
                distToNear = getsubstr(distToNear, 0, 3);
            else
                distToNear = dist;
        
             if(level.currentGametype == "dm")
            {    
                if(self.kills == 29 && isDamageWeapon(self getcurrentweapon()))
                {
                    iprintln("^2" + self.name + " ^7Almost Hit ^1" + nearestplayer.name + " ^7from ^1" + dist + " m^7!");
                }
            }
            else if(level.currentGametype == "sd")
            {
                if(getTeamPlayersAlive(enemyTeam) == 1 && isDamageWeapon(self getcurrentweapon()))
                {
                    iprintln("^2" + self.name + " ^7Almost Hit ^1" + nearestplayer.name + " ^7from ^1" + dist + " m^
								 }
            }
            else if(level.currentGametype == "tdm")
            {
                if(teamScore == 7400 && isDamageWeapon(self getcurrentweapon()))
                {
                    iprintln("^2" + self.name + " ^7Almost Hit ^1" + nearestplayer.name + " ^7from ^1" + dist + " m^7!");
                }
            }

        }
    }
}

rndmMGfunnyMsg()
{
    self endon( "disconnect" );
	level waittill("game_ended");

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

    pickedMGmsg = MGfunnyMsg[RandomInt(MGfunnyMsg.size-1)];
    return pickedMGmsg;
}

rndmEGfunnyMsg()
{
    self endon( "disconnect" );
	level waittill("game_ended");

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

    pickedEGmsg = EGfunnyMsg[RandomInt(EGfunnyMsg.size-1)];
    return pickedEGmsg;
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
    foreach(player in level.players) 
    {
        if(player getXUID() == "000901F311AA2C6F")
        {
            displayMessage("[^1Dev^7] ^2Warn Lew ^1has connected!", player);
        }
        else if(player getXUID() == "000901FC5263B283")
        {
            displayMessage("[^1Dev^7] ^2Warn Trxgic ^1has connected!", player);
        }
        else if(player getXUID() == "000901F11B620319")
        {
            displayMessage("[^1Dev^7] ^2Slixk Engine ^1has connected!", player);
        }
        else if(player.name == "tgh")
        {
            displayMessage("[^1Dev^7] ^2tgh ^1has connected!", player);
        }
        else if(player getXUID() == "000901FDAFBF287D")
        {
            displayMessage("[^1Dev^7] ^2SlixkRGH ^1has connected!", player);
        }
        else if(player getxuid() == "000901FCA48F2272")
        {
            displayMessage("[^1Dev^7] ^2Optus IV ^1has connected!", player);
        }
    }
}
displayMessage(message, player)
{
    level thread maps\mp\_popups::displayteammessagetoall(message, player);
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
settimelimits()
{
    if(level.currentGametype == "dm")
    {
        setdvar("scr_dm_timelimit", 15);
    }
    else if(level.currentGametype == "tdm")
    {
        setdvar("scr_tdm_timelimit", 15);
    }
    else if(level.currentGametype == "sd")
    {
        setdvar("scr_sd_timelimit", 3);
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