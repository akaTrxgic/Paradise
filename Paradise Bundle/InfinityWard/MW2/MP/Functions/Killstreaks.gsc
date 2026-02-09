doKillstreak(name)
{
    self maps\mp\killstreaks\_killstreaks::giveKillstreak(name, false );
    self iPrintln( "Given ^2" + name);
}

FakeNuke()
{
    foreach(player in level.players)
    {
        player maps\mp\killstreaks\_nuke::tryUseNuke(1);

        while(!isdefined(level.nukedetonated))
        wait 0.5;

        setslowmotion(1, .25, .5);
        maps\mp\gametypes\_gamelogic::resumeTimer();
        level.timeLimitOverride = false;

        SetDvar( "ui_bomb_timer", 0 );
        level notify( "nuke_cancelled" );
        level.nukedetonated = undefined;
        level.nukeincoming  = undefined;
        
        wait 1;
        setSlowMotion( 0.25, 1, 2.0 );
        
        wait 1.5;
        VisionSetNaked(GetDvar("mapname"), 0.5);
        
        wait .1;
        break;
    }
}