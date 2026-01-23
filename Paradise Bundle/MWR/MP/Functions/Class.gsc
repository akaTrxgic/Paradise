equip_camo(camo) 
{
    weapon = getBaseWeaponName(self getCurrentWeapon()) + "_mp_a";
    weapon_attachment = strtok(self getCurrentWeapon(), "#")[1];
    weapon_kit = strtok(strtok(self getCurrentWeapon(), "#")[2], "_")[0];
    
    if(camo < 10) 
        camo = "00" + camo;
    else if(int(camo) > 9 && int(camo) < 100) 
        camo = "0" + camo;

    weapon_painted = weapon + "#" + weapon_attachment + "#" + weapon_kit + "_camo" + camo;
    
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

giveUserWeapon(baseWpn) 
{
    weapon = "h1_"+baseWpn+"_mp_a#none_f#base";
        
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
        weapon = self.primaryWeaponList[i];
        self giveWeapon(weapon);
        self giveMaxAmmo(weapon);
    }

    self switchToWeapon(self.primaryWeaponList[1]);
    self setSpawnWeapon(self.primaryWeaponList[1]);
    self giveWeapon("knife_mp");
    /*
    for (i = 0; i < self.offHandWeaponList.size; i++) 
    {
        offhand = self.offHandWeaponList[i];

            switch (offhand) 
            {
                case "h1_claymore_mp":
                case "h1_c4_mp":
                case "h1_rpg_mp":
                self setPerkEquipment(offhand);
                break;

                case "h1_fraggrenade_mp":
                case "h1_concussiongrenade_mp":
                case "h1_flashgrenade_mp":
                case "h1_smokegrenade_mp":
                maps\mp\gametypes\_class::giveOffhand(offhand);
                break;

                default:
                self giveWeapon(offhand);
                break;
        }
    }*/
}

CamoNameTable(a)
{
    return TableLookupIString("mp/camoTable.csv", 0, a, 2);
}