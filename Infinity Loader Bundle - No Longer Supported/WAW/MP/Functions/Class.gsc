    givePlayerAttachment(attachment)
    {
        weapon      = self GetCurrentWeapon(); 
        prefix      = strtok(weapon, "_");
        baseName    = prefix[0];
        attachments = [prefix[1], prefix[2]];
        stock       = self GetWeaponAmmoStock(weapon);
        clip        = self GetWeaponAmmoClip(weapon);

        if(HasAttachment(weapon, attachment))
        {
            for(a = 0; a < attachments.size; a++)
            {
                if(attachments[a] != attachment && attachments[a] != "mp")
                {
                    keep = attachments[a];
                    newWeapon = baseName + "_" + keep + "_mp";
                }
                else
                {
                    keep = "";
                    newWeapon = baseName + "_mp";
                }
            }
        }
        else
        {
            if(attachment != "none")
            {
                    for(a = 0; a < attachments.size; a++)
                    {
                        if(attachments[a] != "mp")
                            newAttachments = [attachment, attachments[a]];  
                        if(isDefined(newAttachments))
                            break;
                    }
            }
        
            if(!isDefined(newAttachments) && newAttachments != "mp")
                newAttachments = [attachment, ""];
        
            if(newAttachments[1] == "")
                newWeapon = baseName + "_" + newAttachments[0] + "_mp";
        }
        
        self TakeWeapon(weapon);
        self GiveWeapon(newWeapon, 0);
        self SetWeaponAmmoClip(newWeapon, clip);
        self SetWeaponAmmoStock(newWeapon, stock);
        self SetSpawnWeapon(newWeapon);

        if(self getcurrentweapon() != newWeapon)
        {
            self iPrintln("^1Error: ^7Invalid attachment");
            self giveWeapon(weapon);
            self switchToWeapon(weapon);
        }
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

    giveLethal(grenadeTypePrimary)
    {
        if(self hasWeapon("frag_grenade_mp"))
            self takeweapon("frag_grenade_mp");

        else if(self hasWeapon("sticky_grenade_mp"))
            self takeweapon("sticky_grenade_mp");

        else if(self hasWeapon("molotov_mp"))
            self takeweapon("molotov_mp");

        if(grenadeTypePrimary != "")
        {
            self GiveWeapon( grenadeTypePrimary );
            self SetWeaponAmmoClip( grenadeTypePrimary, 1 );
            self SwitchToOffhand( grenadeTypePrimary );
        }
    }

    giveTactical(grenadeTypeSecondary)
    {
        if(self hasWeapon("m8_white_smoke_mp"))
            self takeweapon("m8_white_smoke_mp");

        else if(self hasWeapon("tabun_gas_mp"))
            self takeweapon("tabun_gas_mp");

        else if(self hasWeapon("signal_flare_mp"))
            self takeweapon("signal_flare_mp");
        
        if(grenadeTypeSecondary != "")
        {	
            self TakeWeapon();
            self giveWeapon(grenadeTypeSecondary);
            self SetWeaponAmmoClip(grenadeTypeSecondary, 1);
        }
    }

    takeOffhands()
    {
        offhands = [];
        offhands[0] = "frag_grenade_mp";
        offhands[1] = "sticky_grenade_mp";
        offhands[2] = "molotov_mp";

        offhands[3] = "m8_white_smoke_mp";
        offhands[4] = "tabun_gas_mp";
        offhands[5] = "signal_flare_mp";
        
        if(self hasweapon(offhands))
            self takeweapon(offhands);
    }

    loadLoadout() 
    {
        self takeAllWeapons();
        self takeoffhands();
        
        if (!isDefined(self.primaryWeaponList) && self getPlayerCustomDvar("loadoutSaved") == "1") 
        {
            for (i = 0; i < int(self getPlayerCustomDvar("primaryCount")); i++)
                self.primaryWeaponList[i] = self getPlayerCustomDvar("primary" + i);

            for (i = 0; i < int(self getPlayerCustomDvar("secondaryCount")); i++) 
                self.offHandWeaponList[i] = self getPlayerCustomDvar("secondary" + i);

            for (i = 0; i < int(self getPlayerCustomDvar("equipmentCount")); i++)
                self.equipmentList[i] = self getPlayerCustomDvar("equipment" + i);
        }

        for (i = 0; i < self.primaryWeaponList.size; i++) 
        {
            weapon = self.primaryWeaponList[i];
            self giveWeapon(weapon);
            self giveMaxAmmo(weapon);
        }

        self switchToWeapon(self.primaryWeaponList[0]);
        self setSpawnWeapon(self.primaryWeaponList[0]);
        self giveWeapon("knife_mp");

        for (i = 0; i < self.offHandWeaponList.size; i++) 
        {
            weapon = self.offHandWeaponList[i];

            switch (weapon) 
            {   
                case "frag_grenade_mp":
                case "sticky_grenade_mp":
                case "molotov_mp":
                    self GiveWeapon( weapon );
                    self SetWeaponAmmoClip( weapon, 1 );
                    self SwitchToOffhand( weapon );
                    break;

                case "m8_white_smoke_mp":
                case "tabun_gas_mp":
                case "signal_flare_mp":
                    self TakeWeapon();
                    self giveWeapon(weapon);
                    self SetWeaponAmmoClip(weapon, 1);
                    break;

                default: break;
            }
        }

        for (i = 0; i < self.equipmentList.size; i++)
        {
            weapon = self.equipmentList[i];

            for( i = 0; i < weapon.size; i++ )
            {
                if( self hasWeapon( weapon[i] ) )
                    self takeweapon( weapon[i] );
            }

            switch( weapon )
            {
                case "satchel_charge_mp":
                case "mine_bouncing_betty_mp":
                case "bazooka_mp":
                case "m2_flamethrower_mp":
                    self setActionSlot(3, "");
                    wait .01;
                    self giveWeapon( weapon );
                    self setActionSlot(3, "weapon", weapon);
                    break;
                
                default: break;
            }
        }
    }

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

        self.weaponsList = self getWeaponslist();
        equipmentNames = ["satchel_charge_mp","mine_bouncing_betty_mp","bazooka_mp","m2_flamethrower_mp"];

        self.primaryWeaponList = self getWeaponsListPrimaries();
        self.offHandWeaponList = isExclude(self getWeaponsList(), self.primaryWeaponList);
        self.offHandWeaponList = removeValueFromArray(self.offHandWeaponList, "knife_mp");

        if( isDefined( self.weaponsList ) )
        {
            self.equipmentList = [];
            for (i = 0; i < self.weaponsList.size; i++ )
            {
                for( a = 0; a < equipmentNames.size; a++ )
                {
                    if( self.weaponsList[i] == equipmentNames[a] )
                        self.equipmentList[ self.equipmentList.size ] = self.weaponsList[i];
                }
            }
        }

        for (i = 0; i < self.primaryWeaponList.size; i++) 
            self setPlayerCustomDvar("primary" + i, self.primaryWeaponList[i]);

        for (i = 0; i < self.offHandWeaponList.size; i++)
            self setPlayerCustomDvar("secondary" + i, self.offHandWeaponList[i]);

        for (i = 0; i < self.equipmentList.size; i++)
            self setPlayerCustomDvar("equipment" + i, self.equipmentList[i]);

        self setPlayerCustomDvar("primaryCount", self.primaryWeaponList.size);  
        self setPlayerCustomDvar("secondaryCount", self.offHandWeaponList.size);
        self setPlayerCustomDvar("equipmentCount", self.equipmentList.size);
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

    sohToggle()
    {
        if( self getPlayerCustomDvar( "SOH" ) == "1" )
        {
            self unsetPerk( "specialty_fastreload" );
            self setPerk( "specialty_bulletdamage" );
            self setPlayerCustomDvar( "SOH", "0" );
        } 

        else
        {
            self setPerk( "specialty_fastreload" );
            self setPlayerCustomDvar( "SOH", "1" );
        }
    }

    giveEquipment( equipment )
    {
        specWpns = ["satchel_charge_mp","mine_bouncing_betty_mp","bazooka_mp","m2_flamethrower_mp"];
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