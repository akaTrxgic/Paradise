iPadBind(num)
{
    if(!isDefined(self.basediPad))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] for ^2iPad");

        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] for ^2iPad");

        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] for ^2iPad");

        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] for ^2iPad");
        

        self.basediPad = true;

        while(isDefined(self.basediPad))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    self giveweapon("killstreak_remote_turret_mp");
                    self switchtoweapon("killstreak_remote_turret_mp");
                }

                wait .01;
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    self giveweapon("killstreak_remote_turret_mp");
                    self switchtoweapon("killstreak_remote_turret_mp");
                }
                
                wait .01;
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    self giveweapon("killstreak_remote_turret_mp");
                    self switchtoweapon("killstreak_remote_turret_mp");
                }

                wait .01;
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    self giveweapon("killstreak_remote_turret_mp");
                    self switchtoweapon("killstreak_remote_turret_mp");
                }
                
                wait .01;
            }
        }
    }
    else if(isDefined(self.basediPad)) 
    { 
        self iPrintLn("iPad Bind [^1OFF^7]");
        self.basediPad = undefined; 
    }
}

sentryTurret(num)
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
                    self thread maps\mp\killstreaks\_turret_killstreak::useSentryTurret();
                    wait .1;
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_turret_killstreak::useSentryTurret();
                    wait .1;
                    self enableWeapons();
                }
                
                wait .1;
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_turret_killstreak::useSentryTurret();
                    wait .1;
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_turret_killstreak::useSentryTurret();
                    wait .1;
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

microwaveTurret(num)
{
    if(!isDefined(self.basedGuardian))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] for ^2Walking Guardian");

        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] for ^2Walking Guardian");

        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] for ^2Walking Guardian");

        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] for ^2Walking Guardian");
        

        self.basedGuardian = true;

        while(isDefined(self.basedGuardian))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_turret_killstreak::useMicrowaveTurret();
                    wait .1;
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_turret_killstreak::useMicrowaveTurret();
                    wait .1;
                    self enableWeapons();
                }
                
                wait .1;
            }
            else if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_turret_killstreak::useMicrowaveTurret();
                    wait .1;
                    self enableWeapons();
                }

                wait .1;
            }
            else if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                {
                    self thread maps\mp\killstreaks\_turret_killstreak::useMicrowaveTurret();
                    wait .1;
                    self enableWeapons();
                }
                
                wait .1;
            }
        }
    }
    else if(isDefined(self.basedGuardian)) 
    { 
        self iPrintLn("Walking Guardian Bind [^1OFF^7]");
        self.basedGuardian = undefined; 
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
                self thread maps\mp\gametypes\_class::giveloadout( self.team, "CLASS_CUSTOM" + classNum);

            wait .001; 
        }
    }
    else if(isDefined(self.ChangeClass)) 
    { 
        self iPrintLn("Change Class Bind [^1OFF^7]");
        self.ChangeClass = undefined; 
    }  
}