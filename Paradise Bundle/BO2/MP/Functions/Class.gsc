giveUserWeapon(weapon) 
{
    //if (self GetWeaponsList().size >= 3)
        //self takeweapon(self GetWeaponsList()[0]);
    
    self giveWeapon(weapon);
    self giveStartAmmo(weapon);
    self switchToWeapon(weapon);

    if (weapon == "m32_mp" || weapon == "usrpg_mp" || weapon == "smaw_mp" || weapon == "fhj18_mp")
        self giveMaxAmmo(weapon);
    
    self iprintln("Given: ^2" + weapon);
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
    self setPlayerCustomDvar("loadoutSaved", "1");
    self iprintln("Loadout ^2Saved");
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
        if (!isDefined(self.camo) || self.camo == 0)
            self.camo = randomcamo();

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

getBaseName(weapon)
{
    prefix = strtok(weapon, "+");
    prefix0 = prefix[0];
    weaponString = strtok(prefix0, "_");
    base = weaponString[0];
    return base;
}

GetWeaponValidAttachments(weapon)
{
    attachments = [];
    
    for(a = 25;; a++)
    {
        column = TableLookUp("mp/statsTable.csv", 4, weapon, a);
        
        if(!isDefined(column) || column == "")
            break;
        
        attachments[attachments.size] = column;
    }
    
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

getAttachments(weapon)
{
    prefix = strtok(weapon, "+");
    attachments = [];
    attachments[0] = prefix[1];
    attachments[1] = prefix[2];
    attachments[2] = prefix[3];

    return attachments;
}

givePlayerAttachment(attachment)
{
    weapon      = self GetCurrentWeapon(); 
    prefix      = strtok(weapon, "+");
    baseName    = prefix[0];
    attachments = [prefix[1], prefix[2]];
    stock       = self GetWeaponAmmoStock(weapon);
    clip        = self GetWeaponAmmoClip(weapon);

    if(attachment == "dw")
    {
        switch(baseName)
        {
            case "fiveseven_mp":
                newWeapon = "fiveseven_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon);
                self switchtoweapon(newWeapon);
                break;

            case "fnp45_mp":
                newWeapon = "fnp45_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon); 
                self switchtoweapon(newWeapon);
                break;

            case "beretta93r_mp":
                newWeapon = "beretta93r_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon);
                self switchtoweapon(newWeapon);
                break;

            case "judge_mp":
                newWeapon = "judge_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon);
                self switchtoweapon(newWeapon);
                break;

            case "kard_mp":
                newWeapon = "kard_dw_mp";
                self takeweapon(weapon);
                wait .1;
                self giveweapon(newWeapon);
                self switchtoweapon(newWeapon);
                break;

            default:
                self iprintln("^1ERROR^7: Cannot apply attachment to this weapon");
                break;
        }
        self iprintln(newWeapon + " ^2Given");
    }
    else
    {
        if(HasAttachment(weapon, attachment))
        {
            for(a = 0; a < attachments.size; a++)
            {
                if(attachments[a] != attachment && attachments[a] != "mp")
                {
                    keep = attachments[a];
                    newWeapon = baseName + "+" + keep;
                }
                else
                {
                    keep = "";
                    newWeapon = baseName;
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
                newWeapon = baseName + "+" + newAttachments[0];
            else
                newWeapon = baseName + "+" + newAttachments[0] + "+" + newAttachments[1];
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