    sentryBind(num)
    {
        if( isDefined( self.basedSentry ))
        {
            self iPrintLn("Walking Sentry Bind [^1OFF^7]");
            self.basedSentry = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num + "}] for ^2Walking Sentry");
            self.basedSentry = true;

            while(isDefined(self.basedSentry))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                    self enableWeapons();
                }

                wait .1;
            }
        }
    }

    predBind(num)
    {
        if( isDefined( self.laptop ))
        {
            self iPrintLn("Laptop bind [^1OFF^7]");
            self.laptop = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Laptop");
            self.laptop = true;

            while(isDefined(self.laptop))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");

                wait .001;
            } 
        } 
    }

    bombBind(num)
    {
        if( isDefined( self.bomb ))
        {
            self iPrintLn("Bomb bind [^1OFF^7]");
            self.bomb = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Bomb");
            self.bomb = true;

            while(isDefined(self.bomb))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
                wait .001;
            } 
        } 
    }

    trgrBind(num)
    {
        if( isDefined( self.trgr ))
        {
            self iPrintLn("Trigger bind [^1OFF^7]");
            self.trgr = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to Give ^2Trigger");
            self.trgr = true;

            while(isDefined(self.trgr))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
        
                wait .001;
            } 
        } 
    }

    classBind(classNum)
    {
        if( isDefined( self.ChangeClass ))
        {
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

            self.ChangeClass = true;

            while(isDefined(self.ChangeClass))
            {
                if(self isButtonPressed("+actionslot 2") && !self.menu["isOpen"])
                    self notify( "menuresponse", "changeclass", "custom" + classNum);
                
                wait .001; 
            } 
        } 
    }

    nightVision(num)
    {
        if( isDefined( self.nightVision ))
        {
            self iPrintLn("Night Vision Bind [^1OFF^7]");
            self _SetActionSlot(num, "");
            self.nightVision = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Night Vision");
            self.nightVision = true;
            self.nvPressCount = 0;
            self thread nvSound("+actionslot " + num);

            while(isDefined(self.nightVision))
            {
                if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    self _SetActionSlot(num, "nightvision");
                wait .1;
            }
        }
    }

    nvSound(button)
    {
        self endon("disconnect");
        self endon("stop_nvSound");

        self notifyonplayercommand("nvSound", button);

        for(;;)
        {
            self waittill("nvSound");
            self.nvPressCount++;

            if(self.nvPressCount % 2 == 1)
                self PlaySoundToPlayer( "item_nightvision_on", self);

            else if(self.nvPressCount % 2 == 0)
                self PlaySoundToPlayer( "item_nightvision_off", self);
        }
    }

    Canzoom(num)
        {
            if( isDefined( self.Canzoom ))
            {
                self iPrintLn("Canzoom bind [^1OFF^7]");
                self.Canzoom = undefined; 
            }   
            
            else
            {
                self iPrintLn("Press [{+Actionslot " + num + "}] to ^2Can Zoom");
                self.Canzoom = true;

                while(isDefined(self.Canzoom))
                {
                    if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                            self thread CanzoomFunction();
                    wait 0.01; 
                } 
            } 
        }

        CanzoomFunction()
        {
            self.canswapWeap = self getCurrentWeapon();
            self takeWeapon(self.canswapWeap);
            self giveweapon(self.canswapWeap);
            wait 0.05;
            self setSpawnWeapon(self.canswapWeap);
        }

        nacModSave(num)
        {
            if(num == 1)
            {
                self.wep1 = self getCurrentWeapon();
                self iPrintln("Weapon 1 Selected: [^2" + self.wep1 + "^7]");
            }
            else if(num == 2)
            {
                self.wep2 = self getCurrentWeapon();
                self iPrintln("Weapon 2 Selected: [^2" + self.wep2 + "^7]");
            }
        }

        nacModBind(num)
        {
            if( isDefined( self.NacBind ))
            {
                self iPrintLn("Nac Bind [^1OFF^7]");
                self.NacBind = undefined; 
                self.wep1    = undefined;
                self.wep2    = undefined;
                self iPrintLn("Nac Weapons ^1Reset");
            }
            
            else
            {
                self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Nac");
                self.NacBind = true;
                
                while(isDefined(self.NacBind))
                {
                    if( self GetStance() != "prone"  && !self meleebuttonpressed() )
                    {
                        if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                                heliosNac(); 
                    }
                    wait 0.01;
                } 
            } 
        }

        heliosNac()
        {
            if(self.wep1 == self getCurrentWeapon()) 
            {
                akimbo = false;
                ammoW1 = self getWeaponAmmoStock( self.wep1 );
                ammoCW1 = self getWeaponAmmoClip( self.wep1 );
                self takeWeapon(self.wep1);
                self switchToWeapon(self.wep2);
                while(!(self getCurrentWeapon() == self.wep2))
                
                if (self isHost())
                    wait .1;
                
                else
                    wait .15;
                
                self giveWeapon(self.wep1);
                self setweaponammoclip( self.wep1, ammoCW1 );
                self setweaponammostock( self.wep1, ammoW1 );
            }
            else if(self.wep2 == self getCurrentWeapon()) 
            {
                ammoW2 = self getWeaponAmmoStock( self.wep2 );
                ammoCW2 = self getWeaponAmmoClip( self.wep2 );
                self takeWeapon(self.wep2);
                self switchToWeapon(self.wep1);
                while(!(self getCurrentWeapon() == self.wep1))
                
                if (self isHost())
                    wait .1;
                
                else
                    wait .15;
                
                self giveWeapon(self.wep2);
                self setweaponammoclip( self.wep2, ammoCW2 );
                self setweaponammostock( self.wep2, ammoW2 );
            } 
        }

        skreeModSave(num)
        {
            if(num == 1)
            {
                self.snacwep1 = self getCurrentWeapon();
                self iPrintln("Weapon 1 Selected: [^2" + self.snacwep1 + "^7]");
            }
            else if(num == 2)
            {
                self.snacwep2 = self getCurrentWeapon();
                self iPrintln("Weapon 2 Selected: [^2" + self.snacwep2 + "^7]");
            }
        }

        skreeBind(num)
        {
            if( isDefined( self.SnacBind ))
            {
                self iPrintLn("Skree Bind [^1OFF^7]");
                self.SnacBind = undefined; 
                snacwep1      = undefined;
                snacwep2      = undefined;
                self iPrintLn("Skree Weapons ^1Reset");
            }

            else
            {
                self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Skree");
                self.SnacBind = true;
                
                while(isDefined(self.SnacBind))
                {
                    if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                    {
                        if(self getCurrentWeapon() == self.snacwep1)
                        {
                            self SetSpawnWeapon( self.snacwep2 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep1 );
                        }
                        else if(self getCurrentWeapon() == self.snacwep2)
                        {
                            self SetSpawnWeapon( self.snacwep1 );
                            wait .12;
                            self SetSpawnWeapon( self.snacwep2 );
                        } 
                    }
                    wait 0.01; 
                } 
            } 
        }

        gFlipBind(num)
        {
            if( isDefined( self.Gflip ))
            {
                self iPrintLn("GFlip bind [^1OFF^7]");
                self notify("stopProne1");
                self.Gflip = undefined;
            }

            else
            {
                self iPrintLn("Press [{+Actionslot " + num +"}] to ^2GFlip");
                self.Gflip = true;

                while(isDefined(self.Gflip))
                {
                        if(self isbuttonpressed("+actionslot " + num) && !self.menu["isOpen"])
                            self thread MidAirGflip();
                    wait 0.01; 
                } 
            } 
        }

        MidAirGflip()
        {
            self endon("stopProne1");
            self setStance("prone");
            wait 0.01;
            self setStance("prone");
        }