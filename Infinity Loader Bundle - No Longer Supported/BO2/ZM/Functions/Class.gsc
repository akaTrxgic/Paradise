    giveUserWeapon(weapon, akimbo, camo) 
    {      
        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
    }

    getBaseName(weapon)
    {
        prefix = strtok(weapon, "+");
        prefix0 = prefix[0];
        weaponString = strtok(prefix0, "_");
        base = weaponString[0];
        return base;
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

    changeCamo(camoNum)
    {
        num = int( camoNum );
        weap    = self getCurrentWeapon();
        myclip  = self getWeaponAmmoClip(weap);
        mystock = self getWeaponAmmoStock(weap);  
        self takeWeapon(weap);   
        weaponOptions = self calcWeaponOptions(num,0,0,0,0);
        self GiveWeapon(weap,0,weaponOptions); 
        self switchToWeapon(weap);  
        self setSpawnWeapon(weap); 
        self setweaponammoclip(weap,myclip);  
        self setweaponammostock(weap,mystock);  
        self.camo = num;  
    }

    PackCurrentWeapon()
    {
        //cf4_99
        originalWeapon = self GetCurrentWeapon();
        newWeapon      = maps\mp\zombies\_zm_weapons::is_weapon_upgraded(originalWeapon) ? maps\mp\zombies\_zm_weapons::get_base_weapon_name(originalWeapon) : maps\mp\zombies\_zm_weapons::get_upgrade_weapon(originalWeapon);
        
        if(maps\mp\zombies\_zm_weapons::is_weapon_upgraded(newWeapon))
        {
            switch(level.script)
            {
                case "zm_prison":
                    camo_index = 40;
                    break;
                
                case "zm_tomb":
                    camo_index = 45;
                    break;
                
                default:
                    camo_index = 39;
                    break;
            }
        }
        else
            camo_index = 0;
        
        self TakeWeapon(originalWeapon);
        self GiveWeapon(newWeapon, 0, camo_index);
        self SetSpawnWeapon(newWeapon);
    }

    doZmPerk(perk)
    {
        self thread maps\mp\zombies\_zm_perks::give_perk(perk, true);
    }

    giveEquipment(equipment) //works for monkey bombs and frags
    {
        self GiveWeapon(equipment);
        self GiveStartAmmo(equipment);
    }

    giveUserWeapon2(weapon) 
    {
        self giveWeapon(weapon);
        self switchToWeapon(weapon);
        self giveMaxAmmo(weapon);
    }