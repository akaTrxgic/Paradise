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
    if(level.slidesAllowed)
    {
        if (isDefined(self.slideThread))
        {
            self.slideThread delete();
            self.slideThread = undefined;
        }
        if (isDefined(self.spawnedSlide))
        {
            self.spawnedSlide delete();
            self.spawnedSlide = undefined;
        }

        slideOrigin = (bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,0,self)["position"] + (0, 0, 20));
        self.spawnedSlide = spawnscriptmodel(slideOrigin, "com_plasticcase_enemy", self.spawnedSlide.angles, (0,0,0), level.airdropcratecollision);
        self.spawnedSlide.angles = (60, self getPlayerAngles()[1] - 180, 0);
        //spawnscriptmodel(origin,model,angles,time,clip)
        self.slideThread = self thread makeSlide(self.spawnedSlide);
    }
    else
        self iprintln("^1ERROR^7: Slide Spawning is Disabled!");
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

doSpawnOption(selection)
{
    switch(selection)
    {
        case "bounce":
        if(level.bouncesAllowed)
        {
            if (isDefined(self.trampolineThread))
            {
                self.trampolineThread delete();
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
        else
            self iprintln("^1ERROR^7: Bounce Spawning is Disabled!");
        break;

        case "platform":
        if(level.platsAllowed)
        {
            if(!isDefined(self.spawnedplat))
            self.spawnedplat = [];
        
            location = self.origin;
    
            if(isDefined(self.spawnedplat))
            {
                for(i = -3; i < 3; i++)
                {
                    if(!isDefined(self.spawnedplat[i]))
                    continue;
                
                    for(d = -3; d < 3; d++)
                    {
                        if(isDefined(self.spawnedplat[i][d]))
                        self.spawnedplat[i][d] delete();
                    }
                }
            }
    
            startpos = location + (0, 0, -15);
    
            for(i = -3; i < 3; i++)
            {    
                if(!isDefined(self.spawnedplat[i]))
                self.spawnedplat[i] = [];
            
                for(d = -3; d < 3; d++)
                    self.spawnedplat[i][d] = spawnScriptModel(startpos + (d * 56, i * 30, 0),"com_plasticcase_enemy",(0,0,0),0,level.airDropCrateCollision);
            }
        }
        else
            self iprintln("^1ERROR^7: Platform Spawning is Disabled!");
        break;

        case "crate":
        if(level.cratesAllowed)
        {
            if (isDefined(self.spawnedcrate))
            {
                self.spawnedcrate delete();
                self.spawnedcrate = undefined;
            }
            self.spawnedcrate = spawnscriptmodel(self.origin + (0, 0, -15), "com_plasticcase_enemy", (0,0,0), 
                                                0, level.airdropcratecollision);
        }
        else
            self iprintln("^1ERROR^7: Platform Spawning is Disabled!");
        break;
    }
}