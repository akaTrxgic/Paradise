debugexit()
{
   wait 0.4;
    exitlevel( 1 );
    wait 0.1;
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

