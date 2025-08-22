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
    if (getDvar("jump_ladderPushVel") == 128)
    {
        setDvar("jump_ladderPushVel", 500);
        self iPrintln("Reverse Ladder Bounces: ^2[ON]");
    }
    else if(getDvar("jump_ladderPushVel") == 500)
    {
        setDvar("jump_ladderPushVel", 128);
        self iPrintln("Reverse Ladder Bounces: ^1[OFF]");
    }
}

editTime(type)
{
    //rewrite
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

doHostAction(value)
{
    if(value == "FastRestart")
        FastRestart();
    else if(value == "debugexit")
        debugexit();
}