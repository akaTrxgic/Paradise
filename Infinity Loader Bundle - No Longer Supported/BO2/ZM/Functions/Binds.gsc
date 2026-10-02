   crackKnuckleBind(num)
    {
        if( isDefined( self.cKnuck ))
        {
            self iPrintLn("Crack Knuckle bind [^1OFF^7]");
            self.cKnuck = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Crack Knuckles");
            self.cKnuck = true;

            while(isDefined(self.cKnuck))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread force_drink();
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread force_drink();
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread force_drink();
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread force_drink();
                }
                wait .001;
            } 
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
        if( isDefined( self.bweInsp ))
        {
            self iPrintLn("Bowie Inspect bind [^1OFF^7]");
            self.bweInsp = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Bowie Inspect");
            self.bweInsp = true;

            while(isDefined(self.bweInsp))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_bowie_flourish");
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_bowie_flourish");
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_bowie_flourish");
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_bowie_flourish");
                }
                wait .001;
            } 
        } 
    }

    syrInjectBind(num)
    {
        if( isDefined( self.syrInj ))
        {
            self iPrintLn("Syringe Inject bind [^1OFF^7]");
            self.syrInj = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Syringe Inject");
            self.syrInj = true;

            while(isDefined(self.syrInj))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("syrette_zm");
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("syrette_zm");
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("syrette_zm");
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("syrette_zm");
                }
                wait .001;
            } 
        } 
    }

    chalkDrawBind(num)
    {
        if( isDefined( self.chkDraw ))
        {
            self iPrintLn("Chalk Draw bind [^1OFF^7]");
            self.chkDraw = undefined;
        }
        
        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Chalk Draw");
            self.chkDraw = true;

            while(isDefined(self.chkDraw))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("chalk_draw_zm");
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("chalk_draw_zm");
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("chalk_draw_zm");
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("chalk_draw_zm");
                }
                wait .001;
            } 
        }
    }

    retrInspBind(num)
    {
        if( isDefined( self.retrInsp ))
        {
            self iPrintLn("Retriever Inspect bind [^1OFF^7]");
            self.retrInsp = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Inspect Retriever");
            self.retrInsp = true;

            while(isDefined(self.retrInsp))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_tomahawk_flourish");
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_tomahawk_flourish");
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_tomahawk_flourish");
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_tomahawk_flourish");
                }
                wait .001;
            } 
        } 
    }

    aftRevBind(num)
    {
        if( isDefined( self.aftRev ))
        {
            self iPrintLn("Afterlife Revive bind [^1OFF^7]");
            self.aftRev = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Afterlife Revive");
            self.aftRev = true;

            while(isDefined(self.aftRev))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("syrette_afterlife_zm");
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("syrette_afterlife_zm");
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("syrette_afterlife_zm");
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("syrette_afterlife_zm");
                }
                wait .001;
            } 
        }
    }

    oipInspBind(num)
    {
        if( isDefined( self.oipInsp ))
        {
            self iPrintLn("One Inch Punch Inspect bind [^1OFF^7]");
            self.oipInsp = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Inspect One Inch Punch");
            self.oipInsp = true;

            while(isDefined(self.oipInsp))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_one_inch_punch_flourish");
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_one_inch_punch_flourish");
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_one_inch_punch_flourish");
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_one_inch_punch_flourish");
                }
                wait .001;
            } 
        } 
    }

    perkdrinkBind(num, perk)
    {
        self endon ("disconnect");
        self endon ("game_ended");

        switch( perk )
        {
            case "jugg":
            perkName = "Juggernog";
            break;

            case "revive":
            perkName = "Quick Revive";
            break;

            case "sleight":
            perkName = "Speed Cola";
            break;

            case "doubletap":
            perkName = "Double Tap";
            break;

            case "marathon":
            perkName = "Stamin-Up";
            break;

            case "additionalprimaryweapon":
            perkName = "Mule Kick";
            break;

            case "deadshot":
            perkName = "Deadshot Daquiri";
            break;

            case "cherry":
            perkName = "Electric Cherry";
            break;

            case "vulture":
            perkName = "Vulture Aid";
            break;

            case "whoswho":
            perkName = "Who's Who";
            break;

            case "tombstone":
            perkName = "Tombstone";
            break;

            case "nuke":
            perkName = "PHD Flopper";
            break;
        }
        
        perkDrink = perk + "_drink";

        if( isDefined( self.perkDrink ))
        {
            self iPrintLn("Drink " + perk + " bind [^1OFF^7]");
            self.perkDrink = undefined; 
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Drink " + perkName);
            self.perkDrink = true;

            while(isDefined(self.perkDrink))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_perk_bottle_" + perk);
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_perk_bottle_" + perk);
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_perk_bottle_" + perk);
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self giveuserweapon2("zombie_perk_bottle_" + perk);
                }
                wait .001;
            } 
        } 
    }

    Canzoom(num)
    {
        if( isDefined( self.Canzoom ))
        {
            self iPrintLn("Canzoom bind [^1OFF^7]");
            self.Canzoom = undefined; 
        }   
        
        else
        {
            self iPrintLn("Press [{+Actionslot " + num + "}] to ^2Can Zoom");
            self.Canzoom = true;

            while(isDefined(self.Canzoom))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                else if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread CanzoomFunction();
                }
                wait 0.01; 
            } 
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
            self iPrintln("Weapon 1 Selected: [^2" + self.wep1 + "^7]");
        }
        else if(num == 2)
        {
            self.wep2 = self getCurrentWeapon();
            self iPrintln("Weapon 2 Selected: [^2" + self.wep2 + "^7]");
        }
    }

    nacModBind(num)
    {
        if( isDefined( self.NacBind ))
        {
            self iPrintLn("Nac Bind [^1OFF^7]");
            self.NacBind = undefined; 
            self.wep1    = undefined;
            self.wep2    = undefined;
            self iPrintLn("Nac Weapons ^1Reset");
        }
        
        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Nac");
            self.NacBind = true;
            
            while(isDefined(self.NacBind))
            {
                if( self GetStance() != "prone"  && !self meleebuttonpressed() )
                {
                    if(num == 1)
                    {
                        if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 2)
                    {
                        if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 3)
                    {
                        if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                    else if(num == 4)
                    {
                        if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                                heliosNac();   
                    }
                }
                wait 0.01;
            } 
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
            self iPrintln("Weapon 1 Selected: [^2" + self.snacwep1 + "^7]");
        }
        
        else if(num == 2)
        {
            self.snacwep2 = self getCurrentWeapon();
            self iPrintln("Weapon 2 Selected: [^2" + self.snacwep2 + "^7]");
        }
    }

    skreeBind(num)
    {
        if( isDefined( self.SnacBind ))
        {
            self iPrintLn("Skree Bind [^1OFF^7]");
            self.SnacBind = undefined; 
            snacwep1      = undefined;
            snacwep2      = undefined;
            self iPrintLn("Skree Weapons ^1Reset");
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2Skree");
            self.SnacBind = true;
            
            while(isDefined(self.SnacBind))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
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
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
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
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
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
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
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
    }

    gFlipBind(num)
    {
        if( isDefined( self.Gflip ))
        {
            self iPrintLn("GFlip bind [^1OFF^7]");
            self notify("stopProne1");
            self.Gflip = undefined;
        }

        else
        {
            self iPrintLn("Press [{+Actionslot " + num +"}] to ^2GFlip");
            self.Gflip = true;

            while(isDefined(self.Gflip))
            {
                if(num == 1)
                {
                    if(self actionslotonebuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 2)
                {
                    if(self actionslottwobuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 3)
                {
                    if(self actionslotthreebuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                if(num == 4)
                {
                    if(self actionslotfourbuttonpressed() && !self.menu["isOpen"])
                        self thread MidAirGflip();
                }
                wait 0.01; 
            } 
        } 
    }

    MidAirGflip()
    {
        self endon("stopProne1");
        self setStance("prone");
        wait 0.01;
        self setStance("prone");
    }