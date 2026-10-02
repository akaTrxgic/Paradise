    equip_camo(camo) 
    {
        weapon = getBaseWeaponName(self getCurrentWeapon()) + "_mp_a";
        weapon_attachment = strtok(self getCurrentWeapon(), "#")[1];
        weapon_kit = strtok(strtok(self getCurrentWeapon(), "#")[2], "_")[0];
        
        camoNum = int( camo );
        camoNum = (camoNum < 10) ? ("00" + camoNum) : (camoNum < 100 ? ("0" + camoNum) : camoNum);

        weapon_painted = weapon + "#" + weapon_attachment + "#" + weapon_kit + "_camo" + camoNum;
        
        self takeweapon(self getCurrentWeapon());
        self giveweapon(weapon_painted);
        self switchToWeapon(weapon_painted);
    }

    giveSpecWeapon(baseWpn) 
    {
        weapon = "h1_"+baseWpn+"_mp";
            
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }

        self GiveWeapon(Weapon);
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
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

    GivePlayerAttachment(attachment)
    {
        weapon      = self GetCurrentWeapon();
        wpnString   = strtok(weapon, "#");
        base        = wpnString[0];
        attachments = wpnString[1];
        stock       = self GetWeaponAmmoStock(weapon);
        clip        = self GetWeaponAmmoClip(weapon);
        
        //need to finish
    }

    doakimbo(attachment)
    {
        weapon      = self GetCurrentWeapon();
        base        = getBaseWeaponName(weapon);
        attachments = GetWeaponAttachments(weapon);
        stock       = self GetWeaponAmmoStock(weapon);
        clip        = self GetWeaponAmmoClip(weapon);
        akimbo      = false;
        
        if(HasAttachment(weapon, attachment))
        {
            if(isDefined(attachments) && attachments.size > 1)
            {
                for(a = 0; a < attachments.size; a++)
                    if(attachments[a] != attachment)
                        keep = attachments[a];
            }
            else
                keep = "none";
            
            newWeapon = maps\mp\gametypes\_class::buildWeaponName(base, keep, "none");
        }
        else
        {
            if(attachments.size && attachment != "none")
            {
                for(a = 0; a < attachments.size; a++)
                {
                    if(IsValidAttachmentCombo(attachments[a], attachment))
                        newAttachments = [attachments[a], attachment];
                    else if(IsValidAttachmentCombo(attachment, attachments[a]))
                        newAttachments = [attachment, attachments[a]];
                    else if(!isValidAttachmentCombo())
                        self iPrintln("^1Error: ^7Invalid attachment");
                    
                    if(isDefined(newAttachments))
                        break;
                }
            }
            
            if(!isDefined(newAttachments))
                newAttachments = [attachment, "none"];
            
            newWeapon = maps\mp\gametypes\_class::buildWeaponName(base, newAttachments[0], newAttachments[1]);
        }
        
        if(keep == "akimbo" || inarray(newAttachments, "akimbo") || attachment == "akimbo")
            akimbo = true;
        
        self TakeWeapon(weapon);
        self GiveWeapon(newWeapon, 0, akimbo);
        self SetWeaponAmmoClip(newWeapon, clip);
        self SetWeaponAmmoStock(newWeapon, stock);
        self SetSpawnWeapon(newWeapon);
    }

    GetWeaponValidAttachments(weapon)
    {
        attachments = [];
        
        for(a = 11;; a++)
        {
            column = TableLookUp("mp/statsTable.csv", 4, weapon, a);
            
            if(!isDefined(column) || column == "")
                break;
            
            attachments[attachments.size] = column;
        }
        
        return attachments;
    }

    IsValidAttachmentCombo(attachment1, attachment2)
    {
        return TableLookup("mp/attachmentCombos.csv", 0, attachment1, TableLookupRowNum("mp/attachmentCombos.csv", 0, attachment2)) != "no";
    }

    loadLoadout() 
    {
        self takeAllWeapons();
        
        if(self hasperk("_specialty_blastshield"))
            self _unsetperk("_specialty_blastshield");
        wait .01;
        
        if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") 
        {
            for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++) 
                self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

            for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++) 
                self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);
        }

        for (i = 0; i < self.primaryWeaponList.size; i++) 
        {
            weapon = self.primaryWeaponList[i];
            self giveWeapon(weapon);
            self giveMaxAmmo(weapon);
        }

        self switchToWeapon(self.primaryWeaponList[1]);
        self setSpawnWeapon(self.primaryWeaponList[1]);
        self giveWeapon("knife_mp");
        
        for (i = 0; i < self.offHandWeaponList.size; i++) 
        {
            offhand = self.offHandWeaponList[i];

                switch (offhand) 
                {
                    /*
                    case "h1_claymore_mp":
                    case "h1_c4_mp":
                    case "h1_rpg_mp":
                    self setPerkEquipment(offhand);
                    break;
                    */

                    case "h1_fraggrenade_mp":
                    case "h1_concussiongrenade_mp":
                    case "h1_flashgrenade_mp":
                    case "h1_smokegrenade_mp":
                    //?
                    break;

                    default: break;
            }
        }
    }

    CamoNameTable(a)
    {
        return TableLookupIString("mp/camoTable.csv", 0, a, 2);
    }

    giveUserWeapon(weapon, akimbo, camo) 
    {      
        weapon = "h1_"+weapon+"_mp_a#none_f#base";
        
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }

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
        attachments = getWeaponAttachments(weapon);

        foreach(attach in attachments)
            if(attach == attachment)        
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
        self.offHandWeaponList = self GetWeaponsListOffhands();

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

    giveEquipment( equipment )
    {
        specWpns = strtok("h1_c4_mp;h1_rpg_mp;h1_claymore_mp",";");

        for( i = 0; i < specWpns.size; i++ )
        {
            if( self hasWeapon( specWpns[i] ) )
                self takeweapon( specWpns[i] );
        }

        self setActionSlot(3, "");
        wait .01;
        self giveWeapon( equipment );
        self setActionSlot(3, "weapon", equipment);
    }

    giveoffhand( offhand )
    {
        
    }