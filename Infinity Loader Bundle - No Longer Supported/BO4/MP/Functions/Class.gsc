    giveUserWeapon(weapon, akimbo) 
    {      
        weapon = getWeapon(weapon);
        self GiveWeapon(weapon);
        self GiveMaxAmmo(weapon);
        wait 0.1;
        self SwitchToWeapon(weapon);
    }

    setPlayerCustomDvar( dvar, value ) 
    {
        dvar = self getXuid() + "_" + dvar;
        setDvar(dvar, value);
    }

    getPlayerCustomDvar( dvar ) 
    {
        dvar = self getXuid() + "_" + dvar;
        return getDvar(dvar);
    }

    takeWpn()
    {
        self takeweapon(self getcurrentweapon());
    }

    dropWpn() 
    {
        self dropItem(self getCurrentWeapon());
    }