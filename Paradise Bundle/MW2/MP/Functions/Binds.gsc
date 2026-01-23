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