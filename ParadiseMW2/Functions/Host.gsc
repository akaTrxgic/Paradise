debugexit()
{
   wait 0.4;
    exitlevel( 1 );
    wait 0.1;
}
Softlands()
{
    if(self.SoftLandsS == 0)
    {
        self.SoftLandsS = 1;
        self iPrintln("Softlands: ^2[ON]");
        setDvar( "bg_falldamageminheight", 1);
    }
    else if(self.SoftLandsS == 1)
    {
        self.SoftLandsS = 0;
        self iPrintln("Softlands: ^1[OFF]");
        setDvar( "bg_falldamageminheight", 0);
    }
}
reverseladders()
{
    if ( getdvar( "jump_ladderPushVel" ) == "128" )
    {
        setDvar("jump_ladderPushVel", 500);
        self iPrintln("Reverse Ladder Bounces: ^2[ON]");
    }
    else
    {
        setDvar("jump_ladderPushVel", 128);
        self iPrintln("Reverse Ladder Bounces: ^1[OFF]");
    }
}

editTime(type)
{
    if(type == "add")
    {
        setgametypesetting( "timelimit", getgametypesetting( "timelimit" ) + 1);
        self iPrintln("^2Added 1 Minute");
    }
    else if(type == "subtract")
    {
        setgametypesetting( "timelimit", getgametypesetting( "timelimit" ) - 1);
        self iPrintln("^1Subtracted 1 Minute");
    }
}

FastRestart()
{
    for(i = 0; i < level.players.size; i++)
    {
        if (isDefined( level.players[i].pers["isBot"])) 
        {
            kick ( level.players[i] getEntityNumber() );
        }
    }
    wait 1;
    map_restart( 0 );
}
DeleteAllDamageTriggers()
{
    damagebarriers = GetEntArray("trigger_hurt", "classname");
    for(i = 0; i < damagebarriers.size; i++) damagebarriers[i] delete();
    level.damagetriggersdeleted = true;
}

DestroyActiveKillstreaks(type)
{
    player = undefined;
    if(type == "Owned")
        player = self;
    
    foreach(heli in level.helis)
        RadiusDamage(heli.origin,384,5000,5000,player);
    foreach(littleBird in level.littleBird)
        RadiusDamage(littleBird.origin,384,5000,5000,player);
    foreach(turret in level.turrets)
        RadiusDamage(turret.origin,16,5000,5000,player);
    foreach(rocket in level.rockets)
        rocket notify("death");
    if(level.teamBased)
    {
        foreach(uav in level.uavModels["allies"])
            RadiusDamage(uav.origin,384,5000,5000,player);
        foreach(uav in level.uavModels["axis"])
            RadiusDamage(uav.origin,384,5000,5000,player);
    }
    else
        foreach(uav in level.uavModels)
            RadiusDamage(uav.origin,384,5000,5000,player);
    if(isDefined(level.ac130player))
        RadiusDamage(level.ac130.planeModel.origin+(0,0,10),1000,5000,5000,player);
    crates = GetEntArray("care_package","targetname");
    foreach(crate in crates)
    {
        if(isDefined(crate.objIdFriendly))
            _objective_delete(crate.objIdFriendly);
        if(isDefined(crate.objIdEnemy))
            _objective_delete(crate.objIdEnemy);
        crate delete();
    }
    
    self iPrintln("All Active Killstreaks ^2Destroyed");
}