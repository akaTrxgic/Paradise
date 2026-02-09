samTurretBind(num)
{
    if(!isDefined(self.basedSAM))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] for ^2Walking SAM");

        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] for ^2Walking SAM");

        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] for ^2Walking SAM");

        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] for ^2Walking SAM");
        

        self.basedSAM = true;

        while(isDefined(self.basedSAM))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useTowTurret(self);
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useTowTurret(self);
                    self enableWeapons();
                }
                
                wait .1;
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useTowTurret(self);
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useTowTurret(self);
                    self enableWeapons();
                }
                
                wait .1;
            }
        }
    }
    else if(isDefined(self.basedSAM)) 
    { 
        self iPrintLn("Walking SAM Bind [^1OFF^7]");
        self.basedSAM = undefined; 
    }
}

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
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                    self enableWeapons();
                }
                
                wait .1;
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useSentryTurret(self);
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\_turret_killstreak::useSentryTurret(self);
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

classBind(classNum)
{
    if(!isDefined(self.changeClass))
    {
        self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

        self.ChangeClass = true;

        while(isDefined(self.ChangeClass))
        {
            if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
            {
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM" + classNum);
                self thread playerSetup();
            }
            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change Class Bind [^1OFF^7]");
        self.ChangeClass = undefined; 
    }  
}
