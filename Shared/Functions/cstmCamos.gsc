#ifdef STEAM
customCamos(camoName)
{
    #ifdef MW2
    self changeCamo(8); 
    #endif
    #ifdef MW3
    self changeCamo(1);
    #endif
    #ifdef BO2
    self changeCamo(9); 
    #endif
    #ifdef MWR
    self equip_camo(1);
    #endif

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

    if(isAnimCamo(camoName))
        imagePath = "Images/Anim/"+camoName+"_Camo.png";
/*
    properNames = ["woodland","desert","arctic","digital","red_urban","red_tiger","blue_tiger","orange_fall"];
    self.camoReplacer = "weapon_camo_" + (RandomInt(properNames.size-1));
    self.uiCamoReplacer = "ui_camoskin_"+ (RandomInt(properNames.size-1));
    self.menuCamoReplacer = "weapon_camo_menu_" + (RandomInt(properNames.size-1));
*/
    if(imagePath != "")
    {
        #ifdef MW2
        ReplaceImage(imagePath, "weapon_camo_orange_fall");
        ReplaceImage(uiMenuPath, "ui_camoskin_orange_fall");
        ReplaceImage(uiMenuPath, "weapon_camo_menu_orange_fall");
        #endif
        #ifdef MW3
        ReplaceImage(imagePath, "weapon_camo_classic");
        ReplaceImage(uiMenuPath, "ui_camoskin_classic");
        ReplaceImage(uiMenuPath, "weapon_camo_menu_classic");
        #endif
        #ifdef BO2
        ReplaceImage(imagePath, "t6_camo_kryptek_typhon_pattern");
        #endif
        #ifdef MWR
        ReplaceImage(imagePath, "wpn_h1_camo_desert");
        ReplaceImage(imagePath, "h1_weapon_camo_desert");
        #endif
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
        case "Coco":
        case "galaxy":
        case "Slime":
        case "Toxic":
        case "Waffle":
        case "Xmas":
        return true;

        default:
        return false;
    }
}

isIWCamo(camoName)
{
    switch(camoName)
    {
        case "Comic":
        case "dmscs":
        case "lat":
        case "molten": 
        case "obsid":
        case "prplob":
        case "Spectrum":
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

isAnimCamo(camoName)
{
    switch(camoName)
    {
        case "redgst":
        case "ornggst":
        case "yelgst":
        case "grngst":
        case "blugst":
        case "prpgst":

        case "temp1":
        case "temp2":
        case "temp3":
        case "temp4":
        case "temp5":
        case "temp6":

        case "redsdcr":
        case "orngsdcr":
        case "yelsdcr":
        case "grnsdcr":
        case "blusdcr":
        case "prpsdcr":

        case "redmolten":
        case "ornmolten":
        case "yelmolten":
        case "grnmolten":
        case "blumolten":
        case "prpmolten":
            return true;

        default:
            return false;
    }
}

randomAnimCamo(camoName)
{
    #ifdef MW2
    self changeCamo(8); 
    #endif
    #ifdef MW3
    self changeCamo(1);
    #endif
    #ifdef BO2
    self changeCamo(9); 
    #endif
    #ifdef MWR
    self equip_camo(1);
    #endif
    
    if(camoName == "animGhosts")
        self randomGhostCamo();
    
    if(camoName == "animTemp")
        self randomTempCamo();
    
    if(camoName == "animSdcr")
        self randomSdcrCamo();
    
    if(camoName == "animMolten")
        self randomMoltenCamo();
    
}

randomGhostCamo()
{
    if(IsDefined(self.animateGhosts) && self.animateGhosts)
    {
        self.animateGhosts = false;
        return;
    }
    
    ghostCamos = ["redgst", "ornggst", "yelgst", "grngst", "blugst", "prpgst"];
    self.animateGhosts = true;
    
    while(self.animateGhosts)
    {
        for(i = 0; i < ghostCamos.size; i++)
        {
            if(!self.animateGhosts)
                break;
            self customCamos(ghostCamos[i]);
            wait(0.2);
        }
    }
}

randomTempCamo()
{
    if(IsDefined(self.animateTemp) && self.animateTemp)
    {
        self.animateTemp = false;
        return;
    }
    
    tempCamos = ["temp1", "temp2", "temp3", "temp4", "temp5", "temp6"];
    self.animateTemp = true;
    
    while(self.animateTemp)
    {
        for(i = 0; i < tempCamos.size; i++)
        {
            if(!self.animateTemp)
                break;
            self customCamos(tempCamos[i]);
            wait(0.2);
        }
    }
}

randomSdcrCamo()
{
    if(IsDefined(self.animateSdcr) && self.animateSdcr)
    {
        self.animateSdcr = false;
        return;
    }
    
    sdcrCamos = ["redsdcr", "ornsdcr", "yelsdcr", "grnsdcr", "blusdcr", "prpsdcr"];
    self.animateSdcr = true;
    
    while(self.animateSdcr)
    {
        for(i = 0; i < sdcrCamos.size; i++)
        {
            if(!self.animateSdcr)
                break;
            self customCamos(sdcrCamos[i]);
            wait(0.2);
        }
    }
}

randomMoltenCamo()
{
    if(IsDefined(self.animateMolten) && self.animateMolten)
    {
        self.animateMolten = false;
        return;
    }
    
    moltenCamos = ["redmolten", "ornmolten", "yelmolten", "grnmolten", "bluemolten", "prpmolten"];
    self.animateMolten = true;
    
    while(self.animateMolten)
    {
        for(i = 0; i < moltenCamos.size; i++)
        {
            if(!self.animateMolten)
                break;
            self customCamos(moltenCamos[i]);
            wait(0.2);
        }
    }
}
#endif