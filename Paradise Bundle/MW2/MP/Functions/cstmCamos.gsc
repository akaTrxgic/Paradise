customCamos(camoName)
{
    imagePath = "";
    uiPath = "";
    menuPath = "";
    
    if(camoName == "ghosts")
    {
        imagePath = "Images/3ARC/ghosts_Camo.png";
        uiPath = "Images/3ARC/hosts_Menu_camo.png";
        menuPath = "Images/3ARC/ghosts_Menu_camo.png";
        level.camoReplacer = "weapon_camo_orange_fall";
        level.uiCamoReplacer = "ui_camoskin_orange_fall";
        level.menuCamoReplacer = "weapon_camo_menu_orange_fall";
    }
    if(camoName == "sdcr")
    {
        imagePath = "Images/3ARC/sdcr_Camo.png";
        uiPath = "Images/3ARC/sdcr_Menu_camo.png";
        menuPath = "Images/3ARC/sdcr_Menu_camo.png";
        level.camoReplacer = "weapon_camo_orange_fall";
        level.uiCamoReplacer = "ui_camoskin_orange_fall";
        level.menuCamoReplacer = "weapon_camo_menu_orange_fall";
    }
    if(camoName == "dmscs")
    {
        imagePath = "Images/InfWard/dmscs_Camo.png";
        uiPath = "Images/InfWard/dmscs_Menu_camo.png";
        menuPath = "Images/InfWard/dmscs_Menu_camo.png";
        level.camoReplacer = "weapon_camo_orange_fall";
        level.uiCamoReplacer = "ui_camoskin_orange_fall";
        level.menuCamoReplacer = "weapon_camo_menu_orange_fall";
    }
    if(camoName == "lat")
    {
        imagePath = "Images/InfWard/lat_Camo.png";
        uiPath = "Images/InfWard/lat_Menu_camo.png";
        menuPath = "Images/InfWard/lat_Menu_camo.png";
        level.camoReplacer = "weapon_camo_orange_fall";
        level.uiCamoReplacer = "ui_camoskin_orange_fall";
        level.menuCamoReplacer = "weapon_camo_menu_orange_fall";
    }
    if(camoName == "obsid")
    {
        imagePath = "Images/InfWard/obsid_Camo.png";
        uiPath = "Images/InfWard/obsid_Menu_camo.png";
        menuPath = "Images/InfWard/obsid_Menu_camo.png";
        level.camoReplacer = "weapon_camo_orange_fall";
        level.uiCamoReplacer = "ui_camoskin_orange_fall";
        level.menuCamoReplacer = "weapon_camo_menu_orange_fall";
    }
    if(camoName == "molten")
    {
        imagePath = "Images/Custom/molten_Camo.png";
        uiPath = "Images/Custom/molten_Menu_camo.png";
        menuPath = "Images/Custom/molten_Menu_camo.png";
        level.camoReplacer = "weapon_camo_orange_fall";
        level.uiCamoReplacer = "ui_camoskin_orange_fall";
        level.menuCamoReplacer = "weapon_camo_menu_orange_fall";
    }
    if(camoName == "galaxy")
    {
        imagePath = "Images/Custom/galaxy_Camo.png";
        uiPath = "Images/Custom/galaxy_Menu_camo.png";
        menuPath = "Images/Custom/galaxy_Menu_camo.png";
        level.camoReplacer = "weapon_camo_orange_fall";
        level.uiCamoReplacer = "ui_camoskin_orange_fall";
        level.menuCamoReplacer = "weapon_camo_menu_orange_fall";
    }
    if(camoName == "prplob")
    {
        imagePath = "Images/Custom/prplob_Camo.png";
        uiPath = "Images/Custom/prplob_Menu_camo.png";
        menuPath = "Images/Custom/prplob_Menu_camo.png";
        level.camoReplacer = "weapon_camo_orange_fall";
        level.uiCamoReplacer = "ui_camoskin_orange_fall";
        level.menuCamoReplacer = "weapon_camo_menu_orange_fall";
    }
    if(imagePath != "")
    {
        ReplaceImage(imagePath, level.camoReplacer);
        ReplaceImage(uiPath, level.uiCamoReplacer);
        ReplaceImage(menuPath, level.menuCamoReplacer);
        self iPrintln("^4Camo ^1Set");
    }
}
