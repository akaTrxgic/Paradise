doGiveWeapon(weapon)
{
    if (!isdefined(weapon) || weapon == "")
        return;

    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self iPrintln("Given Weapon: ^2" + weapon);
}

getBaseName(weapon)
{
    prefix = strtok(weapon, "_");
    base = prefix[0];
    return base;
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
    prefix = strtok(weapon, "_");
    attachments = [];
    attachments[0] = prefix[1];
    attachments[1] = prefix[2];

    return attachments;
}

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
    if ( grenadeTypePrimary != "" )
	{
		self GiveWeapon( grenadeTypePrimary );
		self SetWeaponAmmoClip( grenadeTypePrimary, 1 );
		self SwitchToOffhand( grenadeTypePrimary );
	}
    self iPrintln("Given: ^2" + grenadeTypePrimary);
}

giveTactical(grenadeTypeSecondary)
{
	if ( grenadeTypeSecondary != "" )
    {	
		if ( grenadeTypeSecondary == level.weapons["flash"])
			self setOffhandSecondaryClass("flash");
		else
			self setOffhandSecondaryClass("smoke");
		
        self TakeWeapon();
		self giveWeapon( grenadeTypeSecondary );
		self SetWeaponAmmoClip( grenadeTypeSecondary, 1 );
	}
    self iPrintln("Given: ^2" + grenadeTypeSecondary);
}