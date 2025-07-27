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
    numEro=randomIntRange(1,44);  
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
    self GiveWeapon( lethal );
    self SetWeaponAmmoClip( lethal, 1);
    self SwitchToOffhand( lethal );
    self iprintln("Given: ^2" + lethal);
}
giveUserTactical(tactical)
{
    self setOffhandSecondaryClass( tactical );
    self giveWeapon( tactical );
    self SetWeaponAmmoClip( tactical, 2 );
    self iprintln("Given: ^2" + tactical);
}
giveUserEquipment(equipment)
{
    class            = self.class;
    class_num        = int( class[class.size-1] )-1;
    
    self GiveWeapon( equipment);
    self SetActionSlot( 1, "weapon", equipment);
    
    self iprintln("Given: ^2" + equipment);
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

takeOffhands()
{
    offhands = [];
    offhands[0] = "frag_grenade_mp";
    offhands[1] = "sticky_grenade_mp";
    offhands[2] = "hatchet_mp";
    offhands[3] = "bouncingbetty_mp";
    offhands[4] = "satchel_charge_mp";
    offhands[5] = "claymore_mp";
    offhands[6] = "concussion_grenade_mp";
    offhands[7] = "willy_pete_mp";
    offhands[8] = "sensor_grenade_mp";
    offhands[9] = "emp_grenade_mp";
    offhands[10] = "proximity_grenade_aoe_mp";
    offhands[11] = "pda_hack_mp";
    offhands[12] = "flash_grenade_mp";
    offhands[13] = "trophy_system_mp";
    offhands[14] = "tactical_insertion_mp";
    
    if(self hasweapon(offhands))
    {
        self takeweapon(offhands);
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
        if (weapon == "china_lake_mp") {
            self giveMaxAmmo(weapon);
        }
    }

    self switchToWeapon(self.primaryWeaponList[0]);
    self setSpawnWeapon(self.primaryWeaponList[0]);
    self giveWeapon("knife_mp");
    for (i = 0; i < self.offHandWeaponList.size; i++) {
        weapon = self.offHandWeaponList[i];

            switch (weapon) {
            case "frag_grenade_mp":
            case "sticky_grenade_mp":
            case "hatchet_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                if (self hasPerk("specialty_twogrenades")) {
                    ammo = stock + 1;
                }
                else {
                    ammo = stock;
                }

                self setWeaponAmmoStock(weapon, ammo);
                break;
            case "flash_grenade_mp":
            case "concussion_grenade_mp":
            case "tabun_gas_mp":
            case "nightingale_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                if (self hasPerk("specialty_twogrenades")) {
                    ammo = stock + 1;
                }
                else {
                    ammo = stock;
                }

                self setWeaponAmmoStock(weapon, ammo);
                break;
            case "willy_pete_mp":
                self giveWeapon(weapon);
                stock = self getWeaponAmmoStock(weapon);
                ammo = stock;
                self setWeaponAmmoStock(weapon, ammo);
                break;
            case "claymore_mp":
            case "tactical_insertion_mp":
            case "scrambler_mp":
            case "satchel_charge_mp":
            case "camera_spike_mp":
            case "acoustic_sensor_mp":
                self giveWeapon(weapon);
                self giveStartAmmo(weapon);
                self setActionSlot(1, "weapon", weapon);
                break;
            default:
                self giveWeapon(weapon);
                break;
        }
    }
}