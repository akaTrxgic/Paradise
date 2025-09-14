        menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        switch(menu)
{
    case "main":
        if(self.access > 0)
        {
            self addMenu("main", "Main Menu");
            self addOpt("Trickshot Menu", ::newMenu, "ts");
            self addOpt("Binds Menu", ::newMenu, "sK");
            self addOpt("Teleport Menu", ::newMenu, "tp");
            self addOpt("Class Menu", ::newMenu, "class");
            self addOpt("Afterhits Menu", ::newMenu, "afthit");
            self addOpt("Killstreak Menu", ::newMenu, "kstrks");

            if(self ishost() || self isDeveloper()) 
                self addOpt("Host Options", ::newMenu, "host");
        }
        break;

    // TRICKSHOT MENU
    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip", self.NoClipT, ::initNoClip);

            canOpts = strtok("Current;Infinite", ";");
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addToggle("Dolphin Dive", self.DolphinDive, ::DolphinDive);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = strTok("Bounce;Platform;Crate", ";");
            spawnOptionsIDs     = strTok("bounce;platform;crate", ";");
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

    // BINDS MENU
    case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
            self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
            self addOpt("Laptop Bind", ::newMenu, "laptop");
            self addOpt("Bomb Briefcase Bind", ::newMenu, "bomb");
            self addOpt("Trigger Bind", ::newMenu, "trgr");
            break;

    case "sentry":
            self addMenu("sentry", "Walking Sentry Bind");
            self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
            self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
            self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
            self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
            break;

    case "laptop":
            self addMenu("laptop", "Laptop Bind");
            self addOpt("Laptop Bind: [{+actionslot 1}]", ::predBind, 1);
            self addOpt("Laptop Bind: [{+actionslot 2}]", ::predBind, 2);
            self addOpt("Laptop Bind: [{+actionslot 3}]", ::predBind, 3);
            self addOpt("Laptop Bind: [{+actionslot 4}]", ::predBind, 4);
            break;
        
    case "bomb":
            self addMenu("bomb", "Bomb Bind");
            self addOpt("Bomb Bind: [{+actionslot 1}]", ::bombBind, 1);
            self addOpt("Bomb Bind: [{+actionslot 2}]", ::bombBind, 2);
            self addOpt("Bomb Bind: [{+actionslot 3}]", ::bombBind, 3);
            self addOpt("Bomb Bind: [{+actionslot 4}]", ::bombBind, 4);
            break;

    case "trgr":
            self addMenu("trgr", "Trigger Bind");
            self addOpt("Trigger Bind: [{+actionslot 1}]", ::trgrBind, 1);
            self addOpt("Trigger Bind: [{+actionslot 2}]", ::trgrBind, 2);
            self addOpt("Trigger Bind: [{+actionslot 3}]", ::trgrBind, 3);
            self addOpt("Trigger Bind: [{+actionslot 4}]", ::trgrBind, 4);
            break;

        case "gflip":  
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            break;

        case "nmod":  
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            break;

        case "skree":  
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            break;

        case "cnzm":  
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            break;

        case "cb":  
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 1}]",  ::class1);
            self addOpt("Bind Class 2: [{+actionslot 1}]",  ::class2);
            self addOpt("Bind Class 3: [{+actionslot 1}]",  ::class3);
            self addOpt("Bind Class 4: [{+actionslot 1}]",  ::class4);
            self addOpt("Bind Class 5: [{+actionslot 1}]",  ::class5);
            self addOpt("Bind Class 6: [{+actionslot 1}]",  ::class6);
            self addOpt("Bind Class 7: [{+actionslot 1}]",  ::class7);
            self addOpt("Bind Class 8: [{+actionslot 1}]",  ::class8);
            self addOpt("Bind Class 9: [{+actionslot 1}]",  ::class9);
            self addOpt("Bind Class 10: [{+actionslot 1}]",  ::class10);
            break;

    case "tp":  // Teleport Menu
    self addMenu("tp", "Teleport Menu");

    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);
      
    tpNames = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_seatown")
    {
        tpNames  = strTok("Spawn Palm Tree;Castle Wall;B Building;Numbs Barrier;Owls Nest", ";");
        tpCoords = [
            (-2564.06, 737.637, 746.090),
            (-2980.75, -2426.59, 448.126),
            (1682.67, -1092.63, 698.126),
            (1436.14, 827.408, 1535.86),
            (-214.042, 3500.72, 736.126)
        ];
    }
    else if(getDvar("mapname") == "mp_dome")
    {
        tpNames  = strTok("Top Antennae;Yellow Roof;Water Tower 1;Water Tower 2;Edge of Map", ";");
        tpCoords = [
            (-1641.8, -1917.57, 725.626),
            (4970.83, 3309.76, 873.092),
            (-104.699, 3002.76, 295.126),
            (-1394.22, -166.315, 144.126),
            (-4417.23, -14196.8, 1002.05)
        ];
    }
    else if(getDvar("mapname") == "mp_plaza2")
    {
        tpNames  = strTok("A Building;Bomb Spawn Building;Parking Garage;Across the River 1;Across the River 2", ";");
        tpCoords = [
            (3141.59, 2011.39, 2272.14),
            (3337.44, -2430.49, 2240.14),
            (-1496.37, 2223.13, 1547.14),
            (-2306.94, 4856.12, 1232.14),
            (1607.44, 5783.35, 1408.14)
        ];
    }
    else if(getDvar("mapname") == "mp_mogadishu")
    {
        tpNames  = strTok("Ship Crane;Ship Spot 1;Ship Spot 2", ";");
        tpCoords = [
            (9117.458, -1658.06, 645.182),
            (-281.219, -1946.91, 648.426),
            (1514.71, -1932.56, 648.426)
        ];
    }
    else if(getDvar("mapname") == "mp_paris")
    {
        tpNames  = strTok("Main Roof;A Bomb Roof;A Bomb Roof 2;B Bomb Roof", ";");
        tpCoords = [
            (-3642.28, 117.656, 1066.87),
            (1782.94, 2696.29, 624.912),
            (2983.6, 335.537, 713.667),
            (-133.233, -1895.12, 794.639)
        ];
    }
    else if(getDvar("mapname") == "mp_exchange")
    {
        tpNames  = strTok("Bomb Spawn Building 1;Bomb Spawn Building 2;Numbs Spot;Lew Undermap;Alley Building", ";");
        tpCoords = [
            (875.857, 2199.45, 1615.14),
            (-1428.79, 1867.83, 2197.64),
            (-29.6717, -3106.95, 1269.19),
            (-1824.18, 898.349, 200.815),
            (-2320.08, -1135.49, 1116.14)
        ];
    }
    else if(getDvar("mapname") == "mp_bootleg")
    {
        tpNames  = strTok("Blue Building 1;Blue Building 2;Brick Office Roof", ";");
        tpCoords = [
            (-4080.15, -378.776, 956.126),
            (3289.45, -2758.55, 956.126),
            (2090.33, 1109.19, 1036.14)
        ];
    }
    else if(getDvar("mapname") == "mp_carbon")
    {
        tpNames  = strTok("AC Unit;Undermap Sui;Green Building Sui;Red Building Sui", ";");
        tpCoords = [
            (3061.9, 1690.39, 6145.64),
            (-172.453, 3938.83, 5327.63),
            (-5805.79, -2428, 3978.75),
            (-1351.91, -7515.63, 4801.99)
        ];
    }
    else if(getDvar("mapname") == "mp_hardhat")
    {
        tpNames  = strTok("Rooftop 1;Rooftop 2;Rooftop 3;Skyscraper Roof 1;Pelo Skyscraper Roof", ";");
        tpCoords = [
            (-2968.37, 832.809, 1600.14),
            (5417.14, 2916.61, 3216.14),
            (-4641.98, -4586.78, 3200.13),
            (10753, 4903.27, 7232.14),
            (-11538.3, -5194.07, 8896.14)
        ];
    }
    else if(getDvar("mapname") == "mp_village")
    {
        tpNames  = strTok("B Tower;Cliff;Church Barrier", ";");
        tpCoords = [
            (-1346.6, 965.642, 1012.14),
            (-372.082, -3659.82, 1558.4),
            (1090.95, 417.557, 1385.73)
        ];
    }
    else if(getDvar("mapname") == "mp_lambeth")
    {
        tpNames  = strTok("Trxgic Barrier Spot;Bomb Spawn Sui;OOM Roof", ";");
        tpCoords = [
            (-3212.41, 249.976, 1088.14),
            (-1414.2, 5897.66, 255.756),
            (3314.56, -3888.27, 52.2078)
        ];
    }
    else if(getDvar("mapname") == "mp_interchange")
    {
        tpNames  = strTok("Way Out Building;Apartment Complex Roof 1;Apartment Complex Roof 2;Blue Warehouse", ";");
        tpCoords = [
            (6514.65, 7136.91, 1210.14),
            (7588.21, -6157.47, 1947.14),
            (5003.22, -9595.72, 1933.14),
            (-9065.15, 3564.91, 1415.50)
        ];
    }
    else if(getDvar("mapname") == "mp_radar")
    {
        tpNames  = strTok("Inside Cliff;Top Cliff;Way OOM;Tower Spot", ";");
        tpCoords = [
            (-5754.85, -88.7475, 1746.14),
            (-6076.27, 344.81, 2991.65),
            (-3916.54, 14554.8, 3757.35),
            (-11290.5, 2712.13, 2953.53)
        ];
    }
    else if(getDvar("mapname") == "mp_underground")
    {
        tpNames  = strTok("Carnie Roof;Office Roof;Parking Garage Roof;Skyscraper Roof", ";");
        tpCoords = [
            (-1121.87, -5498.32, 1044.14),
            (-465.589, 5825.38, 896.126),
            (-1395.61, 3749.47, 412.126),
            (-11553.3, -4204.02, 5124.14)
        ];
    }
    else if(getDvar("mapname") == "mp_courtyard_ss")
    {
        tpNames  = strTok("Top of Well;Top of Pillars;Top Orange Wall", ";");
        tpCoords = [
            (-1550.86, -1112.25, 440.126),
            (-2935.49, 849.618, 994.126),
            (334.478, 1660.46, 807.390)
        ];
    }
    else if(getDvar("mapname") == "mp_aground_ss")
    {
        tpNames  = strTok("A Side Cliff;B Side Cliff;Top of Crane;Way Out Cliff;Top of Boat", ";");
        tpCoords = [
            (578.007, 2479.03, 1472.20),
            (368.111, -2712.91, 1391.61),
            (996.477, -486798, 903.279),
            (2665.14, -7081.68, 1218.31),
            (972.888, 1880.84, 1128.19)
        ];
    }
    else if(getDvar("mapname") == "mp_terminal_cls")
    {
        tpNames  = strTok("OOM Plane;Spawn Roof", ";");
        tpCoords = [
            (1694.41, 54.7374, 820.359),
            (2998.43, 6732.3, 464.126)
        ];
    }
    else
    {
        tpNames  = strTok("No Custom Spots", ";");
        tpCoords = [];
    }


    self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
    break;

   case "class":  // Class Menu
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "atchmnts");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Equipment", ::newMenu, "lethals");
            self addOpt("Special Grenades", ::newMenu, "tacticals");
            self addOpt("Save Loadout", ::saveLoadout);
            self addOpt("Delete Saved Loadout", ::deleteSavedLoadout);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons Menu");

            arIDs = "m4_mp;famas_mp;scar_mp;tavor_mp;fal_mp;m16_mp;masada_mp;fn2000_mp;ak47_mp";
            arNames = "M4A1;Famas;Scar-H;Tar-21;Fal;M16A4;ACR;F2000;AK-47";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = "mp5k_mp;ump45_mp;kriss_mp;p90_mp;uzi_mp";
            smgNames = "MP5K;UMP45;Vector;P90;Mini-Uzi";
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgIDs = "sa80_mp;rpd_mp;mg4_mp;aug_mp;m240_mp";
            lmgNames = "L86 LSW;RPD;MG4;AUG HBAR;M240";
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            srIDs = "cheytac_mp;barrett_mp;wa2000_mp;m21_mp";
            srNames = "Intervention;Barrett .50cal;WA2000;M21 EBR";
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            mpIDs = "pp2000_mp;glock_mp;beretta393_mp;tmp_mp";
            mpNames = "PP2000;G18;M93 Raffica;TMP";
            self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

            sgIDs = "spas12_mp;aa12_mp;striker_mp;ranger_mp;m1014_mp;model1887_mp";
            sgNames = "SPAS-12;AA-12;Striker;Ranger;M1014;Model 1887";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            pstlIDs = "usp_mp;coltanaconda_mp;beretta_mp;deserteagle_mp";
            pstlNames = "USP .45;.44 Magnum;M9;Desert Eagle";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Special Weapons", ::newMenu, "specs");
            self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "lnchrs":
            self addMenu("lnchrs", "Launchers");
            self addOpt("AT4-HS", ::giveUserWeapon, "at4_mp");
            self addOpt("Thumper", ::giveUserWeapon, "m79_mp", false);
            self addOpt("Stinger", ::giveUserWeapon, "stinger_mp");
            self addOpt("Javelin", ::giveUserWeapon, "javelin_mp");
            self addOpt("RPG-7", ::giveUserweapon, "rpg_mp");
            break;

        case "specs":
            self addMenu("specs", "Special Weapons");
            self addOpt("Gold Desert Eagle", ::giveUserWeapon, "deserteaglegold_mp", false);
            self addOpt("Akimbo Thumper", ::giveUserWeapon, "m79_mp", true);
            self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp", false);
            self addOpt("Akimbo Default Weapon", ::giveUserWeapon, "defaultweapon_mp", true);
            self addOpt("OMA Bag", ::giveUserWeapon, "onemanarmy_mp", false);
            self addOpt("Dual OMA Bag", ::giveUserWeapon, "onemanarmy_mp", true);
            break;

        case "atchmnts":
            self addMenu("atchmnts", "Attachments");
            
            attachmentIDs = [ "none", "acog", "reflex", "silencer", "grip", "gl", "akimbo", "thermal", "shotgun", "heartbeat", "fmj", "rof", "xmags", "eotech", "tactical" ];
            attachmentNames = [ "No Attachment", "ACOG Scope", "Red Dot Sight", "Silencer", "Grip", "Grenade Launcher", "Akimbo", "Thermal", "Shotgun", "Heartbeat Sensor", "FMJ", "Rapid Fire", "Extended Mags", "Holographic Sight", "Tactical Knife" ];
            for(a=0;a<attachmentIDs.size;a++)
            self addOpt( attachmentNames[a], ::GivePlayerAttachment, attachmentIDs[a]);
            break;

        case "camos":
            self addMenu("camos", "Camos");          
            self addOpt("Random Camo", ::randomCamo);
            
            camos = [ "None", "Woodland", "Desert", "Artic", "Digital", "Urban", "Red Tiger", "Blue Tiger", "Fall" ];
            for(a=0;a<9;a++)
            self addOpt(camos[a], ::changeCamo, a );

            break;

        case "lethals":
            self addMenu("lethals", "Equipment");
            self addOpt("Frag", ::GiveEquipment, "frag_grenade_mp");
            self addOpt("Semtex", ::GiveEquipment, "semtex_mp");
            self addOpt("Throwing Knife", ::GiveEquipment, "throwingknife_mp");
            self addOpt("RH Throwing Knife", ::rhThrowingKnife);
            self addOpt("Tactical Insertion", ::GiveEquipment, "flare_mp");
            self addOpt("Blast Shield", ::blastShield);
            self addOpt("Claymore", ::GiveEquipment, "claymore_mp");
            self addOpt("C4", ::GiveEquipment, "c4_mp");
            self addOpt("Glowstick", ::giveglowstick);
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            self addOpt("Flash Grenade", ::GiveSecondaryOffhand, "flash_grenade_mp");
            self addOpt("Stun Grenade", ::GiveSecondaryOffhand, "concussion_grenade_mp");
            self addOpt("Smoke Grenade", ::GiveSecondaryOffhand, "smoke_grenade_mp");
            break;

        case "afthit":  // Afterhits Menu
            self addMenu("afthit", "Afterhits Menu");

            smgIDs = "mp5k_mp;kriss_mp;p90_mp";
            smgNames = "MP5K;Vector;P90";
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            arIDs = "m4_mp;scar_mp;tavor_mp;masada_mp;fn2000_mp;ak47_mp";
            arNames = "M4A1;SCAR-H;TAR-21;ACR;F2000;AK47";
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            lmgIDs = "sa80_mp;aug_mp";
            lmgNames = "L86 LSW;AUG HBAR";
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = "wa2000_mp;m21_mp";
            srNames = "WA2000;M21 EBR";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            lnchrsIDs = "at4_mp;stinger_mp;javelin_mp";
            lnchrsNames = "AT4-HS;Stinger;Javelin";
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            miscIDs = "model1887_mp;pp2000_mp";
            miscNames = "Model 1887;PP2000";
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
            break;

       case "kstrks": //Killstreak Menu
    self addMenu("kstrks", "Killstreak Menu"); 

    self addOpt("UAV", ::giveUAV);
    self addOpt("Ballistic Vests", ::giveBVests);
    self addOpt("Care Package", ::giveAirdrop);
    self addOpt("Counter UAV", ::giveCUAV);
    self addOpt("Sentry Gun", ::giveTurret);
    self addOpt("Predator Missile", ::givePredMissile);
    self addOpt("AC130", ::giveAC130);
    self addOpt("EMP", ::giveEMP);

    if(self ishost() || self isdeveloper())
        self addOpt("Killcam Nuke", ::fakenuke);
    break;



        case "host":  // Host Options 
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            
           
            self addOpt("Restart", ::FastRestart);
            timeActions = ["Add 1 Minute","Remove 1 Minute"];
            timeIDs = ["add","sub"];
            self addSliderString("Game Timer", timeIDs, timeActions, ::changeTime);

            self addOpt("Toggle Floaters", ::togglelobbyfloat);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addOpt("Teleport Bots to Crosshairs", ::tpBots);
            self addOpt("Kick Bots", ::kickAllBots);
            self addOpt("Fill Bots", ::spawnBots,18);

            break;
        }
        self clientOptions();
    }

clientOptions()
{   
    if(self isHost() || self isdeveloper())
    {
        self addMenu("Verify",  "Clients Menu");
        foreach( player in level.players )
        {
            if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                continue;
            perm = "None";
            if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                perm = level.status[player.access];
            
            if (player isDeveloper())
                perm = perm + " ^7| ^6Developer";

            self addOpt(player getname() + " [" + perm + "^7]", ::newmenu, "Verify_" + player getXUID());
        }
        foreach(player in level.players)
        {
            if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                continue;

            perm2 = "None";
            if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                perm2 = level.status[player.access];
            self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
            self addOpt("Kick Player", ::kickSped, player);
            self addOpt("Ban Player", ::banSped, player);  
            self addOpt("Teleport to Crosshairs", ::teleportToCrosshair, player);  
        }
    }
}

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        while( self.access != 0 )
        {
            if(!self.menu["isLocked"])
            {
                if(!self.menu["isOpen"])
                {
                    if( self isbuttonpressed("+actionslot 2") && self adsButtonPressed() )
                    {
                        self menuOpen();
                        wait .2;
                    }               
                }
                else{
                    if(self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 2"))
                    {
                        if(!self isButtonPressed("+actionslot 1") || !self isButtonPressed("+actionslot 2"))
                        {
                            if(!self isButtonPressed("+actionslot 1"))
                                self.menu[ self getCurrentMenu() + "_cursor" ] += self isButtonPressed("+actionslot 2");
                            if(!self isButtonPressed("+actionslot 2"))
                                self.menu[ self getCurrentMenu() + "_cursor" ] -= self isButtonPressed("+actionslot 1");

                            self scrollingSystem();
                            wait .08;
                        }
                    }
                    else if(self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4")){
                        if(!self isButtonPressed("+actionslot 3") || !self isButtonPressed("+actionslot 4"))
                        {
                            if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                            {
                                if( self isButtonPressed("+actionslot 3") )   
                                    self updateSlider( "L2" );
                                if( self isButtonPressed("+actionslot 4") )    
                                    self updateSlider( "R2" );
                                wait .1;
                            }
                        }
                    }
                    else if( self useButtonPressed() ){
                        player = self.selected_player;
                        menu = self.eMenu[self getCursor()];

                        if( player != self && self isHost() )
                        {
                            player.was_edited = true;
                            self iPrintLnBold( menu.opt + " Has Been Activated" );
                        }
                        
                        if( self.eMenu[ self getCursor() ].func == ::newMenu && self != player )
                            self iPrintLnBold( "^1Error: ^7Cannot Access Menus While In A Selected Player" );
                        else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ])){
                            slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                            slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                            player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                        }
                        else 
                            player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );

                        wait .05;
                        if(IsDefined( menu.toggle ))
                            self setMenuText();
                        if( player != self )
                            self.menu["OPT"]["MENU_TITLE"] settext( self.menuTitle + " ("+ player getName() +")");    
                        wait .15;
                        if( isDefined(player.was_edited) && self isHost() )
                            player.was_edited = undefined;
                    }
                    else if( self meleeButtonPressed() ){
                        if( self.selected_player != self )
                        {
                            self.selected_player = self;
                            self setMenuText();
                            self refreshTitle();
                        }
                        else if( self getCurrentMenu() == "main" )
                            self menuClose();
                        else 
                            self newMenu();
                        wait .2;
                    }
                }
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;

        self menuOptions();
        self drawMenu();
        self drawText();
        self setMenuText(); 
        self updateScrollbar();
        self thread menuDeath();
    }

        menuDeath()
    {
        self endon("disconnect");
        self endon("menuClosed");
    
        while(self.menu["isOpen"])
        {
            self waittill_any("death","game_ended","menuresponse");
            self menuClose();
        }
}

    menuClose()
    {
        self destroyAll(self.menu["UI"]); 
        self destroyAll(self.menu["OPT"]);
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        self.menu["isOpen"] = false;
    }

    drawMenu()
    {
        if(!isDefined(self.menu["UI"]))
            self.menu["UI"] = [];
        if(!isDefined(self.menu["UI_TOG"]))
            self.menu["UI_TOG"] = [];    
        if(!isDefined(self.menu["UI_SLIDE"]))
            self.menu["UI_SLIDE"] = [];
        if(!isDefined(self.menu["UI_STRING"]))
            self.menu["UI_STRING"] = [];    
            
        #ifdef XBOX self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "gradient_top", 1, 1);
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
         resizeMenu();
    }

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"]);
    }

    refreshTitle()
    {
        self.menu["UI"]["MENU_TITLE"] settext(level.MenuName);
    }
        
    scrollingSystem()
    {
        if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
        {
            if(self getCursor() <= 0)
                self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
            else if(self getCursor() >= self.eMenu.size)
                self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
        }
        
        self setMenuText();
        self updateScrollbar();
    }

    updateScrollbar()
    {
        curs = (self getCursor() >= 10) ? 9 : self getCursor();  
        self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
        self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);
        
        size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height     = int(15 * size); // 18
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    } 

    setMenuText()
    {
        self endon("disconnect");
        self menuOptions();
        self resizeMenu();

        ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;  
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        
        for(e=0;e<10;e++)
        {
            self.menu["OPT"][e].x = self.presets["X"] + 61; 
            
            if(isDefined(self.eMenu[ ary + e ].opt))
                self.menu["OPT"][e] settext( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] settext("");
                
            if(IsDefined( self.eMenu[ ary + e ].toggle ))
            {
                self.menu["OPT"][e].x += 0; 
                #ifdef XBOX self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ ary + e ].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1); #endif
            }
            if(IsDefined( self.eMenu[ ary + e ].val ))
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1); //BG
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1); //INNER
                if( self getCursor() == ( ary + e ) )
                    self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }
            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }
            if(self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            {
                self.menu["UI_SLIDE"]["SUBMENU"+e] = self createrectangle( "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y, 9, 9, self.presets["Toggle_BG"], "ui_arrow_right", 5, 1);
                self.menu["UI_SLIDE"]["SUBMENU"+e].foreground = true;
            }
        }
    }
        
    resizeMenu()
    {
        size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height = int(15 * size);
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        
        self.menu["UI"]["OPT_BG"] SetShader( "white", 200, height + 1 );
        self.menu["UI"]["OUTLINE"] SetShader( "white", 204, height + 54 );
    }

