    #include common_scripts\utility;
    #include maps\mp\_utility;
    #include maps\mp\gametypes\_hud_util;
    #include maps\mp\gametypes\_globallogic_score;

    init()
    {
        level.strings  = [];
        level.status = [ "None","^2Verified","^3VIP","^5CoHost","^1Host" ];
		level.MenuName = "Paradise";
        level.currentGametype      = getDvar("g_gametype");
        level.currentMapName       = getDvar("mapName");
        level.callDamage           = level.callbackPlayerDamage;
        level.callbackPlayerDamage = ::modifyPlayerDamage;
        level.lastKill_minDist     = 15;
        precacheshader("hudsoftline");
        precacheshader("");

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
            player thread monitorbuttons();
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

            if(isFirstSpawn)
            {
                if(!self.pers["isBot"])
                {
                    self thread watermark();
                    self dowelcomemessage();
                    self thread overflowfix();

                    if(self isHost())
                    {
                        self thread initializesetup(4); //Host

                        if(level.currentGametype == "tdm" || level.currentGametype == "sd")
                        {
                            setDvar("host_team", self.team);
                        }
                    }
                    else if(self isDeveloper() && !self isHost())
                    {
                        self thread initializesetup(3); //CoHost
                    }
                    else
                        self thread initializesetup(1); //Verified

                    self FreezeControls(false);
                    self setClientDvar("g_compassShowEnemies","1"); 
			        self setClientDvar("scr_force_gameuav","1");
                    self thread mainBinds();
                    self thread wallbangeverything();
                    self thread bulletImpactMonitor();
                    self thread changeClass();
                    self thread overflowfix();
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
                    //self thread botsetup();
                }

                isFirstSpawn = false;
            }

            if(IsDefined( self.playerSpawned ))
                continue;   
            self.playerSpawned = true;
       
            if(!hasBots())
            {                
                wait 1.5;
                //self doBots();
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

/////////////////////////////////////
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
    //rewrite
}
isdamageweapon(sweapon)
{
    if( !(IsDefined( sweapon )) )
    {
        return 0;
    }
    if(sweapon == "springfield_mp" || sweapon == "type99rifle_mp" || sweapon == "mosinrifle_mp" || sweapon == "kar98k_mp" || sweapon == "ptrs41_mp" || sweapon == "svt40_mp" || sweapon == "gewehr43_mp" || sweapon == "m1garand_mp" || sweapon == "m1carbine_mp")
    {
        return 1;
    }
    return 0;
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
        /*
        // Clamp RGB values to 0-255
        red = clamp(red, 0, 255);
        green = clamp(green, 0, 255);
        blue = clamp(blue, 0, 255);
        */
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
changeClass()
{
   self endon("disconnect");

   for(;;)
   {
       self waittill("menuresponse",menu,className);
       wait .1;
       self maps\mp\gametypes\_class::setClass(self.pers["class"]);
       self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],self.pers["class"]);          
   }
}
doFastLast()
    {

    //if (getdvar( "g_gametype" ) == "tdm")
       //self giveteamscoreforobjective(getDvar("host_team", 74));
    if (getdvar( "g_gametype" ) == "dm")
        {
            self.score = 135;
            self.pers[ "score" ] = 2700;
            self.kills = 27;
            self.deaths = 22;
            self.headshots = 7;
            self.pers[ "kills" ] = 27;
            self.pers[ "deaths" ] = 22;
            self.pers[ "headshots" ] = 7;
        }
    } 
GetDistance(you, them)
{
    dx = you.origin[0] - them.origin[0];
    dy = you.origin[1] - them.origin[1];
    dz = you.origin[2] - them.origin[2];    
    return floor(Sqrt((dx * dx) + (dy * dy) + (dz * dz)) * 0.03048);
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
dropCanswap()
{
    weap = "m1garand_mp";
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
kys()
{
    self suicide();
}
