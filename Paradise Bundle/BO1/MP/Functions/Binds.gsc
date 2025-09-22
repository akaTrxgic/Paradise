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
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self thread CanzoomFunction();
    
                wait .001;
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self thread CanzoomFunction();
            
                wait .001;
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                      self thread CanzoomFunction();

                wait .001;
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
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
                if(self ActionSlotOneButtonPressed() && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 2)
            {
                if(self ActionSlotTwoButtonPressed() && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 3)
            {
                if(self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
                {
                    if (self GetStance() != "prone"  && !self meleebuttonpressed())
                        heliosNac();   
                }
            }
            else if(num == 4)
            {
                if(self ActionSlotFourButtonPressed() && !self.menu["isOpen"])
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
                if(self ActionSlotOneButtonPressed() && !self.menu["isOpen"])
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
                if(self ActionSlotTwoButtonPressed() && !self.menu["isOpen"])
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
                if(self ActionSlotThreeButtonPressed() && !self.menu["isOpen"])
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
                if(self ActionSlotFourButtonPressed() && !self.menu["isOpen"])
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

cowboyBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.CowboyBind))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Cowboy");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Cowboy");
        
        else if(num == 3)    
            self iPrintLn("Press [{+Actionslot 3}] to ^2Cowboy");
        
        else if(num == 4)    
            self iPrintLn("Press [{+Actionslot 4}] to ^2Cowboy");
        
        self.CowboyBind = true;

        while(isDefined(self.CowboyBind))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingCowboy)
                    {
                        self.DoingCowboy = true;
                        self setClientDvar("cg_gun_z", "8");
                    }
                    else
                    {
                        self.DoingCowboy = false;
                        self setClientDvar("cg_gun_z", "0");
                    }
                }
                wait .001; 
            } 
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingCowboy)
                    {
                        self.DoingCowboy = true;
                        self setClientDvar("cg_gun_z", "8");
                    }
                    else
                    {
                        self.DoingCowboy = false;
                        self setClientDvar("cg_gun_z", "0");
                    }
                }
                wait .001; 
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingCowboy)
                    {
                        self.DoingCowboy = true;
                        self setClientDvar("cg_gun_z", "8");
                    }
                    else
                    {
                        self.DoingCowboy = false;
                        self setClientDvar("cg_gun_z", "0");
                    }
                }
                wait .001; 
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingCowboy)
                    {
                        self.DoingCowboy = true;
                        self setClientDvar("cg_gun_z", "8");
                    }
                    else
                    {
                        self.DoingCowboy = false;
                        self setClientDvar("cg_gun_z", "0");
                    }
                }
                wait .001; 
            }
        }
    } 
    else if(isDefined(self.CowboyBind)) 
    { 
        self iPrintLn("Cowboy bind [^1OFF^7]");
        self.CowboyBind = undefined; 
    } 
}
rvrsCowboyBind(num)
{
    self endon("game_ended");
    self endon( "disconnect" );
    
    if(!isDefined(self.rcowboy))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Reverse Cowboy");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Reverse Cowboy");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Reverse Cowboy");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Reverse Cowboy");
        
        self.rcowboy = true;

        while(isDefined(self.rcowboy))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingrCowboy)
                    {
                        self.Doingrcowboy = true;
                        self setClientDvar("cg_gun_z", "-5");
                    }
                    else
                    {
                        self.Doingrcowboy = false;
                        self setClientDvar("cg_gun_z", "0");
                    }
                }
                wait .001; 
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingrCowboy)
                    {
                        self.Doingrcowboy = true;
                        self setClientDvar("cg_gun_z", "-5");
                    }
                    else
                    {
                        self.Doingrcowboy = false;
                        self setClientDvar("cg_gun_z", "0");
                    }
                }
                wait .001; 
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingrCowboy)
                    {
                        self.Doingrcowboy = true;
                        self setClientDvar("cg_gun_z", "-5");
                    }
                    else
                    {
                        self.Doingrcowboy = false;
                        self setClientDvar("cg_gun_z", "0");
                    }
                }
                wait .001; 
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    if(!self.DoingrCowboy)
                    {
                        self.Doingrcowboy = true;
                        self setClientDvar("cg_gun_z", "-5");
                    }
                    else
                    {
                        self.Doingrcowboy = false;
                        self setClientDvar("cg_gun_z", "0");
                    }
                }
                wait .001; 
            }
        } 
    } 
    else if(isDefined(self.rcowboy)) 
    { 
        self iprintln("Reverse Cowboy [^1OFF^7]");
        self.rcowboy = undefined; 
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
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self thread MidAirGflip();
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
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
        self iPrintLn("Press [{+Actionslot 1}] to ^2Change Class");
        self.ChangeClass = true;
        while(isDefined(self.ChangeClass))
        {
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM1");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM2");
                self thread playerSetup();
            }
            wait .001;
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM3");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM4");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM5");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM6");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM7");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM8");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM9");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
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
            if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM10");
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
        { 
            self iPrintLn("Class Bind [^1OFF^7]");
            self.ChangeClass = undefined; 
        }     
}