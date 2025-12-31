    pmapname()
    {
        self iprintln("^1" + getdvar("mapname"));
    }

    porigin()
    {
        self iprintln("^1" + self getorigin());
    }
    
    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];
        foreach( players in level.players )
            player_names[player_names.size] = players.name;

        switch( menu )
        {
            case "main":
        if(self.access > 0)
        {
            self addMenu("main", "Main Menu");
            self addOpt("Print map name", ::pmapname);
            self addOpt("Print origin", ::porigin);
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

    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

        if(level.currentGametype == "dm")
            self addOpt("Go for Two Piece", ::dotwopiece);

            canOpts = "Current;Infinite";
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = "Bounce;Platform;Crate";
            spawnOptionsIDs     = "bounce;platform;crate";
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

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
            break;

    case "tp":
    self addMenu("tp", "Teleport Menu");

    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);
      
    tpNames = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_prisonbreak")
    {
        tpNames = "Hilltop 1;Hilltop 2;Waterfall;Distance Cliff 1;Distance Cliff 2;Distance Cliff 3";
        tpCoords = [
            (-5591.67, -912.814, 1947.81),
            (-6375.85, 2558.38, 2150.17),
            (-6714.49, 902.8, 1524.04),
            (-15714.5, 15693.3, 8406.34),
            (-21353.4, 11285.6, 6681.67),
            (-12926.6, -22831.8, 6063.3)
        ];
    }
    else if(getDvar("mapname") == "mp_lonestar")
    {
        tpNames = "Parking Garage Roof;";
        tpCoords = [
            (67.2244, 1788.87, 580.968)
        ];
    }
    else if(getDvar("mapname") == "mp_frag")
    {
        tpNames = "Owens Roof";
        tpCoords = [
            (-348.583, 1487.86, 921.125)
        ];
    }
    else if(getDvar("mapname") == "mp_fahrenheit")
    {
        tpNames = "Library Roof 1;Library Roof 2;Superty Union Roof;Health Center Roof";
        tpCoords = [
            (163.791, -2001, 1669.13),
            (938.147, -2729.1, 1724.02),
            (-1001.32, -4689.84, 1834.64),
            (-3062.36, -1650.35, 1057.13)
        ];
    }
    else if(getDvar("mapname") == "mp_hashima")
    {
        tpNames = "Complex Roof;Complex Ledge;Warehouse Roof";
        tpCoords = [
            (-2657.33, 4851.85, 1457.13),
            (-735.619, 5113.88, 1131.02),
            (-675.734, -832.674, 1386.13)
        ];
    }
    else if(getDvar("mapname") == "mp_sovereign")
    {
        tpNames = "Roof 1;Roof 2;Roof 3";
        tpCoords = [
            (921.323, 1245.21, 839.125),
            (1792.56, 1984.58, 579.125),
            (1765.35, 5621.11, 1008.12)
        ];
    }
    else if(getDvar("mapname") == "mp_chasm")
    {
        tpNames = "Glass Tower Roof";
        tpCoords = [
            (-4548.54, -2674.93, 3137.13)
        ];
    }
    else if(getDvar("mapname") == "mp_flooded")
    {
        tpNames = "Parking Garage Roof;Brown Building Roof;Crane;Distance Roof";
        tpCoords = [
            (62.4653, -925.004, 1377.13),
            (1488.8, -933.495, 1031.13),
            (-288.774, 344.85, 2478.46),
            (2629.91, 7134.45, 1358.13)
        ];
    }
    else if(getDvar("mapname") == "mp_strikezone")
    {
        tpNames = "Greenway Park Sign;Parking Garage Roof;Greenway Park Roof";
        tpCoords = [
            (-6674.71, -2467.74, 2455.93),
            (2277.63, 2751.49, 780.125),
            (-509.322, -449.98, 769.125)
        ];
    }
    else if(getDvar("mapname") == "mp_ca_rumble")
    {
        tpNames = "Aquarium Roof";
        tpCoords = [
            (1990.67, 1944.31, 722.806)
        ];
    }
    else if(getDvar("mapname") == "mp_swamp")
    {
        tpNames = "Top of Bridge;Treetop";
        tpCoords = [
            (2725.12, -107.887, 414.967),
            (2196.31, -508.024, 1223.93)
        ];
    }
    else if(getDvar("mapname") == "mp_boneyard_ns")
    {
        tpNames = "#3 Roof;";
        tpCoords = [
            (264.148, -783.875, 1147.13)
        ];
    }
    /*
    else if(getDvar("mapname") == "")
    {
        tpNames = "";
        tpCoords = [

        ];
    }
    */
    else
    {
        tpNames  = "No Custom Spots";
        tpCoords = [];
    }

    self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
    break;

   case "class":
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "atchmnts");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Equipment", ::newMenu, "lethals");
            self addOpt("Special Grenades", ::newMenu, "tacticals");
            self addToggle("Save Loadout", self.saveLoadoutEnabled, ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons Menu");

            arIDs = "dlcweap01_mp;sc2010_mp;bren_mp;ak12_mp;fads_mp;r5rgp_mp;msbs_mp;honeybadger_mp;arx160_mp";
            arNames = "Maverick;SC-2010;SA-805;AK-12;FAD;Remington R5;MSBS;Honey Badger;ARX-160";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = "pp19_mp;cbjms_mp;kriss_mp;vepr_mp;k7_mp;microtar_mp;dlcweap02_mp_dlcweap02scope;dlcweap02_mp";
            smgNames = "Bizon;CBJ-MS;Vector CRB;Vepr;K7;MTAR-X;Ripper;Sightless Ripper";
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgIDs = "ameli_mp;m27_mp;lsat_mp;kac_mp";
            lmgNames = "Ameli;M27-IAR;LSAT;Chain SAW";
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            mrksmanIDs = "g28_mp_g28scope;g28_mp;mk14_mp_mk14scope;mk14_mp;imbel_mp_imbelscope;imbel_mp;svu_mp_svuscope;svu_mp";
            mrksmanNames = "MR-28;Scopeless MR-28;MK14 EBR;Scopeless MK14-EBR;IA-2;Scopeless IA-2;SVU;Scopeless SVU";
            self addSliderstring("Marksman Rifles", mrksmanIDs, mrksmanNames, ::giveUserWeapon);

            srIDs = "dlcweap03_mp_dlcweap03scope;dlcweap03_mp;usr_mp_usrscope;usr_mp;l115a3_mp_l115a3scope;_l115a3_mp;gm6_mp_gm6scope;gm6_mp;vks_mp_vksscope;vks_mp";
            srNames = "Maverick-A2;Scopeless Maverick-A2;USR;Scopeless USR;L115;Scopless L115;Lynx;Scopeless Lynx;VKS;Scopeless VKS";
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            sgIDs = "maul_mp;fp6_mp;mts255_mp;uts15_mp";
            sgNames = "Bulldog;FP6;MTS-255;Tac 12";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            pstlIDs = "m9a1_mp;mp443_mp;p226_mp;magnum_mp;magnumhorde_mp;pdw_mp;pdwauto_mp";
            pstlNames = "M9A1;MP-443 Grach;P226;.44 Magnum;Wild Widow;PDW;Gold PDW";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            lnchrIDs = "rgm_mp;panzerfaust3_mp;mk32_mp;mk32horde_mp;maaws_mp";
            lnchrNames = "Kastet;Panzerfaust;MK32;MK32 Single Shot;MAAWS";
            self addSliderstring("Launchers", lnchrIDs, lnchrNames, ::giveUserWeapon);

            specIDs = "knifeonly_mp;knifeonlyfast_mp;minigun_mp";
            specNames = "Combat Knife;Gold Knife;Minigun";
            self addSliderstring("Specials", specIDs, specNames, ::giveUserWeapon);

            self addOpt("Default Weapon", ::giveselfweapon, "defaultweapon_mp");

            self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "atchmnts":
            self addMenu("atchmnts", "Attachments");
            
            attachmentIDs = [];
            attachmentNames = [];
            for(a=0;a<attachmentIDs.size;a++)
            self addOpt( attachmentNames[a], ::GivePlayerAttachment, attachmentIDs[a]);
            break;

        case "camos":
            self addMenu("camos", "Camos");          
            self addOpt("Random Camo", ::randomCamo);
            
            #ifdef STEAM
            self addOpt("Base Camos", ::newMenu, "base");
            self addOpt("Treyarch Camos", ::newMenu, "3arc");
            self addOpt("Infinity Ward Camos", ::newMenu, "iw");
            self addOpt("Minecraft Camos", ::newMenu, "mc");
            self addOpt("Extra Camos", ::newMenu, "xtra");
            self addOpt("Animated Camos", ::newMenu, "anim");
            self addOpt("Test Camos", ::newMenu, "test");
            break;

        case "base":
            self addMenu("base", "Base Camos");
            camos = [];
            for(a=0;a<9;a++)
            self addOpt(camos[a], ::changeCamo, a );
        break;

        case "3arc":
            self addMenu("3arc", "Treyarch Camos");
            camoNames = ["Ghosts", "Seducer"];
            camoIDs = ["ghosts", "sdcr"];
            for(a=0;a<camoNames.size;a++)
            self addOpt(camoNames[a], ::customCamos, camoIDs[a]);
        break;

        case "iw":
            self addMenu("iw", "Infinity Ward Camos");
            camoNames = ["Comic", "Damascus", "Bloodshot", "Obsidian", "Purple Obsidian", "Spectrum"];
            camoIDs = ["Comic", "dmscs", "lat", "obsid", "prplob", "Spectrum"];
            for(a=0;a<camoNames.size;a++)
            self addOpt(camoNames[a], ::customCamos, camoIDs[a]);
        break;

        case "xtra":
            self addMenu("xtra", "Extra Camos");
            camoNames = ["Acid v2", "Coco", "Galaxy", "Slime", "Toxic", "Waffle", "Xmas"];
            camoIDs = ["acidv2", "Coco", "galaxy", "Slime", "Toxic", "Waffle", "Xmas"];
            for(a=0;a<camoNames.size;a++)
            self addOpt(camoNames[a], ::customCamos, camoIDs[a]);
        break;

        case "mc":
            self addMenu("mc", "Minecraft Camos");
            camoNames = ["Coal Ore", "Iron Ore", "Redstone Ore", "Gold Ore", "Lapis Ore", "Diamond Ore", "Emerald Ore", "Creeper Skin"];
            camoIDs = ["MCCoal", "MCIron", "MCRed", "MCGold", "MCLap", "MCDia", "MCEm", "MCCreep"];
            for(a=0;a<camoNames.size;a++)
            self addOpt(camoNames[a], ::customCamos, camoIDs[a]);
        break;

        case "anim":
            self addMenu("anim", "Animated Camos");
            camoNames = ["Ghosts", "Temple", "Seducer", "Molten"];
            camoIDs = ["animGhosts", "animTemp", "animSdcr", "animMolten"];
            for(a=0;a<camoNames.size;a++)
            self addOpt(camoNames[a], ::randomAnimCamo, camoIDs[a]);
        break;

        case "test":
            self addMenu("test", "Test Camos");
            camoNames = ["abs1", "bbgtgr", "blobsid", "blrltgr", "blupal", "bo3aowgl", "bo3aow", "coral", "ffood", "graf", "grpal", "jack", "mlg", "mop", "nb4c", "paradise", "prplpal", "rpal", "space", "tgh2", "tgh", "trxgic", "wf1", "wf2", "wfnewTEST", "wfnew"];
            camoIDs = ["abs1", "bbgtgr", "blobsid", "blrltgr", "blupal", "bo3aowgl", "bo3aow", "coral", "ffood", "graf", "grpal", "jack", "mlg", "mop", "nb4c", "paradise", "prplpal", "rpal", "space", "tgh2", "tgh", "trxgic", "wf1", "wf2", "wfnewTEST", "wfnew"];
            for(a=0;a<camoNames.size;a++)
            self addOpt(camoNames[a], ::customCamos, camoIDs[a]);
        break;
            #endif

        case "lethals":
            self addMenu("lethals", "Equipment");
            self addOpt("Frag", ::GiveEquipment, "frag_grenade_mp");
            self addOpt("Semtex", ::GiveEquipment, "semtex_mp");
            self addOpt("Throwing Knife", ::GiveEquipment, "throwingknife_mp");
            self addOpt("Tactical Insertion", ::GiveEquipment, "flare_mp");
            self addOpt("Claymore", ::GiveEquipment, "claymore_mp");
            self addOpt("C4", ::GiveEquipment, "c4_mp");
            break;

        case "tacticals":
            self addMenu("tacticals", "Special Grenades");
            self addOpt("Flash Grenade", ::GiveSecondaryOffhand, "flash_grenade_mp");
            self addOpt("Stun Grenade", ::GiveSecondaryOffhand, "concussion_grenade_mp");
            self addOpt("Smoke Grenade", ::GiveSecondaryOffhand, "smoke_grenade_mp");
            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            arIDs = "dlcweap01_mp;sc2010_mp;bren_mp;ak12_mp;fads_mp;r5rgp_mp;msbs_mp;honeybadger_mp;arx160_mp";
            arNames = "Maverick;SC-2010;SA-805;AK-12;FAD;Remington R5;MSBS;Honey Badger;ARX-160";
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = "pp19_mp;cbjms_mp;kriss_mp;vepr_mp;k7_mp;microtar_mp;dlcweap02_mp_dlcweap02scope;dlcweap02_mp";
            smgNames = "Bizon;CBJ-MS;Vector CRB;Vepr;K7;MTAR-X;Ripper;Sightless Ripper";
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            lmgIDs = "ameli_mp;m27_mp;lsat_mp;kac_mp";
            lmgNames = "Ameli;M27-IAR;LSAT;Chain SAW";
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            mrksmanIDs = "g28_mp_g28scope;g28_mp;mk14_mp_mk14scope;mk14_mp;imbel_mp_imbelscope;imbel_mp;svu_mp_svuscope;svu_mp";
            mrksmanNames = "MR-28;Scopeless MR-28;MK14 EBR;Scopeless MK14-EBR;IA-2;Scopeless IA-2;SVU;Scopeless SVU";
            self addSliderstring("Marksman Rifles", mrksmanIDs, mrksmanNames, ::afterhit);

            srIDs = "dlcweap03_mp_dlcweap03scope;dlcweap03_mp;usr_mp_usrscope;usr_mp;l115a3_mp_l115a3scope;_l115a3_mp;gm6_mp_gm6scope;gm6_mp;vks_mp_vksscope;vks_mp";
            srNames = "Maverick-A2;Scopeless Maverick-A2;USR;Scopeless USR;L115;Scopless L115;Lynx;Scopeless Lynx;VKS;Scopeless VKS";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            sgIDs = "maul_mp;fp6_mp;mts255_mp;uts15_mp";
            sgNames = "Bulldog;FP6;MTS-255;Tac 12";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::afterhit);

            pstlIDs = "m9a1_mp;mp443_mp;p226_mp;magnum_mp;magnumhorde_mp;pdw_mp;pdwauto_mp";
            pstlNames = "M9A1;MP-443 Grach;P226;.44 Magnum;Wild Widow;PDW;Gold PDW";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::afterhit);

            lnchrIDs = "rgm_mp;panzerfaust3_mp;mk32_mp;mk32horde_mp;maaws_mp";
            lnchrNames = "Kastet;Panzerfaust;MK32;MK32 Single Shot;MAAWS";
            self addSliderString("Launchers", lnchrIDs, lnchrNames, ::afterhit);

            miscIDs = "knifeonly_mp;knifeonlyfast_mp;minigun_mp";
            miscNames = "Combat Knife;Gold Knife;Minigun";
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu"); 
            
            Killstreak = [];
            for(a=0;a<level.killstreaks.size;a++)
            self addOpt( Killstreak[a], ::doKillstreak, level.killstreaks[a] );

            if(self ishost() || self isdeveloper())
                self addOpt("Killcam Nuke", ::fakenuke);
            break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);

            minDistVal = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);

            timeActions = ["Add 1 Minute","Remove 1 Minute"];
            timeIDs = ["add","sub"];
            self addSliderString("Game Timer", timeIDs, timeActions, ::changeTime);

            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);

            botOptNames = ["TP to Crosshairs","Spawn 18 Bots","Kick All Bots"];
            botOptIDs = ["teleport","fill","kick"];
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);

            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
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
                    if( self isButtonPressed("+actionslot 2") && self adsButtonPressed() )
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
                            self.menu["OPT"]["MENU_TITLE"] setsafetext( self.menuTitle + " ("+ player getName() +")");    
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
            
        self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "gradient_top", 1, 1);
        self.menu["UI"]["MENU_TITLE"] = self createtext("default", 2, "TOPLEFT", "CENTER", self.presets["X"] + 103, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
        self resizeMenu();
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
        self.menu["UI"]["MENU_TITLE"] setsafetext(level.MenuName);
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
                self.menu["OPT"][e] setsafetext( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] setsafetext("");
                
            if(IsDefined( self.eMenu[ ary + e ].toggle ))
            {
                self.menu["OPT"][e].x += 0; 
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ ary + e ].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1);
            }
            if(IsDefined( self.eMenu[ ary + e ].val ))
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1); //BG
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1); //INNER
                if( self getCursor() == ( ary + e ) )
                    self.menu["UI_SLIDE"]["VAL"] = self createText("default", 0.8, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }
            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 0.8, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"]);
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
