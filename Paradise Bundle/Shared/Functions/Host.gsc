FastRestart()
{
    for(i = 0; i < level.players.size; i++)
    {
        if (isDefined( level.players[i].pers["isBot"])) 
            kick ( level.players[i] getEntityNumber() );
    }
    wait 1;
    map_restart( 0 );
}
setMinDistance(newDist)
{
    level endon("game_ended");

    switch(newDist)
    {
        case "15":
        level.lastKill_minDist = 15;
        break;

        case "25":
        level.lastKill_minDist = 25;
        break;

        case "50":
        level.lastKill_minDist = 50;
        break;

        case "100":
        level.lastKill_minDist = 100;
        break;

        case "150":
        level.lastKill_minDist = 150;
        break;

        case "200":
        level.lastKill_minDist = 200;
        break;

        case "250":
        level.lastKill_minDist = 250;
        break;

        default:
        level.lastKill_minDist = 15;
        break;
    }

    iprintln("Minimum distance: ^2" + newDist + "m");
}

spawnablesToggle(type)
{
    if(type == "slide")
    {
        if(level.slidesAllowed)
        {
            level.slidesAllowed = 0;
            foreach(player in level.players)
            {
                if (isDefined(player.slideThread))
                {
                    player.slideThread delete();
                    player.slideThread = undefined;
                }
                if (isDefined(player.spawnedSlide))
                {
                    player.spawnedSlide delete();
                    player.spawnedSlide = undefined;
                }
            }
            self iprintln("All Spawned Slides ^1Deleted");
        }
        else if(!level.slidesAllowed)
            level.slidesAllowed = 1;
    }
    else if(type == "bounce")
    {
        if(level.bouncesAllowed)
        {
            level.bouncesAllowed = 0;
            foreach(player in level.players)
            {
                if (isDefined(player.trampolineThread))
                {
                    player.trampolineThread delete();
                    player.trampolineThread = undefined;
                }
                if (isDefined(player.spawnedTrampoline))
                {
                    player.spawnedTrampoline delete();
                    player.spawnedTrampoline = undefined;
                }
            }
            self iprintln("All Spawned Bounces ^1Deleted");
        }
        else if(!level.bouncesAllowed)
            level.bouncesAllowed = 1;
    }
    else if(type == "platform")
    {
        if(level.platsAllowed)
        {
            level.platsAllowed = 0;
            foreach(player in level.players)
            {
                #ifndef WAW
                if(isDefined(player.spawnedplat))
                {
                    for(i = -3; i < 3; i++)
                    {
                        if(!isDefined(player.spawnedplat[i]))
                            continue;
                
                        for(d = -3; d < 3; d++)
                        {
                            if(isDefined(player.spawnedplat[i][d]))
                                player.spawnedplat[i][d] delete();
                        }
                    }
                }
                if(isDefined(player.platformThread))
                {
                    player.platformThread delete();
                    player.platformThread = undefined;
                }
                #else
                if(isDefined(player.spawnedPlatform))
                {
                    for(i = 0; i < 8; i++)
                    {
                        if(!isDefined(player.spawnedPlatform[i]))
                            continue;
                
                        for(d = 0; d < 8; d++)
                        {
                            if(isDefined(player.spawnedPlatform[i][d]))
                                player.spawnedPlatform[i][d] delete();
                        }
                    }
                }
            
                if(isDefined(player.platformThread))
                {
                    for(i=0;i<8;i++)
                    {
                        if(!isDefined(player.platformThread[i]))
                            continue;

                        for(d=0;d<8;d++)
                        {
                            if(isDefined(player.platformThread[i][d]))
                                player.platformThread[i][d] delete();
                        }
                    }
                }
                #endif
            }
            self iprintln("All Spawned Platforms ^1Deleted");
        }
        else if(!level.platsAllowed)
            level.platsAllowed = 1;
    }
    else if(type == "crate")
    {
        if(level.cratesAllowed)
        {
            level.cratesAllowed = 0;
            foreach(player in level.players)
            {
                if (isDefined(player.spawnedcrate))
                {
                    player.spawnedcrate delete();
                    player.spawnedcrate = undefined;
                }
                if(isDefined(player.spawnedCrateThread))
                {
                    player.spawnedCrateThread delete();
                    player.spawnedCrateThread = undefined;
                }
            }
            self iprintln("All Spawned Crates ^1Deleted");
        }
        else if(!level.cratesAllowed)
            level.cratesAllowed = 1;
    }
}