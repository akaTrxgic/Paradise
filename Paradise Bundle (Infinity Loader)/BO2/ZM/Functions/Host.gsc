togglelobbyfloat()
{
    if(!self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] thread enableFloaters();
        self.floaters = 1;
    }
    else if(self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] notify("stopFloaters");
        self.floaters = 0;
    }
}

enableFloaters()
{ 
    self endon("disconnect");
    self endon("stopFloaters");

    for(;;)
    {
        if(level.gameended && !self isonground())
        {
            floatersareback = spawn("script_model", self.origin);
            self playerlinkto(floatersareback);
            self freezecontrols(true);
            for(;;)
            {
                floatermovingdown = self.origin - (0,0,0.5);
                floatersareback moveTo(floatermovingdown, 0.01);
                wait 0.01;
            } 
            wait 6;
            floatersareback delete();
        }
        wait 0.05;
    }
}

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
