////////////////////////////////////////////////////////////////////////////////
//   ______     ______     __   __     __     ______   __  __                 //
//  /\___  \   /\  ___\   /\ "-.\ \   /\ \   /\__  _\ /\ \_\ \                //
//  \/_/  /__  \ \  __\   \ \ \-.  \  \ \ \  \/_/\ \/ \ \  __ \               //
//    /\_____\  \ \_____\  \ \_\\"\_\  \ \_\    \ \_\  \ \_\ \_\              //
//    \/_____/   \/_____/   \/_/ \/_/   \/_/     \/_/   \/_/\/_/              //                                                                               
//                                                                            //
// Zenith MW2 GSC Menu                                                        //
// Created By: XeSoftware & Torq                                              //
//                                                                            //
// Credits to The Following                                                   //
// - Torq                                                                     //
// - CF4_99                                                                   //
// - Smokey xKoVx                                                             //
// - Maximus                                                                  //
// - Extinct - Menu Base [ Ported his BO3 Subversion v2.1 base over ]         //
// - And anyone else that helped with my projects in the past                 //
//                                                                            //
// - This is a free menu I decided to make to go along with the               //
//   Zenith MW2 Tool Me & Torq are making. Feel free to use anything          //
//   from this menu. But please give credit to all the people above this.     //
//   Without those guys, alot of options wouldn't be in the menu. This        //
//   menu will work on both PC & XBOX.                                        //
//                                                                            //
// - Buy Zenith MW2 Steam Tool @ Discord.gg/TTRubWAt2B                        //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;
#include maps\mp\gametypes\_globallogic;
#include maps\mp\killstreaks\_killstreaks;

init()
    {
        level.strings  = [];

        level thread bo2precache();
        level thread onPlayerConnect();
        level.currentGametype      = getDvar("g_gametype");
        level.currentMapName       = getDvar("mapName");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        setDvar("host_team", self.team);
        init_Dvars();
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            SetDvar("Zodiac_" + player GetXUID(),"Banned");
            
            player thread displayVer();
		    player thread initstrings();
            player thread DeleteAllDamageTriggers();    
            player thread onPlayerSpawned();   
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
                isFirstSpawn = false;
            }

	        self setorigin(self.spawn_origin);
            self.angles = self.spawn_angles;

            self thread botsetup();

            if (self getPlayerCustomDvar("loadoutSaved") == "1") 
            {
                self loadLoadout();
            }

            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
       
            if(self.pers["isBot"] == false)
            {  
                self dowelcomemessage();
                self thread monitorbuttons();
                self setclientuivisibilityflag("g_compassShowEnemies", 1);
                self.uav = false;
                self thread mainBinds();
                self thread wallbangeverything();
                self thread bulletImpactMonitor();
                self thread changeClass();
                
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
            if(!hasBots())
            {                
                wait 1.5;
                self doBots();
            }
        }
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
            spawnbotsamount(18);
            level.i++;
            wait 0.5;
        }
    }
    else if(level.currentGametype == "tdm")
    {
        for(i = 0; i < 9; i++)
        {
            self spawnteambots(9, !hostTeam);
            wait 0.125;
        }
    }
    else if(level.currentGametype == "sd")
    {
        if(getteamplayersalive(self.team != hostTeam <= 1))
        {
            spawnteambots(3, !hostTeam);
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
spawnTeamBots(n, team)
{
	for (i = 0; i < n; i++)
	{
		maps\mp\bots\_bot::spawn_bot("autoassign");
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

modifyPlayerDamage(timesAlmHit, eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex )
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
                iprintln("^1" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                iDamage = 999;
                self iprintln("You almost hit ^1" + self.timesAlmHit + " ^7times!");
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
                level.players[i] iprintln("^1" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
            }
            self iprintln("You almost hit ^1" + self.timesAlmHit + " ^7times!");
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
                        level.players[i] iprintln("^1" + eAttacker.name + " ^7killed " + "^1" + self.name + "^7 from " + "^1" + dist + "m^7!");
                }
                self iprintln("You almost hit ^1" + self.timesAlmHit + " ^7times!");
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

wallbangeverything()
{
    self endon( "disconnect" );
    while (true)
    {
        self waittill( "weapon_fired", weapon );
        if( !(isdamageweapon( weapon )) )
        {
            continue;
        }
        if( self.pers[ "isBot"] && IsDefined( self.pers[ "isBot"] ) )
        {
            continue;
        }
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
                {
                    savedpos[a] += vectorscale( anglesf, 0.25 );
                }
            }
            else
            {
                savedpos[a] = bullettrace( eye, vectorscale( anglesf, 1000000 ), 0, self )[ "position"];
            }
            if( savedpos[ a] != savedpos[ a - 1] )
            {
                magicbullet( self getcurrentweapon(), savedpos[ a], vectorscale( anglesf, 1000000 ), self );
            }
            a++;
        }
        wait 0.05;
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
        self waittill("changed_class");
        self thread maps\mp\gametypes\_class::giveLoadout( self.team, self.class );
        self iprintlnbold("");
        wait .1;
        //self thread playerSetup();
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

        bot thread maps\mp\gametypes\_bot::bot_spawn_think( team );
        return true;
    }

    return false;
}
botSetup()
{
    if(!IsDefined(self.pers["isBot"]) || !self.pers["isBot"])
        return;

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
	self endon( "disconnect" );
	level endon( "game_ended" );

	for(;;)
	{
		wait 0.25;
		maps\mp\gametypes\_globallogic_score::_setplayermomentum( self, 0 );
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
                    iprintln("^1" + self.name + " ^7Almost Hit ^1" + nearestplayer.name + " ^7from ^1" + dist + " m^7!");
                    self.timesAlmHit ++;        
                }
            }
            else if(level.currentGametype == "sd")
            {
                if(getTeamPlayersAlive(enemyTeam) == 1 && isDamageWeapon(self getcurrentweapon()))
                {
                    iprintln("^1" + self.name + " ^7Almost Hit ^1" + nearestplayer.name + " ^7from ^1" + dist + " m^7!");
                    self.timesAlmHit ++;
                }
            }
            else if(level.currentGametype == "tdm")
            {
                if(teamScore == 7400 && isDamageWeapon(self getcurrentweapon()))
                {
                    iprintln("^1" + self.name + " ^7Almost Hit ^1" + nearestplayer.name + " ^7from ^1" + dist + " m^7!");
                    self.timesAlmHit ++;
                }
            }

        }
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

   
