    initNoClip()
    {    
        if( level.oomUtilDisabled )
        {
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
            return;
        }

        if(!self.NoClipT)
        {
            self thread doNoClip();
            self.NoClipT = 1;
        }
        else
        {
            self notify("EndNoClip");
            self.NoClipT = 0;
        }
    }

    doNoClip()
    {
        self endon("EndNoClip");
        self.Fly = 0;
        UFO = spawn("script_model", self.origin);
        for (;;) 
        {
            if (self FragButtonPressed()) 
            {
                self playerLinkTo(UFO);
                self.Fly = 1;
            } else {
                self unlink();
                self.Fly = 0;
            }
            if (self.Fly == 1) {
                Fly = self.origin + vectorScale(anglesToForward(self getPlayerAngles()), 20);
                UFO moveTo(Fly, .01);
            }
            wait .001;
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
                self setVelocity(self getVelocity() + (0, 0, 200));

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
                break;

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
                        player setVelocity(player getVelocity() + (0, 0, 100));
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

    SpawnScriptModel(origin,model,angles,time,clip)
    {
        if(isDefined(time)) wait time;

        ent = spawn("script_model",origin);
        ent SetModel(model);

        if(isDefined(angles))
            ent.angles = angles;

        if(isDefined(clip))
            ent CloneBrushModelToScriptModel(clip);

        return ent;
    }

    doSpawnables( action, type )
    {
        switch( type )
        {
            case "cpStall":
            if( action == "delete" )
            {
                if( isDefined( self.spawnedCP ) )
                    self.spawnedCP maps\mp\killstreaks\_airdrop::deleteCrate();
            }

            else
            {
                if ( isDefined( self.spawnedCP ) )
                    self.spawnedCP maps\mp\killstreaks\_airdrop::deleteCrate();

                cpOrigin = bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglesToForward( self getplayerangles() ) * 100, 0, self )[ "position" ] + ( 0, 0, 20 );
                self.spawnedCP = spawnscriptmodel( cpOrigin, "com_plasticcase_friendly", self.angles,(0,0,0),level.airdropcratecollision);
                self.spawnedCP.team = self.team;
                self.spawnedCP.owner = self;
                self.spawnedCP.cratetype = "uav";
                self.spawnedCP maps\mp\killstreaks\_airdrop::killstreakCrateThink("airdrop_assault");
            }
            break;

            case "slide":
            if (action == "delete")
            {
                if( isDefined(self.slideThread) )
                {
                    self.slideThread delete();
                    self.slideThread = undefined;
                }

                if( isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }
            }

            else
            {
                if (isDefined(self.slideThread))
                {
                    self.slideThread delete();
                    self.slideThread = undefined;
                }
                if (isDefined(self.spawnedSlide))
                {
                    self.spawnedSlide delete();
                    self.spawnedSlide = undefined;
                }

                slideOrigin = (bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,0,self)["position"] + (0, 0, 20));
                self.spawnedSlide = spawnscriptmodel(slideOrigin, "carepackage_friendly_iw6", self.spawnedSlide.angles, (0,0,0), level.airdropcratecollision);
                self.spawnedSlide.angles = (60, self getPlayerAngles()[1] - 180, 0);
                self.slideThread = self thread makeSlide(self.spawnedSlide);
            }
            break;

            case "bounce":
            if(action == "delete")
            {
                if(isDefined(self.trampolineThread))
                {
                    self.trampolineThread delete();
                    self.trampolineThread = undefined;
                }

                if(isDefined(self.spawnedTrampoline))
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

                if( isDefined( self.spawnedTrampoline))
                {
                    self.spawnedTrampoline delete();
                    self.spawnedTrampoline = undefined;
                }
        
                self.spawnedTrampoline = spawn("script_model", self.origin);
                self.spawnedTrampoline setModel("carepackage_friendly_iw6");
                self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
            }
            break;

            case "platform":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
                return; 
            }

            if( action == "delete")
            {
                if(!isDefined(self.spawnedplat))
                self.spawnedplat = [];
            
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

                startpos = self.origin + (0, 0, -15);

                for(i = -3; i < 3; i++)
                {    
                    if(!isDefined(self.spawnedplat[i]))
                    self.spawnedplat[i] = [];
                
                    for(d = -3; d < 3; d++)
                        self.spawnedplat[i][d] = spawnScriptModel(startpos + (d * 56, i * 30, 0),"carepackage_friendly_iw6",(0,0,0),0,level.airDropCrateCollision);
                }
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
                if(isDefined(self.spawnedcrate))
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

                self.spawnedcrate = spawnscriptmodel(self.origin + (0, 0, -15), "carepackage_friendly_iw6", (0,0,0), 0, level.airdropcratecollision);
            }
            break;
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
            self.score   = 28;
            self.pers["pointstowin"] = 28;
            self.pers["kills"] = 28;
            self.pers["score"] = 28;
        }
    }

    dropCanswap()
    {
        weap = "iw6_m27_mp";
        self giveweapon(weap);
        self dropitem(weap);
    }

    toggleSuiBind()
    {
        if( self getPlayerCustomDvar( "suicideBind" ) == "1" )
            self setPlayerCustomDvar( "suicideBind", "0" );
        
        else
            self setPlayerCustomDvar( "suicideBind", "1" );
    }