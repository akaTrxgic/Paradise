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
        self.instashoot = 0;
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
    #ifdef WAW || MW1
    if (level.currentGametype == "dm")
    {
        self.score = 140;
        self.pers[ "score" ] = 140;
        self.kills = 28;
        self.deaths = 22;
        self.headshots = 7;
        self.pers[ "kills" ] = 28;
        self.pers[ "deaths" ] = 22;
        self.pers[ "headshots" ] = 7;
    }
    #endif

    #ifdef MW2 || MW3 || BO1 || BO2
    if(level.currentGametype == "dm")
    {
        self.kills   = 28;
        self.score   = 1400;
        self.deaths  = 13;
        self.assists = 2;
        self.pers["pointstowin"] = 28;
        self.pers["kills"] = 28;
        self.pers["score"] = 1400;
        self.pers["deaths"] = 13;
        self.pers["assists"] = 2;
    }
    #endif

    #ifdef MWR
    if(level.currentGametype == "dm")
    {
        self.kills   = 23;
        self.score   = 23;
        self.deaths  = 13;
        self.assists = 2;
        self.pers["pointstowin"] = 23;
        self.pers["kills"] = 23;
        self.pers["score"] = 23;
        self.pers["deaths"] = 13;
        self.pers["assists"] = 2;
    }
    #endif

    #ifdef Ghosts
    if(level.currentGametype == "dm")
    {
        self.kills   = 28;
        self.score   = 28;
        self.deaths  = 13;
        self.assists = 2;
        self.pers["pointstowin"] = 28;
        self.pers["kills"] = 28;
        self.pers["score"] = 28;
        self.pers["deaths"] = 13;
        self.pers["assists"] = 2;
    }
    #endif
}