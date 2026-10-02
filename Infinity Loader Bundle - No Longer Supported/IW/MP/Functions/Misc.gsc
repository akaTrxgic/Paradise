    AfterHit(gun)
    {
        self endon("afterhit");
        self endon( "disconnect" );

        if(!self.AfterHit)
        {
            self iprintln("Afterhit Weapon set: [^2" + gun + "^7]");
            self thread doAfterHit(gun);
            self.AfterHit = 1;
        }
        else
        {
            self iprintln("Afterhits [^1OFF^7]");
            self.AfterHit = 0;
            KeepWeapon = "";
            self notify("afterhit");
        }
    }

    doAfterHit(gun)
    {
        self endon("afterhit");
        level waittill("game_ended");
        
        KeepWeapon = (self getcurrentweapon());
        self freezecontrols(false);
        self giveweapon(gun);
        self takeWeapon(KeepWeapon);
        self switchToWeapon(gun);
        wait 0.02;
        self freezecontrols(true);
    }

    give_killstreak(streak) 
    {
        self thread scripts\mp\_hud_message::func_10134(streak, undefined, 1);
        self scripts\mp\killstreaks\_killstreaks::func_26D4(streak, self);
    }