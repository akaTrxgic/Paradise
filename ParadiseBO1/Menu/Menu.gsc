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

    case "test":
        self addMenu("test", "Test Menu");

    // TRICKSHOT MENU
    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+smoke}]", self.UFOMode, ::UFOMode);

            canOpts = strtok("Current;Infinite", ";");
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);

            self addToggle("Rocket Ride",  self.RPGRide, ::ToggleRPGRide);
            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = strTok("Bounce;Platform;Crate", ";");
            spawnOptionsIDs     = strTok("bounce;platform;crate", ";");
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            break;

    // BINDS MENU
    case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Cowboy Bind", ::newMenu, "cwby");
            self addOpt("Reverse Cowboy Bind", ::newMenu, "rcwby");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
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
            self addOpt("Set Spawn",::setSpawn);
            self addOpt("Unset Spawn", ::unsetSpawn);
            self addToggle("Save & Load", self.snl, ::saveandload);
        
    tpnames = [];
    tpCoords = [];

   if (getDvar("mapname") == "mp_array")
    {
        tpNames = strtok("Satellite Barrier;Platform OOM;End of Road Sui", ";");
        tpCoords = [
            (-2911.79, 1275.46, 967.126),
            (-3693.71, 12239.5, 3943.98),
            (-4316.74, 4201.55, 558.828)
        ];
    } 
    else if (getDvar("mapname") == "mp_firingrange") 
    {
        tpNames = strtok("Guard Tower 1;Guard Tower 2;Trailer Sign", ";");
        tpCoords = [
            (-1498.27, -2445.87, 351.149),
            (3215.73, -976.481, 320.606),
            (150.43, 2682.4, 473.125)
        ];
        
    }
    else if (getDvar("mapname") == "mp_nuked") 
    {
        tpNames = strtok("Nuke Tower;Where TF Am I;Backyard", ";");
        tpCoords = [
            (3722.89, 12221.2, 3779.54),
            (-176.716, -8530.06, 3101.12),
            (-6044.9, 840.61, 2905.33)
        ];
        
    } 
    else if (getDvar("mapname") == "mp_cracked") 
    {
        tpNames = strtok("Spawn Barrier;Platform;Spawn Barrier 2", ";");
        tpCoords = [
            (1667.4, -4.04464, 1185.13),
            (-1746.1, -4883.62, 575.742),
            (-3532.51, 1.30511, 1185.13)
        ];
        
    }
    else if (getDvar("mapname") == "mp_crisis") 
    {
        tpNames = strtok("Spawn Platform 1;Spawn Platform 2;Tower Spot", ";");
        tpCoords = [
            (-5748.65, 415.442, 1786.82),
            (10115.2, 424.233, 4230.95),
            (-2649.62, -41.9161, 1158.6)
        ];
        
    }
    else if (getDvar("mapname") == "mp_duga") 
    {
        tpNames = strtok("Transmission Tower;Bunker Spot;Barrier Spot", ";");
        tpCoords = [
            (108.001, 2328.06, 3248.2),
            (-3508.49, -1569.76, 265.125),
            (-2631.85, -5976.45, 2497.13)
        ];
        
    }
    else if (getDvar("mapname") == "mp_hanoi") 
    {
        tpNames = strtok("Barrier Spot 1;Barrier Spot 2;Barrier Spot 3", ";");
        tpCoords = [
            (-410.636, -3174.41, 1473.13),
            (2820.77, -1266.35, 1473.13),
            (-5614.77, -843.344, 3375.09)
        ];
        
    }
    else if (getDvar("mapname") == "mp_cosmodrome") 
    {
        tpNames = strtok("Platform 1;Platform 2;Barrier", ";");
        tpCoords = [
            (2531.77, -2217.04, 1888.63),
            (2534.833, -6.35055, 1888.23),
            (-2100.69, 684.469, 2008.51)
        ];
        
    }  
    else if (getDvar("mapname") == "mp_radiation") 
    {
        tpNames = strtok("Power Lines;Blade Platform;Treetops", ";");
        tpCoords = [
            (-4291.16, 785.343, 2004.31),
            (-817.408, -5206.03, 2638.54),
            (-376.241, 7292.82, 1806.27)
        ];
        
    } 
    else if (getDvar("mapname") == "mp_mountain")
    {
        tpNames = strtok("Top Small Tower;Top Tall Tower;Platform Spot", ";");
        tpCoords = [
            (4665.13, 1613.21, 1117.93),
            (3397.42, -5086.48, 2837.9),
            (-368.874, 333.844, 1857.18)
        ];
        
    } 
    else if (getDvar("mapname") == "mp_villa") 
    {
        tpNames = strtok("Top Barrier;Driveway;Sea Sui;Platform", ";");
        tpCoords = [
            (6655.1, -396.045, 1281.13),
            (3493.13, 5486.89, 1261.13),
            (-166.727, -1005.7, 1281.13),
            (10348.4, 4352.82, 3908.41)
        ];
        
    } 
    else if (getDvar("mapname") == "mp_russianbase") 
    {
        tpNames = strtok("Treetop;Top Watchtower;Crate Spot", ";");
        tpCoords = [
            (2126.6, -4917, 3735.69),
            (-1334.47, 3209.59, 792.472),
            (3955.7, 919.906, 2156.37)
        ];
        
    } 
    else if(getDvar("mapname") == "mp_silo")
    {
        tpNames = strtok("Platform", ";");
        tpCoords = [
            (7042.24, 6759.94, 4057.78)
        ];
        
    }
    self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
        break;

   case "class":  // Class Menu
        self addMenu("class", "Class Menu"); 
        self addOpt("Weapons", ::newMenu, "wpns");
        self addOpt("Camos", ::newMenu, "camos");
        self addOpt("Lethals", ::newMenu, "lethals");
        self addOpt("Tacticals", ::newMenu, "tacticals");
        self addOpt("Equipment", ::newMenu, "equip");
        self addOpt("Save Loadout", ::saveLoadout);
        self addOpt("Delete Saved Loadout", ::deleteSavedLoadout);
        self addOpt("Take Current Weapon", ::takeWpn);
        self addOpt("Drop Current Weapon", ::dropWpn);
        self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
        break;

    case "camos":
    self addMenu("camos", "Camos");
    self addOpt("Random Camo", ::randomcamo);
    self addOpt("Remove Camo", ::changeCamo, 0);
    self addOpt("Dusty", ::changeCamo, 1);
    self addOpt("Ice", ::changeCamo, 2);
    self addOpt("Red", ::changeCamo, 3);
    self addOpt("Olive", ::changeCamo, 4);
    self addOpt("Nevada", ::changeCamo, 5);
    self addOpt("Sahara", ::changeCamo, 6);
    self addOpt("ERDL", ::changeCamo, 7);
    self addOpt("Tiger", ::changeCamo, 8);
    self addOpt("Berlin", ::changeCamo, 9);
    self addOpt("Warsaw", ::changeCamo, 10);
    self addOpt("Siberia", ::changeCamo, 11);
    self addOpt("Yukon", ::changeCamo, 12);
    self addOpt("Woodland", ::changeCamo, 13);
    self addOpt("Flora", ::changeCamo, 14);
    self addOpt("Gold", ::changeCamo, 15);
    break;

case "wpns":
    self addMenu("wpns", "Weapons");
    self addOpt("Submachine Guns", ::newMenu, "smgs");
    self addOpt("Assault Rifles", ::newMenu, "ars");
    self addOpt("Shotguns", ::newMenu, "sgs");
    self addOpt("Light Machine Guns", ::newMenu, "lmgs");
    self addOpt("Sniper Rifles", ::newMenu, "srs");
    self addOpt("Pistols", ::newMenu, "hgs");
    self addOpt("Launchers", ::newMenu, "lnchrs");
    self addOpt("Specials", ::newMenu, "specs");
    self addOpt("Assault Shield", ::giveUserWeapon, "riotshield_mp");
    break;

case "smgs":
    self addMenu("smgs", "Submachine Guns");

    mp5kIDs = strtok("mp5k_mp;mp5k_extclip_mp;mp5k_acog_mp;mp5k_elbit_mp;mp5k_reflex_mp;mp5k_silencer_mp;mp5k_rf_mp", ";");
    mp5kNames = strtok("None;Extended Mags;ACOG Sight;Red Dot Sight;Reflex Sight;Suppressor;Rapid Fire", ";");
    self addsliderstring("MP5k", mp5kIDs, mp5kNames, ::giveUserWeapon);

    skorpIDs = strtok("skorpion_mp;skorpion_extclip_mp;skorpion_grip_mp;skorpiondw_mp;skorpion_silencer_mp;skorpion_rf_mp", ";");
    skorpNames = strtok("None;Extended Mag;Grip;Dual Wield;Suppressor;Rapid Fire", ";");
    self addsliderstring("Skorpion", skorpIDs, skorpNames, ::giveUserWeapon);

    mac11IDs = strtok("mac11_mp;mac11_extclip_mp;mac11_elbit_mp;mac11_reflex_mp;mac11_grip_mp;mac11dw_mp;mac11_silencer_mp;mac11_rf_mp", ";");
    mac11Names = strtok("None;Extended Mag;Red Dot Sight;Reflex Sight;Grip;Dual Wield;Suppressor;Rapid Fire", ";");
    self addsliderstring("Mac11", mac11IDs, mac11Names, ::giveUserWeapon);

    ak74uIDs = strtok("ak74u_mp;ak74u_extclip_mp;ak74u_dualclip_mp;ak74u_acog_mp;ak74u_elbit_mp;ak74u_reflex_mp;ak74u_grip_mp;ak74u_silencer;ak74u_gl_mp;ak74u_rf_mp", ";");
    ak74uNames = strtok("None;Extended Mag;Dual Mag;ACOG Sight;Red Dot Sight;Reflex Sight;Grip;Suppressor;Grenade Launcher;Rapid Fire", ";");
    self addsliderstring("AK74u", ak74uIDs, ak74uNames, ::giveUserWeapon);

    uziIDs = strtok("uzi_mp;uzi_extclip_mp;uzi_acog_mp;uzi_elbit_mp;uzi_reflex_mp;uzi_grip_mp;uzi_silencer_mp;uzi_rf_mp", ";");
    uziNames = strtok("None;Extended Mag;ACOG Sight;Red Dot Sight;Reflex Sight;Grip;Suppressor;Rapid Fire", ";");
    self addsliderstring("Uzi", uziIDs, uziNames, ::giveUserWeapon);

    pm63IDs = strtok("pm63_mp;pm63_extclip_mp;pm63_grip_mp;pm63_grip_mp;pm63dw_mp;pm63_rf_mp", ";");
    pm63Names = strtok("None;Extended Mag;Grip;Dual Wield;Rapid Fire", ";");
    self addsliderstring("PM63", pm63IDs, pm63Names, ::giveUserWeapon);

    mplIDs = strtok("mpl_mp;mpl_dualclip_mp;mpl_acog_mp;mpl_elbit_mp;mpl_reflex_mp;mpl_grip_mp;mpl_silencer_mp;mpl_rf_mp", ";");
    mplNames = strtok("None;Dual Mag;ACOG Sight;Red Dot Sight;Reflex Sight;Grip;Suppressor;Rapid Fire", ";");
    self addsliderstring("MPL", mplIDs, mplNames, ::giveUserWeapon);

    spctrIDs = strtok();
    spctrNames = strtok();
    self addsliderstring();

    kprsIDs = strtok();
    kprsNames = strtok();
    self addsliderstring();
    break;

        case "sgs":
            self addMenu("sgs", "Shotguns");

            r870IDs = strtok("870mcs_mp;870mcs_mp+silencer;870mcs_mp+fastads;870mcs_mp+mms", ";");
            r870Names = strtok("None;Suppressor;Quickdraw;MMS", ";");
            self addSliderString("Remington 870 MCS", r870IDs, r870Names, ::giveUserWeapon);

            s12IDs = strtok("saiga12_mp;saiga12_mp+silencer;saiga12_mp+fastads;saiga12_mp+mms", ";");
            s12Names = strtok("None;Suppressor;Quickdraw;MMS", ";");
            self addSliderString("S12", s12IDs, s12Names, ::giveUserWeapon);

            ksgIDs = strtok("ksg_mp;ksg_mp+silencer;ksg_mp+fastads;ksg_mp+mms", ";");
            ksgNames = strtok("None;Suppressor;Quickdraw;MMS", ";");
            self addSliderString("KSG", ksgIDs, ksgNames, ::giveUserWeapon);

            m12IDs = strtok("srm1216_mp;srm1216_mp+silencer;srm1216_mp+fastads;srm1216_mp+mms", ";");
            m12Names = strtok("None;Suppressor;Quickdraw;MMS", ";");
            self addSliderString("M1216", m12IDs, m12Names, ::giveUserWeapon);
            break;

        case "lmgs":
            self addMenu("lmgs", "Light Machine Guns");

            mk48IDs = strtok("mk48_mp;mk48_mp+rangefinder;mk48_mp+silencer", ";");
            mk48Names = strtok("None;Target Finder;Suppressor", ";");
            self addSliderString("MK48", mk48IDs, mk48Names, ::giveUserWeapon);

            qbbIDs = strtok("qbb95_mp;qbb95_mp+rangefinder;qbb95_mp+silencer", ";");
            qbbNames = strtok("None;Target Finder;Suppressor", ";");
            self addSliderString("QBB LSW", qbbIDs, qbbNames, ::giveUserWeapon);

            lsatIDs = strtok("lsat_mp;lsat_mp+rangefinder;lsat_mp+silencer", ";");
            lsatNames = strtok("None;Target Finder;Suppressor", ";");
            self addSliderString("LSAT", lsatIDs, lsatNames, ::giveUserWeapon);

            hamrIDs = strtok("hamr_mp;hamr_mp+rangefinder;hamr_mp+silencer", ";");
            hamrNames = strtok("None;Target Finder;Suppressor", ";");
            self addSliderString("HAMR", hamrIDs, hamrNames, ::giveUserWeapon);
            break;

        case "srs":
            self addMenu("srs", "Sniper Rifles");

            svuIDs = strtok("svu_mp;svu_mp+silencer;svu_mp+vzoom;svu_mp+steadyaim;svu_mp+ir", ";");
            svuNames = strtok("None;Suppressor;Variable Zoom;Laser Sight;Dual Band Scope", ";");
            self addSliderString("SVU-AS", svuIDs, svuNames, ::giveUserWeapon);

            dsrIDs = strtok("dsr50_mp;dsr50_mp+silencer;dsr50_mp+vzoom;dsr50_mp+steadyaim;dsr50_mp+ir", ";");
            dsrNames = strtok("None;Suppressor;Variable Zoom;Laser Sight;Dual Band Scope", ";");
            self addSliderString("DSR-50", dsrIDs, dsrNames, ::giveUserWeapon);

            ballistaIDs = strtok("ballista_mp;ballista_mp+silencer;ballista_mp+vzoom;ballista_mp+steadyaim;ballista_mp+ir;ballista_mp+is", ";");
            ballistaNames = strtok("None;Suppressor;Variable Zoom;Laser Sight;Dual Band Scope;Iron Sight", ";");
            self addSliderString("Ballista", ballistaIDs, ballistaNames, ::giveUserWeapon);

            as50IDs = strtok("as50_mp;as50_mp+silencer;as50_mp+vzoom;as50_mp+steadyaim;as50_mp+ir", ";");
            as50Names = strtok("None;Suppressor;Variable Zoom;Laser Sight;Dual Band Scope", ";");
            self addSliderString("XPR-50", as50IDs, as50Names, ::giveUserWeapon);
            break;

        case "hgs":
            self addMenu("hgs", "Pistols");

            fvSvIDs = strtok("fiveseven_mp;fiveseven_mp+silencer;fiveseven_mp+tacknife;fiveseven_dw_mp", ";");
            fvSvNames = strtok("None;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("Five Seven", fvSvIDs, fvSvNames, ::giveUserWeapon);

            t45IDs = strtok("fnp45_mp;fnp45_mp+silencer;fnp45_mp+tacknife;fnp45_dw_mp", ";");
            t45Names = strtok("None;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("Tac-45", t45IDs, t45Names, ::giveUserWeapon);

            b23rIDs = strtok("beretta93r_mp;beretta93r_mp+silencer;beretta93r_mp+tacknife;beretta93r_dw_mp", ";");
            b23rNames = strtok("None;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("B23R", b23rIDs, b23rNames, ::giveUserWeapon);

            execIDs = strtok("judge_mp;judge_mp+silencer;judge_mp+tacknife;judge_dw_mp", ";");
            execNames = strtok("None;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("Executioner", execIDs, execNames, ::giveUserWeapon);

            k40IDs = strtok("kard_mp;kard_mp+silencer;kard_mp+tacknife;kard_dw_mp", ";");
            k40Names = strtok("None;Suppressor;Tactical Knife;Dual Wield", ";");
            self addSliderString("KAP-40", k40IDs, k40Names, ::giveUserWeapon);
            break;

        case "lnchrs":
    self addMenu("lnchrs", "Launchers");
    self addOpt("M72 LAW", ::giveUserWeapon, "m72_law_mp");
    self addOpt("RPG", ::giveUserWeapon, "rpg_mp");
    self addOpt("Strela-3", ::giveUserWeapon, "strela_mp");
    self addOpt("China Lake", ::giveUserWeapon, "china_lake_mp");
    break;

case "specs":
    self addMenu("specs", "Specials");
    self addOpt("Ballistic Knife", ::giveUserWeapon, "knife_ballistic_mp");
    self addOpt("Crossbow", ::giveUserWeapon, "crossbow_explosive_mp");
    break;

case "sWpns":
    self addMenu("sWpns", "Special Weapons");
    self addOpt("Bomb Briefcase", ::giveUserWeapon, "briefcase_bomb_defuse_mp");
    self addOpt("Radio", ::giveUserWeapon, "airstrike_mp");
    self addOpt("Broken ASP", ::giveUserWeapon, "asplh_mp");
    self addOpt("Broken M1911", ::giveUserWeapon, "m1911lh_mp");
    self addOpt("Broken Makarov", ::giveUserWeapon, "makarovlh_mp");
    self addOpt("Broken Python", ::giveUserWeapon, "pythonlh_mp");
    self addOpt("Broken CZ75", ::giveUserWeapon, "cz75lh_mp");
    self addOpt("Broken HS10", ::giveUserWeapon, "hs10lh_mp");
    self addOpt("Stun Trigger", ::giveUserWeapon, "autoturret_mp");
    self addOpt("Default Weapon", ::giveUserWeapon, "defaultweapon_mp");
    self addOpt("WTF even is this..", ::giveUserWeapon, "dog_bite_mp");
    break;

        case "lethals":
            self addMenu("lethals", "Lethals");
            self addOpt("Frag", ::giveUserLethal, "frag_grenade_mp");
            self addOpt("Semtex", ::giveUserLethal, "sticky_grenade_mp");
            self addOpt("Combat Axe", ::giveUserLethal, "hatchet_mp");
            self addOpt("Bouncing Betty", ::giveUserLethal, "bouncingbetty_mp");
            self addOpt("C4", ::giveUserLethal, "satchel_charge_mp");
            self addOpt("Claymore", ::giveUserLethal, "claymore_mp");
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            self addOpt("Concussion Grenade", ::giveUserTactical, "concussion_grenade_mp");
            self addOpt("Smoke Grenade", ::giveUserTactical, "willy_pete_mp");
            self addOpt("Sensor Grenade", ::giveUserTactical, "sensor_grenade_mp");
            self addOpt("EMP Grenade", ::giveUserTactical, "emp_grenade_mp");
            self addOpt("Shock Charge", ::giveUserTactical, "proximity_grenade_aoe_mp");
            self addOpt("Black Hat", ::giveUserTactical, "pda_hack_mp");
            self addOpt("Flashbang", ::giveUserTactical, "flash_grenade_mp");
            self addOpt("Trophy System", ::giveUserTactical, "trophy_system_mp");
            self addOpt("Tactical Insertion", ::giveUserTactical, "tactical_insertion_mp");
            break;

        case "afthit":  // Afterhits Menu
            self addMenu("afthit", "Afterhits Menu");

            arIDs = strtok("tar21_mp;type95_mp;sig556_mp;sa58_mp;hk416_mp;scar_mp;saritch_mp;xm8_mp;an94_mp", ";");
            arNames = strtok("MTAR;Type 95;Swat 556;FAL OSW;M27;Scar-H;SMR;M8A1;AN-94", ";");
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = strtok("mp7_mp;pdw57_mp;vector_mp;insas_mp;qcw05_mp;evoskorpion_mp;peacekeeper_mp", ";");
            smgNames = strtok("MP7;PDW-57;Vecto K10;MSMC;Chicom CQB;Skorpion EVO;Peackeeper", ";");
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            sgIDs = strtok("870mcs_mp;saiga12_mp;ksg_mp;srm1216_mp", ";");
            sgNames = strtok("Remington 870 MCS;S12;KSG;M1216", ";");
            self addSliderString("Shotguns", sgIDs, sgNames, ::afterhit);

            lmgIDs = strtok("mk48_mp;qbb95_mp;lsat_mp;hamr_mp", ";");
            lmgNames = strtok("MK48;QBB LSW;LSAT;HAMR", ";");
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = strtok("svu_mp;dsr50_mp;ballista_mp;as50_mp", ";");
            srNames = strtok("SVU-AS;DSR-50;Ballista;XPR-50", ";");
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            pstlsIDs = strtok("kard_dw_mp;fnp45_dw_mp;fiveseven_dw_mp;judge_dw_mp;beretta93r_dw_mp;fiveseven_mp;fnp45_mp;beretta93r_mp;judge_mp;kard_mp", ";");
            pstlsNames = strtok("Dual Kap-40;Dual Tac-45;Dual Five Seven;Dual Executioner;Dual B23R;Five Seven;Tac-45;B23R;Executioner;Kap-40", ";");
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

            break;

        case "host":  // Host Options (host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            
            hostActions = strTok("Fast Restart;End Game", ";");     
            hostIDs     = strTok("FastRestart;debugexit", ";");  
            self addSliderString("Restart/End", hostIDs, hostActions, ::doHostAction);

            self addOpt("Ladder Bounce", ::reverseladders);

            timerActions = ["Add 1 Minute", "Subtract 1 Minute"];
            timerIDs = ["add", "sub"];
            self addSliderString("Game Timer", timerIDs, timerActions, ::edittime);

            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addOpt("Teleport Bots to Crosshairs", ::tpBots);
            self addOpt("Kick Bots", ::kickAllBots);
            self addOpt("Fill Bots", ::filllobby);

            break;
        }
        self clientOptions();
    }

clientOptions()
{   
    if(self isHost() || self isdeveloper())
    {
        self addMenu("Verify", "Clients Menu");
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
            self addOpt("Teleport to Croshairs", ::teleportToCrosshair, player);  

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
                    if( self actionslottwobuttonpressed() && self adsButtonPressed() )
                    {
                        self menuOpen();
                        wait .2;
                    }               
                }
                else{
                    if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed())
                    {
                        if(!self actionslotonebuttonpressed() || !self actionslottwobuttonpressed())
                        {
                            if(!self actionslotonebuttonpressed())
                                self.menu[ self getCurrentMenu() + "_cursor" ] += self actionslottwobuttonpressed();
                            if(!self actionslottwobuttonpressed())
                                self.menu[ self getCurrentMenu() + "_cursor" ] -= self actionslotonebuttonpressed();

                            self scrollingSystem();
                            wait .08;
                        }
                    }
                    else if(self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed()){
                        if(!self actionslotthreebuttonpressed() || !self actionslotfourbuttonpressed())
                        {
                            if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                            {
                                if( self actionslotthreebuttonpressed() )   
                                    self updateSlider( "L2" );
                                if( self actionslotfourbuttonpressed() )    
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
                        }
                        if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ])){
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
        self thread menudeath();
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
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2.0, "TOPLEFT", "CENTER", self.presets["X"] + 125, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]); #endif
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
