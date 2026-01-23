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
            if(self isbuttonpressed("+actionslot 2"))
            {
                self maps\mp\gametypes\_class::setclass("custom" + classNum);
			    self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],"custom" + classNum);
    		    self maps\mp\gametypes\_class::applyloadout();
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