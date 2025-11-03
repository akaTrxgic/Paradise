#ifdef STEAM
customCamos(camoName)
{
    if(is3arcCamo(camoName))
    {
        imagePath = "Images/3ARC/"+camoName+"_Camo.png";
        uiMenuPath = "Images/3ARC/"+camoName+"_Menu.png";
    }

    if(isIWCamo(camoName))
    {
        imagePath = "Images/InfWard/"+camoName+"_Camo.png";
        uiMenuPath = "Images/InfWard/"+camoName+"_Menu.png";
    }

    if(isCustomCamo(camoName))
    {
        imagePath = "Images/Custom/"+camoName+"_Camo.png";
        uiMenuPath = "Images/Custom/"+camoName+"_Menu.png";
    }

    if(isMCCamo(camoName))
    {
        imagePath = "Images/MC/"+camoName+"_Camo.png";
        uiMenuPath = "Images/MC/"+camoName+"_Menu.png";
    }

    if(isTestCamo(camoName))
    {
        imagePath = "Images/Test/"+camoName+"_Camo.png";
        uiMenuPath = "Images/Test/"+camoName+"_Menu.png";
    }

    properNames = ["woodland","desert","arctic","digital","red_urban","red_tiger","blue_tiger","orange_fall"];
    self.camoReplacer = "weapon_camo_" + (RandomInt(properNames.size-1));
    self.uiCamoReplacer = "ui_camoskin_"+ (RandomInt(properNames.size-1));
    self.menuCamoReplacer = "weapon_camo_menu_" + (RandomInt(properNames.size-1));
    
    if(imagePath != "")
    {
        ReplaceImage(imagePath, self.camoReplacer);
        ReplaceImage(uiMenuPath, self.uiCamoReplacer);
        ReplaceImage(uiMenuPath, self.menuCamoReplacer);
    }
}

is3arcCamo(camoName)
{
    switch(camoName)
    {
        case "ghosts":
        case "sdcr":
        return true;

        default:
        return false;
    }
}

isCustomCamo(camoName)
{
    switch(camoName)
    {
        case "acidv2":
        case "coco":
        case "galaxy":
        case "slime":
        case "toxic":
        case "waffle":
        case "xmas":
        return true;

        default:
        return false;
    }
}

isIWCamo(camoName)
{
    switch(camoName)
    {
        case "comic":
        case "dmscs":
        case "lat":
        case "molten": 
        case "obsid":
        case "prplob":
        case "spectrum":
        return true;

        default:
        return false;
    }
}

isMCCamo(camoName)
{
    switch(camoName)
    {
        case "MCCoal":
        case "MCCreep":
        case "MCDia":
        case "MCEm": 
        case "MCGold":
        case "MCIron":
        case "MCLap":
        case "MCRed":
        return true;

        default:
        return false;
    }
}

isTestCamo(camoName)
{
    switch(camoName)
    {
        case "abs1":
        case "bbgtgr":
        case "blobsid": 
        case "blpsdcr":
        case "blrltgr":
        case "blupal":
        case "bo3aow":
        case "bo3aowgl":
        case "coral":
        case "ffood":
        case "graf": 
        case "grpal":
        case "jack":
        case "mlg":
        case "mop":
        case "nb4c":
        case "paradise":
        case "prplpal": 
        case "rpal":
        case "space":
        case "tgh":
        case "tgh2":
        case "trxgic":
        case "wf1":
        case "wf2":
        case "wfnew":
        case "wfnewTEST":
        return true;

        default:
        return false;
    }
}

animCamoTggl(camoName)
{
    camoArray = [];

    if(IsDefined(self.animCamoOn) && self.animCamoOn && camoName != self.currAnimCamo)
    {
        self.animCamoOn = 0;
        self.currAnimCamo = undefined;
        self notify("stop_animCamo");
        return;
    }

    if(camoName == "animGhosts")
    {
        self.animCamoOn = 1;
        camoArray = ["redgst", "ornggst", "yelgst", "grngst", "blugst", "prpgst"];
        self.currAnimCamo = camoName;
        self thread doAnimCamo();
    }
    else if(camoName == "animTemp")
    {
        self.animCamoOn = 1;
        camoArray = ["temp1", "temp2", "temp3", "temp4", "temp5", "temp6"];
        self.currAnimCamo = camoName;
        self thread doAnimCamo();
    }
    else if(camoName == "animSdcr")
    {
        self.animCamoOn = 1;
        camoArray = ["redsdcr", "orngsdcr", "yelsdcr", "grnsdcr", "blusdcr", "prpsdcr"];
        self.currAnimCamo = camoName;
        self thread doAnimCamo();
    }
    else if(camoName == "animMolten")
    {
        self.animCamoOn = 1;
        camoArray = ["redmolten", "ornmolten", "yelmolten", "grnmolten", "bluemolten", "prpmolten"];
        self.currAnimCamo = camoName;
        self thread doAnimCamo();
    }
}

doAnimCamo(camoArray, camoName)
{
    self endon("stop_animCamo");

    for(;;)
    {
        for(i=0;i<camoArray.size;i++)
        {
            imagePath = "Images/Anim" + camoArray[i] + "_Camo.png";
            wait .2;
        }
        ReplaceImage(imagePath, "weapon_camo_menu_orange_fall");
    }
}
#endif