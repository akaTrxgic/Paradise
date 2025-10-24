initNoClip()
{
    if(self.NoClipT == 0)
    {
        self thread Noclip();
        self.NoClipT = 1;
    }
    else
    {
        self.NoClipT = 0;
        self notify("stop_noclip");
    }
}

Noclip()
{
    self endon("stop_noclip");
    if(!isDefined(self.noClipSpeed)) self.noClipSpeed = 50;

    for(;;)
    {
        if( self secondaryoffhandbuttonpressed() && self.specNadeActive == 0)
        {
            if(self.NoClipOBJ == 0)
            {
                self.originObj = spawn( "script_origin", self.origin, 1 );
                self.originObj.angles = self.angles;
                self playerlinkto( self.originObj, undefined );
                self.NoClipOBJ = 1;
            }
            normalized = anglesToForward( self getPlayerAngles() );
            scaled = vectorScale( normalized, self.noClipSpeed );
            originpos = self.origin + scaled;
            self.originObj.origin = originpos;
        }
        else
        {
            if(self.NoClipOBJ == 1)
            {
                self unlink();
                self enableweapons();
                self.originObj delete();
                self.NoClipOBJ = 0;
            }
            wait .05;
        }
        wait .05;
    }
}

getprimary()
{
    class = self.class;
    class_num      = int( class[class.size-1] )-1; 
    primaryweapon  = self getloadoutweapon( class_num, "primary" );
    return primaryweapon;
}

getsecondary()
{
    class = self.class;
    class_num      = int( class[class.size-1] )-1; 
    secondaryweapon = self getloadoutweapon( class_num, "secondary" );
    return secondaryweapon;
}

monitortrampoline(model)
{
    self endon( "disconnect" );
    level endon( "game_ended" );

    for(;;)
    {
        if (!isDefined(model))
            break;

        if(distance(self.origin, model.origin) < 85 )
            self setvelocity( self getvelocity() + ( 0, 0, 999 ) );

        wait 0.01;
    }
}

slide()
{
    if(level.slidesAllowed)
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
    self.spawnedSlide setModel("t6_wpn_supply_drop_ally");
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

            self.spawnedTrampoline = spawn("script_model", self.origin + (0,0,-15));
            self.spawnedTrampoline setModel("t6_wpn_supply_drop_ally");
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
                {
                    self.spawnedplat[i][d] = spawn("script_model", startpos + (d * 35, i * 70, 0));
                    self.spawnedplat[i][d] setModel("t6_wpn_supply_drop_ally");
                    self.spawnedplat[i][d].angles = (0, 0, 0);
                }
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
            cratePos = self.origin + (0, 0, -15); 
            self.spawnedcrate = spawn("script_model", cratePos);
            self.spawnedcrate setModel("t6_wpn_supply_drop_ally");
            self.spawnedcrate.angles = (0, 0, 0);
        }
        else
            self iprintln("^1ERROR^7: Crate Spawning is Disabled!");
        break;
    }
}