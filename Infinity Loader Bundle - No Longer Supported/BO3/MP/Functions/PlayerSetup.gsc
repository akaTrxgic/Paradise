    doWelcomeMessage()
    {
        switch( level.currentGametype )
        {
            case "dm":
            mode = "FFA";
            break;
        }

        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise " + mode +"!");
    }
    
    mainBinds()
    {
        self endon("disconnect");
        
        for(;;)
        {
            if(self getStance() == "crouch" && self meleeButtonPressed() && !self.menu["isOpen"])
            {
                self thread refillAmmo();
                wait 0.3;
            }
            wait 0.05;
        }
    }

    refillAmmo()
    {
        self givemaxammo(self getprimary());
        self givemaxammo(self getsecondary());
        self givestartammo(self getcurrentoffhand());
        self givestartammo(self getoffhandsecondaryclass());
        wait .4;
    }

    wallbangeverything()
    {
        self endon( "disconnect" );

        while(true)
        {
            self waittill( "weapon_fired", weapon );

            if(!( getweapon(isDamageWeapon(weapon))))
                continue;
            
            if(self.pers["isBot"] && isDefined(self.pers["isBot"]))
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
                    magicbullet( getweapon(self getcurrentweapon()), savedpos[ a], vectorscale( anglesf, 1000000 ), self );
                a++;
            }
            wait 0.05;
        }
    }

    bulletImpactMonitor()
    {
        self endon("disconnect");
        level endon("game_ended");

        for(;;)
        {
            self waittill("weapon_fired");

            eAttacker = self;

            if(self isOnGround())
                continue;

            start = self getTagOrigin("tag_eye");
            end = anglestoforward(self getPlayerAngles()) * 1000000;
            impact = BulletTrace(start, end, true, self)["position"];
            nearestDist = 150;

            hostTeam = (getDvar("host_team"));
            enemyTeam = getOtherTeam(eAttacker.team);

            foreach(player in level.players)
            {
                dist = distance(player.origin, impact);

                weapon = self getcurrentweapon();

                if(dist < nearestDist && getweapon(isdamageweapon(weapon)) && player != self)
                {
                    nearestDist = dist;
                    nearestPlayer = player;
                }
            }

            if(nearestDist != 150)
            {
                ndist = nearestDist * 0.0254;
                ndist_i = int(ndist);

                ndist = ( ndist_i < 1 ) ? getsubstr( ndist, 0, 3 ) : ndist_i;

                distToNear = distance(self.origin, nearestPlayer.origin) * 0.0254;
                dist = int(distToNear);

                distToNear = ( dist < 1 ) ? getsubstr( distToNear, 0, 3) : dist;

                if(level.currentGametype == "dm")  
                    if(self.kills == 29 && isAlive(nearestPlayer) && getweapon(isDamageWeapon(weapon)))
                        self thread registerAlmostHit(nearestPlayer, dist);
            }
        }
    }

    registerAlmostHit(nearestPlayer, dist)
    {
        iprintln("^2" + self.name + "^7 almost hit ^1" + nearestPlayer.name + " ^7from ^1" + dist + "m^7!");
        self.ahCount++;

        if(self.ahCount % 3 == 0) self iprintlnbold( "^1" + rndmmgfunnymsg() );
    }

    trackstats()
    {
        self endon("disconnect");
        level waittill("game_ended");

        if(level.currentGametype == "dm")
        {
            wait 0.5;

            if(self.ahCount == 1) self iprintln("You almost hit ^1" + self.ahCount + " ^7time!");

            else if(self.ahCount > 0) self iprintln("You almost hit ^1" + self.ahCount + " ^7times!");
            
            else self iprintln("You didn't almost hit ^1anyone^7! " + self rndmEGfunnyMsg());
        }
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

    FastLast( player )
    {
        if( !isDefined( player ) ) player = self;

        switch( level.currentGametype )
        {
            case "dm":
            player.pointstowin = 29;
            player.kills   = 29;
            player.score   = 29;
            player.pers["pointstowin"] = 29;
            player.pers["kills"] = 29;
            player.pers["score"] = 29;
            break;
        }
    }

    menuInst()
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        menuInst = self hud::CreateFontString( "objective", 1 );

        self.menuInst = menuInst;

        menuInst.x = -250;
        menuInst.y = 460;

        menuInst.alpha = ( self GetPlayerCustomDvar( "menuInst" ) == "0" ) ? 0 : 1;

        instString = ( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" ) ? "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise" : "[{" + self.presets["BindOne"] + "}] = Paradise";
        menuInst setsafetext( instString );

        self thread monitorMenuState( menuInst );
    }

    monitorMenuState( menuInst )
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        for( ;; )
        {
            wait 0.05;

            instString = ( isDefined( self.menu["isOpen"] ) && self.menu["isOpen"] ) ? "[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select [{+melee}] = Back/Close" : ( (isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none") ? "[{" + self.presets["BindOne"] + "}] + [{" + self.presets["BindTwo"] + "}] = Paradise" : "[{" + self.presets["BindOne"] + "}] = Paradise" );
            menuInst setsafeText( instString );
        }
    }

    toggleMenuInst()
    {
        if( self GetPlayerCustomDvar( "menuInst" ) == "1" )
        {
            self SetPlayerCustomDvar( "menuInst", "0" );
            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 0;
        }
        else
        {
            self SetPlayerCustomDvar( "menuInst", "1" );
            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 1;
        }
    }

    changeClass()
    {
        self endon("disconnect");

        game["strings"]["change_class"] = "";

        for(;;)
        {
            self waittill("menuresponse", menu, response);
            if (response == "cancel") 
                return;

            self.selectedclass = 1;
            self CloseInGameMenu();

            playerclass = self loadout::getclasschoice(response);
            if (isDefined(self.pers["class"]) && self.pers["class"] == playerclass) 
                return;

            if (isDefined(self.curclass) && self.curclass == playerclass)
                self.pers["changed_class"] = false;
            else
                self.pers["changed_class"] = true;

            self notify("changed_class");

            self.pers["class"]  = playerclass;
            self.curclass       = playerclass;
            self.pers["weapon"] = undefined;

            if (self.sessionstate == "playing")
            {
                self loadout::setclass(playerclass);
                self.tag_stowed_back = undefined;
                self.tag_stowed_hip = undefined;
                self loadout::giveloadout(self.pers["team"], playerclass);
                self killstreaks::give_owned();
            }
            wait .1;
        }
    }