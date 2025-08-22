changeCamo(num)
{
    Weapon  = self GetCurrentWeapon();
    oldammo = self GetWeaponAmmoStock(Weapon);
    oldclip = self GetWeaponAmmoClip(Weapon);
    self TakeWeapon(Weapon);
    self GiveWeapon(Weapon,num);
    self SetWeaponAmmoStock(Weapon,oldammo);
    self SetWeaponAmmoClip(Weapon,oldclip);
    self SetSpawnWeapon(Weapon);
}

randomCamo()
{
    numEro=randomIntRange(1,8);  
    Weapon  = self GetCurrentWeapon();
    oldammo = self GetWeaponAmmoStock(Weapon);
    oldclip = self GetWeaponAmmoClip(Weapon);
    self TakeWeapon(Weapon);
    self GiveWeapon(Weapon,numEro);
    self SetWeaponAmmoStock(Weapon,oldammo);
    self SetWeaponAmmoClip(Weapon,oldclip);
    self SetSpawnWeapon(Weapon);
}
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

giveUserWeapon(weapon, akimbo) 
{      
    weap = StrTok(Weapon,"_");

    if(weap[weap.size-1] != "mp")
        Weapon += "_mp";
        
    if(self hasWeapon(Weapon))
    {
        self SetSpawnWeapon(Weapon);
        return;
    }

    if(issubstr(weapon, "akimbo"))
        akimbo = true;

    self GiveWeapon(Weapon,0,Akimbo);
    self GiveMaxAmmo(Weapon);
    self SwitchToWeapon(Weapon);
    
    self iprintln("Given: ^2" + weapon);
} 
GiveSelfWeapon(weapon)
{
        weap = StrTok(Weapon,"_");
        if(weap[weap.size-1] != "mp")
            Weapon += "_mp";
  
        self GiveWeapon(weapon);    
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
}

giveUserLethal(lethal)
{
    self takeEquipment();
    wait .1;
    self GiveWeapon( lethal );
    self SetWeaponAmmoClip( lethal, 1);
    self SwitchToOffhand( lethal );
    self iprintln("Given: ^2" + lethal);
}
giveUserTactical(tactical)
{
    self takeSpecGren();
    wait .1;
    self giveWeapon( tactical );
    self SetWeaponAmmoClip( tactical, 2 );
    self switchtooffhand(tactical);
    self iprintln("Given: ^2" + tactical);
}

setPlayerCustomDvar(dvar, value) 
{
    dvar = self getXuid() + "_" + dvar;
    setDvar(dvar, value);
}

getPlayerCustomDvar(dvar) 
{
    dvar = self getXuid() + "_" + dvar;
    return getDvar(dvar);
}
isExclude(array, array_exclude)
{
    newarray = array;

    if (IsInArray(array_exclude))
    {
        for (i = 0; i < array_exclude.size; i++)
        {
            exclude_item = array_exclude[i];
            removeValueFromArray(newarray, exclude_item);
        }
    }
    else
    {
        removeValueFromArray(newarray, array_exclude);
    }

    return newarray;
}
removeValueFromArray(array, valueToRemove)
{
    newArray = [];
    for (i = 0; i < array.size; i++)
    {
        if (array[i] != valueToRemove)
        {
            newArray[newArray.size] = array[i];
        }
    }
    return newArray;
}

saveLoadout() 
{
    self endon("disconnect");

    self.primaryWeaponList = self getWeaponsListPrimaries();
    self.offHandWeaponList = isExclude(self getWeaponsList(), self.primaryWeaponList);
    self.offHandWeaponList = removeValueFromArray(self.offHandWeaponList, "knife_mp");

    self.saveLoadoutEnabled = true;
    for (i = 0; i < self.primaryWeaponList.size; i++) {
        self setPlayerCustomDvar("primary" + i, self.primaryWeaponList[i]);
    }

    for (i = 0; i < self.offHandWeaponList.size; i++) {
        self setPlayerCustomDvar("secondary" + i, self.offHandWeaponList[i]);
    }

    self setPlayerCustomDvar("primaryCount", self.primaryWeaponList.size);
    self setPlayerCustomDvar("secondaryCount", self.offHandWeaponList.size);
    self setPlayerCustomDvar("loadoutSaved", "1");
    self iPrintLn("Loadout: ^2Saved");
}

deleteSavedLoadout() 
{
    if (self getPlayerCustomDvar("loadoutSaved") == "1")
    {
        self setPlayerCustomDvar("loadoutSaved", "0");
        self iPrintLn("Saved Loadout: ^1Deleted");
    }
}

takeEquipment(lethals)
{
    switch(lethals)
    {
        case "frag_grenade_mp":
        case "sticky_grenade_mp":
        case "throwingknife_mp":
        case "throwingknife_rhand_mp":
        case "flare_mp":
        case "_specialty_blastshield":
        case "claymore_mp":
        case "c4_mp":

        if(self hasweapon(lethals))
        {
            self takeweapon(lethals);
        }
    }
}
takeSpecGren(tacticals)
{
    switch(tacticals)
    {
        case "concussion_grenade_mp":
        case "smoke_grenade_mp":
        case "flash_grenade_mp":
        case "lightstick_mp":
    
        if(self hasweapon(tacticals))
        {
            self takeweapon(tacticals);
        }
    }
}

loadLoadout() 
{
    self takeAllWeapons();
    self takeEquipment();
    self takeSpecGren();
    
    if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") {
        for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++) {
            self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);
        }

        for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++) {
            self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
        }
    }

    for (i = 0; i < self.primaryWeaponList.size; i++) {
        if (!isDefined(self.camo) || self.camo == 0) {
            self.camo = randomIntRange(1, 16);
        }

        weapon = self.primaryWeaponList[i];
        //weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);
        self giveWeapon(weapon, 0); //0, weaponOptions
        if (weapon == "rpg_mp" || weapon == "m79_mp") {
            self giveMaxAmmo(weapon);
        }
    }

    self switchToWeapon(self.primaryWeaponList[0]);
    self setSpawnWeapon(self.primaryWeaponList[0]);
    self giveWeapon("knife_mp");
    for (i = 0; i < self.offHandWeaponList.size; i++) {
        weapon = self.offHandWeaponList[i];

            switch (weapon) 
            {
            case "flash_grenade_mp":
            case "concussion_grenade_mp":
            case "bouncingbetty_mp":
            case "sensor_grenade_mp":
            case "emp_grenade_mp":
            case "proximity_grenade_aoe_mp":
            case "pda_hack_mp":
            case "trophy_system_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                self setWeaponAmmoStock(weapon, ammo);
                break;

            case "willy_pete_mp":
            case "claymore_mp":
            case "hatchet_mp":
            case "frag_grenade_mp":
            case "sticky_grenade_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                ammo = stock + 1;
                self setWeaponAmmoStock(weapon, ammo);
                break;

            case "tactical_insertion_mp":
            case "satchel_charge_mp":
                self giveWeapon(weapon);
                self giveStartAmmo(weapon);
            default:
                self giveWeapon(weapon);
                break;
        }
    }
}
rhThrowingKnife()
{
    self takeweapon("semtex_mp");
    self takeweapon("claymore_mp");
    self takeweapon("frag_grenade_mp");
    self takeweapon("c4_mp");
    self takeweapon("throwingknife_mp");
    self giveweapon("throwingknife_mp",0,false);
    wait 0.01;
    self takeweapon("throwingknife_mp");
    wait 0.01;
    self giveweapon("throwingknife_rhand_mp",0,false); 
}