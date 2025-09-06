debugexit()
{
   wait 0.4;
    exitlevel( 1 );
    wait 0.1;
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