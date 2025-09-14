initNoClip()
{    
    if(isConsole())
        address = 0x830CF3A3 + (self GetEntityNumber() * 0x3700);
    else
        address = 0x1B11554 + (self GetEntityNumber() * 0x366C);
    
    if(!self.NoClipT)
    {
        WriteByte(address,0x02);
        self.NoClipT = 1;
    }
    else
    {
        WriteByte(address,0x00);
        self.NoClipT = 0;
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
normalbounce()
{
    if (isDefined(self.trampolineThread))
    {
        threadStop(self.trampolineThread);
        self.trampolineThread = undefined;
    }
    if (isDefined(self.spawnedTrampoline))
    {
        self.spawnedTrampoline delete();
        self.spawnedTrampoline = undefined;
    }
    
    self.spawnedTrampoline = spawn("script_model", self.origin);
    self.spawnedTrampoline setModel("com_plasticcase_enemy");
    self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
}

monitortrampoline(model)
{
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        if (!isDefined(model))
            break;
        if (distance(self.origin, model.origin) < 85)
            self setVelocity(self getVelocity() + (0, 0, 200));

        wait 0.01;
    }
}


slide()
{
    if (isDefined(self.slideThread))
    {
        threadStop(self.slideThread);
        self.slideThread = undefined;
    }
    if (isDefined(self.spawnedSlide))
    {
        self.spawnedSlide delete();
        self.spawnedSlide = undefined;
    }
    self.spawnedSlide = spawn("script_model", bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,0,self)["position"] + (0, 0, 20));

    self.spawnedSlide.angles = (60, self getPlayerAngles()[1] - 180, 0);
    self.spawnedSlide setModel("com_plasticcase_enemy");
    self.slideThread = self thread makeSlide(self.spawnedSlide);
}

threadstop()
{
    //blank function
}

makeSlide(slideEntity)
{
    level endon("game_ended");
    self endon("disconnect");
    self endon("stop_slide");

    for (;;)
    {
        if (!isDefined(slideEntity)) 
            break;

        for (i = 0; i < level.players.size; i++)
        {
            player = level.players[i];

            if (isDefined(slideEntity) && player isInPos(slideEntity.origin) && player meleeButtonPressed())
            {
                player setOrigin(player getOrigin() + (0, 0, 10));
                playngles2 = anglesToForward(player getPlayerAngles());
                x = 0;

                player setVelocity(player getVelocity() + (playngles2[0] * 750, playngles2[1] * 750, 0));

                while (x < 15)
                {
                    player setVelocity(player getVelocity() + (0, 0, 100));
                    x++;
                    wait 0.01;
                }

                wait 1;
            }
        }

        wait 0.01;
    }
}

isInPos(sP) 
{
    if (distance(self.origin, sP) < 100) 
        return true;
    else 
        return false;
}

Platform()
{
    if(!isDefined(self.spawnedcrate))
        self.spawnedcrate = [];
        
    location = self.origin;
    if(isDefined(self.spawnedcrate))
    {
        for(i = 0; i < 7; i++)
        {
            if(!isDefined(self.spawnedcrate[i]))
                continue;
                
            for(d = 0; d < 5; d++)
            {
                if(isDefined(self.spawnedcrate[i][d]))
                    self.spawnedcrate[i][d] delete();
            }
        }
    }
    startpos = location + (0, 0, -15);
    
    for(i = 0; i < 7; i++)
    { 
        if(!isDefined(self.spawnedcrate[i]))
            self.spawnedcrate[i] = [];
            
        for(d = 0; d < 5; d++)
            self.spawnedcrate[i][d] = spawnScriptModel(startpos + (d * 56, i * 30, 0),"com_plasticcase_enemy",(0,0,0),0,level.airDropCrateCollision);
    }
}

SpawnScriptModel(origin,model,angles,time,clip)
{
    if(isDefined(time))
        wait time;
    ent = spawn("script_model",origin);
    ent SetModel(model);
    if(isDefined(angles))
        ent.angles = angles;
    if(isDefined(clip))
        ent CloneBrushModelToScriptModel(clip);
    return ent;
}

Crate()
{
    if (isDefined(self.spawnedcrate))
    {
        self.spawnedcrate delete();
        self.spawnedcrate = undefined;
    }
    self.spawnedcrate = spawnscriptmodel(self.origin + (0, 0, -15), "com_plasticcase_enemy", (0,0,0), 0, level.airdropcratecollision);
}
doSpawnOption(selection)
{
    switch(selection)
    {
        case "bounce":
            if (isDefined(self.trampolineThread))
            {
                threadStop(self.trampolineThread);
                self.trampolineThread = undefined;
            }
            if (isDefined(self.spawnedTrampoline))
            {
                self.spawnedTrampoline delete();
                self.spawnedTrampoline = undefined;
            }
            self thread normalbounce();
            break;

        case "platform":
    if (isDefined(self.spawnedPlatform))
    {
        for(i = -3; i < 3; i++)
        {
            if(!isDefined(self.spawnedPlatform[i]))
                continue;

            for(d = -3; d < 3; d++)
            {
                if(isDefined(self.spawnedPlatform[i][d]))
                {
                    self.spawnedPlatform[i][d] delete();
                    self.spawnedPlatform[i][d] = undefined;
                }
            }
            self.spawnedPlatform[i] = undefined;
        }
        self.spawnedPlatform = undefined;
    }
    self thread Platform();
    break;


        case "crate":
            if (isDefined(self.spawnedCrate))
            {
                self.spawnedCrate delete();
                self.spawnedCrate = undefined;
            }
            self thread Crate();
            break;
    }
}