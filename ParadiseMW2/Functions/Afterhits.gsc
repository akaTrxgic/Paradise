AfterHit(gun)
{
    self endon("afterhit");
    self endon( "disconnect" );
    if(self.AfterHit == 0)
    {
        self iprintln("Afterhit Weapon set: ^2" + gun);
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

afterhitsMonitorStance()
{
    self waittill("weapon_fired");
    level waittill("game_ended");

    if(self.pers["afterhitsST"])
    {
        self FreezeControls(false);
        
        self setStance(self.pers["afterhit_stance"]);
        wait 0.2;
    }
}
afterhitsProne()
{
    self.pers["afterhitsST"] = true;
    self thread afterhitsMonitorStance();       
    self.pers["afterhit_stance"] = ("prone");
    self iprintln("^7Afterhit Stance Selected: ^5" + self.pers["afterhit_stance"]);
}