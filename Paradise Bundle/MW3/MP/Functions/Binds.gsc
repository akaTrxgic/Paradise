remSentryBind(num)
{
    if(!isDefined(self.basedRemSentry))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] for ^2Walking Remote Sentry");

        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] for ^2Walking Remote Sentry");

        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] for ^2Walking Remote Sentry");

        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] for ^2Walking Remote Sentry");
        

        self.basedRemSentry = true;

        while(isDefined(self.basedRemSentry))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_remoteTurret::tryUseRemoteMGTurret(self);
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_remoteTurret::tryUseRemoteMGTurret(self);
                    self enableWeapons();
                }
                
                wait .1;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_remoteTurret::tryUseRemoteMGTurret(self);
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_remoteTurret::tryUseRemoteMGTurret(self);
                    self enableWeapons();
                }
                
                wait .1;
            }
        }
    }
    else if(isDefined(self.basedRemSentry)) 
    { 
        self iPrintLn("Walking Remote Sentry Bind [^1OFF^7]");
        self.basedRemSentry = undefined; 
    }
}

imsBind(num)
{
    if(!isDefined(self.basedIMS))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] for ^2Walking IMS");

        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] for ^2Walking IMS");

        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] for ^2Walking IMS");

        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] for ^2Walking IMS");
        

        self.basedIMS = true;

        while(isDefined(self.basedIMS))
        {
            if(num == 1)
            {
                if(self isbuttonpressed("+actionslot 1") && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_ims::tryUseIMS(self);
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_ims::tryUseIMS(self);
                    self enableWeapons();
                }
                
                wait .1;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_ims::tryUseIMS(self);
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_ims::tryUseIMS(self);
                    self enableWeapons();
                }
                
                wait .1;
            }
        }
    }
    else if(isDefined(self.basedIMS)) 
    { 
        self iPrintLn("Walking IMS Bind [^1OFF^7]");
        self.basedIMS = undefined; 
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
                    self thread giveuserweapon("killstreak_ac130_mp");

                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread giveuserweapon("killstreak_ac130_mp");
        
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread giveuserweapon("killstreak_ac130_mp");
                
                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread giveuserweapon("killstreak_ac130_mp");
                
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
                    self thread giveuserweapon("c4_mp");
        
                wait .001;
            }
            else if(num == 2)
            {
                if(self isbuttonpressed("+actionslot 2") && !self.menu["isOpen"])
                    self thread giveuserweapon("c4_mp");
                
                wait .001;
            }
            else if(num == 3)
            {
                if(self isbuttonpressed("+actionslot 3") && !self.menu["isOpen"])
                    self thread giveuserweapon("c4_mp");
                
                wait .001;
            }
            else if(num == 4)
            {
                if(self isbuttonpressed("+actionslot 4") && !self.menu["isOpen"])
                    self thread giveuserweapon("c4_mp");
                
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
    self giveuserweapon("c4_mp");
    wait .1;
}

classBind(classNum)
{
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

        self.ChangeClass = true;

        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+actionslot 2") && !self.menu["isOpen"])
                self notify( "menuresponse", "changeclass", "custom" + classNum);
            
            wait .001; 
        } 
    } 
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change Class Bind [^1OFF^7]");
        self.ChangeClass = undefined; 
    }
}