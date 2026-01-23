giveUserWeapon(weap, akimbo) 
{      
    weapon = "iw6_" + weap;
        
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
        column = TableLookUp("mp/attachmentTable.csv", 4, weapon, a);
        
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

        if(issubstr(weapon, "akimbo"))
            self giveuserweapon(weapon, true);
        else
            self giveWeapon(weapon, 0);

        if (weapon == "rpg_mp" || weapon == "m79_mp") 
            self giveMaxAmmo(weapon);
    }

    self switchToWeapon(self.primaryWeaponList[1]);
    self setSpawnWeapon(self.primaryWeaponList[1]);
    self giveWeapon("knife_mp");
    for (i = 0; i < self.offHandWeaponList.size; i++) 
    {
        offhand = self.offHandWeaponList[i];

            switch(offhand) 
            {
                case "frag_grenade_mp":
                case "semtex_mp":
                case "throwingknife_mp":
                case "proximity_explosive_mp":
                case "c4_mp":
                case "mortar_shell_mp":
                self thread giveequipment(offhand);
                break;

                case "flash_grenade_mp":
                case "concussion_grenade_mp":
                case "smoke_grenade_mp":
                case "trophy_mp":
                case "motion_sensor_mp":
                case "thermobaric_grenade_mp":
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
    equip = StrTok(equipment, "_");
    
    if(equip[(equip.size - 1)] != "mp" && !IsSubStr(equipment, "specialty"))
        equipment += "_mp";
    
    lethals = ["frag_grenade_mp","semtex_mp","throwingknife_mp","proximity_explosive_mp","c4_mp","mortar_shell_mp"];
    hasEquipment     = self HasWeapon(equipment);

    for(a=0;a<lethals.size;a++)
    {
        if(self HasWeapon1(lethals[a]))
            self TakeWeapon(lethals[a] + "_mp");
        
        if(self _HasPerk(lethals[a] + "_mp"))
            self _UnsetPerk(lethals[a] + "_mp");
        
        self SetOffhandPrimaryClass("none");
    }
    
    if(!hasEquipment)
        self givePerkEquipment(equipment, false);
}

GiveSecondaryOffhand(offhand)
{
    if(!IsSubStr(offhand, "specialty"))
    {
        equip = StrTok(offhand, "_");
        
        if(equip[(equip.size - 1)] != "mp")
            offhand += "_mp";
    }
    
    offhands = ["flash_grenade_mp","concussion_grenade_mp","smoke_grenade_mp","trophy_mp","motion_sensor_mp","thermobaric_grenade_mp"];
    hasEquipment       = self HasWeapon(offhand);
    
    for(a = 0; a < offhands.size; a++)
    {
        if(self HasWeapon1(offhands[a]))
            self TakeWeapon(offhands[a] + "_mp");
        
        if(self _HasPerk(offhands[a]))
            self _UnsetPerk(offhands[a]);
        
        self SetOffhandSecondaryClass("none");
    }
    
    if(!hasEquipment)
        self givePerkOffhand(offhand, false);
}

HasWeapon1(weapon)
{
    foreach(weap in self GetWeaponsList())
        if(IsSubStr(weap, weapon) || weapon == weap)
            return true;
    
    return false;
}