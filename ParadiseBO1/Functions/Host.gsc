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
DeleteAllDamageTriggers()
{
    damagebarriers = GetEntArray("trigger_hurt", "classname");
    for(i = 0; i < damagebarriers.size; i++) damagebarriers[i] delete();
    level.damagetriggersdeleted = true;
}

ChangeShader( imagepath, shader, multiple = undefined )
{
    imagepath = strTok(imagepath, ",");
    shader = strTok(shader, ",");
    
    if(!isDefined(multiple)) // Check if the multiple has at least one element
    {
        //self iPrintln("Path = " + imagepath[0] + " Shader = " + shader[0] ); // Debug msg
        replaceimage( imagepath[0], shader[0] );
    }

    if(isDefined(multiple)) // Check if the multiple has at least more then one element
    {
        for( command = 0; command < imagepath.size; command++ )
        {
            //self iPrintln("Path " + imagepath[command] + " Shader = " + shader[command] + " Size = " + imagepath.size ); // Debug msg
            replaceimage( imagepath[command], shader[command] );
        }
    }
}