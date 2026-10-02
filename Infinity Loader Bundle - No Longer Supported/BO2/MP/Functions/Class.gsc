    giveUserWeapon(weapon, akimbo, camo) 
    {      
        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
    }

    getBaseName(weapon)
    {
        prefix = strtok(weapon, "+");
        prefix0 = prefix[0];
        weaponString = strtok(prefix0, "_");
        base = weaponString[0];
        return base;
    }

    getAttachments(weapon)
    {
        prefix = strtok(weapon, "+");
        attachments = [];
        attachments[0] = prefix[1];
        attachments[1] = prefix[2];
        attachments[2] = prefix[3];
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

    GetPlayerEquipment(type)
    {
        equipment = [];
        
        for(a = 63; a < 79; a++)
        {
            class = TableLookup("mp/statstable.csv", 0, a, 2);
            
            if(class != "weapon_grenade" || isDefined(type) && TableLookup("mp/statstable.csv", 0, a, 13) != type)
                continue;
            
            weapon = TableLookup("mp/statstable.csv", 0, a, 4);
            
            if(self HasWeapon(weapon))
                equipment[equipment.size] = GetWeapon1(weapon);
        }
        
        return equipment;
    }

    GivePlayerEquipment(equipment)
    {
        if(self HasWeapon(equipment))
        {
            self GiveStartAmmo(self GetWeapon1(equipment));
            return;
        }
        
        type  = TableLookup("mp/statstable.csv", 4, equipment, 13);
        equip = StrTok(equipment, "_");
        
        if(equip[(equip.size - 1)] != "mp")
            equipment += "_mp";
        
        currentEquipment = GetPlayerEquipment(type);
        
        foreach(curEquip in currentEquipment)
            self TakeWeapon(curEquip);
        
        self GiveWeapon(equipment);
        self GiveStartAmmo(equipment);
    }

    GetWeapon1(weapon)
    {
        foreach(weap in self GetWeaponsList())
            if(IsSubStr(weap, weapon) || weapon == weap)
                return weap;
        
        return false;
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

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];

        column = TableLookUp("mp/statsTable.csv", 4, weapon, 8);

        if(!isDefined(column) || column == "")
            return attachments;

        parts = strTok(column, " ");

        for(i = 0; i < parts.size; i++)
        {
            if(parts[i] != "")
                attachments[attachments.size] = parts[i];
        }

        return attachments;
    }

    givePlayerAttachment(attachment)
    {
        weapon     = self GetCurrentWeapon(); 
        prefix     = strtok(weapon, "+");
        baseWeapon = prefix[0];
        baseName   = getbasename(weapon);
        
        attachments = [];
        attachments[0] = prefix[1];
        attachments[1] = prefix[2];

        stock = self GetWeaponAmmoStock(weapon);
        clip  = self GetWeaponAmmoClip(weapon);

        if(attachment == "dw")
        {
            newWeapon = baseName + "_dw_mp";
            self takeweapon(weapon);
            wait .1;
            self giveweapon(newWeapon);
            self switchtoweapon(newWeapon);
        }
        else
        {
            newAttachments = undefined;

            if(HasAttachment(weapon, attachment))
            {
                newWeapon = baseWeapon;

                for(a = 0; a < attachments.size; a++)
                {
                    if(isDefined(attachments[a]) && attachments[a] != "" && attachments[a] != attachment && attachments[a] != "mp")
                        newWeapon = baseWeapon + "+" + attachments[a];
                }
            }
            else
            {
                if(attachment != "none")
                {
                    for(a = 0; a < attachments.size; a++)
                    {
                        if(isDefined(attachments[a]) && attachments[a] != "" && attachments[a] != "mp")
                        {
                            newAttachments = [];
                            newAttachments[0] = attachment;
                            newAttachments[1] = attachments[a];
                            break;
                        }
                    }
                }

                if(!isDefined(newAttachments))
                {
                    newAttachments = [];
                    newAttachments[0] = attachment;
                    newAttachments[1] = "";
                }

                if(newAttachments[1] == "" || !isDefined(newAttachments[1]))
                    newWeapon = baseWeapon + "+" + newAttachments[0];
                else
                    newWeapon = baseWeapon + "+" + newAttachments[0] + "+" + newAttachments[1];
            }

            self TakeWeapon(weapon);
            self GiveWeapon(newWeapon, 0);
            self SetWeaponAmmoClip(newWeapon, clip);
            self SetWeaponAmmoStock(newWeapon, stock);
            self SetSpawnWeapon(newWeapon);

            if(self getcurrentweapon() != newWeapon)
                self iPrintln("^1Error: ^7Invalid attachment");
        }       
    }
