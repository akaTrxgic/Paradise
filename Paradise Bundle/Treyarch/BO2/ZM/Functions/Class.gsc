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
    self iprintln("Given: ^2" + newWeapon);
}

giveUserWeapon(weapon) 
{
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self giveMaxAmmo(weapon);
    
    self iprintln("Given: ^2" + weapon);
}

giveUserWeapon2(weapon) 
{
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self giveMaxAmmo(weapon);
}

doZmPerk(perk)
{
    self thread maps\mp\zombies\_zm_perks::give_perk(perk, true);
    self iprintln("Given ^2" + perk);
}

giveEquipment(equipment) //works for monkey bombs and frags
{
    self GiveWeapon(equipment);
    self GiveStartAmmo(equipment);
}