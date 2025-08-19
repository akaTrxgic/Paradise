doGiveWeapon(weapon)
{
    if (!isdefined(weapon) || weapon == "")
    {
        return;
    }

    // Remove just the current weapon before giving new one
    currentWpn = self getCurrentWeapon();

    if (isdefined(currentWpn) && currentWpn != "")
    {
        self takeWeapon(currentWpn);
    }

    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self iPrintln("Given Weapon: ^1" + weapon);
}

