NoClip()
{
    if (!self.ufo)
    {
        self thread onUfo();
        self.ufo = 1;
    }
    else
    {
        self notify("stop_ufo");
        self.ufo = 0;
    }
}

onUfo()
{
    self endon("stop_ufo");
    
    if (isdefined(self.N))
    self.N delete();
    
    self.N = spawn("script_origin", self.origin);
    self.On = 0;
    
    for (;;)
    {
        if (self SecondaryOffHandButtonPressed())
        {
            self.On = 1;
            self.N.origin = self.origin;
            self linkto(self.N);
        }
        else
        {
            self.On = 0;
            self unlink();
        }
        
        if (self.On)
        {
            vec = anglestoforward(self getPlayerAngles());
            end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
            self.N.origin = self.N.origin + end;
        }
        
        wait 0.05;
    }
}

getprimary()
{
    class = self.class;
    class_num      = int( class[class.size-1] )-1; 
    primaryweapon  = self.custom_class[class_num]["primary"];
    return primaryweapon;
}

getsecondary()
{
    class = self.class;
    class_num      = int( class[class.size-1] )-1; 
    secondaryweapon = self.custom_class[class_num]["secondary"];
    return secondaryweapon;
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

    if(getDvar("mapname") == "mp_seelow")
        model = "dest_seelow_crate_long";
    else
        model = "static_peleliu_crate01";

    bouncePos = self.origin + (0,0,-30);

    self.spawnedTrampoline = spawn("script_model", bouncePos);
    self.spawnedTrampoline.angles = (0, 0, 90);
    self.spawnedTrampoline setModel(model);
    self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
}

monitortrampoline(model)
{
    self endon("disconnect");
    level endon("game_ended");

    cooldown = false;

    for (;;)
    {
        if (!isDefined(model))
            break;

        playerPos = self.origin;
        modelPos = model.origin;

        deltaX = playerPos[0] - modelPos[0];
        deltaY = playerPos[1] - modelPos[1];
        horizontalDist = sqrt(deltaX * deltaX + deltaY * deltaY);

        verticalDist = abs(playerPos[2] - modelPos[2]);
        
        if (!cooldown && horizontalDist < 85 && verticalDist < 50)
        {
            cooldown = true;

            startOrigin = self.origin;
            duration = 0.7;    
            steps = 20;        
            stepTime = duration / steps;

            for (i = 0; i <= steps; i++)
            {
                fraction = i / steps;
                newOrigin = startOrigin + (0, 0, 500 * fraction);
                self setOrigin(newOrigin);
                wait stepTime;
            }

            wait 1; 

            cooldown = false;
        }

        wait 0.01;
    }
}
threadstop()
{
    //blank function
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

    if(getDvar("mapname") == "mp_seelow")
        model = "dest_seelow_crate_long";
    else
        model = "static_peleliu_crate01";

    slidePos = bullettrace(
        self gettagorigin("j_head"), 
        self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 10000, 
        0, 
        self
        )["position"] + (0, 0, 50);

    self.spawnedSlide = spawn("script_model", slidePos);
    playngles = self getPlayerAngles();
    self.spawnedSlide.angles = (130, playngles[1] + 0, 0);
    self.spawnedSlide setModel(model);
    self.slideThread = self thread makeSlide(self.spawnedSlide);
}

isInPos(sP) 
{
    if (distance(self.origin, sP) < 100)
        return true;
    else
        return false;
}

makeSlide(model, slidePos)
{
    level endon("game_ended");
    self endon("disconnect");
    self endon("stop_slide");

    for (;;)
    {
        foreach(player in level.players)
        {
            if (!isDefined(model))
            break;

            playerPos = player.origin;
            modelPos = model.origin;

            deltaX = playerPos[0] - modelPos[0];
            deltaY = playerPos[1] - modelPos[1];
            horizontalDist = sqrt(deltaX * deltaX + deltaY * deltaY);

            verticalDist = abs(playerPos[2] - modelPos[2]);
        
            if (horizontalDist < 85 && verticalDist < 50 && player meleeButtonPressed())
            {
               
                startOrigin = player.origin;
                targetOrigin = startOrigin + (0, 0, 0);
                
                duration = 1.0; 
                steps = 20; 
                stepTime = duration / steps; 

                
                for (i = 0; i <= steps; i++)
                {
                    
                    fraction = i / steps;
                    newOrigin = startOrigin + (0, 0, 500 * fraction);
                    player setOrigin(newOrigin);
                    wait stepTime;
                }

                wait 1; 
            }
        }
        wait 0.05; 
    }
}

crate()
{
    if (isDefined(self.spawnedcrate))
    {
        self.spawnedcrate delete();
        self.spawnedcrate = undefined;
    }
    if(isDefined(self.spawnedCrateThread))
    {
        self.spawnedCrateThread delete();
        self.spawnedCrateThread = undefined;
    }

    if(getDvar("mapname") == "mp_seelow")
        model = "dest_seelow_crate_long";
    else
        model = "static_peleliu_crate01";

    cratePos = self.origin + (0, 0, -30); 
    self.spawnedcrate = spawn("script_model", cratePos);
    self.spawnedcrate setModel(model);
    self.spawnedcrate.angles = (0, 0, 0);
    self.spawnedCrateThread = spawncollision("collision_geo_32x32x32","collider",cratePos, (0,0,0));
    self setorigin(cratePos + (0, 0, 15));
}

platform()
{
    if(!isDefined(self.spawnedPlatform))
        self.spawnedPlatform = [];
        
    if(isDefined(self.spawnedPlatform))
    {
        for(i = 0; i < 8; i++)
        {
            if(!isDefined(self.spawnedPlatform[i]))
                continue;
                
            for(d = 0; d < 8; d++)
            {
                if(isDefined(self.spawnedPlatform[i][d]))
                    self.spawnedPlatform[i][d] delete();
            }
        }
    }
    if(isDefined(self.platformThread))
    {
        self.platformThread delete();
        self.platformThread = undefined;
    }

    startpos = self.origin + (0, 0, -35);
    barrierpos = self.origin + (0, 0, -60);

    if(getDvar("mapname") == "mp_seelow")
        model = "dest_seelow_crate_long";
    else
        model = "static_peleliu_crate01";
    
    for(i = 0; i < 8; i++)
    { 
        if(!isDefined(self.spawnedPlatform[i]))
            self.spawnedPlatform[i] = [];
            
        for(d = 0; d < 8; d++)
        {
            self.spawnedPlatform[i][d] = spawn("script_model", startpos + (d * 61, i * 30, 0));
            self.spawnedPlatform[i][d] setModel(model);
            self.spawnedPlatform[i][d].angles = (0, 0, 0);
            self.platformThread = spawncollision("collision_wall_128x128x10","collider",barrierpos + (d * 61, i * 30, 0),(0,0,0));
        }
    }
    self setorigin(startpos + (0, 0, 60));
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
        for(i = 0; i < 8; i++)
        {
            if(!isDefined(self.spawnedPlatform[i]))
                continue;

            for(d = 0; d < 8; d++)
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
    if (isDefined(self.platformThread))
    {
        threadStop(self.platformThread);
        self.platformThread = undefined;
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
