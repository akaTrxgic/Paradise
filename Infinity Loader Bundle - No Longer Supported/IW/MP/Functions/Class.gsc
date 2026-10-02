    giveUserWeapon(weapon, akimbo, camo) 
    {      
        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
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
            currentoffhand = self method_8115();
            if (currentoffhand != "none")
                self givemaxammo(currentoffhand);
        }
    }

    dropWpn() 
    {
        self method_80B8(self getcurrentweapon());//method_80B8 = DropItem
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

    GiveSelfWeapon(weapon)
    {
        weap = StrTok(Weapon,"_");
        if(weap[weap.size-1] != "mp")
            Weapon += "_mp";
    
        self GiveWeapon(weapon);    
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
    }

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];
        
        for(a = 9;; a++)
        {
            column = TableLookUp("mp/statsTable.csv", 4, weapon, a);
            
            if(!isDefined(column) || column == "")
                break;
            
            attachments[attachments.size] = column;
        }
        
        return attachments;
    }

    getbaseweaponname(param_00) 
    {
        var_01 = strtok(param_00,"_");

        if(var_01[0] == "iw5" || var_01[0] == "iw6" || var_01[0] == "iw7") 
            param_00 = var_01[0] + "_" + var_01[1];

        else if(var_01[0] == "alt") 
            param_00 = var_01[1] + "_" + var_01[2];

        return param_00;
    }  

    equip_camo(camo) 
    {
        weapon = getBaseWeaponName(self getCurrentWeapon()) + "_mp";
        weapon_attachment = strtok(self getCurrentWeapon(), "+")[1];

        weapon_painted = weapon + "+" + weapon_attachment + "+camo" + camo;
        
        self takeweapon(self getCurrentWeapon());
        self giveweapon(weapon_painted);
        self switchToWeapon(weapon_painted);
    }

    CamoNameTable(a)
    {
        return TableLookupIString("mp/camoTable.csv", 0, a, 6);
    }

    GiveEquipment(equipment)
    {
        equip = StrTok(equipment, "_");
        
        if(equip[(equip.size - 1)] != "mp" && !IsSubStr(equipment, "specialty"))
            equipment += "_mp";
        
        lethals = ["frag_grenade_mp","semtex_mp","throwingknife_mp","proximity_explosive_mp","c4_mp","mortar_shell_mp"];
        hasEquipment     = self HasWeapon(equipment);

        for(a=0;a<lethals.size;a++)
        {
            if(self HasWeapon1(lethals[a]))
                self TakeWeapon(lethals[a] + "_mp");
            
            if(self scripts\mp\_utility::_hasperk(lethals[a] + "_mp"))
                self scripts\mp\perks\_perks::func_1430(lethals[a] + "_mp");
        }
        
        if(!hasEquipment)
            self method_8389(equipment, false);
    }

    GiveSecondaryOffhand(offhand)
    {
        if(!IsSubStr(offhand, "specialty"))
        {
            equip = StrTok(offhand, "_");
            
            if(equip[(equip.size - 1)] != "mp")
                offhand += "_mp";
        }
        
        offhands = "cluster_grenade_mp;power_exploding_drone_mp;splash_grenade_mp;power_spider_grenade_mp;trip_mine_mp;wristrocket_mp;split_grenade_mp;blackhole_grenade_mp;c4_mp;throwingknife_mp;throwingknifec4_mp;deployable_cover_mp;cryo_mine_mp;concussion_grenade_mp;domeshield_mp;trophy_mp;smoke_grenade_mp;blackout_grenade_mp;flare_mp";
        hasEquipment       = self HasWeapon(offhand);
        
        for(a = 0; a < offhands.size; a++)
        {
            if(self HasWeapon1(offhands[a]))
                self TakeWeapon(offhands[a] + "_mp");
            
            if(self scripts\mp\_utility::_hasperk(offhands[a]))
                self scripts\mp\perks\_perks::func_1430(offhands[a]);
        }
        
        if(!hasEquipment)
            self method_8389(offhand, false);
    }

    HasWeapon1(weapon)
    {
        foreach(weap in self GetWeaponsList())
            if(IsSubStr(weap, weapon) || weapon == weap)
                return true;
        
        return false;
    }