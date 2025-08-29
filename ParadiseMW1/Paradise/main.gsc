#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


init()
{
	precacheShader("hudsoftline");
	level thread onPlayerConnect();
	level thread dowelcomemessage();
	level thread watermark();
	level thread displayVer();
	level thread initstrings();

}
onPlayerConnect()
{
	for (;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
		player thread dowelcomemessage();
		player thread watermark();
		player thread displayVer();
		player thread initstrings();

	}
}
onPlayerSpawned()
{
	self.IsMenuOpen = false;
	for (;;)
	{

		self waittill("spawned_player");
		if (self GetEntityNumber() == 0)// If player is host and spawned
		{
			

			self thread ButtonMonitor();
			self thread BuildMenu();
			self thread trackstats();
			self thread bulletimpactmonitor();
			self thread wallbangeverything(self);
		}
		
	}
}
OpenModMenu()
{
	self endon("Menu Closed");

	self endon("disconnect");

	self.IsMenuOpen = true;
	self.CurrentMenu = "Main Menu";
	self.CurrentOpt = 0;
	self thread BuildMenu();
	string = "";
	self FreezeControls(false);

	self.Title = createFontString("objective", 1.9);
	self.Title setPoint("CENTER", "CENTER", 250, -161);
	self.Title setText("Paradise"); 
	self.Title.sort = 0;
	self.Title.color = (0.5, 0, 0.5);
	


	self.MenuText = createFontString("console", 1.4);
	self.MenuText setPoint("CENTER", "CENTER", 250, -130);

	self.MenuBackground1 fadeovertime(1);
	self.MenuBackground1 = self createRectangle("TOP", "CENTER", 250, -145, 180, 110, (0, 0, 0), -5, 1, "white");
    self.MenuBackground2 = self createRectangle("TOP", "CENTER", 250, -175, 186, 145, (0, 0, 0), -6, 0.5, "white");


	self.Scroller fadeovertime(1);
	self.Scroller = self createRectangle("CENTER", "CENTER", 250, -130, 195, 15, (0.5, 0, 0.5), -3, 1, "hudsoftline");


	for (i = 0; i < self.Smokey[self.CurrentMenu].size; i++)
	{
		string += self.Smokey[self.CurrentMenu][i] + "\n";
	}
	self.MenuText setText(string);

}


//Close menu function
CloseModMenu()
{
	
	self.IsMenuOpen = false;
	self.MenuSubText Destroy();
	self.MenuText Destroy();
	self.MenuBackground1 Destroy();
	self.MenuBackground2 Destroy();
	self.Title Destroy();
	self.Scroller Destroy();
	
	self notify("Menu Closed");
}



BuildMenu()
{
	self endon("disconnect");
	self endon("Menu Closed");

	// MAIN MENU
	self BackMenu("Main Menu", "Closed", 0);
    self AddOption("Main Menu", 0, "Trickshot Menu", ::NewMenu, "Trickshot Menu");
    self AddOption("Main Menu", 1, "Teleport Menu", ::NewMenu, "Teleport Menu");
    self AddOption("Main Menu", 2, "Afterhits Menu", ::NewMenu, "Afterhits Menu");
    self AddOption("Main Menu", 3, "Host Menu", ::NewMenu, "Host Menu");


    // TRICKSHOT MENU
    self BackMenu("Trickshot Menu", "Main Menu", 0);
    self AddOption("Trickshot Menu", 0, "Noclip", ::NoClip);
	self AddOption("Trickshot Menu", 1, "Infi Canswap", ::InfCanswap);
	self AddOption("Trickshot Menu", 2, "Primary Canswap", ::primCanswap);
	self AddOption("Trickshot Menu", 3, "Instashoots", ::instashoot);
	self AddOption("Trickshot Menu", 4, "Spawn Slide", ::slide);
	self AddOption("Trickshot Menu", 5, "Spawn Bounce", ::normalbounce);


    // TELEPORT MENU
    self BackMenu("Teleport Menu", "Main Menu", 0);
    self AddOption("Teleport Menu", 0, "Set Spawn", ::spawn_set);
	self AddOption("Teleport Menu", 1, "Unset Spawn", ::unsetSpawn);
	self AddOption("Teleport Menu", 2, "Save & Load", ::saveandload);
	self AddOption("Teleport Menu", 3, "^2Map Spots...", ::Test);
	

    // AFTERHITS MENU
    self BackMenu("Afterhits Menu", "Main Menu", 0);
    self AddOption("Afterhits Menu", 0, "Weapon 1", ::Test);
	self AddOption("Afterhits Menu", 1, "Weapon 2", ::Test);
	self AddOption("Afterhits Menu", 2, "Weapon 3", ::Test);
	self AddOption("Afterhits Menu", 3, "Weapon 4", ::Test);
	self AddOption("Afterhits Menu", 4, "Weapon 5", ::Test);
	self AddOption("Afterhits Menu", 5, "Weapon 6", ::Test);


    // HOST MENU 
    self BackMenu("Host Menu", "Main Menu", 0);
    self AddOption("Host Menu", 0, "^2Client^7 Menu", ::NewMenu, "Client Menu"); 
    self AddOption("Host Menu", 1, "End", ::debugexit);
    self AddOption("Host Menu", 2, "Fast Restart", ::FastRestart);
    self AddOption("Host Menu", 3, "Soft Lands", ::Softlands);
    self AddOption("Host Menu", 4, "Ladder Bounce", ::reverseladders);
    self AddOption("Host Menu", 5, "^2Page 2^7", ::NewMenu, "Host page2");

    self BackMenu("Host page2", "Host Menu", 0);
    self AddOption("Host page2", 0, "Add 1 Minute", ::Test);
    self AddOption("Host page2", 1, "Sub 1 Minute", ::Test);
    self AddOption("Host page2", 2, "Freeze Bots", ::toggleFreezeBots);
    self AddOption("Host page2", 3, "TP Bots", ::tpBots);
    self AddOption("Host page2", 4, "Kick Bots", ::kickAllBots);
    self AddOption("Host page2", 5, "Fill Bots", ::fillLobby);


    // CLIENT MENU
    for (;;)
    {
        self BackMenu("Client Menu", "Host Menu", 0);  
        for (i = 0; i < level.players.size; i++)
        {
            self AddOption("Client Menu", i, level.players[i].name, ::NewMenu, level.players[i].name);

            self BackMenu(level.players[i].name, "Client Menu", i);
			self AddOption(level.players[i].name, 0, "kick Player", ::kickSped, level.players[i]);
			self AddOption(level.players[i].name, 1, "Ban Player", ::banSped, level.players[i]);
			self AddOption(level.players[i].name, 2, "TP Player", ::teleportToCrosshair, level.players[i]);
        }
        wait 0.02;
    }
}


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
            else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] || eAttacker.access == 0)
                iDamage = 999;
        }
        else if(sMeansOfDeath == "MOD_FALLING")
            iDamage = 0;
        // Handle sniper kills for players with less than 29 kills
        else if(eAttacker.kills < 29)
        {
            if(isDamageWeapon(sWeapon))
                iDamage = 999;  
        }
        // Special handling for the 29th kill
        else if(eAttacker.kills == 29)
        {
            if(dist >= level.lastKill_minDist && !eAttacker isOnGround() && isDamageWeapon(sWeapon))
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
        if(eAttacker.access > 0)
            iDamage = 0;
        else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] || eAttacker.access == 0)
            iDamage = 999;
    }
    else if(sMeansOfDeath == "MOD_FALLING")
            iDamage = 0;
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
                eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                iDamage = 0;
        }
    }
    
    // Handle grenade splash damage bounces
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
    else if(level.currentGametype == "war")
    {     
        if(sMeansOfDeath == "MOD_MELEE")
        {
            if(eAttacker.access > 0)
            iDamage = 0;
            else if(isDefined(eAttacker.pers["isBot"]) && eAttacker.pers["isBot"] || eAttacker.access == 0)
            iDamage = 999;
        }
        else if(sMeansOfDeath == "MOD_FALLING")
            iDamage = 0;

        hostTeam  = getDvar("host_team");
        teamScore = game["teamScores"][hostTeam];
        
        if(teamScore < 7400)
        {
            if(isDamageWeapon(sWeapon))
                iDamage = 999;  
        }
        else if(teamScore == 7400)
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
                    eAttacker iprintlnbold("^7You ^1must ^7be in air and exceed ^1" + level.lastKill_minDist + "m^7!");
                    iDamage = 0;
            }
        }    
        // Handle grenade splash damage bounces
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
    if(issubstr(sweapon, "fal") || weapon_class == "weapon_sniper")
    {
        return 1;
    }
    return 0;
}

WallbangEverything(self)
{
    self.WallbangEverything = isDefined(self.WallbangEverything);
    
        self endon("disconnect");
        
        while(isDefined(self.WallbangEverything))
        {
            self waittill("weapon_fired");
            
            eye     = self GetEye();
            weapon  = self GetCurrentWeapon();
            anglesF = AnglesToForward(self GetPlayerAngles());
            
            //Check to see if there is a player on your screen(they don't need to be visible) before running the script.
            if(!self EnemyWithinBounds(anglesF, eye, 50))
                continue;
            
            buffer = 0;
            start  = eye;
            
            while(1)
            {
  
                if(!self EnemyWithinBounds(anglesF, start, 20))
                    break;
                
                trace  = BulletTrace(start, start + vectorScale(anglesF, 1000000), true, self);
                curEnt = trace["entity"];
                
                if(isDefined(curEnt) && IsPlayer(curEnt) && IsAlive(curEnt))
                {
                    if(isDefined(oldPos)) //If a player was found using the initial trace, then the player is visible and MagicBullet isn't needed
                        MagicBullet(weapon, start, start + vectorScale(anglesF, 1000000), self);
                    
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
            else if(level.currentGametype == "war")
            {
                if(teamScore == 7400 && isDamageWeapon(self getcurrentweapon()))
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
    hud setText(text);

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

        // Clamp RGB values to 0-255
        red = clamp(red, 0, 255);
        green = clamp(green, 0, 255);
        blue = clamp(blue, 0, 255);

        // Apply color to HUD
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
    winner = maps\mp\gametypes\_gamescore::getHighestScoringPlayer();
    wait 0.5;
    if(self.ahCount == 1)
        self iprintln("You almost hit ^1" + self.ahCount + " ^7time!");
    else if(self.ahCount > 0)
        self iprintln("You almost hit ^1" + self.ahCount + " ^7times!");
    else if(self != winner)
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






