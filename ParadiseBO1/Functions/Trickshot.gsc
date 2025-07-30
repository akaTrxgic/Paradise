Test()
{
    self iprintln ("^1test");
}
Say1(OpenTheMenu)
{
    self SayAll("Open The Menu");
}
UFOMode()
{
    if(!isDefined( self.UFOMode ))
    {
        self.UFOMode = true;
        self IPrintLn("UFO Mode: [^2ON^7]");
        wait .1;
        self IPrintLn("Press [{+frag}] to fly!");
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
        if(self fragbuttonpressed() && self.MenuOpen == false)
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
InfCanswap()
{
    if(self.InfiniteCan == 0)
    {
      self.InfiniteCan = 1;
      self iprintln("Infinite Canswap [^2ON^7]");
      self thread doInfCan();
    }
    else
    {
      self.InfiniteCan = 0;
      self iprintln("Infinite Canswap [^1OFF^7]");
      self notify("stop_infCanswap");
    }
}
doInfCan()
{
    self endon("disconnect");
    self endon("stop_infCanswap");
    for(;;)
    {
        self waittill( "weapon_change", currentWeapon );
        currentWeapon = self getCurrentWeapon();
        self.WeapClip    = self getWeaponAmmoClip(currentWeapon);
        self.WeapStock     = self getWeaponAmmoStock(currentWeapon);
        self takeWeapon(currentWeapon);
        waittillframeend;
        self giveweapon(currentWeapon);
        self setweaponammostock(currentWeapon, self.WeapStock);
        self setweaponammoclip(currentWeapon, self.WeapClip);
    }
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

normalbounce()
{
    trampoline = spawn( "script_model", self.origin );
    trampoline setmodel("mp_supplydrop_ally");
    self thread monitortrampoline( trampoline );
    self iprintln("Bounce ^2Spawned");
}
monitortrampoline(model)
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    for(;;)
    {
        if(distance(self.origin, model.origin ) < 85 )
        {
            self setvelocity( self getvelocity() + ( 0, 0, 2000 ) );
        }
        wait 0.01;
    }
}

slide() 
{
    self thread makeSlide(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"] + (0, 0, 20), self getPlayerAngles());
    self iprintln("Slide ^2Spawned");
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
    level.CP setModel("mp_supplydrop_ally");

    for (;;) {
        for (p = 0; p < level.players.size; p++) {
            player = level.players[p];
            if (player isInPos(slidePos) && player meleeButtonPressed()) {
                player setOrigin(player getOrigin() + (0, 0, 10));
                playngles2 = anglesToForward(player getPlayerAngles());
                x = 0;
                player setVelocity(player getVelocity() + (playngles2[0] * 1000, playngles2[1] * 1000, 0));
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
            self.spawnedcrate[i][d] setModel("mp_supplydrop_ally");
            self.spawnedcrate[i][d].angles = (0, 0, 0);
        }
    }
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


