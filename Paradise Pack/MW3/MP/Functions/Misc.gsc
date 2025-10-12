togglelobbyfloat()
{
    if(!self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] thread enableFloaters();
        self.floaters = 1;
    }
    else if(self.floaters)
    {
        for(i = 0; i < level.players.size; i++)level.players[i] notify("stopFloaters");
        self.floaters = 0;
    }
}

enableFloaters()
{ 
    self endon("disconnect");
    self endon("stopFloaters");

    for(;;)
    {
        if(level.gameended && !self isonground())
        {
            floatersareback = spawn("script_model", self.origin);
            self playerlinkto(floatersareback);
            self freezecontrols(true);
            for(;;)
            {
                floatermovingdown = self.origin - (0,0,0.5);
                floatersareback moveTo(floatermovingdown, 0.01);
                wait 0.01;
            } 
            wait 6;
            floatersareback delete();
        }
        wait 0.05;
    }
}

endGame()
{
    level thread maps\mp\gametypes\_gamelogic::forceEnd();
}

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

DolphinDive()
{
 if(!IsDefined( self.DolphinDive ))
    {
         self.DolphinDive = true;
            
         while(IsDefined( self.DolphinDive ))
         {
             self.Prone360 = true;
             setDvar("bg_prone_yawcap", 360);
            
            if(self isSprinting())
            {
                vec = AnglesToForward( self GetPlayerAngles() );
                end = ( vec[0] * 110,vec[1] * 110,vec[2] * 110 );
                    
                if(self GetStance() == "crouch" && self IsOnGround())
                {
                    self SetStance( "prone" );
                    self SetVelocity( self GetVelocity() + end + (0, 0, 300) );
                        
                    while(1)
                    {
                        if(self IsOnGround())
                        break;
                        wait .05;
                    }
                }
            }
            wait .05;
        }
    }    
    else
        self.DolphinDive = undefined; 
}
isSprinting()
{
  v = self GetVelocity();
        
  return v[0] >= 190 || v[1] >= 190 || v[0] <= -190 || v[1] <= -190;
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

kys()
{
    self suicide();
}