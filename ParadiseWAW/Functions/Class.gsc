takeWpn()
{
    self takeweapon(self getcurrentweapon());
}
toggleInfEquip()
{
    self.infEquipOn = !isDefined(self.infEquipOn) || !self.infEquipOn;

    if (self.infEquipOn)
    {
        self thread InfEquipment();

    }
    else
    {
        self notify("noMoreInfEquip");

    }
}

InfEquipment()
{
    self endon("disconnect");
    self endon("noMoreInfEquip");

    for (;;)
    {
        wait 0.1;
        currentoffhand = self getcurrentoffhand();
        if (currentoffhand != "none")
        {
            self givemaxammo(currentoffhand);
        }
    }
}

dropWpn() 
{
    self dropItem(self getCurrentWeapon());
}

giveUserLethal(lethal)
{
    self takelethals();
    wait .1;
    self GiveWeapon( lethal );
    self SetWeaponAmmoClip( lethal, 1);
    self SwitchToOffhand( lethal );
    self iprintln("Given: ^2" + lethal);
}
giveUserTactical(tactical)
{
    self taketacticals();
    wait .1;
    self giveWeapon( tactical );
    self SetWeaponAmmoClip( tactical, 2 );
    self switchtooffhand(tactical);
    self iprintln("Given: ^2" + tactical);
}

takeLethals(lethals)
{
    switch(lethals)
    {
        case "frag_grenade_mp":
        case "sticky_grenade_mp":
        case "molotov_mp":

        if(self hasweapon(lethals))
        {
            self takeweapon(lethals);
        }
    }
}
takeTacticals(tacticals)
{
    switch(tacticals)
    {
        case "m8_white_smoke_mp":
        case "tabun_gas_mp":
        case "signal_flare_mp":
    
        if(self hasweapon(tacticals))
        {
            self takeweapon(tacticals);
        }
    }
}

doGiveWeapon(weapon)
{
    if (!isdefined(weapon) || weapon == "")
    {
        return;
    }

    // Remove just the current weapon before giving new one
    currentWpn = self getCurrentWeapon();

    if (isdefined(currentWpn) && currentWpn != "")
    {
        self takeWeapon(currentWpn);
    }

    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self iPrintln("Given Weapon: ^1" + weapon);
}
