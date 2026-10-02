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
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
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
                    if(num == 1)
                    {
                        if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 2)
                    {
                        if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 3)
                    {
                        if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 4)
                    {
                        if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
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
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
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
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
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
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
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
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
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
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
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

    samTurretBind(num)
    {
        if( isDefined( self.basedSAM ))
        {
            self iPrintLn("Walking SAM Bind [^1OFF^7]");
            self.basedSAM = undefined; 
        }
        
        else
        {
            self iPrintLn("Press [{+actionslot " + num +"}] for ^2Walking SAM");
            self.basedSAM = true;

            while(isDefined(self.basedSAM))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useTowTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useTowTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useTowTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useTowTurret(self);
                        self enableWeapons();
                    }
                }
                wait .001; 
            }
        }
    }

    sentryBind(num)
    {
        if( isDefined( self.basedSentry ))
        {
            self iPrintLn("Walking Sentry Bind [^1OFF^7]");
            self.basedSentry = undefined;
        }   

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] for ^2Walking Sentry");
            self.basedSentry = true;

            while(isDefined(self.basedSentry))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                        self enableWeapons();
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                        self enableWeapons();
                    }
                }
                wait .001; 
            }
        }
    }

    cowboyBind(num)
    {
        if( isDefined( self.CowboyBind ))
        {
            self iPrintLn("Cowboy bind [^1OFF^7]");
            self.CowboyBind = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Cowboy");
            self.CowboyBind = true;

            while(isDefined(self.CowboyBind))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingCowboy)
                        {
                            self.DoingCowboy = true;
                            self setClientDvar("cg_gun_z", 8);
                        }
                        else
                        {
                            self.DoingCowboy = false;
                            self setClientDvar("cg_gun_z", 0);
                        }
                    }
                } 
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingCowboy)
                        {
                            self.DoingCowboy = true;
                            self setClientDvar("cg_gun_z", 8);
                        }
                        else
                        {
                            self.DoingCowboy = false;
                            self setClientDvar("cg_gun_z", 0);
                        }
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingCowboy)
                        {
                            self.DoingCowboy = true;
                            self setClientDvar("cg_gun_z", 8);
                        }
                        else
                        {
                            self.DoingCowboy = false;
                            self setClientDvar("cg_gun_z", 0);
                        }
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingCowboy)
                        {
                            self.DoingCowboy = true;
                            self setClientDvar("cg_gun_z", 8);
                        }
                        else
                        {
                            self.DoingCowboy = false;
                            self setClientDvar("cg_gun_z", 0);
                        }
                    }
                }
                wait .001; 
            }
        } 
    }

    rvrsCowboyBind(num)
    {
        if( isDefined( self.rcowboy ))
        {
            self iprintln("Reverse Cowboy [^1OFF^7]");
            self.rcowboy = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Reverse Cowboy");
            self.rcowboy = true;

            while(isDefined(self.rcowboy))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingrCowboy)
                        {
                            self.Doingrcowboy = true;
                            self setClientDvar("cg_gun_z", 8);
                        }
                        else
                        {
                            self.Doingrcowboy = false;
                            self setClientDvar("cg_gun_z", 0);
                        }
                    }
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingrCowboy)
                        {
                            self.Doingrcowboy = true;
                            self setClientDvar("cg_gun_z", 8);
                        }
                        else
                        {
                            self.Doingrcowboy = false;
                            self setClientDvar("cg_gun_z", 0);
                        }
                    }
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingrCowboy)
                        {
                            self.Doingrcowboy = true;
                            self setClientDvar("cg_gun_z", 8);
                        }
                        else
                        {
                            self.Doingrcowboy = false;
                            self setClientDvar("cg_gun_z", 0);
                        }
                    }
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    {
                        if(!self.DoingrCowboy)
                        {
                            self.Doingrcowboy = true;
                            self setClientDvar("cg_gun_z", 8);
                        }
                        else
                        {
                            self.Doingrcowboy = false;
                            self setClientDvar("cg_gun_z", 0);
                        }
                    }
                }
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
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM" + classNum);

                wait .001; 
            }
        }
    }