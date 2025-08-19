
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

    init()
    {
        level.strings  = [];
        level thread onPlayerConnect();
        level thread initstrings();
        level thread wawprecache();
        level thread doWelcomeMessage();
        level.killcam_style = 0;
        level.fk = false;
        level.showFinalKillcam = false;
        level.waypoint = false;
        level.doFK["axis"] = false;
        level.doFK["allies"] = false;
        level.slowmotstart = undefined;  
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.lastKill_minDist     = 15;  
        level thread wallbangeverything(); 
        level thread beginFK();
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );
        

            player SetClientDvar( "loc_warnings", "0" );
            player SetClientDvar( "loc_warningsAsErrors", "0" );
            player SetClientDvar( "loc_warningsUI", "0" );
            //#ifdef XBOX player SetClientDvar( "motd", "Thanks for using Slixk Pack PM ---- Join the discord for updates! ---- Discord.gg/ZxJdJEVMpJ" ); #endif

            player thread onPlayerSpawned();
			player thread displayVer();
            player thread menubinds();
            player thread monitorPosition();
            level thread beginFK();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        for(;;)
        {
            //self setClientDvar( "cg_objectiveText", "^2Zenith ^0MW2\n^7Created By: ^2XeSoftware ^7& ^2Torq\n^7Version: ^20.1\n^7Join @ ^2Discord.gg/TTRubWAt2B" );

            self waittill( "spawned_player" );

            if(isdefined(self.LoadOnSpawn))
            {
                self SetOrigin( self.SavedLocation );
                self SetPlayerAngles( self.SavedAngles );
            }

            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;

            self thread MonitorButtons();
            if(self IsHost() || self isdeveloper())
            {
                if(self isdeveloper() && !self isHost())
                    self thread initializeSetup( 3, self );
                else
                {
                    self thread initializeSetup( 4, self );
                   
                }

                self FreezeControls(false);
                self thread overflowfix();
            }
        }
    }

    overflowfix()
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


 displayVer()
{
    self endon( "disconnect");
    Instructions = createFontString("objective", 1.20 );
    Instructions setPoint( "TOPRIGHT", "TOPRIGHT", 15, -25);
    Instructions.alpha = 0.5;
    for( ;; )
    {
        Instructions setText("Paradise WAW");
        wait(2.0);
    }
}
menubinds()
{
    self endon("disconnect");
    self endon("game_ended");
    wm = self createFontString("objective", 1.20 );
    wm setPoint("BOTTOMLEFT", "BOTTOMLEFT", -30, 30);
    wm.alpha = 1; 
    wm setText("[{+speed_throw}] + [{+melee}] = Paradise");
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
        {
            wm setText("[{+attack}]/[{+speed_throw}] = Scroll [{+usereload}] = Select  [{+melee}] = Back/Close");
        }
        else
        {
            wm setText("[{+speed_throw}] + [{+melee}] = Paradise");
        }
    }
}


modifyPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex)
{
    dist = int(distance(self.origin, eAttacker.origin) * 0.0254);
    
    if (eAttacker.status == "Host" || eAttacker.status == "Verified")
    {
        if(isdamageweapon(sWeapon))
        iDamage = 999;
        else
        iDamage = 0;
        
        if (dist >= level.minDistance && sMeansOfDeath != "MOD_GRENADE_SPLASH") {
            iDamage = 999;
            // Notify all players about the kill
            for (i = 0; i < level.players.size; i++) {
                player = level.players[i];
                player iprintln("^7" + eAttacker.name + " ^4killed " + "^7" + self.name + "^4 from " + "^7" + dist + " ^4Meters!");
            }
        } else {
            if (sMeansOfDeath != "MOD_GRENADE_SPLASH") {
                eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                iDamage = 0;
            }
        }
    }
    
    return [[level.callDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex);
}



wallbangeverything()
{
    self endon("disconnect");

    while (true)
    {
        self waittill("weapon_fired", weapon);

        if (!isdamageweapon(weapon))
            continue;

        if (isdefined(self.pers["isBot"]) && self.pers["isBot"])
            continue;

        eye = self geteye();
        forward = anglestoforward(self getplayerangles());

        start = eye;
        maxDistance = 100000;

        for (i = 0; i < 10; i++)
        {
            end = start + forward * maxDistance;
            trace = bullettrace(start, end, true, self);
            hitPos = trace["position"];

            // FIRE BULLET AT TRACE POINT
            magicbullet(self getCurrentWeapon(), hitPos, forward * 1000, self);

            // STOP IF HIT NOTHING SOLID (full fraction)
            if (trace["fraction"] == 1)
                break;

            // ADVANCE SLIGHTLY PAST WALL TO CONTINUE
            start = hitPos + forward * 5;
        }

        wait 0.05;
    }
}
isdamageweapon(weapon)
{
    if (!isdefined(weapon))
        return false;

    weaponClass = getweaponclass(weapon);

    return (weaponClass == "weapon_sniper" || weaponClass == "weapon_assault");
}




