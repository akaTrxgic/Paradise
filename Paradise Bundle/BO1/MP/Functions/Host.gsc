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
        self iPrintln("Reverse Ladder Bounces: [^2ON^7]");
    }
    else
    {
        setDvar("jump_ladderPushVel", 128);
        self iPrintln("Reverse Ladder Bounces: [^1OFF^7]");
    }
}

editTime(type)
{
    if(type == "add")
        self add1min();

    else if(type == "sub")
        self sub1min();
}
add1Min()
{
    timeLeft       = GetDvar("scr_" + level.gametype + "_timelimit");
    timeLeftProper = int(timeLeft);
    setTime        = timeLeftProper + 1; 
    SetDvar("scr_" + level.gametype + "_timelimit", setTime);
    wait .05;
    self iPrintln("^2Added 1 Minute");
}
sub1Min()
{
    timeLeft       = GetDvar("scr_" + level.gametype + "_timelimit");
    timeLeftProper = int(timeLeft);
    setTime        = timeLeftProper - 1;
    SetDvar("scr_" + level.gametype + "_timelimit", setTime);
    wait .05;
    self iprintln("^1Removed 1 Minute");
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