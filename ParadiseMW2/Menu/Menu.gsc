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
            {
                self addOpt("Host Options", ::newMenu, "host");
            }
        }
        break;

    // TRICKSHOT MENU
    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+smoke}]", self.NoClipT, ::initNoClip);

            canOpts = strtok("Current;Infinite", ";");
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Rocket Ride",  self.RPGRide, ::ToggleRPGRide);
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
            self addOpt("Third Eye Bind", ::newMenu, "tEye");
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

    case "tEye":
            self addMenu("tEye", "Third Eye Bind");
            self addOpt("Third Eye Bind: [{+actionslot 1}]", ::empbind, 1);
            self addOpt("Third Eye Bind: [{+actionslot 2}]", ::empbind, 2);
            self addOpt("Third Eye Bind: [{+actionslot 3}]", ::empbind, 3);
            self addOpt("Third Eye Bind: [{+actionslot 4}]", ::empbind, 4);
            break;

        case "cwby":
            self addMenu("cwby", "Cowboy Bind");
            self addOpt("Cowboy Bind: [{+actionslot 1}]", ::cowboyBind, 1);
            self addOpt("Cowboy Bind: [{+actionslot 2}]", ::cowboyBind, 2);
            self addOpt("Cowboy Bind: [{+actionslot 3}]", ::cowboyBind, 3);
            self addOpt("Cowboy Bind: [{+actionslot 4}]", ::cowboyBind, 4);
            break;

        case "rcwby":  // Reverse Cowboy Bind submenu
            self addMenu("rcwby", "Reverse Cowboy Bind");
            self addOpt("Reverse Cowboy Bind: [{+actionslot 1}]",  ::rvrsCowboyBind, 1);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 2}]",  ::rvrsCowboyBind, 2);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 3}]",  ::rvrsCowboyBind, 3);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 4}]",  ::rvrsCowboyBind, 4);
            break;

        case "gflip":  // Mid Air GFlip Bind submenu
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind,1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind,2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind,3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind,4);
            break;

        case "nmod":  // Nac Mod Bind submenu
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind,1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind,2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind,3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind,4);
            break;

        case "skree":  // Skree Bind submenu
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind,1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind,2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind,3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind,4);
            break;

        case "cnzm":  // Can Zoom Bind submenu
            self addMenu("cnzm", "Can Zoom Bind");
            self addOpt("Canzoom: [{+actionslot 1}]", ::Canzoom,1);
            self addOpt("Canzoom: [{+actionslot 2}]", ::Canzoom,2);
            self addOpt("Canzoom: [{+actionslot 3}]", ::Canzoom,3);
            self addOpt("Canzoom: [{+actionslot 4}]", ::Canzoom,4);
            break;

        case "cb":  // Change Class Bind submenu
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

    // TELEPORT MENU
    case "tp":  // Teleport Menu
    self addMenu("tp", "Teleport Menu");

    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);

    tpNames = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_crash")
    {
        tpNames   = strTok("Bomb Spawn OOM;Roof Way Out;Hilltop;Great Wall", ";");
        tpCoords  = [
            (524.595, 3381.14, 824.126),
            (-2802.75, -3663.08, 1112.13),
            (6778.43, 1326.18, 715.940),
            (5795.25, -223.995, 584.125)
        ];
    }
    else if(getDvar("mapname") == "mp_overgrown")
    {
        tpNames  = strTok("Water Tower;A Barrier Sui;River Bed Sui", ";");
        tpCoords = [
            (3082.29, -2284.81, 992.126),
            (-1972.75, -1927.23, 992.126),
            (1351.02, 536.997, 992.126)
        ];
    }
    else if(getDvar("mapname") == "mp_storm")
    {
        tpNames  = strTok("A OOM Tower 1;A OOM Tower 2;B OOM Tower 1;Construction Spot", ";");
        tpCoords = [
            (162.407, 3400.21, 1528.14),
            (1362.07, 2732.52, 1068.14),
            (1055.09, -4464.07, 1360.14),
            (-2425, -3082.99, 537.626)
        ];
    }
    else if(getDvar("mapname") == "mp_abandon")
    {
        tpNames  = strTok("Flying Saucer;Overpass;Top of Dome", ";");
        tpCoords = [
            (290.325, 1858.08, 1429.96),
            (677.383, 9410.43, 468.126),
            (-3231.82, -4795.27, 1175.17)
        ];
    }
    else if(getDvar("mapname") == "mp_fuel2")
    {
        tpNames  = strTok("White Tower 1;White Tower 2;Edge of Map", ";");
        tpCoords = [
            (3767.23, -1541.8, 747.095),
            (-2869.46, -92.1384, 1018.86),
            (-11856.7, -4897.51, 1451.46)
        ];
    }
    else if(getDvar("mapname") == "mp_afghan")
    {
        tpNames  = strTok("A Barrier;B Barrier;Cliff Barrier", ";");
        tpCoords = [
            (1507.01, -1331.07, 1296.14),
            (-1435.34, 2687.04, 1296.14),
            (1083.92, 4634.11, 1296.14)
        ];
    }
    else if(getDvar("mapname") == "mp_derail")
    {
        tpNames  = strTok("Yellow Roof;Mountain Ridge;Mountain Peak 1;Mountain Peak 2;Water Tower", ";");
        tpCoords = [
            (-3350.53, -1807.69, 874.126),
            (-6810.06, 856.458, 1872.87),
            (-9719.58, -5325.42, 2553.49),
            (14557.4, -2865.92, 3640.28),
            (-784.772, -1109.62, 695.126)
        ];
    }
    else if(getDvar("mapname") == "mp_estate")
    {
        tpNames  = strTok("A Barrier;B Barrier;Spawn Sui;Hella Far Tree", ";");
        tpCoords = [
            (2415.35, 253.95, 1216.14),
            (1373.09, 4469.03, 1216.14),
            (-4013.6, -1291.56, 1216.14),
            (-712.487, 8924.99, 2038.55)
        ];
    }
    else if(getDvar("mapname") == "mp_favela")
    {
        tpNames  = strTok("A Building OOM;Top of Sign;Defenders Undermap;Attackers Undermap;Jesus Statue;Yellow Building;Cliff Sui", ";");
        tpCoords = [
            (1725.92, -1694.85, 728.126),
            (-1807.83, -504.29, 672.126),
            (-99.8282, -1538.56, -41.876),
            (1813.92, 2064.69, 145.143),
            (9671.63, 18431.6, 13604.1),
            (-7818.56, -514.921, 928.126),
            (-7489.34, -11022.7, 1696.42)
        ];
    }
    else
    {
        tpNames  = strtok("", ";");
        tpCoords = [];
    }

    self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
break;

   case "class":  // Class Menu
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
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
            self addMenu("wpns", "Weapons Classes");
            self addOpt("Submachine Guns", ::newMenu, "smgs");
            self addOpt("Assault Rifles", ::newMenu, "ars");
            self addOpt("Light Machine Guns", ::newMenu, "lmgs");
            self addOpt("Sniper Rifles", ::newMenu, "srs");
            self addOpt("Machine Pistols", ::newMenu, "mps");
            self addOpt("Shotguns", ::newMenu, "sgs");
            self addOpt("Pistols", ::newMenu, "hgs");
            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Special Weapons", ::newMenu, "specs");
            self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "smgs":
            self addMenu("smgs", "Submachine Guns");

            mp5kIDs = strtok("mp5k_mp;mp5k_silencer_mp;mp5k_akimbo_mp", ";");
            mp5kNames = strtok("None;Silencer;Akimbo", ";");
            self addSliderString("MP5K", mp5kIDs, mp5kNames, ::giveUserWeapon);

            ump45IDs = strtok("ump45_mp;ump45_silencer_mp;ump45_akimbo_mp", ";");
            ump45Names = strtok("None;Silencer;Akimbo", ";");
            self addSliderString("UMP45", ump45IDs, ump45Names, ::giveUserWeapon);

            vectIDs = strtok("kriss_mp;kriss_silencer_mp;kriss_akimbo_mp", ";");
            vectNames = strtok("None;Silencer;Akimbo", ";");
            self addSliderString("Vector", vectIDs, vectNames, ::giveUserWeapon);

            p90IDs = strtok("p90_mp;p90_silencer_mp;p90_akimbo_mp", ";");
            p90Names = strtok("None;Silencer;Akimbo", ";");
            self addSliderString("P90", p90IDs, p90Names, ::giveUserWeapon);

            uziIDs = strtok("uzi_mp;uzi_silencer_mp;uzi_akimbo_mp", ";");
            uziNames = strtok("None;Silencer;Akimbo", ";");
            self addSliderString("Mini-Uzi", uziIDs, uziNames, ::giveUserWeapon);
            break;

        case "ars":
            self addMenu("ars", "Assault Rifles");
            
            m4a1IDs = strtok("m4_mp;m4_gl_mp;m4_silencer_mp;m4_shotgun_mp", ";");
            m4a1Names = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("M4A1", m4a1IDs, m4a1Names, ::giveUserWeapon);

            famasIDs = strtok("famas_mp;famas_gl_mp;famas_silencer_mp;famas_shotgun_mp", ";");
            famasNames = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("Famas", famasIDs, famasNames, ::giveUserWeapon);

            scarIDs = strtok("scar_mp;scar_gl_mp;scar_silencer_mp;scar_shotgun_mp", ";");
            scarNames = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("SCAR-H", scarIDs, scarNames, ::giveUserWeapon);

            t21IDs = strtok("tavor_mp;tavor_gl_mp;tavor_silencer_mp;tavor_shotgun_mp", ";");
            t21Names = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("TAR-21", t21IDs, t21Names, ::giveUserWeapon);

            falIDs = strtok("fal_mp;fal_gl_mp;fal_silencer_mp;fal_shotgun_mp", ";");
            falNames = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("FAL", falIDs, falNames, ::giveUserWeapon);

            m16IDs = strtok("m16_mp;m16_gl_mp;m16_silencer_mp;m16_shotgun_mp", ";");
            m16Names = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("M16A4", m16IDs, m16Names, ::giveUserWeapon);

            acrIDs = strtok("masada_mp;masada_gl_mp;masada_silencer_mp;masada_shotgun_mp", ";");
            acrNames = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("ACR", acrIDs, acrNames, ::giveUserWeapon);

            f2kIDs = strtok("fn2000_mp;fn2000_gl_mp;fn2000_silencer_mp;fn2000_shotgun_mp", ";");
            f2kNames = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("F2000", f2kIDs, f2kNames, ::giveUserWeapon);

            ak47IDs = strtok("ak47_mp;ak47_gl_mp;ak47_silencer_mp;ak47_shotgun_mp", ";");
            ak47Names = strtok("None;Grenade Launcher;Silencer;Shotgun", ";");
            self addSliderString("AK-47", ak47IDs, ak47Names, ::giveUserWeapon);
            break;

        case "sgs":
            self addMenu("sgs", "Shotguns");

            spasIDs = strtok("spas12_mp;spas12_silencer_mp;spas12_grip_mp;spas12_fmj_mp", ";");
            spasNames = strtok("None;Silencer;Grip;FMJ", ";");
            self addSliderString("SPAS-12", spasIDs, spasNames, ::giveUserWeapon);

            aa12IDs = strtok("aa12_mp;aa12_silencer_mp;aa12_grip_mp;aa12_fmj_mp", ";");
            aa12Names = strtok("None;Silencer;Grip;FMJ", ";");
            self addSliderString("AA-12", aa12IDs, aa12Names, ::giveUserWeapon);

            strkrIDs = strtok("striker_mp;striker_silencer_mp;striker_grip_mp;striker_fmj_mp", ";");
            strkrNames = strtok("None;Silencer;Grip;FMJ", ";");
            self addSliderString("Striker", strkrIDs, strkrNames, ::giveUserWeapon);

            rngrIDs = strtok("ranger_mp;ranger_akimbo_mp;ranger_fmj_mp", ";");
            rngrNames = strtok("None;Akimbo;FMJ", ";");
            self addSliderString("Ranger", rngrIDs, rngrNames, ::giveUserWeapon);

            m1014IDs = strtok("m1014_mp;m1014_silencer_mp;m1014_grip_mp;m1014_fmj_mp", ";");
            m1014Names = strtok("None;Silencer;Grip;FMJ", ";");
            self addSliderString("M1014", m1014IDs, m1014Names, ::giveUserWeapon);

            m1887IDs = strtok("model1887_mp;model1887_akimbo_mp;model1887_fmj_mp", ";");
            m1887Names = strtok("None;Akimbo;FMJ", ";");
            self addSliderString("Model 1887", m1887IDs, m1887Names, ::giveUserWeapon);
            break;

        case "lmgs":
            self addMenu("lmgs", "Light Machine Guns");

            l86IDs = strtok("sa80_mp;sa80_silencer_mp;sa80_thermal_mp", ";");
            l86Names = strtok("None;Silencer;Thermal", ";");
            self addSliderString("L86 LSW", l86IDs, l86Names, ::giveUserWeapon);

            rpdIDs = strtok("rpd_mp;rpd_silencer_mp;rpd_thermal_mp", ";");
            rpdNames = strtok("None;Silencer;Thermal", ";");
            self addSliderString("RPD", rpdIDs, rpdNames, ::giveUserWeapon);

            mg4IDs = strtok("mg4_mp;mg4_silencer_mp;mg4_thermal_mp", ";");
            mg4Names = strtok("None;Silencer;Thermal", ";");
            self addSliderString("MG4", mg4IDs, mg4Names, ::giveUserWeapon);

            augIDs = strtok("aug_mp;aug_silencer_mp;aug_thermal_mp", ";");
            augNames = strtok("None;Silencer;Thermal", ";");
            self addSliderString("AUG HBAR", augIDs, augNames, ::giveUserWeapon);

            m240IDs = strtok("m240_mp;m240_silencer_mp;m240_thermal_mp", ";");
            m240Names = strtok("None;Silencer;Thermal", ";");
            self addSliderString("M240", m240IDs, m240Names, ::giveUserWeapon);
            break;

        case "srs":
            self addMenu("srs", "Sniper Rifles");

            intrIDs = strtok("cheytac_mp;cheytac_silencer_mp;cheytac_fmj_mp;cheytac_heartbeat_mp;cheytac_thermal_mp", ";");
            intrNames = strtok("None;Silencer;FMJ;Heartbeat Sensor;Thermal", ";");
            self addSliderString("Intervention", intrIDs, intrNames, ::giveUserWeapon);

            b50calIDs = strtok("barrett_mp;barrett_silencer_mp;barrett_fmj_mp;barrett_heartbeat_mp;barrett_thermal_mp", ";");
            b50calNames = strtok("None;Silencer;FMJ;Heartbeat Sensor;Thermal", ";");
            self addSliderString("Barrett .50cal", b50calIDs, b50calNames, ::giveUserWeapon);

            wa2kIDs = strtok("wa2000_mp;wa2000_silencer_mp;wa2000_fmj_mp;wa2000_heartbeat_mp;wa2000_thermal_mp", ";");
            wa2kNames = strtok("None;Silencer;FMJ;Heartbeat Sensor;Thermal;Iron Sight", ";");
            self addSliderString("WA2000", wa2kIDs, wa2kNames, ::giveUserWeapon);

            m21ebrIDs = strtok("m21_mp;m21_silencer_mp;m21_fmj_mp;m21_heartbeat_mp;m21_thermal_mp", ";");
            m21ebrNames = strtok("None;Silencer;FMJ;Heartbeat Sensor;Thermal", ";");
            self addSliderString("M21 EBR", m21ebrIDs, m21ebrNames, ::giveUserWeapon);
            break;

        case "mps":
            self addMenu("mps", "Machine Pistols");

            pp2kIDs = strtok("pp2000_mp;pp2000_silencer_mp;pp2000_akimbo_mp;pp2000_eotech", ";");
            pp2kNames = strtok("None;Silencer;Akimbo;Holographic Sight", ";");
            self addSliderString("PP2000", pp2kIDs, pp2kNames, ::giveUserWeapon);

            g18IDs = strtok("glock_mp;glock_silencer_mp;glock_akimbo_mp;glock_eotech", ";");
            g18Names = strtok("None;Silencer;Akimbo;Holographic Sight", ";");
            self addSliderString("G18", g18IDs, g18Names, ::giveUserWeapon);

            m93IDs = strtok("beretta393_mp;beretta393_silencer_mp;beretta393_akimbo_mp;beretta393_eotech", ";");
            m93Names = strtok("None;Silencer;Akimbo;Holographic Sight", ";");
            self addSliderString("M93 Raffica", m93IDs, m93Names, ::giveUserWeapon);

            tmpIDs = strtok("tmp_mp;tmp_silencer_mp;tmp_akimbo_mp;tmp_eotech", ";");
            tmpNames = strtok("None;Silencer;Akimbo;Holographic Sight", ";");
            self addSliderString("TMP", tmpIDs, tmpNames, ::giveUserWeapon);
            break;

        case "hgs":
            self addMenu("hgs", "Pistols");

            usp45IDs = strtok("usp_mp;usp_silencer_mp;usp_akimbo_mp;usp_tactical_mp", ";");
            usp45Names = strtok("None;Silencer;Akimbo;Tactical Knife", ";");
            self addSliderString("USP .45", usp45IDs, usp45Names, ::giveUserWeapon);

            magnumIDs = strtok("coltanaconda_mp;coltanaconda_akimbo_mp;coltanaconda_tactical_mp", ";");
            magnumNames = strtok("None;Akimbo;Tactical Knife", ";");
            self addSliderString(".44 Magnum", magnumIDs, magnumNames, ::giveUserWeapon);

            m9IDs = strtok("beretta_mp;beretta_silencer_mp;beretta_akimbo_mp;beretta_tactical_mp", ";");
            m9Names = strtok("None;Silencer;Akimbo;Tactical Knife", ";");
            self addSliderString("M9", m9IDs, m9Names, ::giveUserWeapon);

            deagleIDs = strtok("deserteagle_mp;deserteagle_akimbo_mp;deserteagle_tactical_mp", ";");
            deagleNames = strtok("None;Akimbo;Tactical Knife", ";");
            self addSliderString("Desert Eagle", deagleIDs, deagleNames, ::giveUserWeapon);
            break;

        case "lnchrs":
            self addMenu("lnchrs", "Launchers");
            self addOpt("AT4-HS", ::giveUserWeapon, "at4");
            self addOpt("Thumper", ::giveUserWeapon, "m79");
            self addOpt("Stinger", ::giveUserWeapon, "stinger");
            self addOpt("Javelin", ::giveUserWeapon, "javelin");
            self addOpt("RPG-7", ::giveUserWeapon, "rpg");
            break;

        case "specs":
            self addMenu("specs", "Special Weapons");
            self addOpt("Gold Desert Eagle", ::giveUserWeapon, "deserteaglegold", false);
            self addOpt("Akimbo Thumper", ::giveUserWeapon, "m79", true);
            self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon", false);
            self addOpt("Akimbo Default Weapon", ::giveUserWeapon, "defaultweapon", true);
            self addOpt("OMA Bag", ::giveUserWeapon, "onemanarmy", false);
            self addOpt("Dual OMA Bag", ::giveUserWeapon, "onemanarmy", true);
            break;

        case "camos":
            self addMenu("camos", "Camos");
            self addOpt("Remove Camo", ::changeCamo, 0);
            self addOpt("Random Camo", ::randomCamo);
            self addOpt("Desert", ::changeCamo, 2);
            self addOpt("Arctic", ::changeCamo, 3);
            self addOpt("Woodland", ::changeCamo, 1);
            self addOpt("Digital", ::changeCamo, 4);
            self addOpt("Urban", ::changeCamo, 5);
            self addOpt("Blue Tiger", ::changeCamo, 7);
            self addOpt("Red Tiger", ::changeCamo, 6);
            self addOpt("Fall", ::changeCamo, 8);
            break;

        case "lethals":
            self addMenu("lethals", "Equipment");
            self addOpt("Frag", ::giveUserLethal, "frag_grenade_mp");
            self addOpt("Semtex", ::giveUserLethal, "sticky_grenade_mp");
            self addOpt("Throwing Knife", ::giveUserLethal, "throwingknife_mp");
            self addOpt("RH Throwing Knife", ::rhThrowingKnife);
            self addOpt("Tactical Insertion", ::giveUserLethal, "flare_mp");
            self addOpt("Blast Shield");
            self addOpt("Claymore", ::giveUserLethal, "claymore_mp");
            self addOpt("C4", ::giveUserLethal, "c4_mp");
            self addOpt("Glowstick", ::giveUserLethal, "lightstick_mp");
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            self addOpt("Flash Grenade", ::giveUserTactical, "flash_grenade_mp");
            self addOpt("Stun Grenade", ::giveUserTactical, "concussion_grenade_mp");
            self addOpt("Smoke Grenade", ::giveUserTactical, "smoke_grenade_mp");
            break;

        case "afthit":  // Afterhits Menu
            self addMenu("afthit", "Afterhits Menu");

            arIDs = strtok("tar21_mp;type95_mp;sig556_mp;sa58_mp;hk416_mp;scar_mp;saritch_mp;xm8_mp;ak47_mp", ";");
            arNames = strtok("m4a1;Type 95;Swat 556;t21 OSW;fal;Scar-H;acr;f2k;AN-94", ";");
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = strtok("mp7_mp;pdw57_mp;vector_mp;insas_mp;qcw05_mp;evoskorpion_mp;peacekeeper_mp", ";");
            smgNames = strtok("MP7;PDW-57;Vecto K10;MSMC;Chicom CQB;Skorpion EVO;Peackeeper", ";");
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            sgIDs = strtok("870mcs_mp;saiga12_mp;m1887_mp;srm101416_mp", ";");
            sgNames = strtok("Remington 870 MCS;aa12;m1887;m101416", ";");
            self addSliderString("Shotguns", sgIDs, sgNames, ::afterhit);

            lmgIDs = strtok("l86_mp;rpd95_mp;mg4_mp;aug_mp", ";");
            lmgNames = strtok("l86;rpd LSW;mg4;aug", ";");
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = strtok("intr_mp;b50cal50_mp;wa2k_mp;m21ebr_mp", ";");
            srNames = strtok("intr-AS;b50cal-50;wa2k;XPR-50", ";");
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            pstlsIDs = strtok("kard_dw_mp;fnp45_dw_mp;fiveseven_dw_mp;judge_dw_mp;beretta93r_dw_mp;fiveseven_mp;fnp45_mp;beretta93r_mp;judge_mp;kard_mp", ";");
            pstlsNames = strtok("Dual Kap-40;Dual Tac-45;Dual Five Seven;Dual deagleutioner;Dual m9;Five Seven;Tac-45;m9;deagleutioner;Kap-40", ";");
            self addSliderString("Pistols", pstlsIDs, pstlsNames, ::afterhit);

            lnchrsIDs = strtok("m32_mp;smaw_mp;fhj18_mp;usrpg_mp", ";");
            lnchrsNames = strtok("War Machine;SMAW;FHJ-18;RPG", ";");
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            specIDs = strtok("knife_held_mp;defaultweapon_mp;minigun_mp;riotshield_mp;crossbow_mp;knife_ballistic_mp;briefcase_bomb_mp;claymore_mp;destructible_car_mp", ";");
            specNames = strtok("CSGO Knife;Default Weapon;Death Machine;Riot Shield;Crossbow;Ballistic Knife;Bomb;Claymore;Car", ";");
            self addSliderString("Special Weapons", specIDs, specNames, ::afterhit);
            break;

        case "kstrks": //Killstreak Menu
            self addMenu("kstrks", "Killstreak Menu"); 
            self addOpt("UAV", ::doKillstreak, "uav");
            self addOpt("Care Package", ::doKillstreak, "airdrop");
            self addOpt("Counter-UAV", ::doKillstreak, "counter_uav");
            self addOpt("Sentry Gun", ::doKillstreak, "sentry");
            self addOpt("Predator Missile", ::doKillstreak, "predator_missile");
            self addOpt("Emergency Airdrop", ::doKillstreak, "mega_airdrop");//
            self addOpt("Chopper Gunner", ::doKillstreak, "chopper_gunner");//
            self addOpt("AC130", ::doKillstreak, "ac130");
            self addOpt("EMP", ::doKillstreak, "emp");
            break;

        case "host":  // Host Options (host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addOpt("Toggle Floaters", ::togglelobbyfloat);
            
            hostActions = strTok("Fast Restart;End Game", ";");     
            hostIDs     = strTok("FastRestart;debugexit", ";");  
            self addSliderString("Restart/End", hostIDs, hostActions, ::doHostAction);

            self addOpt("Ladder Bounce", ::reverseladders);
            self addOpt("Add 1 Minute", ::editTime, "add");
            self addOpt("Remove 1 Minute", ::editTime, "subtract");
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
        self addMenu("Verify",  "Client Menu");
        foreach( player in level.players )
        {
            if(!player.pers["isBot"])
            self addOpt(player getname(), ::newmenu, "Verify_" + player getentitynumber());
        }
        foreach(player in level.players)
        {
            if(!player.pers["isBot"])
            {
                self addMenu("Verify_" + player getentitynumber(), player getName());
                for(e=0;e<level.status.size-1;e++)
                    self addOpt("Kick Player", ::kickSped, player);
                    self addOpt("Ban Player", ::banSped, player);  
                    self addOpt("Teleport to Croshairs", ::teleportToCrosshair, player);  
            }
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
                            self.menu["OPT"]["MENU_TITLE"] setSafeText( self.menuTitle + " ("+ player getName() +")");    
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
            
        #ifdef XBOX self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "gradient_top", 1, 1);
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
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
        self.menu["UI"]["MENU_TITLE"] setSafeText(level.MenuName);
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
                self.menu["OPT"][e] setSafeText( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] setSafeText("");
                
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
