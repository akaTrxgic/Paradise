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
InfCanswap()
{
    if(self.InfiniteCan == 0)
    {
        self.InfiniteCan = 1;
        self iprintln("Infinite Canswap [^2ON^7]");
        
        while(self.infiniteCan == 1)
        {
            self waittill("weapon_change", currentWeapon);
            currentWeapon = self getCurrentWeapon();
            if(currentWeapon != "none") // Ensure valid weapon
            {
                self.WeapClip = self getWeaponAmmoClip(currentWeapon);
                self.WeapStock = self getWeaponAmmoStock(currentWeapon);
                self takeWeapon(currentWeapon);
                waittillframeend;
                self giveWeapon(currentWeapon);
                self setWeaponAmmoStock(currentWeapon, self.WeapStock);
                self setWeaponAmmoClip(currentWeapon, self.WeapClip);
            }
        }
    }
    else if(self.infiniteCan == 1)
    {
        self.InfiniteCan = 0;
    }
}

primCanswap()
{
    if(self.primCan == 0)
    {
      self.primCan = 1;
      self iprintln("Canswap Weapon: ^1" + self getprimary());

        while(self.primCan == 1)
        {
            self waittill("weapon_change", primCanWpn);
            primCanWpn     = self getprimary();
            self.WeapClip  = self getWeaponAmmoClip(primCanWpn);
            self.WeapStock = self getWeaponAmmoStock(primCanWpn);
            self takeWeapon(primCanWpn);
            waittillframeend;
            self giveweapon(primCanWpn);
            self setweaponammostock(primCanWpn, self.WeapStock);
            self setweaponammoclip(primCanWpn, self.WeapClip);   
        }
    }
    else if(self.primCan == 1)
    {
      self.primCan = 0;
    }
}

scndCanswap()
{
    if(self.scndCan == 0)
    {
      self.scndCan = 1;
      self iprintln("Canswap Weapon: ^1" + self getsecondary());
      
        while(self.scndCan == 1)
        {
            self waittill("weapon_change", scndCanWpn);
            scndCanWpn     = self getsecondary();
            self.WeapClip  = self getWeaponAmmoClip(scndCanWpn);
            self.WeapStock = self getWeaponAmmoStock(scndCanWpn);
            self takeWeapon(scndCanWpn);
            waittillframeend;
            self giveweapon(scndCanWpn);
            self setweaponammostock(scndCanWpn, self.WeapStock);
            self setweaponammoclip(scndCanWpn, self.WeapClip);
        }
    }
    else
    {
      self.scndCan = 0;
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

normalbounce()
{
    trampoline = spawn( "script_model", self.origin );
    trampoline setmodel("t6_wpn_supply_drop_ally");
    self thread monitortrampoline( trampoline );
}
monitortrampoline(model)
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    for(;;)
    {
        if(distance(self.origin, model.origin ) < 85 )
        {
            self setvelocity( self getvelocity() + ( 0, 0, 7000 ) );
        }
        wait 0.01;
    }
}

slide() 
{
    self thread makeSlide(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"] + (0, 0, 20), self getPlayerAngles());
}

isInPos(sP) 
{
    if (distance(self.origin, sP) < 100)
        return true;
    else
        return false;
}

makeSlide(slidePos, direction) 
{
    level endon("game_ended");
    self endon("disconnect");
    self endon("stop_slide");
    
    playngles = self getPlayerAngles();
    playnglesV = anglesToForward(playngles);
    
    level.CP = spawn("script_model", slidePos);
    level.CP.angles = (0, playngles[1] - 90, 60);
    level.CP setModel("t6_wpn_supply_drop_ally");

    for (;;) {
        for (p = 0; p < level.players.size; p++) {
            player = level.players[p];
            if (player isInPos(slidePos) && player meleeButtonPressed()) {
                player setOrigin(player getOrigin() + (0, 0, 10));
                playngles2 = anglesToForward(player getPlayerAngles());
                x = 0;
                player setVelocity(player getVelocity() + (playngles2[0] * 2000, playngles2[1] * 2000, 0));
                while (x < 15) {
                    player setVelocity(self getVelocity() + (0, 0, 2000));
                    x++;
                    wait 0.01;
                }
                wait 1;
            }
        }
        wait 0.01;
    }
}
Platform()
{
    if(!isDefined(self.spawnedcrate))
        self.spawnedcrate = [];
        
    location = self.origin;
    
    // Delete existing platform
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
    
    // Create new platform
    startpos = location + (0, 0, -15);
    
    for(i = -3; i < 3; i++)
    { 
        if(!isDefined(self.spawnedcrate[i]))
            self.spawnedcrate[i] = [];
            
        for(d = -3; d < 3; d++)
        {
            self.spawnedcrate[i][d] = spawn("script_model", startpos + (d * 25, i * 45, 0));
            self.spawnedcrate[i][d] setModel("t6_wpn_supply_drop_ally");
            self.spawnedcrate[i][d].angles = (0, 0, 0);
        }
    }
}
ipad()
{
    self giveWeapon("rcbomb_mp", 0, false); 
    self setWeaponAmmoClip("rcbomb_mp", 1);
    self setWeaponAmmoStock("rcbomb_mp", 0); 
    self switchToWeapon("rcbomb_mp");
}
CurrCanswap()
{
    if(self.currCan == 0)
    {
      self.currCan    = 1;
      self.currCanWpn = self getcurrentweapon();
      self iprintln("Canswap Weapon ^1" + self.currCanWpn);
      
      while(self.currCan == 1)
      {
        self waittill( "weapon_change", self.currCanWpn );
        self.WeapClip    = self getWeaponAmmoClip(self.currCanWpn);
        self.WeapStock     = self getWeaponAmmoStock(self.currCanWpn);
        self takeWeapon(self.currCanWpn);
        waittillframeend;
        self giveweapon(self.currCanWpn);
        self setweaponammostock(self.currCanWpn, self.WeapStock);
        self setweaponammoclip(self.currCanWpn, self.WeapClip);
      }
    }
    else if(self.currCan == 1)
    {
      self.currCan = 0;
    }
}


