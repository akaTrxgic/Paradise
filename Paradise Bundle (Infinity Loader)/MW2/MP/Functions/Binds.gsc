sentryBind(num)
{
    if(!isDefined(self.basedSentry))
    {
            if(num == 1)
                self iPrintLn("Press [{+Actionslot 1}] for ^2Walking Sentry");

            else if(num == 2)
                self iPrintLn("Press [{+Actionslot 2}] for ^2Walking Sentry");

            else if(num == 3)
                self iPrintLn("Press [{+Actionslot 3}] for ^2Walking Sentry");

            else if(num == 4)
                self iPrintLn("Press [{+Actionslot 4}] for ^2Walking Sentry");
            

            self.basedSentry = true;

            while(isDefined(self.basedSentry))
            {
                if(num == 1)
                {
                    if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                        self enableWeapons();
                    }

                    wait .1;
                }
                else if(num == 2)
                {
                    if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                        self enableWeapons();
                    }
                    
                    wait .1;
                }
                else if(num == 3)
                {
                    if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                        self enableWeapons();
                    }

                    wait .1;
                }
                else if(num == 4)
                {
                    if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    {
                        self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
                        self enableWeapons();
                    }
                    
                    wait .1;
                }
            }
    }
    else if(isDefined(self.basedSentry)) 
    { 
        self iPrintLn("Walking Sentry Bind [^1OFF^7]");
        self.basedSentry = undefined; 
    }
}

predBind(num)
{
     if(!isDefined(self.laptop))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to Give ^2Laptop");

        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to Give ^2Laptop");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to Give ^2Laptop");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to Give ^2Laptop");
        
        self.laptop = true;

        while(isDefined(self.laptop))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");

                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");
        
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");
                
                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread giveselfweapon("killstreak_ac130_mp");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.laptop)) 
    { 
        self iPrintLn("Laptop bind [^1OFF^7]");
        self.laptop = undefined; 
    }
}
bombBind(num)
{
    if(!isDefined(self.bomb))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to Give ^2Bomb");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to Give ^2Bomb");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to Give ^2Bomb");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to Give ^2Bomb");
        
        self.bomb = true;

        while(isDefined(self.bomb))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");

                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread giveselfweapon("briefcase_bomb_defuse_mp");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.bomb)) 
    { 
        self iPrintLn("Bomb bind [^1OFF^7]");
        self.bomb = undefined; 
    }
}
trgrBind(num)
{
    if(!isDefined(self.trgr))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to Give ^2Trigger");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to Give ^2Trigger");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to Give ^2Trigger");
    
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to Give ^2Trigger");
        
        self.trgr = true;

        while(isDefined(self.trgr))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
        
                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
                
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
                
                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread giveselfweapon("c4_mp");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.trgr)) 
    { 
        self iPrintLn("Trigger bind [^1OFF^7]");
        self.trgr = undefined; 
    }
}
doTrigger()
{
    self giveselfweapon("c4_mp");
    wait .1;
}

Canzoom(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Canzoom))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Can Zoom");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Can Zoom");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Can Zoom");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Can Zoom");
        
        self.Canzoom = true;

        while(isDefined(self.Canzoom))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread CanzoomFunction();
                
                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread CanzoomFunction();
                
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread CanzoomFunction();
                
                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread CanzoomFunction();
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.Canzoom)) 
    { 
        self iPrintLn("Canzoom bind [^1OFF^7]");
        self.Canzoom = undefined; 
    }
}
CanzoomFunction()
{
    self.canswapWeap = self getCurrentWeapon();
    self takeWeapon(self.canswapWeap);
    self giveweapon(self.canswapWeap);
    wait 0.05;
    self setSpawnWeapon(self.canswapWeap);
}

nacModSave(num)
{
    if(num == 1)
    {
        self.wep1 = self getCurrentWeapon();
        self iPrintln("Weapon 1 Selected: ^2" + self.wep1);
    }
    else if(num == 2)
    {
        self.wep2 = self getCurrentWeapon();
        self iPrintln("Weapon 2 Selected: ^2" + self.wep2);
    }
}

nacModBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.NacBind))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Nac");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Nac");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Nac");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Nac");
        
        self.NacBind = true;
        
        while(isDefined(self.NacBind))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            wait 0.01; 
        } 
    } 
    else if(isDefined(self.NacBind)) 
    { 
        self iPrintLn("Nac Bind [^1OFF^7]");
        self.NacBind = undefined; 
        self.wep1    = undefined;
        self.wep2    = undefined;
        self iPrintLn("Nac Weapons ^1Reset");
    } 
}

heliosNac()
{
    if(self.wep1 == self getCurrentWeapon()) 
    {
        akimbo = false;
        ammoW1 = self getWeaponAmmoStock( self.wep1 );
        ammoCW1 = self getWeaponAmmoClip( self.wep1 );
        self takeWeapon(self.wep1);
        self switchToWeapon(self.wep2);
        while(!(self getCurrentWeapon() == self.wep2))
        
        if (self isHost())
            wait .1;

        else
            wait .15;

        self giveWeapon(self.wep1);
        self setweaponammoclip( self.wep1, ammoCW1 );
        self setweaponammostock( self.wep1, ammoW1 );
    }
    else if(self.wep2 == self getCurrentWeapon()) 
    {
        ammoW2 = self getWeaponAmmoStock( self.wep2 );
        ammoCW2 = self getWeaponAmmoClip( self.wep2 );
        self takeWeapon(self.wep2);
        self switchToWeapon(self.wep1);
        while(!(self getCurrentWeapon() == self.wep1))
        
        if (self isHost())
            wait .1;

        else
            wait .15;

        self giveWeapon(self.wep2);
        self setweaponammoclip( self.wep2, ammoCW2 );
        self setweaponammostock( self.wep2, ammoW2 );
    } 
}
skreeModSave(num)
{
    if(num == 1)
    {
        self.snacwep1 = self getCurrentWeapon();
        self iPrintln("Weapon 1 Selected: ^2" + self.snacwep1);
    }
    else if(num == 2)
    {
        self.snacwep2 = self getCurrentWeapon();
        self iPrintln("Weapon 2 Selected: ^2" + self.snacwep2);
    }
}

skreeBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.SnacBind))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Skree");
    
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Skree");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Skree");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Skree");
        
        self.SnacBind = true;
        
        while(isDefined(self.SnacBind))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                {
                    if(self getCurrentWeapon() == self.snacwep1)
                    {
                        self SetSpawnWeapon( self.snacwep2 );
                        wait .12;
                        self SetSpawnWeapon( self.snacwep1 );
                    }
                    else if(self getCurrentWeapon() == self.snacwep2)
                    {
                        self SetSpawnWeapon( self.snacwep1 );
                        wait .12;
                        self SetSpawnWeapon( self.snacwep2 );
                    } 
                }
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                {
                    if(self getCurrentWeapon() == self.snacwep1)
                    {
                        self SetSpawnWeapon( self.snacwep2 );
                        wait .12;
                        self SetSpawnWeapon( self.snacwep1 );
                    }
                    else if(self getCurrentWeapon() == self.snacwep2)
                    {
                        self SetSpawnWeapon( self.snacwep1 );
                        wait .12;
                        self SetSpawnWeapon( self.snacwep2 );
                    } 
                }
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                {
                    if(self getCurrentWeapon() == self.snacwep1)
                    {
                        self SetSpawnWeapon( self.snacwep2 );
                        wait .12;
                        self SetSpawnWeapon( self.snacwep1 );
                    }
                    else if(self getCurrentWeapon() == self.snacwep2)
                    {
                        self SetSpawnWeapon( self.snacwep1 );
                        wait .12;
                        self SetSpawnWeapon( self.snacwep2 );
                    } 
                }
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                {
                    if(self getCurrentWeapon() == self.snacwep1)
                    {
                        self SetSpawnWeapon( self.snacwep2 );
                        wait .12;
                        self SetSpawnWeapon( self.snacwep1 );
                    }
                    else if(self getCurrentWeapon() == self.snacwep2)
                    {
                        self SetSpawnWeapon( self.snacwep1 );
                        wait .12;
                        self SetSpawnWeapon( self.snacwep2 );
                    } 
                }
            }
            wait 0.01; 
        } 
    } 
    else if(isDefined(self.SnacBind)) 
    { 
        self iPrintLn("Skree Bind [^1OFF^7]");
        self.SnacBind = undefined; 
        snacwep1      = undefined;
        snacwep2      = undefined;
        self iPrintLn("Skree Weapons ^1Reset");
    } 
}

gFlipBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.Gflip))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2GFlip");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2GFlip");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2GFlip");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2GFlip");
        
        self.Gflip = true;
        
        while(isDefined(self.Gflip))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                    self thread MidAirGflip();

                wait .001;
            }
            if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread MidAirGflip();
            
                wait .001;
            }
            if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
            if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.Gflip)) 
    { 
        self iPrintLn("GFlip bind [^1OFF^7]");
        self notify("stopProne1");
        self.Gflip = undefined; 
    } 
}
MidAirGflip()
{
    self endon("stopProne1");
    self setStance("prone");
    wait 0.01;
    self setStance("prone");
}
class1()
{
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom1" );
            
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class2()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom2" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class3()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom3" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }

}
class4()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom4" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
 
}
class5()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom5" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class6()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom6" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class7()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom7" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class8()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom8" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class9()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom9" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}
class10()
{
 if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 1") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom10" );
            
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Change Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }
}

nightVision(num)
{
    if(!isDefined(self.nightVision))
    {
            if(num == 1)
                self iPrintLn("Press [{+Actionslot 1}] for ^2Night Vision");

            else if(num == 2)
                self iPrintLn("Press [{+Actionslot 2}] for ^2Night Vision");

            else if(num == 3)
                self iPrintLn("Press [{+Actionslot 3}] for ^2Night Vision");

            else if(num == 4)
                self iPrintLn("Press [{+Actionslot 4}] for ^2Night Vision");
            

            self.nightVision = true;

            while(isDefined(self.nightVision))
            {
                if(num == 1)
                {
                    if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                        self _SetActionSlot(num, "nightvision");

                    wait .1;
                }
                else if(num == 2)
                {
                    if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                        self _SetActionSlot(num, "nightvision");
                    
                    wait .1;
                }
                else if(num == 3)
                {
                    if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                        self _SetActionSlot(num, "nightvision");

                    wait .1;
                }
                else if(num == 4)
                {
                    if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                        self _SetActionSlot(num, "nightvision");
                    
                    wait .1;
                }
            }
    }
    else if(isDefined(self.nightVision)) 
    { 
        self iPrintLn("Night Vision Bind [^1OFF^7]");
        self _SetActionSlot(num, "");
        self.nightVision = undefined; 
    }
}

/*
nvSound(button)
{
    self endon("disconnect");
    self endon("stop_nvSound");

    self notifyonplayercommand("nvSound", button);

    for(;;)
    {
        self waittill("nvSound");
        self.nvPressCount++;

        if(self.nvPressCount % 2 == 1)
            self PlaySoundToPlayer( "item_nightvision_on", self);

        else if(self.nvPressCount % 2 == 0)
            self PlaySoundToPlayer( "item_nightvision_off", self);
    }
}
*/

hostMigration(num)
{
    if(!isDefined(self.hostMigrate))
    {
            if(num == 1)
                self iPrintLn("Press [{+Actionslot 1}] for ^2Host Migration");

            else if(num == 2)
                self iPrintLn("Press [{+Actionslot 2}] for ^2Host Migration");

            else if(num == 3)
                self iPrintLn("Press [{+Actionslot 3}] for ^2Host Migration");

            else if(num == 4)
                self iPrintLn("Press [{+Actionslot 4}] for ^2Host Migration");
            

            self.hostMigrate = true;

            while(isDefined(self.hostMigrate))
            {
                if(num == 1)
                {
                    if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                        self thread hostmigratelogic();

                    wait .1;
                }
                else if(num == 2)
                {
                    if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                        self thread hostmigratelogic();
                    
                    wait .1;
                }
                else if(num == 3)
                {
                    if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                        self thread hostmigratelogic();

                    wait .1;
                }
                else if(num == 4)
                {
                    if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                        self thread hostmigratelogic();
                    
                    wait .1;
                }
            }
    }
    else if(isDefined(self.hostMigrate)) 
    { 
        self iPrintLn("Host Migration Bind [^1OFF^7]");
        self notify("stopHostMigrate");
        self.hostMigrate = undefined; 
    }
}

hostmigrateLogic()
{
    self endon("disconnect");
    self endon("game_ended");
    self endon("stopHostMigrate");

    for (;;)
    {
        foreach(player in level.players)
        {
            setDvar("HostMigrationState", "0");
            player openPopupMenu(game["menu_hostmigration"]);
            player freezeControlsWrapper(true);
            wait .1;
            setDvar("HostMigrationState", "1");
            wait .1;
            player closePopupMenu();
            thread maps\mp\gametypes\_gamelogic::matchStartTimer("match_resuming_in", 5.0);
            wait 5.0;
            player freezeControlsWrapper(false);
            wait 1; 
        }
        wait 0.01;
    }
}