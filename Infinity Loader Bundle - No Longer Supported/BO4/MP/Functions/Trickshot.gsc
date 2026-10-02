    
    initNoClip()
    {
        if(level.oomUtilDisabled)
        {
            self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
            return;
        }

        if( isDefined( self.NoClip ) )
        {
            self.NoClip = undefined;
            self notify("stop_noclip");
        }
        
        else
        {
            self thread Noclip();
            self.NoClip = true;
        }
    }

    Noclip()
    {
        self endon("stop_noclip");
        if( !isDefined( self.noClipSpeed ) ) self.noClipSpeed = 50;

        for( ;; )
        {
            if( self fragbuttonpressed())
            {
                if( !isDefined( self.NoClipOBJ ) )
                {
                    self.originObj = spawn( "script_origin", self.origin, 1 );
                    self.originObj.angles = self.angles;
                    self playerlinkto( self.originObj, undefined );
                    self.NoClipOBJ = true;
                }
                normalized = anglesToForward( self getPlayerAngles() );
                scaled = vectorScale( normalized, self.noClipSpeed );
                originpos = self.origin + scaled;
                self.originObj.origin = originpos;
            }
            else
            {
                if( isDefined( self.NoClipOBJ ) )
                {
                    self unlink();
                    self enableweapons();
                    self.originObj delete();
                    self.originObj = undefined;
                    self.NoClipOBJ = undefined;
                }
                wait .05;
            }
            wait .05;
        }
    }

    SetCanswapMode(type)
    {
        if(type == "Current") 
        {
            if( isDefined( self.currCan ) )
            {
                self.currCan = undefined;
                self notify( "stop_currCan" );
                self iprintln("Canswap Mode: [^1OFF^7]");
                return;
            }

            else
            {
                if( isDefined( self.InfiniteCan ) )
                    self.InfiniteCan = undefined;

                self.currCan = true;
                self.currCanWpn = self getcurrentweapon();
                self iprintln( "Canswap Weapon: [^2" + self.currCanWpn.name + "^7]" );
                self thread CurrCanswapLoop();
            }
        }

        else if(type == "Infinite") 
        {
            if( isDefined( self.InfiniteCan ) )
            {
                self.InfiniteCan = undefined;
                self notify( "stop_infCan" );
                self iprintln("Canswap Mode: [^1OFF^7]");
                return;
            }

            else
            {
                if( isDefined( self.currCan ) )
                    self.currCan = undefined;

                self.InfiniteCan = true;
                self iprintln("Canswap Mode: [^2Infinite^7]");
                self thread InfiniteCanswapLoop();
            }
        }
    }

    CurrCanswapLoop()
    {
        self endon( "disconnect" );
        self endon( "stop_currCan" );

        while( isDefined( self.currCan ) )
        {
            self waittill( #"weapon_change" );

            if( isDefined( self.isSwappingCan ) )
                continue;

            wait .0001;

            if( isDefined( self.currCanWpn ) && self getCurrentWeapon() == self.currCanWpn )
            {
                self.isSwappingCan = true;

                self.WeapClip  = self getWeaponAmmoClip( self.currCanWpn );
                self.WeapStock = self getWeaponAmmoStock( self.currCanWpn );
                self takeWeapon( self.currCanWpn );
                waittillframeend;
                self giveWeapon( self.currCanWpn );
                self setWeaponAmmoStock( self.currCanWpn, self.WeapStock );
                self setWeaponAmmoClip( self.currCanWpn, self.WeapClip );

                self switchToWeapon( self.currCanWpn );

                wait .0001;

                self.isSwappingCan = undefined;
            }

            wait .0001;
        }
    }

    InfiniteCanswapLoop()
    {
        self endon( "disconnect" );
        self endon( "stop_infCan" );

        while( isDefined( self.InfiniteCan ) )
        {
            self waittill( #"weapon_change" );

            if( isDefined( self.isSwappingCan ) )
                continue;

            wait 0.05;

            currentWeapon = self getCurrentWeapon();

            if( isDefined( currentWeapon ) )
            {
                self.isSwappingCan = true;

                clip  = self getWeaponAmmoClip( currentWeapon );
                stock = self getWeaponAmmoStock( currentWeapon );

                self takeWeapon( currentWeapon );

                waittillframeend;

                self giveWeapon( currentWeapon );

                self setWeaponAmmoStock( currentWeapon, stock );
                self setWeaponAmmoClip( currentWeapon, clip );

                self switchToWeapon( currentWeapon );

                wait 0.2;

                self.isSwappingCan = undefined;
            }
        }
    }

    slide()
    {
        self notify("stop_slide");

        if (isDefined(self.spawnedSlide))
        {
            self.spawnedSlide delete();
            self.spawnedSlide = undefined;
        }

        self.spawnedSlide = spawn( "script_model", bullettrace( self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100, 0, self )["position"] + (0, 0, 20) );
        self.spawnedSlide.angles = (0, self getPlayerAngles()[1] - 90, 60);
        self.spawnedSlide setModel("p8_care_package_01_a");

        self.slideThread = self thread makeSlide( self.spawnedSlide );
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

                if ( isDefined(player) && isDefined(slideEntity) && player isInPos(slideEntity.origin) && player attackButtonPressed() && !player.menu["isOpen"] )
                {
                    playngles2 = anglesToForward(player getPlayerAngles());

                    player setVelocity(
                        player getVelocity() +
                        (playngles2[0] * 750, playngles2[1] * 750, 200)
                    );

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
            if( action == "Delete" )
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

                self.spawnedSlide = spawn("script_model", bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,0,self)["position"] + (0, 0, 20));
                self.spawnedSlide.angles = (0, self getPlayerAngles()[1] - 90, 60);
                self.spawnedSlide setModel("p8_care_package_01_a");
                self.slideThread = self thread makeSlide(self.spawnedSlide);
            }
            break;

            case "bounce":
            if( action == "Delete" )
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

                self.spawnedTrampoline = spawn("script_model", self.origin + (0,0,-15));
                self.spawnedTrampoline setModel("p8_care_package_01_a");
                self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
            }
            break;

            case "platform":
            if(level.oomUtilDisabled)
            {
                self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
                return;
            }

            if( action == "Delete" )
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
                
                startpos = self.origin + (0, 0, -15);

                for(i = -3; i < 3; i++)
                { 
                    if(!isDefined(self.spawnedplat[i]))
                        self.spawnedplat[i] = [];
                
                    for(d = -3; d < 3; d++)
                    {
                        self.spawnedplat[i][d] = spawn("script_model", startpos + (d * 35, i * 70, 0));
                        self.spawnedplat[i][d] setModel("p8_care_package_01_a");
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

            if( action == "Delete" )
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
                self.spawnedcrate setModel("p8_care_package_01_a");
                self.spawnedcrate.angles = (0, 0, 0);
            }
            break;
        }
    }

    monitortrampoline(model)
    {
        self endon( "disconnect" );
        level endon( "game_ended" );

        for(;;)
        {
            if (!isDefined(model))
                break;

            if(distance(self.origin, model.origin) < 85 )
                self setvelocity( self getvelocity() + ( 0, 0, 999 ) );

            wait 0.01;
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