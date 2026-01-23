disableBombs()
{
    bombZones = GetEntArray("bombzone", "targetname");
    
    if(!isDefined(bombZones) || !bombZones.size)
        return;
    
    shouldDisable = !AreBombsDisabled();
    
    for(a = 0; a < bombZones.size; a++)
    {
        if(shouldDisable)
            bombZones[a] trigger_off(); //common_scripts/utility
        else
            bombZones[a] trigger_on();  //common_scripts/utility
    }
}

AreBombsDisabled()
{
    bombZones = GetEntArray("bombzone", "targetname");
    
    if(!isDefined(bombZones) || !bombZones.size)
        return false;
    
    for(a = 0; a < bombZones.size; a++)
        if(!isDefined(bombZones[a].trigger_off) || !bombZones[a].trigger_off)
            return false;
            self iprintln("Bomb planting [^2ON^7]");
        
    return true;
}

endGame()
{
    level thread maps\mp\gametypes\_gamelogic::forceEnd();
}