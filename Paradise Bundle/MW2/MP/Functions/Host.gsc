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

AzzaLobby()
{
    if(!level.isAzzaLobby)
    {
        SetDvar("xblive_privatematch",0);
        SetDvar("onlinegame",1);
        level.isAzzaLobby = true;
    }
    else if(level.isAzzaLobby)
    {
        SetDvar("xblive_privatematch",1);
        SetDvar("onlinegame",0);
        level.isAzzaLobby = false;
    }
}

mapRot(type)
{
    switch(type)
    {
        case "bestBase":
        level.mapRot = 1;
        mapArray = ["mp_favela","mp_highrise","mp_quarry","mp_boneyard","mp_terminal","mp_underpass"];
        break;

        case "bestDLC":
        level.mapRot = 1;
        mapArray = ["mp_complex","mp_crash","mp_overgrown","mp_storm","mp_abandon","mp_fuel2"];
        break;

        case "baseDLC":
        level.mapRot = 1;
        mapArray = ["mp_favela","mp_complex","mp_highrise","mp_crash","mp_quarry","mp_overgrown","mp_boneyard","mp_storm","mp_terminal","mp_abandon","mp_underpass","mp_fuel2"];
        break;

        case "off":
        level.mapRot = 0;
        break;
    }

    if(level.mapRot)
    {
        level waittill("game_ended");
        
    }
}

/*
//Base
mp_afghan       (Afghan)
mp_derail       (Derail)
mp_estate       (Estate)
mp_favela       (Favela)
mp_highrise     (Highrise)
mp_invasion     (Invasion)
mp_checkpoint   (Karachi)
mp_quarry       (Quarry)
mp_rundown      (Rundown)
mp_rust         (Rust)
mp_boneyard     (Scrapyard)
mp_nightshift   (Skidrow)
mp_subbase      (Sub Base)
mp_terminal     (Terminal)
mp_underpass    (Underpass)
mp_brecourt     (Wasteland)

//Stimulus
mp_complex      (Bailout)
mp_crash        (Crash)
mp_overgrown    (Overgrown)
mp_compact      (Salvage)
mp_storm        (Storm)

//Resurgence
mp_abandon      (Carnival)
mp_fuel2        (Fuel)
mp_strike       (Strike)
mp_trailerpark  (Trailer Park)
mp_vacant       (Vacant)
*/