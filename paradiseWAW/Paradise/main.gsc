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
			player thread initWatermark();
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


 initWatermark()
{
    level endon("disconnect");

    level.watermark = createFontString("objective", 1.2);
    level.watermark setPoint("TOPRIGHT", "TOPRIGHT", 15, -25);

    while(1)
    {
        level.watermark setText("^4Paradise WaW");
        wait 1;
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




