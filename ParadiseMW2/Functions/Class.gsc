giveLightstick()
{
    self TakeWeapon(self GetCurrentOffhand());
    self SetOffhandPrimaryClass("other");
    self GiveWeapon("lightstick_mp");
}
GivePlayerWeapon(Weapon,Akimbo)
{
    self TakeWeapon(self GetCurrentWeapon());
    
        weap = StrTok(Weapon,"_");
        if(weap[weap.size-1] != "mp")
            Weapon += "_mp";
        
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }
        
        self GiveWeapon(Weapon,0,Akimbo);
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
}
shootEquipment()
{
    if(isConsole())
        client = 0x830CC23F+(self GetEntityNumber()*0x3700);
    else
        client = 0x01B0E47C+(self GetEntityNumber()*0x366C);
    
    self.ShootEquipment = (isDefined(self.ShootEquipment) ? undefined : true);
    
    if(isDefined(self.ShootEquipment))
    {
        self iPrintln("Shoot Equipment: [^2ON^7]");
        while(isDefined(self.ShootEquipment))
        {
            WriteByte(client,0x02);
            wait .1;
        }
    }
    else
    {
        self iPrintln("Shoot Equipment: [^1OFF^7]");
        WriteByte(client,0x00);
    }
}
changeCamo(num)
{
    weap=self getCurrentWeapon();
    myclip=self getWeaponAmmoClip(weap);
    mystock=self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  
    weaponOptions=self calcWeaponOptions(num,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo=num;  
}

randomCamo()
{
    numEro=randomIntRange(1,8);  
    weap=self getCurrentWeapon();  
    myclip=self getWeaponAmmoClip(weap);  
    mystock=self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  
    weaponOptions=self calcWeaponOptions(numEro,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    self.camo=numEro;  
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

giveUserWeapon(weapon) {
    self giveWeapon(weapon);
    self giveStartAmmo(weapon);
    self switchToWeapon(weapon);

    if (weapon == "china_lake_mp") {
        self giveMaxAmmo(weapon);
    }
    
    self iprintln("Given: ^2" + weapon);
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
    self setOffhandSecondaryClass( tactical );
    self giveWeapon( tactical );
    self SetWeaponAmmoClip( tactical, 2 );
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

    if (IsArray(array_exclude))
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
    if (isDefined(self.equipment)) 
    {
        self.offHandWeaponList[self.offHandWeaponList.size] = self.equipment;
    }

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

takeLethals()
{
    lethals = [];
    lethals[0] = "frag_grenade_mp";
    lethals[1] = "semtex_mp";
    lethals[2] = "throwingknife_mp";
    lethals[3] = "c4_mp";
    lethals[4] = "claymore_mp";
    
    if(self hasweapon(lethals))
    {
        self takeweapon(lethals);
    }
}
takeTacticals()
{
    tacticals = [];
    tacticals[0] = "flash_grenade_mp";
    tacticals[1] = "concussion_grenade_mp";
    tacticals[2] = "smoke_grenade_mp";
    tacticals[3] = "lightstick_mp";
    tacticals[4] = "flare_mp";
    
     if(self hasweapon(tacticals))
    {
        self takeweapon(tacticals);
    }
}
loadLoadout() 
{
    self takeAllWeapons();
    self takeOffhands();
    
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
        weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);
        self giveWeapon(weapon, 0, weaponOptions);
        if (weapon == "rpg_mp" || weapon == "m79_mp" || weapon == "at4_mp") 
        {
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
            case "frag_grenade_mp":
            case "semtex_mp":
            case "throwingknife_mp":
            case "flash_grenade_mp":
            case "concussion_grenade_mp":
            case "lighstick_mp":
            case "smoke_grenade_mp":
            case "c4_mp":
            case "claymore_mp":
            case "flare_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                ammo = stock;
                self setWeaponAmmoStock(weapon, ammo);
                break;

            default:
                self giveWeapon(weapon);
                break;
        }
    }
}