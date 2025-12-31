changeCamo(num)
{
    Weapon  = self GetCurrentWeapon();
    oldammo = self GetWeaponAmmoStock(Weapon);
    oldclip = self GetWeaponAmmoClip(Weapon);
    self TakeWeapon(Weapon);
    self GiveWeapon(Weapon,num);
    self SetWeaponAmmoStock(Weapon,oldammo);
    self SetWeaponAmmoClip(Weapon,oldclip);
    self SetSpawnWeapon(Weapon);
}

randomCamo()
{
    numEro  = randomIntRange(1,8);  
    Weapon  = self GetCurrentWeapon();
    oldammo = self GetWeaponAmmoStock(Weapon);
    oldclip = self GetWeaponAmmoClip(Weapon);
    self TakeWeapon(Weapon);
    self GiveWeapon(Weapon,numEro);
    self SetWeaponAmmoStock(Weapon,oldammo);
    self SetWeaponAmmoClip(Weapon,oldclip);
    self SetSpawnWeapon(Weapon);
}

giveUserWeapon(weap, akimbo) 
{      
    weapon = "iw6_" + weap;
        
    if(self hasWeapon(Weapon))
    {
        self SetSpawnWeapon(Weapon);
        return;
    }

    //if(issubstr(weapon, "akimbo"))
        //akimbo = true;

    self GiveWeapon(Weapon);
    self GiveMaxAmmo(Weapon);
    self SwitchToWeapon(Weapon);
    self iprintln("Given: ^2" + weapon);
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
        if (!isDefined(self.camo) || self.camo == 0) 
            self.camo = self randomcamo();

        weapon = self.primaryWeaponList[i];
        //weaponOptions = self calcWeaponOptions(self.camo, self.currentLens, self.currentReticle, 0);
        if(issubstr(weapon, "akimbo"))
            self giveuserweapon(weapon, true);
        else
            self giveWeapon(weapon, 0); //0, weaponOptions
        if (weapon == "rpg_mp" || weapon == "m79_mp") 
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
                case "sticky_grenade_mp":
                case "claymore_mp":
                case "c4_mp":
                case "flare_mp":
                case "throwingknife_mp":
                self thread giveequipment(offhand);
                break;

                case "concussion_grenade_mp":
                case "flash_grenade_mp":
                case "smoke_grenade_mp":
                self thread givesecondaryoffhand(offhand);
                break;

                default:
                self giveWeapon(offhand);
                break;
        }
    }
}
GiveEquipment(equipment)
{
    equip = StrTok(equipment,"_");
    if(equip[equip.size-1] != "mp" && !isSubStr(equipment,"specialty"))
        equipment += "_mp";
    
    self TakeWeapon(self GetCurrentOffhand());
    self SetOffhandPrimaryClass("other");
    self GiveStartAmmo(equipment);
    self SetWeaponHudIconOverride( "primaryoffhand", equipment );
}

GiveSecondaryOffhand(offhand)
{
    equip = StrTok(offhand,"_");
    if(equip[equip.size-1] != "mp")
        offhand += "_mp";
    
    if(offhand == "flash_grenade_mp")
    {
        self SetOffhandSecondaryClass("flash");
        self SetWeaponAmmoClip(offhand,2);
    }
    else if(offhand == "concussion_grenade_mp")
    {
        self SetOffhandSecondaryClass("concussion");
        self SetWeaponAmmoClip(offhand,2);
    }
    else if(offhand == "smoke_grenade_mp")
    {
        self SetOffhandSecondaryClass("smoke");
        self SetWeaponAmmoClip(offhand,1);
    }
    self TakeWeapon(self GetCurrentOffhand());
    self GiveWeapon(offhand);
    self SetWeaponHudIconOverride( "secondaryoffhand", offhand );
}
