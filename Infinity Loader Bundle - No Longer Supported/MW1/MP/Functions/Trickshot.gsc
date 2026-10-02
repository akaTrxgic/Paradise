    NoClip()
    {
        if(level.oomUtilDisabled)
        {
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
            return;
        }

        if (!self.ufo)
        {
            self thread onUfo();
            self.ufo = 1;
        }
        else
        {
            self notify("stop_ufo");
            self.ufo = 0;
        }
    }

    onUfo()
    {
        self endon("stop_ufo");
        
        if (isdefined(self.N))
        self.N delete();
        
        self.N = spawn("script_origin", self.origin);
        self.On = 0;
        
        for (;;)
        {
            if (self SecondaryOffHandButtonPressed())
            {
                self.On = 1;
                self.N.origin = self.origin;
                self linkto(self.N);
            }
            else
            {
                self.On = 0;
                self unlink();
            }
            
            if (self.On)
            {
                vec = anglestoforward(self getPlayerAngles());
                end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
                self.N.origin = self.N.origin + end;
            }
            
            wait 0.05;
        }
    }

    instashoot()
    {
        if( isDefined( self.instashoot ))
        {
            self.instashoot = undefined;
            self notify( "stop_Instashoots" );
        }

        else
        {
            self.instashoot = true;
            self thread instaShootLoop();
        }
    }

    instaShootLoop()
    {
        self endon( "disconnect" );
        self endon( "stop_Instashoots" );

        for(;;)
        {
            self waittill( "weapon_change" );

            self disableweapons();
            wait .0001;
            self enableWeapons();
            wait .0001;
        }
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

            else if(self.currCan)
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
        while(self.currCan)
        {
            self waittill("weapon_change", self.currCanWpn);
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
        if (level.currentGametype == "dm")
        {
            self.score = 140;
            self.pers[ "score" ] = 140;
            self.kills = 28;
            self.pers[ "kills" ] = 28;
        }
    }

    dropCanswap()
    {
        weap = "rpd_mp";
        self giveweapon(weap);
        self dropitem(weap);
    }

    monitortrampoline(model)
    {
        self endon("disconnect");
        level endon("game_ended");

        cooldown = false;

        for (;;)
        {
            if (!isDefined(model))
                break;

            playerPos = self.origin;
            modelPos = model.origin;

            deltaX = playerPos[0] - modelPos[0];
            deltaY = playerPos[1] - modelPos[1];
            horizontalDist = sqrt(deltaX * deltaX + deltaY * deltaY);

            verticalDist = abs(playerPos[2] - modelPos[2]);
            
            if (!cooldown && horizontalDist < 85 && verticalDist < 50)
            {
                cooldown = true;

                startOrigin = self.origin;
                duration = 0.7;    
                steps = 20;        
                stepTime = duration / steps;

                for (i = 0; i <= steps; i++)
                {
                    fraction = i / steps;
                    newOrigin = startOrigin + (0, 0, 500 * fraction);
                    self setOrigin(newOrigin);
                    wait stepTime;
                }

                wait 1; 

                cooldown = false;
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

    makeSlide(model, slidePos)
    {
        level endon("game_ended");
        self endon("disconnect");
        self endon("stop_slide");

        for (;;)
        {
            foreach(player in level.players)
            {
                if (!isDefined(model))
                break;

                playerPos = player.origin;
                modelPos = model.origin;

                deltaX = playerPos[0] - modelPos[0];
                deltaY = playerPos[1] - modelPos[1];
                horizontalDist = sqrt(deltaX * deltaX + deltaY * deltaY);

                verticalDist = abs(playerPos[2] - modelPos[2]);
            
                if (horizontalDist < 85 && verticalDist < 50 && player meleeButtonPressed() && !self.menu["isOpen"])
                {
                
                    startOrigin = player.origin;
                    targetOrigin = startOrigin + (0, 0, 0);
                    
                    duration = 1.0; 
                    steps = 20; 
                    stepTime = duration / steps; 

                    
                    for (i = 0; i <= steps; i++)
                    {
                        
                        fraction = i / steps;
                        newOrigin = startOrigin + (0, 0, 500 * fraction);
                        player setOrigin(newOrigin);
                        wait stepTime;
                    }

                    wait 1; 
                }
            }
            wait 0.05; 
        }
    }

    doSpawnables( action, type )
    {
        switch( type )
        {
            case "slide":
            if (action == "delete")
            {
                if( isDefined(self.slideThread) )
                {
                    self.slideThread delete();
                    self.slideThread = undefined;
                }

                if( isDefined(self.spawnedSlide) )
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }
            }

            else
            {
                if(isDefined(self.slideThread))
                {
                    self.slidethread delete();
                    self.slideThread = undefined;
                }

                if(isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }

                slidePos = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 10000, 0, self)["position"] + (0, 0, 50);
                self.spawnedSlide = spawn("script_model", slidePos);
                playngles = self getPlayerAngles();
                self.spawnedSlide.angles = (130, playngles[1] + 0, 180);
                self.spawnedSlide setModel("com_plasticcase_beige_big");
                self.slideThread = self thread makeSlide(self.spawnedSlide);
            }
            break;

            case "bounce":
            if (action == "delete")
            {
                if( isDefined( self.trampolineThread ) )
                {
                    self.trampolineThread delete();
                    self.trampolineThread = undefined;
                }

                if( isDefined( self.spawnedTrampoline ) )
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }
            }

            else
            {
                if (isDefined(self.trampolineThread))
                {
                    self.trampolineThread delete();
                    self.trampolineThread = undefined;
                }
                if( isDefined( self.spawnedTrampoline ) )
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }

                bouncePos = self.origin + (0,0,-30);

                self.spawnedTrampoline = spawn("script_model", bouncePos);
                self.spawnedTrampoline.angles = (0, 0, 0);
                self.spawnedTrampoline setModel("com_plasticcase_beige_big");
                self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
            }
            break;

            case "platform":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
                return;
            }

            if( action == "delete" )
            {
                if(isDefined(self.spawnedPlatform))
                {
                    for(i = -3; i < 3; i++)
                    {
                        if(!isDefined(self.spawnedPlatform[i]))
                            continue;
                            
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(self.spawnedPlatform[i][d]))
                                self.spawnedPlatform[i][d] delete();
                        }
                    }
                }

                //collisions?
            }

            else
            {
                if(!isDefined(self.spawnedPlatform))
                self.spawnedPlatform = [];
                
                if(isDefined(self.spawnedPlatform))
                {
                    for(i = -3; i < 3; i++)
                    {
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(self.spawnedPlatform[i][d]))
                                self.spawnedPlatform[i][d] delete();
                        }
                    }
                }

                startpos = self.origin + (0, 0, -35);
                barrierpos = self.origin + (0, 0, -60);

                for(i = -3; i < 3; i++)
                { 
                    if(!isDefined(self.spawnedPlatform[i]))
                        self.spawnedPlatform[i] = [];
                        
                    for(d = -3; d < 3; d++)
                    {
                        self.spawnedPlatform[i][d] = spawn("script_model", startpos + (d * 56, i * 30, 0));
                        self.spawnedPlatform[i][d] setModel("com_plasticcase_beige_big");
                        self.spawnedPlatform[i][d].angles = (0, 0, 0);
                    }
                }
                
                //collisions?               
                
                self setorigin(startpos + (0, 0, 60));
            }
            break;

            case "crate":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Crate Spawning is[^1Disabled^7]!");
                return;
            }

            if (action == "delete")
            {
                if( isDefined(self.spawnedcrate) )
                {
                    self.spawnedcrate delete();
                    self.spawnedcrate = undefined;
                }
            }

            else
            {               
                if (isDefined(self.spawnedcrate))
                {
                    self.spawnedcrate delete();
                    self.spawnedcrate = undefined;
                }
                
                //collisions?

                cratePos = self.origin + (0, 0, -30); 
                self.spawnedcrate = spawn("script_model", cratePos);
                self.spawnedcrate setModel("com_plasticcase_beige_big");
                self.spawnedcrate.angles = (0, 0, 0);
                self setorigin(cratePos + (0, 0, 15));
            }
            break;
        }
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
    }

    endGame()
    {
        level thread maps\mp\gametypes\_globallogic::forceEnd();
    }

    toggleSuiBind()
    {
        if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
            self setPlayerCustomDvar( "suicideBind", "0" );
        
        else
            self setPlayerCustomDvar( "suicideBind", "1" );
    }
