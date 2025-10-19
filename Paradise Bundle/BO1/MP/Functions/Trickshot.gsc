UFOMode()
{
    if(!isDefined( self.UFOMode ))
    {
        self.UFOMode = true;
        self thread UFODude();
    }
    else
    {
        self.UFOMode = undefined;
        self notify("stop_ufo");
    }
}

UFODude()
{
    self endon("stop_ufo");
    self endon("unverified");
    if(isdefined(self.N))
    self.N delete();
    self.N  = spawn("script_origin", self.origin);
    self.On = 0;
    for(;;)
    {
        if(self secondaryoffhandbuttonpressed())
        {
            self.On       = 1;
            self.N.origin = self.origin;
            self linkto(self.N);
        }
        else
        {
            self.On = 0;
            self unlink();
        }
        if(self.On == 1)
        {
            vec           = anglestoforward(self getPlayerAngles());
            end           = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
            self.N.origin = self.N.origin+end;
        }
        wait 0.05;
    }
}

getprimary()
{
    class = self.class;
    class_num = int( class[class.size-1] )-1;
    return self.custom_class[class_num]["primary"];
}
getsecondary()
{
    class = self.class;
    class_num = int( class[class.size-1] )-1;
    return self.custom_class[class_num]["secondary"];
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
            self setVelocity(self getVelocity() + (0, 0, 1500));

        wait 0.01;
    }
}

slide()
{
    if (isDefined(self.slideThread))
    {
        self.slidethread delete();
        self.slideThread = undefined;
    }
    if (isDefined(self.spawnedSlide))
    {
        self.spawnedSlide delete();
        self.spawnedSlide = undefined;
    }
    self.spawnedSlide = spawn("script_model",
        bullettrace(
            self gettagorigin("j_head"),
            self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 100,
            0,
            self
        )["position"] + (0, 0, 20)
    );

    self.spawnedSlide.angles = (0, self getPlayerAngles()[1] - 90, 60);
    self.spawnedSlide setModel("mp_supplydrop_ally");
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
        {
            break;
        }

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
                    player setVelocity(player getVelocity() + (0, 0, 750));
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
            self.spawnedTrampoline setModel("mp_supplydrop_ally");
            self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
        break;

        case "platform":
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
                {
                    self.spawnedplat[i][d] = spawn("script_model", startpos + (d * 25, i * 45, 0));
                    self.spawnedplat[i][d] setModel("mp_supplydrop_ally");
                    self.spawnedplat[i][d].angles = (0, 0, 0);
                }
            }
        break;

        case "crate":
            if (isDefined(self.spawnedcrate))
            {
                self.spawnedcrate delete();
                self.spawnedcrate = undefined;
            }
            cratePos = self.origin + (0, 0, -15); 
            self.spawnedcrate = spawn("script_model", cratePos);
            self.spawnedcrate setModel("mp_supplydrop_ally");
            self.spawnedcrate.angles = (0, 0, 0);
        break;
    }
}