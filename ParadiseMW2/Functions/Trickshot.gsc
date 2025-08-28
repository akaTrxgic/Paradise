
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

instashoot()
{
    if(!self.instashoot )
    {
        self.instashoot = 1;

        while(self.instashoot)
        {
            self waittill("weapon_change");
            self disableWeapons();
            wait 0.01;
            self enableWeapons();
            wait 0.01;
        }
    }
    else if(self.instashoot)
    {
        self.instashoot = 0;
    }
}

SetCanswapMode()
{
    value = self.sliders[self getCurrentMenu() + "_" + self getCursor()]; 

    if(value == 0) 
    {
        if(!self.currCan)
        {
            self.currCan = 1;
            self.InfiniteCan = 0;
            self.currCanWpn = self getcurrentweapon();
            self iprintln("Canswap Weapon: (^2" + self.currCanWpn + "^7)");
            self thread CurrCanswapLoop();
        }

        else if(self.currCan && self.currCanWpn == self getCurrentWeapon())
        {
            self.currCan = 0;
            self iprintln("Canswap Mode: [^1OFF^7]");
            return;
        }
    }
    else if(value == 1) 
    {
        if(!self.InfiniteCan)
        {
            self.InfiniteCan = 1;
            self.currCan     = 0;       
            self iprintln("Canswap Mode: ^2Infinite^7");
            self thread InfiniteCanswapLoop();
        }
        else if(self.InfiniteCan)
        {
            self.InfiniteCan = 0;
            self iprintln("Canswap Mode: [^1OFF^7]");
            return;
        }
    }
}

CurrCanswapLoop()
{
    while(self.currCan)
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
    while(self.InfiniteCan)
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
    {
        self.DolphinDive = undefined;
    } 
 
}
isSprinting()
{
  v = self GetVelocity();
        
  return v[0] >= 190 || v[1] >= 190 || v[0] <= -190 || v[1] <= -190;
}

SpawnPlatform()
{
    model = "com_plasticcase_enemy";
    
    crate = [];
    for(a=0;a<7;a++)
        for(b=0;b<11;b++)
            crate[crate.size] = SpawnScriptModel(self.origin+((a*56),(b*30),-50),model,(0,0,0),0,level.airDropCrateCollision);
    wait .05;
    self SetOrigin(crate[0].origin+(0,0,20));
}

SpawnSlide()
{
    AngF  = AnglesToForward(self GetPlayerAngles());
    slide = SpawnScriptModel(self.origin+(0,0,5)+AnglesToForward(self.angles)*25,"com_plasticcase_enemy",(-65,self.angles[1],0),undefined,level.airDropCrateCollision);
    self SetOrigin(self.origin+(0,0,20));
    slide thread MonitorSlide();
}

MonitorSlide()
{
    while(isDefined(self))
    {
        foreach(player in level.players)
            if(Distance(self.origin,player.origin) <= 50 && player MeleeButtonPressed())
            {
                AngF = AnglesToForward(player GetPlayerAngles());
                player SetVelocity((AngF[0]*725,AngF[1]*725,player GetVelocity()[2]+975));
            }
        wait .025;
    }
}

SpawnBounce()
{
    if(!isDefined(level.Bounces))level.Bounces = [];
    
    level.Bounces[level.Bounces.size] = SpawnScriptModel(self.origin,"com_plasticcase_enemy",(0,self.angles[1],0),undefined,level.airDropCrateCollision);
    self SetOrigin(self.origin+(0,0,20));

    level.Bounces[level.Bounces.size-1] thread MonitorBounce();
}

MonitorBounce()
{
    while(isDefined(self))
    {
        foreach(player in level.players)
            if(Distance(self.origin,player.origin) <= 50)
                player SetVelocity(player GetVelocity()+(0,0,800));
        wait .025;
    }
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
            if (isDefined(level.Bounces))
            {
                level.Bounces delete();
                level.Bounces = undefined;
            }
            self thread spawnBounce();
            break;

        case "platform":
    if (isDefined())
    {
        for(a=0;a<7;a++)
        {
            if(!isDefined(crate[a]))
                continue;

            for(b=0;b<11;b++)
            {
                if(isDefined(crate[a][b]))
                {
                    crate[a][b] delete();
                    crate[a][b] = undefined;
                }
            }
            crate[a] = undefined;
        }
        crate = undefined;
    }
    self thread SpawnPlatform();
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

threadstop()
{
    //blank function
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
    self.spawnedcrate setModel("com_plasticcase_enemy");
    self.spawnedcrate.angles = (0, 0, 0);
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
