UFOMode()
{
    if(!isDefined( self.UFOMode ))
    {
        self.UFOMode = true;
        self IPrintLn("UFO Mode: [^2ON^7]");
        wait .1;
        self IPrintLn("Press [{+smoke}] to fly!");
        self thread UFODude();
    }
    else
    {
        self.UFOMode = undefined;
        self IPrintLn("UFO Mode: [^1OFF^7]");
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
        if(self secondaryoffhandbuttonpressed() && self.MenuOpen == false)
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

ToggleRPGRide()
{
    if(!isDefined( self.RPGRide ))
    {
        self.RPGRide = true;
        self thread RPGRide();
        self iprintln("Rocket Ride [^2ON^7]");
    }
    else
    {
        self.RPGRide = undefined;
        self notify("stop_rpgride");
        self iprintln("Rocket Ride [^1OFF^7]");
    }
}

RPGRide()
{
    self endon("disconnect");
    self endon("death");
    self endon("stop_rpgride");

    
    for (;;)
    {
        self waittill("missile_fire", weapon, weapname);
        if (weapname == "rpg_mp")
        {
            self linkto(weapon);
        }
        wait .05;
    }
}

instashoot()
{
    if( self.instashoot == 0 )
    {
        self.instashoot = 1;

        while(self.instashoot == 1)
        {
            self waittill("weapon_change");
            self disableWeapons();
            wait 0.01;
            self enableWeapons();
            wait 0.01;
        }
    }
    else if( self.instashoot == 1 )
    {
        self.instashoot = 0;
    }
}

SetCanswapMode()
{
    value = self.sliders[self getCurrentMenu() + "_" + self getCursor()]; 

    if(value == 0) 
    {

        if(self.currCan == 1 && self.currCanWpn == self getCurrentWeapon())
        {
            self.currCan = 0;
            self iprintln("Canswap Mode: ^7OFF");
            return;
        }

        self.currCan     = 1;
        self.InfiniteCan = 0;    
        self.currCanWpn  = self getCurrentWeapon();
        self iprintln("Canswap Weapon: (" + self.currCanWpn + ")");
        thread CurrCanswapLoop();
    }
    else if(value == 1) 
    {
        if(self.InfiniteCan == 1)
        {
            self.InfiniteCan = 0;
            self iprintln("Canswap Mode: ^7OFF");
            return;
        }
        self.InfiniteCan = 1;
        self.currCan     = 0;       
        self iprintln("Canswap Mode: ^2Infinite^7");
        thread InfiniteCanswapLoop();
    }
}

CurrCanswapLoop()
{
    while(self.currCan == 1)
    {
        self waittill("weapon_change", self.currCanWpn);
        self.WeapClip  = self getWeaponAmmoClip(self.currCanWpn);
        self.WeapStock = self getWeaponAmmoStock(self.currCanWpn);
        self takeWeapon(self.currCanWpn);
        waittillframeend;
        self giveWeapon(self.currCanWpn);
        self setWeaponAmmoStock(self.currCanWpn, self.WeapStock);
        self setWeaponAmmoClip(self.currCanWpn, self.WeapClip);
    }
}

InfiniteCanswapLoop()
{
    while(self.InfiniteCan == 1)
    {
        currentWeapon = self getCurrentWeapon();
        if(currentWeapon != "none")
        {
            self.WeapClip  = self getWeaponAmmoClip(currentWeapon);
            self.WeapStock = self getWeaponAmmoStock(currentWeapon);
            self takeWeapon(currentWeapon);
            waittillframeend;
            self giveWeapon(currentWeapon);
            self setWeaponAmmoStock(currentWeapon, self.WeapStock);
            self setWeaponAmmoClip(currentWeapon, self.WeapClip);
        }
        self waittill("weapon_change", currentWeapon);
    }
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
    self.spawnedTrampoline setModel("mp_supplydrop_ally");
    self.trampolineThread = self thread monitortrampoline(self.spawnedTrampoline);
}

monitortrampoline(model)
{
    self endon("disconnect");
    level endon("game_ended");

    for (;;)
    {
        if (!isDefined(model))
        {
            break;
        }
        if (distance(self.origin, model.origin) < 85)
        {
            self setVelocity(self getVelocity() + (0, 0, 1000));
        }

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

Platform()
{
    if(!isDefined(self.spawnedcrate))
        self.spawnedcrate = [];
        
    location = self.origin;
    if(isDefined(self.spawnedcrate))
    {
        for(i = -3; i < 3; i++)
        {
            if(!isDefined(self.spawnedcrate[i]))
                continue;
                
            for(d = -3; d < 3; d++)
            {
                if(isDefined(self.spawnedcrate[i][d]))
                    self.spawnedcrate[i][d] delete();
            }
        }
    }
    startpos = location + (0, 0, -15);
    
    for(i = -3; i < 3; i++)
    { 
        if(!isDefined(self.spawnedcrate[i]))
            self.spawnedcrate[i] = [];
            
        for(d = -3; d < 3; d++)
        {
            self.spawnedcrate[i][d] = spawn("script_model", startpos + (d * 25, i * 45, 0));
            self.spawnedcrate[i][d] setModel("mp_supplydrop_ally");
            self.spawnedcrate[i][d].angles = (0, 0, 0);
        }
    }
}
Crate()
{
    if (isDefined(self.spawnedcrate))
    {
        self.spawnedcrate delete();
        self.spawnedcrate = undefined;
    }
    cratePos = self.origin + (0, 0, -15); 
    self.spawnedcrate = spawn("script_model", cratePos);
    self.spawnedcrate setModel("mp_supplydrop_ally");
    self.spawnedcrate.angles = (0, 0, 0);
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