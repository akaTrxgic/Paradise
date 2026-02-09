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

classBind(classNum)
{
    if(!isDefined(self.ChangeClass))
    {
        self iPrintLn("Press [{+Actionslot 2}] to ^2Change Class");

        self.ChangeClass = true;

        while(isDefined(self.ChangeClass))
        {
            if(self isButtonPressed("+Actionslot 2") && !self.menu["isOpen"])
            {

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
