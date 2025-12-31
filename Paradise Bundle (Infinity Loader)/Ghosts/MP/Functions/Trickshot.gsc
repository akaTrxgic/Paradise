initNoClip()
{    
    if(!level.oomUtilDisabled)
    {
        if(!self.NoClipT)
        {
            self thread doNoClip();
            self.NoClipT = 1;
        }
        else
        {
            self notify("EndNoClip");
            self.NoClipT = 0;
        }
    }
    else
        self iprintln("^1ERROR^7: UFO use is [^1Disabled^7]!");
}

doNoClip()
{
    self endon("EndNoClip");
        self.Fly = 0;
        UFO = spawn("script_model", self.origin);
        for (;;) 
        {
            if (self FragButtonPressed()) 
            {
                self playerLinkTo(UFO);
                self.Fly = 1;
            } else {
                self unlink();
                self.Fly = 0;
            }
            if (self.Fly == 1) {
                Fly = self.origin + vectorScale(anglesToForward(self getPlayerAngles()), 20);
                UFO moveTo(Fly, .01);
            }
            wait .001;
        }
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
            self.slideThread delete();
            self.slideThread = undefined;
        }
        if (isDefined(self.spawnedSlide))
        {
            self.spawnedSlide delete();
            self.spawnedSlide = undefined;
        }

        slideOrigin = (bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,0,self)["position"] + (0, 0, 20));
        self.spawnedSlide = spawnscriptmodel(slideOrigin, "carepackage_friendly_iw6", self.spawnedSlide.angles, (0,0,0), level.airdropcratecollision);
        self.spawnedSlide.angles = (60, self getPlayerAngles()[1] - 180, 0);
        self.slideThread = self thread makeSlide(self.spawnedSlide);
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

            if (isDefined(slideEntity) && player isInPos(slideEntity.origin) && player meleeButtonPressed() && !self.menu["isOpen"])
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
            self.spawnedTrampoline setModel("carepackage_friendly_iw6");
            self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
        break;

        case "platform":
        if(!level.oomUtilDisabled)
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
                    self.spawnedplat[i][d] = spawnScriptModel(startpos + (d * 56, i * 30, 0),"carepackage_friendly_iw6",(0,0,0),0,level.airDropCrateCollision);
            }
        }
        else
            self iprintln("^1ERROR^7: Platform Spawning is [^1Disabled^7]!");
        break;

        case "crate":
        if(!level.oomUtilDisabled)
        {
            if (isDefined(self.spawnedcrate))
            {
                self.spawnedcrate delete();
                self.spawnedcrate = undefined;
            }
            self.spawnedcrate = spawnscriptmodel(self.origin + (0, 0, -15), "carepackage_friendly_iw6", (0,0,0), 
                                                0, level.airdropcratecollision);
        }
        else
            self iprintln("^1ERROR^7: Crate Spawning is[^1Disabled^7]!");
        break;
    }
}
