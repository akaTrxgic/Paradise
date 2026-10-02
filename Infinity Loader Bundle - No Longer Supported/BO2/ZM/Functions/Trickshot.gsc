    initNoClip()
    {
        if(self.NoClipT == 0)
        {
            self thread Noclip();
            self.NoClipT = 1;
        }
        else
        {
            self.NoClipT = 0;
            self notify("stop_noclip");
        }
    }

    Noclip()
    {
        self endon("stop_noclip");
        if(!isDefined(self.noClipSpeed)) self.noClipSpeed = 50;

        for(;;)
        {
            if( self secondaryoffhandbuttonpressed())
            {
                if(!self.NoClipOBJ)
                {
                    self.originObj = spawn( "script_origin", self.origin, 1 );
                    self.originObj.angles = self.angles;
                    self playerlinkto( self.originObj, undefined );
                    self.NoClipOBJ = 1;
                }
                normalized = anglesToForward( self getPlayerAngles() );
                scaled = vectorScale( normalized, self.noClipSpeed );
                originpos = self.origin + scaled;
                self.originObj.origin = originpos;
            }
            else
            {
                if(self.NoClipOBJ == 1)
                {
                    self unlink();
                    self enableweapons();
                    self.originObj delete();
                    self.NoClipOBJ = 0;
                }
                wait .05;
            }
            wait .05;
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
                #ifndef BO3
                self iprintln("Canswap Weapon: [^2" + self.currCanWpn + "^7]");
                #else
                self iprintln("Canswap Weapon: [^2" + self.currCanWpn.name + "^7]");
                #endif
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