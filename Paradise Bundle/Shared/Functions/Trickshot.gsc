instashoot()
{
    if(!self.instashoot)
    {
        self.instashoot = 1;

        while(self.instashoot)
        {
            self waittill("weapon_change");
            self disableWeapons();
            wait 0.01;
            self enableWeapons();
            wait 0.01;
        }
    }
    else if( self.instashoot)
    {
        self.instashoot = 0;
    }
}

SetCanswapMode()
{
    value = self.sliders[self getCurrentMenu() + "_" + self getCursor()]; 

    if(value == 0) 
    {
        if(!self.currCan)
        {
            self.currCan = 1;
            self.InfiniteCan = 0;
            self.currCanWpn = self getcurrentweapon();
            self iprintln("Canswap Weapon: (^2" + self.currCanWpn + "^7)");
            self thread CurrCanswapLoop();
        }

        else if(self.currCan && self.currCanWpn == self getCurrentWeapon())
        {
            self.currCan = 0;
            self iprintln("Canswap Mode: [^1OFF^7]");
            return;
        }
    }
    else if(value == 1) 
    {
        if(!self.InfiniteCan)
        {
            self.InfiniteCan = 1;
            self.currCan     = 0;       
            self iprintln("Canswap Mode: ^2Infinite^7");
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