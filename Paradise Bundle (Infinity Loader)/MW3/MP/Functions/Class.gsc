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

giveUserWeapon(weapon) 
{
    if(self hasWeapon(Weapon))
    {
        self SetSpawnWeapon(Weapon);
        return;
    }

    if(issubstr(weapon, "akimbo"))
        akimbo = true;

    self GiveWeapon(Weapon);
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

HasAttachment(weapon, attachment)
{
    attachments = getWeaponAttachments(weapon);
    
    foreach(attach in attachments)
        if(attach == attachment)
            return true;
    
    return false;
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

GiveGlowstick()
{
    wait .1;
    self TakeWeapon(self GetCurrentOffhand());
    self SetOffhandPrimaryClass("other");
    self GiveWeapon("lightstick_mp");
    self SetWeaponHudIconOverride( "primaryoffhand", "lightstick_mp" );
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