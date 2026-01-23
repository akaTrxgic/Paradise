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
            self iprintln("Bomb planting ^2ON");
            
    return true;
}

endGame()
{
    level thread maps\mp\gametypes\_gamelogic::forceEnd();
}

doUnstuck()
{
    player = self;  
   
    if (!isAlive(player)) 
        return;  

    FAR = 25; 
    pos = player.origin; 

    
    pos = physicsTrace(pos, pos + (0, 0, FAR), false, player);
    pos += (0, 0, 1); 

 
    pos = physicsTrace(pos, pos + (0, 0, FAR), false, player);
    pos = playerPhysicsTrace(pos, pos - (0, 0, FAR * 2), false, player);

  
    player setOrigin(pos);
}

tptoSpawn()
{
    self setOrigin( self.lastSpawnPoint.origin + ( 0, 0, 10 ) );
    self setVelocity((0,0,0));
}