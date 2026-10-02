    giveUserWeapon(weapon, akimbo) 
    {      
        if(self hasWeapon(Weapon))
        {
            self SetSpawnWeapon(Weapon);
            return;
        }

        if(issubstr(weapon, "akimbo"))
            akimbo = true;

        self GiveWeapon(Weapon, 0, Akimbo);
        self GiveMaxAmmo(Weapon);
        self SwitchToWeapon(Weapon);
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
        self GiveWeapon(weap, num);
        self switchToWeapon(weap);  
        self setSpawnWeapon(weap); 
        self setweaponammoclip(weap,myclip);  
        self setweaponammostock(weap,mystock);  
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
            self _unsetperk( "specialty_quickdraw" );
            self _unsetperk( "specialty_fastoffhand" );
            self setPlayerCustomDvar( "SOH", "0" );
        } 

        else
        {
            self givePerk( "specialty_quickdraw", false );
            self givePerk( "specialty_fastoffhand", false );
            self setPlayerCustomDvar( "SOH", "1" );
        }
    }

    camoString(camoNum)
    {
        num = int( camoNum );
        if(num < 10 && num > 0)num = "0"+num;
        weapon = self GetCurrentWeapon();
        
        if(num > 0)
        {
            if(isSubStr(weapon,"_camo"))
            {
                weapon1 = StrTok(weapon,"_");
                string  = "";
                for(a=0;a<weapon1.size;a++)
                    if(!isSubStr(weapon1[a],"camo"))
                        string += weapon1[a]+"_";
                
                string += "camo"+num;
            }
            else string = weapon+"_camo"+num;
        }
        else
        {
            weapon1 = StrTok(weapon,"_");
            string  = "iw5";
            
            for(a=1;a<weapon1.size;a++)
                if(!isSubStr(weapon1[a],"camo"))
                    string += "_"+weapon1[a];
        }
        
        self TakeWeapon(weapon);
        self GiveWeapon(string);
        self SetSpawnWeapon(string);
    }

    GivePlayerAttachment(attachment)
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

    IsValidAttachmentCombo(attachment1, attachment2)
    {
        return TableLookup("mp/attachmentCombos.csv", 0, attachment1, TableLookupRowNum("mp/attachmentCombos.csv", 0, attachment2)) != "no";
    }

    loadLoadout() 
    {
        self takeAllWeapons();
            
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
            //weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);
            if(issubstr(weapon, "akimbo"))
                self giveuserweapon(weapon, true);
            else
                self giveuserweapon(weapon, false); //0, weaponOptions 
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
                    case "frag_grenade_mp":
                    case "semtex_mp":
                    case "throwingknife_mp":
                    case "bouncingbetty_mp":
                    case "claymore_mp":
                    case "c4_mp":
                    self thread giveequipment(offhand);
                    break;

                    case "flash_grenade_mp":
                    case "concussion_grenade_mp":
                    case "smoke_grenade_mp":
                    case "flare_mp":
                    case "trophy_mp":
                    case "scrambler_mp":
                    case "portable_radar_mp":
                    case "emp_grenade_mp":
                    self thread givesecondaryoffhand(offhand);
                    break;

                    default:
                    self giveWeapon(offhand);
                    break;
            }
        }
    }

    giveEquipment( equipment )
    {
        self TakeWeapon(self GetCurrentOffhand());
        self SetOffhandPrimaryClass("other");

        if( equipment == "lightstick_mp" )
        {
            self GiveWeapon("lightstick_mp");
            self SetWeaponHudIconOverride( "primaryoffhand", "lightstick_mp" );
        }

        else
        {
            equipment = maps\mp\perks\_perks::validatePerk( 1, equipment );
            self givePerk( equipment, true );
        }
    }

    GiveSecondaryOffhand(offhand)
    {
        weaponList = self GetWeaponsListOffhands();
        
        foreach( weapon in weaponList )
        {
            switch( weapon )
            {
                case "flash_grenade_mp":
                case "concussion_grenade_mp":
                case "smoke_grenade_mp":
                case "flare_mp":
                case "trophy_mp":
                case "scrambler_mp":
                case "portable_radar_mp":
                case "emp_grenade_mp":
                self TakeWeapon( weapon );
                break;
            }
        }
                
        if ( offhand == "flash_grenade_mp" )
            self SetOffhandSecondaryClass( "flash" );

        else if ( offhand == "smoke_grenade_mp" || offhand == "concussion_grenade_mp" )
            self SetOffhandSecondaryClass( "smoke" );

        else 
            self SetOffhandSecondaryClass( "flash" );

        switch( offhand )
        {
            case "smoke_grenade_mp":
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 1 );
                break;
            case "flash_grenade_mp":
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 2 );
                break;
            case "concussion_grenade_mp":
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 2 );
                break;
            case "emp_grenade_mp":
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 1 );
                break;
            case "specialty_portable_radar":
                self givePerk( offhand, false );
                self setWeaponAmmoClip( "portable_radar_mp", 1 );
                break;
            case "specialty_scrambler":
                self givePerk( offhand, false );
                self setWeaponAmmoClip( "scrambler_mp", 1 );
                break;
            case "specialty_tacticalinsertion":
                self givePerk( offhand, false );
                self setWeaponAmmoClip( "flare_mp", 1 );
                break;
            case "trophy_mp":
                self givePerk( offhand, false );
                self setWeaponAmmoClip( offhand, 1 );
                break;
            default:
                self giveWeapon( offhand );
                self setWeaponAmmoClip( offhand, 1 );
                break;
        }
    }

    giveQuickdrawKillstreak()
    {
        if(!self.quickdraw)
        {
            self givePerk( "specialty_quickdraw", false );
            self givePerk( "specialty_fastoffhand", false );
            self.quickdraw = 1;
        }
        else if(self.quickdraw)
        {
            self unsetperk("specialty_quickdraw");
            self unsetperk("specialty_fastoffhand");
            self.quickdraw = 0;
        }
    }

    rhThrowingKnife()
    {
        wait .1;
        self takeweapon(self getcurrentoffhand());
        wait 0.01;
        self giveweapon("throwingknife_mp",0,false);
        wait 0.01;
        self takeweapon("throwingknife_mp");
        wait 0.01;
        self giveweapon("throwingknife_rhand_mp",0,false); 
    }