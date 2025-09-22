changeCamo(num)
    {
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

randomCamo()
{
    numEro=randomIntRange(1,14);  
    Weapon  = self GetCurrentWeapon();
    oldammo = self GetWeaponAmmoStock(Weapon);
    oldclip = self GetWeaponAmmoClip(Weapon);
    self TakeWeapon(Weapon);
    self GiveWeapon(Weapon,numEro);
    self SetWeaponAmmoStock(Weapon,oldammo);
    self SetWeaponAmmoClip(Weapon,oldclip);
    self SetSpawnWeapon(Weapon);
}

giveUserWeapon(weapon, akimbo) 
{      
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
    base        = getBaseWeaponName(weapon);
    attachments = GetWeaponAttachments(weapon);
    stock       = self GetWeaponAmmoStock(weapon);
    clip        = self GetWeaponAmmoClip(weapon);
    akimbo      = false;

        if(attachment == "acogHandler")
        {
            if(weaponClass(weapon) == "smg")
                attachment = "acogsmg";
            else
                attachment = "acog";
        }
        else if(attachment == "reflexHandler")
        {
            if(weaponClass(weapon) == "smg")
                attachment = "reflexsmg";
            else if(weaponClass(weapon) == "lmg")
                attachment = "reflexlmg";
            else
                attachment = "reflex";
        }
        else if(attachment == "silencerHandler")
        {
            if(weaponClass(weapon) == "smg" || weaponClass(weapon) == "assault" || weaponClass(weapon) == "lmg")
                attachment = "silencer";
            else if(weaponClass(weapon) == "pistol" || weaponClass(weapon) == "machine_pistol")
                attachment = "silencer02";
            else if(weaponClass(weapon) == "shotgun" || weaponClass(weapon) == "sniper")
                attachment = "silencer03";
        }
        else if(attachment == "glHandler")
        {
            sub = strTok(weapon,"_");
            switch(sub[1]) 
            {
	            case "m4":
	            case "m16":
                attachment = "gl";
                break;

                case "ak47":
                attachment = "gp25";
                break;

                case "scar":
                case "cm901":
                case "type95":
                case "g36c":
                case "acr":
                case "mk14":
                case "fad":
                attachment = "m320";
                break;
            }
        }
        else if(attachment == "thermalHandler")
        {
            if(weaponClass(weapon) == "smg")
                attachment = "thermalsmg";
            else
                attachment = "thermal";
        }
        else if(attachment == "holoHandler")
        {
            if(weaponClass(weapon) == "smg")
                attachment = "eotechsmg";
            else if(weaponClass(weapon) == "lmg")
                attachment = "eotechlmg";
            else
                attachment = "eotech";
        }
    
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

GetWeaponValidAttachments(weapon) //Gets The Supported Attachments Of A Given Weapon
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

HasAttachment(weapon, attachment)
{
    attachments = getWeaponAttachments(weapon);
    
    foreach(attach in attachments)
        if(attach == attachment)
            return true;
    
    return false;
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

saveloadouttoggle()
{
    if(!self.saveLoadoutEnabled)
    {
        self saveloadout();
        self.saveLoadoutEnabled = 1;
    }
    else if(self.saveLoadoutEnabled)
    {
        self deleteloadout();
        self.saveLoadoutEnabled = 0;
    }
}
saveLoadout() 
{
    wait .01;
        
    self.primaryWeaponList = self getWeaponsListPrimaries();
    self.offHandWeaponList = isExclude(self getweaponslistoffhands(), self.primaryWeaponList);
    self.offHandWeaponList = removeValueFromArray(self.offHandWeaponList, "knife_mp");

    for (i = 0; i < self.primaryWeaponList.size; i++) 
        self setPlayerCustomDvar("primary" + i, self.primaryWeaponList[i]);

    for (i = 0; i < self.offHandWeaponList.size; i++)
        self setPlayerCustomDvar("secondary" + i, self.offHandWeaponList[i]);

    self setPlayerCustomDvar("primaryCount", self.primaryWeaponList.size);  
    self setPlayerCustomDvar("secondaryCount", self.offHandWeaponList.size);
    self setPlayerCustomDvar("loadoutSaved", "1");
    self iprintln("Loadout ^2Saved");
}

deleteLoadout()
{        
    self setPlayerCustomDvar("loadoutSaved", "0");
    self iprintln("Loadout ^1Deleted");
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
        if (!isDefined(self.camo) || self.camo == 0) 
            self.camo = self randomcamo();

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
giveEquipment(equipment)
{
    self TakeWeapon( self GetCurrentOffhand() );
	self SetOffhandPrimaryClass( "other" );
	equipment = maps\mp\perks\_perks::validatePerk( 1, equipment );
	self givePerk( equipment, true );
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
AttachmentTable(a)
{
    return TableLookup("mp/attachmentTable.csv",0,a,4);
}

AttachmentNameTable(name)
{
    return TableLookupIString("mp/attachmentTable.csv",4,name,3);
}
tryUseQuickdraw( var_0 )
{
    doPerkFunctions( "specialty_quickdraw" );
}

doPerkFunctions( var_0 )
{
    maps\mp\_utility::givePerk( var_0, 0 );
    thread watchDeath( var_0 );
    thread checkForPerkUpgrade( var_0 );
    maps\mp\_matchdata::logKillstreakEvent( var_0 + "_ks", self.origin );
}
giveQuickdrawKillstreak()
{
    if(!self.quickdraw)
    {
        self doperkfunctions("specialty_quickdraw");
        self.quickdraw = 1;
    }
    else if(self.quickdraw)
    {
        maps\mp\_utility::_unsetPerk("specialty_quickdraw");
        maps\mp\_utility::_unsetExtraPerks("specialty_quickdraw");
        self.quickdraw = 0;
    }
}
watchDeath( var_0 )
{
    self endon( "disconnect" );
    self waittill( "death" );
    maps\mp\_utility::_unsetPerk( var_0 );
    maps\mp\_utility::_unsetExtraPerks( var_0 );
}

checkForPerkUpgrade( var_0 )
{
    var_1 = maps\mp\gametypes\_class::getPerkUpgrade( var_0 );

    if ( var_1 != "specialty_null" )
    {
        maps\mp\_utility::givePerk( var_1, 0 );
        thread watchDeath( var_1 );
    }
}