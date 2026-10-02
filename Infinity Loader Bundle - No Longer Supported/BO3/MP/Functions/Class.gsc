    giveUserWeapon(weapon, akimbo, camo) 
    {      
        weapon = getWeapon(weapon);
        self GiveWeapon(weapon);
        self GiveMaxAmmo(weapon);
        wait 0.1;
        self SwitchToWeapon(weapon);
    }

    getBaseName(weapon)
    {
        prefix = strtok(weapon, "_");
        base = prefix[0];
        return base;
    }

    getAttachments(weapon)
    {
        prefix = strtok(weapon, "_");
        attachments = [];
        attachments[0] = prefix[1];
        attachments[1] = prefix[2];

        return attachments;
    }

    HasAttachment(weapon, attachment)
    {
        attachments = getattachments(weapon);
        
        for(a=0;a<attachments.size;a++)
            if(attachments[a] == attachment)     
                return true;
        
        return false;
    }  

    takeWpn()
    {
        self takeweapon(self getcurrentweapon());
    }

    toggleInfEquip()
    {
        self.infEquipOn = !isDefined(self.infEquipOn) || !self.infEquipOn;

        if (self.infEquipOn)
            self thread InfEquipment();
        else
            self notify("noMoreInfEquip");
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
                self givemaxammo(currentoffhand);
        }
    }

    dropWpn() 
    {
        self dropItem(self getCurrentWeapon());
    }

    saveLoadout() 
    {
        wait .01;
            
        self.primaryWeaponList = self getWeaponsListPrimaries();
        self.offHandWeaponList = isExclude(self getWeaponsList(), self.primaryWeaponList);
        self.offHandWeaponList = removeValueFromArray(self.offHandWeaponList, "knife_mp");

        for (i = 0; i < self.primaryWeaponList.size; i++) 
            self setPlayerCustomDvar("primary" + i, self.primaryWeaponList[i]);

        for (i = 0; i < self.offHandWeaponList.size; i++)
            self setPlayerCustomDvar("secondary" + i, self.offHandWeaponList[i]);

        self setPlayerCustomDvar("primaryCount", self.primaryWeaponList.size);  
        self setPlayerCustomDvar("secondaryCount", self.offHandWeaponList.size);
    }

    isExclude(array, array_exclude)
    {
        newarray = array;

        if (inarray(array_exclude))
        {
            for (i = 0; i < array_exclude.size; i++)
            {
                exclude_item = array_exclude[i];
                removeValueFromArray(newarray, exclude_item);
            }
        }
        else
            removeValueFromArray(newarray, array_exclude);

        return newarray;
    }

    removeValueFromArray(array, valueToRemove)
    {
        newArray = [];
        for (i = 0; i < array.size; i++)
        {
            if (array[i] != valueToRemove)
                newArray[newArray.size] = array[i];
        }
        return newArray;
    }

    changeCamo(camoNum)
    {
        num = int( camoNum );
        weap    = self getCurrentWeapon();
        myclip  = self getWeaponAmmoClip(weap);
        mystock = self getWeaponAmmoStock(weap);  
        self takeWeapon(weap);   
        weaponOptions = self calcWeaponOptions(num,0,0,0,0);
        self GiveWeapon(weap,0,weaponOptions); 
        self switchToWeapon(weap);  
        self setSpawnWeapon(weap); 
        self setweaponammoclip(weap,myclip);  
        self setweaponammostock(weap,mystock);  
        self.camo = num;  
    }

    saveLoadoutToggle()
    {
        if( self getPlayerCustomDvar( "loadoutSaved" ) == "1" )
            self setPlayerCustomDvar( "loadoutSaved", "0" );

        else
        {
            self setPlayerCustomDvar( "loadoutSaved", "1" );
            self saveLoadout();
        }
    }

    loadLoadout()
    {
        self takeAllWeapons();
        self giveWeapon("knife_mp");
        
        if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1")
        {
            self.primaryWeaponList = [];

            for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++)
                self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

            for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++)
                self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
        }

        for (i = 0; i < self.primaryWeaponList.size; i++)
        {
            weapon = self.primaryWeaponList[i];
            weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);

            self giveWeapon(weapon, 0, weaponOptions);
            self giveMaxAmmo(weapon);

            if(isDefined(level.primary_weapon_array[weapon]))
                self SwitchToWeapon(weapon);
        }

        for (i = 0; i < self.offHandWeaponList.size; i++)
        {
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
                    self setWeaponAmmoStock(weapon, self getWeaponAmmoStock(weapon) + 1);
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
                    break;
                
                default:
                    self giveWeapon(weapon);
                    break;
            }
        }
    }

    giveOffhand(offhand)
    {
        offhand = getWeapon(offhand);

        if(self HasWeapon(offhand))
        {
            self GiveStartAmmo(offhand);
            return;
        }
        
        self GiveWeapon(offhand);
        self GiveStartAmmo(offhand);
    }

    givePlayerAttachment(attachment)
    {
        weapon = self getCurrentweapon();
        prefix = strtok(weapon.name, "+");
        baseName = prefix[0];
        attachments = weapon.attachments;

        if(attachment == "dw" && attachments.size < 0)
            newWeapon = getweapon(baseName + "_dw");

        else
        {
            if(HasAttachment(weapon, attachment))
            {
                for(a = 0; a < attachments.size; a++)
                {
                    if(attachments[a] != attachment)
                    {
                        keep = attachments[a];
                        newWeapon = baseName + "+" + keep;
                    }
                    else
                    {
                        keep = "";
                        newWeapon = baseName;
                    }
                }
            }
            else
            {
                if(HasAttachment(weapon, attachment))
                {
                    for(a = 0; a < attachments.size; a++)
                    {
                        if(attachments[a] != attachment && attachments[a] != "mp")
                        {
                            keep = attachments[a];
                            newWeapon = baseName + "+" + keep;
                        }
                        else
                        {
                            keep = "";
                            newWeapon = baseName;
                        }
                    }
                }

                if(isinarray(attachments, attachment))
                    attachments = ArrayRemove(attachments, attachment);

                else
                {
                    if(attachments.size >= 8)
                        return self iprintln("^1Error: ^7Max Attachments Reached");

                    array::add(attachments, attachment, 0);
                }

                newWeapon = getWeapon(baseName, attachments);
                if(newWeapon == level.weaponnone)
                    return self iprintln("^1Error: ^7Attachment Swap Failed on " + baseName);
            }
            
            self TakeWeapon(weapon);
            self GiveWeapon(newWeapon);
            self SetSpawnWeapon(newWeapon, true);
            self switchtoweapon(newWeapon);
        }       
    }

    //XeSoftware
    GiveLethalEquipment(lethal)
    {
        if (lethal == "Frag")           weapon = "frag_grenade";
        if (lethal == "Semtex")         weapon = "sticky_grenade";
        if (lethal == "Trip Mine")      weapon = "bouncingbetty";
        if (lethal == "Thermite")       weapon = "incendiary_grenade";
        if (lethal == "Combat Axe")     weapon = "hatchet";
        if (lethal == "C4")             weapon = "satchel_charge";

        grenade = GetWeapon(weapon);
        self TakeWeapon(self GetCurrentOffhand());
        self GiveWeapon(grenade);
        self SetOffhandPrimaryClass(grenade);
        self GiveMaxAmmo(grenade);

        self iPrintLn(lethal +" ^2Given");
    }

    GiveTacticalEquipment(tactical)
    {
        if (tactical == "Concussion")     weapon = "concussion_grenade";
        if (tactical == "Smoke Screen")   weapon = "willy_pete";
        if (tactical == "EMP")            weapon = "emp_grenade";
        if (tactical == "Trophy System")  weapon = "trophy_system";
        if (tactical == "Shock Charge")   weapon = "proximity_grenade";
        if (tactical == "Flashbang")      weapon = "flash_grenade";
        if (tactical == "Black Hat")      weapon = "pda_hack";

        grenade = GetWeapon(weapon);
        self TakeWeapon(self GetCurrentOffhand());
        self GiveWeapon(grenade);
        self SetOffhandSecondaryClass(grenade);
        self GiveMaxAmmo(grenade);

        self iPrintLn(tactical +" ^2Given");
    }