    UFOMode()
    {
        if(level.oomUtilDisabled)
        {
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
            return;
        }

        if(!isDefined( self.UFOMode ))
        {
            self.UFOMode = true;
            self thread UFODude();
        }
        else
        {
            self.UFOMode = undefined;
            self notify("stop_ufo");
        }
    }

    UFODude()
    {
        self endon("stop_ufo");
        self endon("unverified");

        if(isdefined(self.N))
        self.N delete();
        self.N  = spawn("script_origin", self.origin);
        self.On = 0;
        for(;;)
        {
            if(self secondaryoffhandbuttonpressed())
            {
                self.On       = 1;
                self.N.origin = self.origin;
                self linkto(self.N);
            }
            else
            {
                self.On = 0;
                self unlink();
            }
            if(self.On == 1)
            {
                vec           = anglestoforward(self getPlayerAngles());
                end           = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
                self.N.origin = self.N.origin+end;
            }
            wait 0.05;
        }
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
                self setVelocity(self getVelocity() + (0, 0, 1500));

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
            {
                break;
            }

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

    doSpawnables( action, type )
    {
        switch( type )
        {
            case "slide":
            if( action == "delete" )
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
            }

            else
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

                self.spawnedSlide = spawn("script_model",bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100, 0,self)["position"] + (0, 0, 20));
                self.spawnedSlide.angles = (0, self getPlayerAngles()[1] - 90, 60);
                self.spawnedSlide setModel("mp_supplydrop_ally");
                self.slideThread = self thread makeSlide(self.spawnedSlide);
            }
            break;

            case "bounce":
            if( action == "delete" )
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

            else
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
                self.spawnedTrampoline setModel("mp_supplydrop_ally");
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
            }

            else
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
                    {
                        self.spawnedplat[i][d] = spawn("script_model", startpos + (d * 25, i * 45, 0));
                        self.spawnedplat[i][d] setModel("mp_supplydrop_ally");
                        self.spawnedplat[i][d].angles = (0, 0, 0);
                    }
                }
            }
            break;

            case "crate":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Crate Spawning is [^1Disabled^7]!");
                return;
            }
            
            if( action == "delete" )
            {
                if (isDefined(self.spawnedcrate))
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

                cratePos = self.origin + (0, 0, -15); 
                self.spawnedcrate = spawn("script_model", cratePos);
                self.spawnedcrate setModel("mp_supplydrop_ally");
                self.spawnedcrate.angles = (0, 0, 0);
            }
            break;
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
        if(level.currentGametype == "dm")
        {
            self.kills   = 28;
            self.score   = 1400;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 1400;
        }
    }

    getprimary()
    {
        class = self.class;
        class_num      = int( class[class.size-1] )-1; 
        primaryweapon  = self.custom_class[class_num]["primary"];
        return primaryweapon;
    }

    getsecondary()
    {
        class = self.class;
        class_num      = int( class[class.size-1] )-1; 
        secondaryweapon = self.custom_class[class_num]["secondary"];
        return secondaryweapon;
    }

    dropCanswap()
    {
        weap = "hk21_mp";
        self giveweapon(weap);
        self dropitem(weap);
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

    toggleSuiBind()
    {
        if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
            self setPlayerCustomDvar( "suicideBind", "0" );
        
        else
            self setPlayerCustomDvar( "suicideBind", "1" );
    }