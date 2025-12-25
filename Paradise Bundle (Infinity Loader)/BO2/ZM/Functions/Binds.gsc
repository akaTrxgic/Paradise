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

crackKnuckleBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.cKnuck))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Crack Knuckles");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Crack Knuckles");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Crack Knuckles");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Crack Knuckles");
        
        self.cKnuck = true;

        while(isDefined(self.cKnuck))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self thread force_drink();
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self thread force_drink();
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self thread force_drink();
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    self thread force_drink();
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.cKnuck)) 
    { 
        self iPrintLn("Crack Knuckle bind [^1OFF^7]");
        self.cKnuck = undefined; 
    } 
}

force_drink()
{
	wait 0.01;
	lean = self AllowLean( false );
	ads = self AllowAds( false );
	sprint = self AllowSprint( false );
	crouch = self AllowCrouch( true );
	prone = self AllowProne( false );
	melee = self AllowMelee( false );
    
	self increment_is_drinking();
	orgweapon = self GetCurrentWeapon(); 
	self GiveWeapon( "zombie_builder_zm" );
	self SwitchToWeapon( "zombie_builder_zm" );

	self.build_time = self.useTime;
	self.build_start_time = getTime();

	wait 2;

	self maps\mp\zombies\_zm_weapons::switch_back_primary_weapon(orgweapon);

	self TakeWeapon( "zombie_builder_zm" );
	if (is_true(self.is_drinking))
		self decrement_is_drinking();
	self AllowLean( lean );
	self AllowAds( ads );
	self AllowSprint( sprint );
	self AllowProne( prone );		
	self AllowCrouch( crouch );		
	self AllowMelee( melee );
}

bowieInspectBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");

    if(!isDefined(self.bweInsp))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Bowie Inspect");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Bowie Inspect");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Bowie Inspect");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Bowie Inspect");
        
        self.bweInsp = true;

        while(isDefined(self.bweInsp))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_bowie_flourish");
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_bowie_flourish");
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_bowie_flourish");
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_bowie_flourish");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.bweInsp)) 
    { 
        self iPrintLn("Bowie Inspect bind [^1OFF^7]");
        self.bweInsp = undefined; 
    } 
}

syrInjectBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");

    if(!isDefined(self.syrInj))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Syringe Inject");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Syringe Inject");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Syringe Inject");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Syringe Inject");
        
        self.syrInj = true;

        while(isDefined(self.syrInj))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("syrette_zm");
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("syrette_zm");
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("syrette_zm");
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("syrette_zm");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.syrInj)) 
    { 
        self iPrintLn("Syringe Inject bind [^1OFF^7]");
        self.syrInj = undefined; 
    } 
}

chalkDrawBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");

    if(!isDefined(self.chkDraw))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Chalk Draw");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Chalk Draw");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Chalk Draw");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Chalk Draw");
        
        self.chkDraw = true;

        while(isDefined(self.chkDraw))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("chalk_draw_zm");
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("chalk_draw_zm");
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("chalk_draw_zm");
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("chalk_draw_zm");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.chkDraw)) 
    { 
        self iPrintLn("Chalk Draw bind [^1OFF^7]");
        self.chkDraw = undefined; 
    } 
}

retrInspBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");

    if(!isDefined(self.retrInsp))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Inspect Retriever");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Inspect Retriever");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Inspect Retriever");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Inspect Retriever");
        
        self.retrInsp = true;

        while(isDefined(self.retrInsp))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_tomahawk_flourish");
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_tomahawk_flourish");
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_tomahawk_flourish");
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_tomahawk_flourish");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.retrInsp)) 
    { 
        self iPrintLn("Retriever Inspect bind [^1OFF^7]");
        self.retrInsp = undefined; 
    } 
}

aftRevBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");

    if(!isDefined(self.aftRev))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Afterlife Revive");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Afterlife Revive");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Afterlife Revive");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Afterlife Revive");
        
        self.aftRev = true;

        while(isDefined(self.aftRev))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("syrette_afterlife_zm");
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("syrette_afterlife_zm");
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("syrette_afterlife_zm");
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("syrette_afterlife_zm");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.aftRev)) 
    { 
        self iPrintLn("Afterlife Revive bind [^1OFF^7]");
        self.aftRev = undefined; 
    } 
}

oipInspBind(num)
{
    self endon ("disconnect");
    self endon ("game_ended");

    if(!isDefined(self.oipInsp))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Inspect One Inch Punch");
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Inspect One Inch Punch");
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Inspect One Inch Punch");
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Inspect One Inch Punch");
        
        self.oipInsp = true;

        while(isDefined(self.oipInsp))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_one_inch_punch_flourish");
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_one_inch_punch_flourish");
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_one_inch_punch_flourish");
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_one_inch_punch_flourish");
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.oipInsp)) 
    { 
        self iPrintLn("One Inch Punch Inspect bind [^1OFF^7]");
        self.oipInsp = undefined; 
    } 
}

perkdrinkBind(num, perk)
{
    self endon ("disconnect");
    self endon ("game_ended");

    if(perk == "jugg")
        perkName = "Juggernog";
    else if(perk == "revive")
        perkName = "Quick Revive";
    else if(perk == "sleight")
        perkName = "Speed Cola";
    else if(perk == "doubletap")
        perkName = "Double Tap";
    else if(perk == "marathon")
        perkName = "Stamin-Up";
    else if(perk == "additionalprimaryweapon")
        perkName = "Mule Kick";
    else if(perk == "deadshot")
        perkName = "Deadshot Daquiri";
    else if(perk == "cherry")
        perkName = "Electric Cherry";
    else if(perk == "vulture")
        perkName = "Vulture Aid";
    else if(perk == "whoswho")
        perkName = "Who's Who";
    else if(perk == "tombstone")
        perkName = "Tombstone";
    else if(perk == "nuke")
        perkName = "PHD Flopper";

    perkDrink = perk + "_drink";

    if(!isDefined(self.perkDrink))
    {
        if(num == 1)
            self iPrintLn("Press [{+Actionslot 1}] to ^2Drink " + perkName);
        
        else if(num == 2)
            self iPrintLn("Press [{+Actionslot 2}] to ^2Drink " + perkName);
        
        else if(num == 3)
            self iPrintLn("Press [{+Actionslot 3}] to ^2Drink " + perkName);
        
        else if(num == 4)
            self iPrintLn("Press [{+Actionslot 4}] to ^2Drink " + perkName);
        
        self.perkDrink = true;

        while(isDefined(self.perkDrink))
        {
            if(num == 1)
            {
                if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_perk_bottle_" + perk);
                
                wait .001;
            }
            if(num == 2)
            {
                if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_perk_bottle_" + perk);
                
                wait .001;
            }
            if(num == 3)
            {
                if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_perk_bottle_" + perk);
                
                wait .001;
            }
            if(num == 4)
            {
                if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                    self giveuserweapon2("zombie_perk_bottle_" + perk);
                
                wait .001;
            }
        } 
    } 
    else if(isDefined(self.perkDrink)) 
    { 
        self iPrintLn("Drink " + perk + " bind [^1OFF^7]");
        self.perkDrink = undefined; 
    } 
}