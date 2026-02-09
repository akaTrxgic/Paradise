TeleportZombies()
{
    origin = BulletTrace(self GetWeaponMuzzlePoint(), self GetWeaponMuzzlePoint() + vectorScale(AnglesToForward(self GetPlayerAngles()), 1000000), 0, self)["position"];
    zombies = GetAISpeciesArray(level.zombie_team);

    for(a = 0; a < zombies.size; a++)
    {
        if(isDefined(zombies[a]) && IsAlive(zombies[a]))
        {
            zombies[a] StopAnimScripted(0);
            zombies[a] ForceTeleport(origin);
            zombies[a].find_flesh_struct_string = "find_flesh";
            zombies[a].ai_state = "find_flesh";
            zombies[a] notify("zombie_custom_think_done", "find_flesh");
        }
    }
}

togglefreezeZombies()
{
    if(!self.zmFrozen)
    {
        setDvar("g_ai", 0);
        self.zmFrozen = 1;
    }
    else if(self.zmFrozen)
    {
        setDvar("g_ai", 1);
        self.zmFrozen = 0;
    }
}
