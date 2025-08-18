Test()
{
    self iprintln ("^1test");
}
Say1(OpenTheMenu)
{
    self SayAll("Open The Menu");
}
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
        if( self secondaryoffhandbuttonpressed())
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
SetCanswapMode()
{
    value = self.sliders[self getCurrentMenu() + "_" + self getCursor()]; 

    if(value == 0) // Current Weapon
    {
        // If already active with same weapon, toggle off
        if(self.currCan == 1 && self.currCanWpn == self getCurrentWeapon())
        {
            self.currCan = 0;
            self iprintln("Canswap Mode: ^7OFF");
            return;
        }

        // Otherwise, enable Current Canswap
        self.currCan     = 1;
        self.InfiniteCan = 0;          // turn off infinite
        self.currCanWpn  = self getCurrentWeapon();
        self iprintln("Canswap Weapon: (" + self.currCanWpn + ")");
        thread CurrCanswapLoop();
    }
    else if(value == 1) // Infinite Canswap
    {
        // If already active, toggle off
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

cac_getWeapon( classIndex, weaponIndex )
{
	return self getPlayerData( "customClasses", classIndex, "weaponSetups", weaponIndex, "weapon" );
}

getprimary()
{
    class = self.class;
    class_num      = int( class[class.size-1] )-1; 
    primaryweapon  = self cac_getweapon( class_num, "primary" );
    return primaryweapon;
}

getsecondary()
{
    class = self.class;
    class_num      = int( class[class.size-1] )-1; 
    secondaryweapon = self cac_getweapon( class_num, "secondary" );
    return secondaryweapon;
}

ToggleRPGRide()
{
    if(self.RPGRide == 0)
    {
        self.RPGRide = 1;

        while(self.RPGRide == 1)
        {
            self waittill("missile_fire", weapon, weapname);
            if (weapname == "usrpg_mp" || weapname == "smaw_mp")
            {
                self linkto(weapon);
            }
            wait .05;
        }
    }
    else if(self.RPGRide == 1)
    {
        self.RPGRide = 0;
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

SlidesNormal() 
{
    
    forward = anglestoforward(self getPlayerAngles());
    spawnPos = self.origin + (forward[0] * 100, forward[1] * 100, 20); 
    
    slide = spawn("script_model", spawnPos);
    slide setModel("com_plasticcase_enemy");
    slide makeUsable();
    slide setContents(1);
    angles = self getPlayerAngles();
    slide.angles = (0, angles[1] - 90, 60);
    slide clonebrushmodeltoScriptmodel(level.airDropCrateCollision);
    
    level thread MonitorSlides(slide);
}

MonitorSlides(model)
{
    level endon("game_ended");
    
    while(1)
    {
        wait 0.05;
        
        foreach(player in level.players)
        {
            if(!isDefined(player) || !isAlive(player))
                continue;
                
            forward = anglestoforward(player getPlayerAngles());
            velocity = (forward[0] * 300, forward[1] * 300, 999);
            
           
            if(distance(player.origin, model.origin) < 55 && !isDefined(player.allowedToSlide) && player meleeButtonPressed())
            {
                player.allowedToSlide = 1;
                
               
                for(i = 0; i < 15; i++)
                {
                    if(!isDefined(player))
                        break;
                        
                    player setVelocity(velocity);
                    wait 0.05;
                }
                
             
                if(isDefined(player))
                    player.allowedToSlide = undefined;
                    
               
                while(isDefined(player) && distance(player.origin, model.origin) < 55)
                {
                    wait 0.1;
                }
            }
        }
    }
}


BouncePad() 
{
    if(isDefined(self.spawnedcrate))
        self.spawnedcrate delete();
        
    location = self.origin;
    
   
    startpos = location + (0, 0, -15);
    self.spawnedcrate = spawn("script_model", startpos);
    self.spawnedcrate setModel("com_plasticcase_enemy");
    self.spawnedcrate makeUsable();
    self.spawnedcrate setContents(1);
    self.spawnedcrate.angles = (0, 0, 0);
    self.spawnedcrate clonebrushmodeltoScriptmodel(level.airDropCrateCollision);
    
 
    self thread MonitorBouncePad();
}

MonitorBouncePad()
{
    self endon("death");
    self endon("disconnect");
    
    if(!isDefined(self.spawnedcrate))
        return;
        
    while(1)
    {
        wait 0.05;
        if(!isDefined(self.spawnedcrate))
            break;
            
        playerPos = self.origin;
        padPos = self.spawnedcrate.origin;
        
        
        if(playerPos[2] > padPos[2] && playerPos[2] < (padPos[2] + 100))
        {
            distanceX = abs(playerPos[0] - padPos[0]);
            distanceY = abs(playerPos[1] - padPos[1]);
            
           
            if(distanceX < 30 && distanceY < 30)
            {
                
                self setVelocity(self getVelocity() + (0, 0, 800));
                wait 0.5; 
            }
        }
    }
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
            self.spawnedcrate[i][d] setModel("com_plasticcase_enemy");
            self.spawnedcrate[i][d].angles = (0, 0, 0);
        }
    }
}



