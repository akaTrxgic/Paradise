takeWpn()
{
    self takeweapon(self getcurrentweapon());
}
toggleInfEquip()
{
    self.infEquipOn = !isDefined(self.infEquipOn) || !self.infEquipOn;

    if (self.infEquipOn)
        self thread InfEquipment();
    else
        self notify("noMoreInfEquip");
}

InfEquipment()
{
    self endon("disconnect");
    self endon("noMoreInfEquip");

    for (;;)
    {
        wait 0.1;
        currentoffhand = self getcurrentoffhand();
        if (currentoffhand != "none")
            self givemaxammo(currentoffhand);
    }
}

dropWpn() 
{
    self dropItem(self getCurrentWeapon());
}
