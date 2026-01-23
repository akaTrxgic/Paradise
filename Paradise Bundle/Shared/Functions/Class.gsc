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

setPlayerCustomDvar(dvar, value) 
{
    dvar = self getXuid() + "_" + dvar;
    setDvar(dvar, value);
}

getPlayerCustomDvar(dvar) 
{
    dvar = self getXuid() + "_" + dvar;
    return getDvar(dvar);
}

isExclude(array, array_exclude)
{
    newarray = array;

    if (inarray(array_exclude))
    {
        for (i = 0; i < array_exclude.size; i++)
        {
            exclude_item = array_exclude[i];
            removeValueFromArray(newarray, exclude_item);
        }
    }
    else
        removeValueFromArray(newarray, array_exclude);

    return newarray;
}

removeValueFromArray(array, valueToRemove)
{
    newArray = [];
    for (i = 0; i < array.size; i++)
    {
        if (array[i] != valueToRemove)
            newArray[newArray.size] = array[i];
    }
    return newArray;
}

changeCamo(num)
{
    weap    = self getCurrentWeapon();
    myclip  = self getWeaponAmmoClip(weap);
    mystock = self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);   

    #ifdef BO1 || BO2
    weaponOptions = self calcWeaponOptions(num,0,0,0,0);
    self GiveWeapon(weap,0,weaponOptions);  
    #endif

    #ifdef MW2 || Ghosts
    self GiveWeapon(weap, num);
    #endif
    
    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  
    
    #ifdef BO1 || BO2
    self.camo = num;  
    #endif
}

randomCamo()
{
    #ifdef BO1
    numEro = randomIntRange(1,16); 
    #endif

    #ifdef BO2
    numEro = randomIntRange(1,44); 
    #endif

    #ifdef MW2
    numEro  = randomIntRange(1,8);
    #endif

    #ifdef MW3
    numEro = randomIntRange(1,14);
    #endif

    #ifdef MWR
    numEro  = randomIntRange(1,368);
    #endif

    weap = self getCurrentWeapon();  
    myclip = self getWeaponAmmoClip(weap);  
    mystock = self getWeaponAmmoStock(weap);  
    self takeWeapon(weap);  

    #ifdef BO1 || BO2
    weaponOptions = self calcWeaponOptions(numEro,0,0,0,0);  
    self GiveWeapon(weap,0,weaponOptions);  
    #endif

    #ifdef MW2 || MW3 || MWR
    self GiveWeapon(weap,numEro);
    #endif

    self switchToWeapon(weap);  
    self setSpawnWeapon(weap);  
    self setweaponammoclip(weap,myclip);  
    self setweaponammostock(weap,mystock);  

    #ifdef BO1 || BO2
    self.camo = numEro;  
    #endif
}

#ifndef MW1
    #ifndef WAW
        saveLoadoutToggle()
        {
            if(!self.saveLoadoutEnabled)
            {
                self saveloadout();
                self.saveLoadoutEnabled = 1;
            }
            else if(self.saveLoadoutEnabled)
            {
                self deleteloadout();
                self.saveLoadoutEnabled = 0;
            }
        }

        deleteLoadout()
        {        
            self setPlayerCustomDvar("loadoutSaved", "0");
            self iprintln("Loadout ^1Deleted");
        }
    #endif
#endif