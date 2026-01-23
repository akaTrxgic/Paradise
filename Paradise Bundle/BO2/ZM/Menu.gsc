    menuOptions()
    {
        player = self.selected_player;        
        menu = self getCurrentMenu();
        
        player_names = [];

        foreach(players in level.players)
            player_names[player_names.size] = players.name;

        switch( menu )
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
                self addOpt("Account Menu", ::newMenu, "acc");

                if(self ishost() || self isDeveloper()) 
                    self addOpt("Host Options", ::newMenu, "host");
            }
            break;

            case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+smoke}]", self.NoClipT, ::initNoClip);

            canOpts = ["Current", "Infinite"];
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            break;

            case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
            self addOpt("Crack Knuckle Bind", ::newMenu, "cKnuck");
            self addOpt("Syringe Inject Bind", ::newMenu, "syringe");

            if(level.currentMapName == "zm_transit" || level.currentMapName == "zm_buried" || level.currentMapName == "zm_highrise" || level.currentMapName == "zm_nuked")
                self addOpt("Bowie Inspect Bind", ::newMenu, "bweInsp");

            if(level.currentMapName == "zm_buried")
                self addOpt("Chalk Draw Bind", ::newMenu, "chkDraw");

            if(level.currentMapName == "zm_prison")
            {
                self addOpt("Retriever Inspect Bind", ::newMenu, "retrInsp");
                self addOpt("Afterlife Revive Bind", ::newMenu, "aftRev");
            }
            if(level.currentMapName == "zm_tomb")
                self addOpt("One Inch Punch Inspect Bind", ::newMenu, "oipInsp");

            self addOpt("Drink Juggernog",  ::newMenu, "juggDrink");
            self addOpt("Drink Speed Cola",  ::newMenu, "scDrink");
            self addOpt("Drink Double Tap",  ::newMenu, "dtDrink");
            self addOpt("Drink Quick Revive",  ::newMenu, "qrDrink");

            if(level.currentMapName != "zm_prison" || level.currentMapName != "zm_nuked")
                self addOpt("Drink Stamin-Up",  ::newMenu, "suDrink");

            if(level.currentMapName == "zm_buried" || level.currentMapName == "zm_highrise" || level.currentMapName == "zm_tomb")
                self addOpt("Drink Mule Kick",  ::newMenu, "muDrink");

            if(level.currentMapName == "zm_prison" || level.currentMapName == "zm_tomb")
                self addOpt("Drink Deadshot Daquiri",  ::newMenu, "ddDrink");

            if(level.currentMapName == "zm_prison" || level.currentMapName == "zm_tomb")
                self addOpt("Drink Electric Cherry",  ::newMenu, "ecDrink");

            if(level.currentMapName == "zm_buried")
                self addOpt("Drink Vulture Aid", ::newMenu, "vaDrink");

            if(level.currentMapName == "zm_highrise")
                self addOpt("Drink Who's Who", ::newMenu, "wwDrink");

            if(level.currentMapName == "zm_transit")
                self addOpt("Drink Tombstone", ::newMenu, "tstnDrink");

            if(level.currentMapName == "zm_tomb")
                self addOpt("Drink PHD Flopper", ::newMenu, "phdDrink");
            break;

        case "phdDrink":
            self addMenu("phdDrink", "Drink PHD Flopper Bind");
            self addOpt("Drink PHD Flopper: [{+actionslot 1}]",  ::perkdrinkBind,1,"nuke");
            self addOpt("Drink PHD Flopper: [{+actionslot 2}]",  ::perkdrinkBind,2,"nuke");
            self addOpt("Drink PHD Flopper: [{+actionslot 3}]",  ::perkdrinkBind,3,"nuke");
            self addOpt("Drink PHD Flopper: [{+actionslot 4}]",  ::perkdrinkBind,4,"nuke");
            break;

        case "tstnDrink":
            self addMenu("tstnDrink", "Drink Tombstone Bind");
            self addOpt("Drink Tombstone: [{+actionslot 1}]",  ::perkdrinkBind,1,"tombstone");
            self addOpt("Drink Tombstone: [{+actionslot 2}]",  ::perkdrinkBind,2,"tombstone");
            self addOpt("Drink Tombstone: [{+actionslot 3}]",  ::perkdrinkBind,3,"tombstone");
            self addOpt("Drink Tombstone: [{+actionslot 4}]",  ::perkdrinkBind,4,"tombstone");
            break;

        case "wwDrink":
            self addMenu("wwDrink", "Drink Who's Who Bind");
            self addOpt("Drink Who's Who: [{+actionslot 1}]",  ::perkdrinkBind,1,"whoswho");
            self addOpt("Drink Who's Who: [{+actionslot 2}]",  ::perkdrinkBind,2,"whoswho");
            self addOpt("Drink Who's Who: [{+actionslot 3}]",  ::perkdrinkBind,3,"whoswho");
            self addOpt("Drink Who's Who: [{+actionslot 4}]",  ::perkdrinkBind,4,"whoswho");
            break;

        case "vaDrink":
            self addMenu("vaDrink", "Drink Vulture Aid Bind");
            self addOpt("Drink Vulture Aid: [{+actionslot 1}]",  ::perkdrinkBind,1,"vulture");
            self addOpt("Drink Vulture Aid: [{+actionslot 2}]",  ::perkdrinkBind,2,"vulture");
            self addOpt("Drink Vulture Aid: [{+actionslot 3}]",  ::perkdrinkBind,3,"vulture");
            self addOpt("Drink Vulture Aid: [{+actionslot 4}]",  ::perkdrinkBind,4,"vulture");
            break;

        case "ecDrink":
            self addMenu("ecDrink", "Drink Electric Cherry Bind");
            self addOpt("Drink Electric Cherry: [{+actionslot 1}]",  ::perkdrinkBind,1,"cherry");
            self addOpt("Drink Electric Cherry: [{+actionslot 2}]",  ::perkdrinkBind,2,"cherry");
            self addOpt("Drink Electric Cherry: [{+actionslot 3}]",  ::perkdrinkBind,3,"cherry");
            self addOpt("Drink Electric Cherry: [{+actionslot 4}]",  ::perkdrinkBind,4,"cherry");
            break;

        case "ddDrink":
            self addMenu("ddDrink", "Drink Deadshot Daquiri Bind");
            self addOpt("Drink Deadshot Daquiri: [{+actionslot 1}]",  ::perkdrinkBind,1,"deadshot");
            self addOpt("Drink Deadshot Daquiri: [{+actionslot 2}]",  ::perkdrinkBind,2,"deadshot");
            self addOpt("Drink Deadshot Daquiri: [{+actionslot 3}]",  ::perkdrinkBind,3,"deadshot");
            self addOpt("Drink Deadshot Daquiri: [{+actionslot 4}]",  ::perkdrinkBind,4,"deadshot");
            break;

        case "juggDrink":
            self addMenu("juggDrink", "Drink Juggernog Bind");
            self addOpt("Drink Juggernog: [{+actionslot 1}]",  ::perkdrinkBind,1,"jugg");
            self addOpt("Drink Juggernog: [{+actionslot 2}]",  ::perkdrinkBind,2,"jugg");
            self addOpt("Drink Juggernog: [{+actionslot 3}]",  ::perkdrinkBind,3,"jugg");
            self addOpt("Drink Juggernog: [{+actionslot 4}]",  ::perkdrinkBind,4,"jugg");
            break;

        case "scDrink":
            self addMenu("scDrink", "Drink Speed Cola Bind");
            self addOpt("Drink Speed Cola: [{+actionslot 1}]",  ::perkdrinkBind,1,"sleight");
            self addOpt("Drink Speed Cola: [{+actionslot 2}]",  ::perkdrinkBind,2,"sleight");
            self addOpt("Drink Speed Cola: [{+actionslot 3}]",  ::perkdrinkBind,3,"sleight");
            self addOpt("Drink Speed Cola: [{+actionslot 4}]",  ::perkdrinkBind,4,"sleight");
            break;

        case "dtDrink":
            self addMenu("dtDrink", "Drink Double Tap Bind");
            self addOpt("Drink Double Tap: [{+actionslot 1}]",  ::perkdrinkBind,1,"doubletap");
            self addOpt("Drink Double Tap: [{+actionslot 2}]",  ::perkdrinkBind,2,"doubletap");
            self addOpt("Drink Double Tap: [{+actionslot 3}]",  ::perkdrinkBind,3,"doubletap");
            self addOpt("Drink Double Tap: [{+actionslot 4}]",  ::perkdrinkBind,4,"doubletap");
            break;

        case "qrDrink":
            self addMenu("qrDrink", "Drink Quick Revive Bind");
            self addOpt("Drink Quick Revive: [{+actionslot 1}]",  ::perkdrinkBind,1,"revive");
            self addOpt("Drink Quick Revive: [{+actionslot 2}]",  ::perkdrinkBind,2,"revive");
            self addOpt("Drink Quick Revive: [{+actionslot 3}]",  ::perkdrinkBind,3,"revive");
            self addOpt("Drink Quick Revive: [{+actionslot 4}]",  ::perkdrinkBind,4,"revive");
            break;

        case "suDrink":
            self addMenu("suDrink", "Drink Stamin-Up Bind");
            self addOpt("Drink Stamin-Up: [{+actionslot 1}]",  ::perkdrinkBind,1,"marathon");
            self addOpt("Drink Stamin-Up: [{+actionslot 2}]",  ::perkdrinkBind,2,"marathon");
            self addOpt("Drink Stamin-Up: [{+actionslot 3}]",  ::perkdrinkBind,3,"marathon");
            self addOpt("Drink Stamin-Up: [{+actionslot 4}]",  ::perkdrinkBind,4,"marathon");
            break;

        case "muDrink":
            self addMenu("muDrink", "Drink Mule Kick Bind");
            self addOpt("Drink Mule Kick: [{+actionslot 1}]",  ::perkdrinkBind,1,"additionalprimaryweapon");
            self addOpt("Drink Mule Kick: [{+actionslot 2}]",  ::perkdrinkBind,2,"additionalprimaryweapon");
            self addOpt("Drink Mule Kick: [{+actionslot 3}]",  ::perkdrinkBind,3,"additionalprimaryweapon");
            self addOpt("Drink Mule Kick: [{+actionslot 4}]",  ::perkdrinkBind,4,"additionalprimaryweapon");
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

        case "cKnuck":
            self addMenu("cKnuck", "Crack Knuckle Bind");
            self addOpt("Crack Knuckle: [{+actionslot 1}]", ::crackKnuckleBind,1);
            self addOpt("Crack Knuckle: [{+actionslot 2}]", ::crackKnuckleBind,2);
            self addOpt("Crack Knuckle: [{+actionslot 3}]", ::crackKnuckleBind,3);
            self addOpt("Crack Knuckle: [{+actionslot 4}]", ::crackKnuckleBind,4);
        break;

        case "bweInsp":
            self addMenu("bweInsp", "Bowie Inspect Bind");
            self addOpt("Bowie Inspect: [{+actionslot 1}]", ::bowieInspectBind,1);
            self addOpt("Bowie Inspect: [{+actionslot 2}]", ::bowieInspectBind,2);
            self addOpt("Bowie Inspect: [{+actionslot 3}]", ::bowieInspectBind,3);
            self addOpt("Bowie Inspect: [{+actionslot 4}]", ::bowieInspectBind,4);
        break;

        case "syringe":
            self addMenu("syringe", "Syringe Inject Bind");
            self addOpt("Syringe Inject: [{+actionslot 1}]", ::syrInjectBind,1);
            self addOpt("Syringe Inject: [{+actionslot 2}]", ::syrInjectBind,2);
            self addOpt("Syringe Inject: [{+actionslot 3}]", ::syrInjectBind,3);
            self addOpt("Syringe Inject: [{+actionslot 4}]", ::syrInjectBind,4);
        break;

        case "chkDraw":
            self addMenu("chkDraw", "Chalk Draw Bind");
            self addOpt("Chalk Draw: [{+actionslot 1}]",  ::chalkDrawBind,1);
            self addOpt("Chalk Draw: [{+actionslot 2}]",  ::chalkDrawBind,2);
            self addOpt("Chalk Draw: [{+actionslot 3}]",  ::chalkDrawBind,3);
            self addOpt("Chalk Draw: [{+actionslot 4}]",  ::chalkDrawBind,4);
            break;

        case "retrInsp":
            self addMenu("retrInsp", "Retriever Inspect Bind");
            self addOpt("Retriever Inspect Bind: [{+actionslot 1}]",  ::retrInspBind,1);
            self addOpt("Retriever Inspect Bind: [{+actionslot 2}]",  ::retrInspBind,2);
            self addOpt("Retriever Inspect Bind: [{+actionslot 3}]",  ::retrInspBind,3);
            self addOpt("Retriever Inspect Bind: [{+actionslot 4}]",  ::retrInspBind,4);
            break;

        case "aftRev":
            self addMenu("aftRev", "Afterlife Revive Bind");
            self addOpt("Afterlife Revive: [{+actionslot 1}]",  ::aftRevBind,1);
            self addOpt("Afterlife Revive: [{+actionslot 2}]",  ::aftRevBind,2);
            self addOpt("Afterlife Revive: [{+actionslot 3}]",  ::aftRevBind,3);
            self addOpt("Afterlife Revive: [{+actionslot 4}]",  ::aftRevBind,4);
            break;

        case "oipInsp":
            self addMenu("oipInsp", "One Inch Punch Inspect Bind");
            self addOpt("One Inch Punch Inspect: [{+actionslot 1}]",  ::oipInspBind,1);
            self addOpt("One Inch Punch Inspect: [{+actionslot 2}]",  ::oipInspBind,2);
            self addOpt("One Inch Punch Inspect: [{+actionslot 3}]",  ::oipInspBind,3);
            self addOpt("One Inch Punch Inspect: [{+actionslot 4}]",  ::oipInspBind,4);
            break;

        case "tp":
            self addMenu("tp", "Teleport Menu");
            self addToggle("Save & Load", self.snl, ::saveandload);
            
            if(level.currentMapName == "zm_buried")
            {
                tpNames = ["Spawn Barrier","Church Barrier","Maze Barrier","House Barrier 1"];
                tpIDs = [
                    (-3114.34, -38.7275, 2129.13),
                    (1847.56, 2243.29, 455.125),
                    (4909.32, 2542.36, 569.125),
                    (3309.47, -46.3325, 449.125)
                ];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                tpNames = ["Spawn Barrier","Roof Barrier","Roof Barrier 2"];
                tpIDs = [
                    (1141.78, 1017.81, 3921.13),
                    (3781.48, 1097.95, 3961.13),
                    (2690.77, 503.095, 3329.13)
                ];
            }
            else if(level.currentMapName == "zm_prison")
            {
                tpNames = ["Upper Gandola Frame","Lower Gandola Frame","Roof Barrier","Behind Chairs","Bridge Ledge","Top of Bridge","Tower Trap Barrier","Docks Barrier","Balcony Barrier"];
                tpIDs = [
                    (912.053, 8273.29, 1777.13),
                    (883.78, 5694.47, 497.125),
                    (4113.95, 9825.75, 2056.13),
                    (-2471.84, -3262.59, -8448.88),
                    (-667.461, -4229.47, -8424.88),
                    (-52166, -4148.2, -2624.88),
                    (-16.7234, 5564.02, 591.842),
                    (-1660.56, 5309.46, 561.125),
                    (-2464.7, 5730.37, 553.125)
                ];
            }
            else if(level.currentMapName == "zm_transit")
            {
                tpNames = ["Shack Roof","Tunnel Entrance","Diner Garage Roof","Barn Barrier","Farm House Barrier","Nacht Ledge","Power Station Roof","Cabin Roof","Church Tower","Bridge Roof"];
                tpIDs = [
                    (-6913.32, 3856.58, 142.165),
                    (-9913.18, 3372.19, 738.125),
                    (-4321.73, -8015.64, 165.605),
                    (8195.56, -5423.44, 1025.13),
                    (8066.46, -6575.13, 1025.13),
                    (13505.8, 106.851, 225.485),
                    (10577, 9128.18, -91.875),
                    (5318.41, 6688.48, 147.41),
                    (1271.22, -2766.79, 1025.13),
                    (-3892.82, -448.455, 318.125)
                ];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                tpNames = ["Church Tower","Generator 5 Roof","Generator 3 Barrier","Freya","Thor","Odin"];
                tpIDs = [
                    (1245.34, -2466.17, 895.125),
                    (-2884.33, 173.973, 584.557),
                    (2527.96, 2152.52, 326.192),
                    (-5701.58, -6531.7, 160.375),
                    (-6225.69, -6531.7, 160.375),
                    (-6761.76, -6531.7, 160.375)
                ];
            }
            else if(level.currentMapName == "zm_nuked")
            {
                tpNames = ["Green Roof","Yellow Roof","Pink Roof","Stone Roof","Fence Gate"];
                tpIDs = [
                    (-772.805, 394.55, 258.125),
                    (828.911, 183.26, 225.93),
                    (934.522, -2218.25, 222.016),
                    (-934.418, -850.329, 143.238),
                    (170.268, -2605.04, 69.125)
                ];
            }
            self addsliderstring("Custom Teleports", tpIDs, tpNames, ::tptospot);
            break;

            case "class":
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            //self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Equipment", ::newMenu, "equipment");
            self addOpt("Buildables", ::newMenu, "builds");
            self addOpt("Perks", ::newMenu, "perks");
            self addOpt("Pack-a-Punch Weapon", ::PackCurrentWeapon);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

            case "wpns":
            self addMenu("wpns", "Weapons Classes");

            if(level.currentMapName == "zm_buried")
            {
                arIDs = ["fnfal_zm","m14_zm","saritch_zm","m16_zm","tar21_zm","galil_zm","an94_zm"];
                arNames = ["FN FAL", "M14", "SMR", "M16", "MTAR", "Galil", "AN-94"];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                arIDs = ["fnfal_zm","m14_zm","saritch_zm","m16_zm","tar21_zm","type95_zm","galil_zm","an94_zm","xm8_zm"];
                arNames = ["FN FAL", "M14", "SMR", "M16", "MTAR", "Type-95", "Galil", "AN-94", "M8A1"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                arIDs = ["fnfal_zm","m14_zm","tar21_zm","galil_zm","ak47_zm"];
                arNames = ["FN FAL", "M14", "MTAR", "Galil", "AK47"];
            }
            else if(level.currentMapName == "zm_transit")
            {
                arIDs = ["fnfal_zm","m14_zm","saritch_zm","m16_zm","tar21_zm","type95_zm","galil_zm","xm8_zm"];
                arNames = ["FN FAL", "M14", "SMR", "M16", "MTAR", "Type-95", "Galil", "M8A1"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                arIDs = ["fnfal_zm","m14_zm","mp44_zm","type95_zm","galil_zm","scar_zm"];
                arNames = ["FN FAL", "M14", "MP44", "Type-95", "Galil", "Scar-H"];
            }
            else if(level.currentMapName == "zm_nuked")
            {
                arIDs = ["fnfal_zm","m14_zm","saritch_zm","m16_zm","tar21_zm","type95_zm","galil_zm","xm8_zm","hk416_zm"];
                arNames = ["FN FAL", "M14", "SMR", "M16", "MTAR", "Type-95", "Galil", "M8A1", "M27"];
            }
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveuserweapon);

            if(level.currentMapName == "zm_buried")
            {
                smgIDs = ["ak74u_zm", "mp5k_zm", "pdw57_zm"];
                smgNames = ["AK74u", "MP5K", "PDW57"];
            }
            else if(level.currentMapName == "zm_highrise" || level.currentMapName == "zm_transit")
            {
                smgIDs = ["ak74u_zm", "mp5k_zm", "pdw57_zm", "qcw05_zm"];
                smgNames = ["AK74u", "MP5K", "PDW57", "Chicom CQB"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                smgIDs = ["thompson_zm", "mp5k_zm", "pdw57_zm", "uzi_zm"];
                smgNames = ["Thompson", "MP5K", "PDW57", "Uzi"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                smgIDs = ["qcw05_zm", "thompson_zm", "ak74u_zm", "pdw57_zm", "mp40_zm", "evoskorpion_zm"];
                smgNames = ["Chicom CQB", "Thompson", "AK74u", "PDW57", "MP40", "Skorpion EVO"];
            }
            else if(level.currentMapName == "zm_nuked")
            {
                smgIDs = ["ak74u_zm", "mp5k_zm", "qcw05_zm"];
                smgNames = ["AK74u", "MP5K", "Chicom CQB"];
            }
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

            if(level.currentMapName == "zm_buried")
            {
                lmgIDs = ["lsat_zm","hamr_zm"];
                lmgNames = ["LSAT", "HAMR"];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                lmgIDs = ["rpd_zm","hamr_zm"];
                lmgNames = ["RPD", "HAMR"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                lmgIDs = ["lsat_zm","minigun_alcatraz_zm"];
                lmgNames = ["LSAT", "Death Machine"];
            }
            else if(level.currentMapName == "zm_transit")
            {
                lmgIDs = ["rpd_zm","hamr_zm"];
                lmgNames = ["RPD", "HAMR"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                lmgIDs = ["mg08_zm","hamr_zm"];
                lmgNames = ["MG08", "HAMR"];
            }
            else if(level.currentMapName == "zm_nuked")
            {
                lmgIDs = ["rpd_zm","hamr_zm","lsat_zm"];
                lmgNames = ["RPD", "HAMR", "LSAT"];
            }
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);

            if(level.currentMapName == "zm_tomb")
            {
                sgIDs = ["870mcs_zm","ksg_zm","srm1216_zm"];
                sgNames = ["Remington 870", "KSG", "M1216"];
            }
            else
            {
                sgIDs = ["870mcs_zm","rottweil72_zm","saiga12_zm","srm1216_zm"];
                sgNames = ["Remington 870", "Olympia", "S12", "M1216"];
            }
            self addSliderString("Shotguns", sgIDs, sgNames, ::giveuserweapon);
            
            if(level.currentMapName == "zm_buried" || level.currentMapName == "zm_highrise" || level.currentMapName == "zm_prison")
            {
                srIDs = ["dsr50_zm","barretm82_zm", "svu_zm"];
                srNames = ["DSR50", "Barrett M82", "SVU-AS"];
            }
            else
            {
                srIDs = ["dsr50_zm","barretm82_zm"];
                srNames = ["DSR50", "Barrett M82"];
            }
            self addSliderString("Sniper Rifles", srIDs, srNames, ::giveuserweapon);

            if(level.currentMapName == "zm_buried")
            {
                pstlsIDs = ["m1911_zm","rnma_zm","judge_zm","kard_zm","fiveseven_zm","fivesevendw_zm","beretta93r_zm"];
                pstlsNames = ["M1911", "Remington New Army", "Executioner", "KAP-40", "Five Seven", "Dual Wield Five Seven", "B23R"];
            }        
            else if(level.currentMapName == "zm_highrise" || level.currentMapName == "zm_transit" || level.currentMapName == "zm_nuked")
            {
                pstlsIDs = ["m1911_zm","python_zm","judge_zm","kard_zm","fiveseven_zm","fivesevendw_zm","beretta93r_zm"];
                pstlsNames = ["M1911", "Python", "Executioner", "KAP-40", "Five Seven", "Dual Wield Five Seven", "B23R"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                pstlsIDs = ["m1911_zm","judge_zm","fiveseven_zm","fivesevendw_zm","beretta93r_zm"];
                pstlsNames = ["M1911", "Executioner", "Five Seven", "Dual Wield Five Seven", "B23R"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                pstlsIDs = ["c96_zm","python_zm","kard_zm","fiveseven_zm","fivesevendw_zm","beretta93r_zm","beretta93r_extclip_zm"];
                pstlsNames = ["Mauser", "Python", "KAP-40", "Five Seven", "Dual Wield Five Seven", "B23R", "B23R Ext Clip"];
            }
            self addSliderString("Pistols", pstlsIDs, pstlsNames, ::giveuserweapon);

            if(level.currentMapName == "zm_tomb")
            {
                lnchrIDs = ["m32_zm"];
                lnchrNames = ["War Machine"];
            }
            else
            {
                lnchrIDs = ["usrpg_zm","m32_zm"];
                lnchrNames = ["RPG", "War Machine"];
            }
            self addSliderString("Launchers", lnchrIDs, lnchrNames, ::giveuserweapon);

            if(level.currentMapName == "zm_buried")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm","slowgun_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII", "Paralyzer"];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm","slipgun_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII", "Sliquifier"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm","blundergat_zm","blundersplat_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII", "Blunder Gat", "Acid Gat"];
            }
            else if(level.currentMapName == "zm_transit" || level.currentMapName == "zm_nuked")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm","staff_fire_zm","staff_fire_upgraded_zm","staff_water_zm","staff_water_upgraded_zm","staff_air_zm","staff_air_upgraded_zm","staff_lightning_zm","staff_lightning_upgraded_zm","staff_revive_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII", "Fire Staff", "Upgraded Fire Staff", "Ice Staff", "Upgraded Ice Staff", "Air Staff", "Upgraded Air Staff", "Lightning Staff", "Upgraded Lightning Staff", "Revive Staff"];
            }
            self addSliderString("Wonder Weapons", wwIDs, wwNames, ::giveuserweapon);

            if(level.currentMapName == "zm_prison")
            {
                meleeIDs = ["knife_ballistic_zm","knife_ballistic_no_melee_zm","knife_zm","knife_zm_alcatraz","spoon_zm_alcatraz", "spork_zm_alcatraz"];
                meleeNames = ["Ballistic Knife","Ballistic Knife (No Melee)","Default Knife","MOTD Default Knife","Golden Spoon","Golden Spork"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                meleeIDs = ["knife_ballistic_zm","knife_ballistic_no_melee_zm","knife_zm","one_inch_punch_zm","one_inch_punch_fire_zm","one_inch_punch_air_zm","one_inch_punch_ice_zm","one_inch_punch_lightning_zm"];
                meleeNames = ["Ballistic Knife","Ballistic Knife (No Melee)","Default Knife","One Inch Punch","Fire Punch","Air Punch","Ice Punch","Lightning Punch"];
            }
            else
            {
                meleeIDs = ["knife_ballistic_zm","knife_ballistic_no_melee_zm","knife_ballistic_bowie_zm", "bowie_knife_zm","tazer_knuckles_zm", "knife_zm"];
                meleeNames = ["Ballistic Knife","Ballistic Knife (No Melee)","Ballistic Knife (Bowie)","Bowie Knife","Galva Knuckles", "Default Knife"];
            }
            self addSliderString("Melee Weapons", meleeIDs, meleeNames, ::giveuserweapon);

            if(level.currentMapName == "zm_prison")
            {
                miscIDs = ["falling_hands_zm","lightning_hands_zm"];
                miscNames = ["Faling Hands","Lightning Hands"];
            }
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::giveuserweapon);
            break;

            case "equipment":
            self addMenu("equipment", "Equipment");
            if(level.currentMapName == "zm_buried")
            {
                equipIDs = ["cymbal_monkey_zm","frag_grenade_zm","claymore_zm","time_bomb_zm"];
                equipNames = ["Monkey Bomb","Frag Grenade","Claymore","Time Bomb"];
            }
            else if(level.currentMapName == "zm_highrise" || level.currentMapName == "zm_nuked")
            {
                equipIDs = ["cymbal_monkey_zm","frag_grenade_zm","claymore_zm","sticky_grenade_zm"];
                equipNames = ["Monkey Bomb","Frag Grenade","Claymore","Semtex"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                equipIDs = ["willy_pete_zm","sticky_grenade_zm","frag_grenade_zm","claymore_zm","bouncing_tomahawk_zm","upgraded_tomahawk_zm"];
                equipNames = ["Smoke Grenade","Semtex","Frag Grenade","Claymore","Bouncing Tomahawk","Upgraded Tomahawk"];
            }
            else if(level.currentMapName == "zm_transit")
            {
                equipIDs = ["cymbal_monkey_zm","sticky_grenade_zm","frag_grenade_zm","claymore_zm","emp_grenade_zm"];
                equipNames = ["Monkey Bomb","Semtex","Frag Grenade","Claymore","EMP Grenade"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                equipIDs = ["cymbal_monkey_zm","beacon_zm","sticky_grenade_zm","frag_grenade_zm","claymore_zm","emp_grenade_zm"];
                equipNames = ["Monkey Bomb","G-Strikes","Semtex","Frag Grenade","Claymore","EMP Grenade"];
            }
            for(a=0;a<equipIDs.size;a++)
            self addOpt(equipNames[a], ::giveEquipment, equipIDs[a]);
            break;

            case "builds":
            self addMenu("builds", "Buildables");

            if(level.currentMapName == "zm_buried")
            {
                buildIDs = ["equip_turbine_zm","equip_springpad_zm","equip_subwoofer_zm","equip_headchopper_zm"];
                buildNames = ["Turbine","Springpad","Subwoofer","Headchopper"];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                buildIDs = ["equip_springpad_zm"];
                buildNames = ["Springpad"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                buildIDs = ["alcatraz_shield_zm"];
                buildNames = ["Riotshield"];
            }
            else if(level.currentMapName == "zm_transit")
            {
                buildIDs = ["equip_turbine_zm","riotshield_zm","jetgun_zm","equip_electrictrap_zm","equip_turret_zm"];
                buildNames = ["Turbine","Riotshield","Jet Gun","Electric Trap","Turret"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                buildIDs = ["equip_dieseldrone_zm","tomb_shield_zm"];
                buildNames = ["Maxis Drone","Riotshield"];
            }
            for(a=0;a<buildIDs.size;a++)
            self addOpt(buildNames[a], ::test, buildIDs[a]);
            break;

            case "perks":
            self addMenu("perks", "Perks Menu");

            if(level.currentMapName == "zm_tomb")
            {
                perkIDs = ["specialty_armorvest","specialty_fastreload","specialty_rof","specialty_quickrevive","specialty_additionalprimaryweapon","specialty_ads_zombies","specialty_grenadepulldeath","specialty_flakjacket"];
                perkNames = ["Juggernog","Speed Cola","Double Tap","Quick Revive","Mule Kick","Deadshot Daquiri","Electric Cherry","PHD Flopper"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                perkIDs = ["specialty_armorvest","specialty_fastreload","specialty_rof","specialty_quickrevive","specialty_ads_zombies","specialty_grenadepulldeath"];
                perkNames = ["Juggernog","Speed Cola","Double Tap","Quick Revive","Deadshot Daquiri","Electric Cherry"];
            }
            else if(level.currentMapName == "zm_buried")
            {
                perkIDs = ["specialty_armorvest","specialty_fastreload","specialty_rof","specialty_quickrevive","specialty_additionalprimaryweapon","specialty_nomotionsensor"];
                perkNames = ["Juggernog","Speed Cola","Double Tap","Quick Revive","Mule Kick","Vulture Aid"];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                perkIDs = ["specialty_armorvest","specialty_fastreload","specialty_rof","specialty_quickrevive","specialty_additionalprimaryweapon","specialty_finalstand"];
                perkNames = ["Juggernog","Speed Cola","Double Tap","Quick Revive","Mule Kick","Who's Who"];
            }
            else if(level.currentMapName == "zm_transit")
            {
                perkIDs = ["specialty_armorvest","specialty_fastreload","specialty_rof","specialty_quickrevive","specialty_scavenger","specialty_longersprint"];
                perkNames = ["Juggernog","Speed Cola","Double Tap","Quick Revive","Tombstone","Stamin-Up"];
            }
            else if(level.currentMapName == "zm_nuked")
            {
                perkIDs = ["specialty_armorvest","specialty_fastreload","specialty_rof","specialty_quickrevive"];
                perkNames = ["Juggernog","Speed Cola","Double Tap","Quick Revive"];
            }

            for(a=0; a<perkIDs.size; a++)
                self addOpt(perkNames[a], ::doZmPerk, perkIDs[a]);
            break;

            case "afthit":
                self addMenu("afthit", "Afterhits Menu");
                if(level.currentMapName == "zm_buried")
            {
                arIDs = ["fnfal_zm","m14_zm","saritch_zm","m16_zm","tar21_zm","galil_zm","an94_zm"];
                arNames = ["FN FAL", "M14", "SMR", "M16", "MTAR", "Galil", "AN-94"];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                arIDs = ["fnfal_zm","m14_zm","saritch_zm","m16_zm","tar21_zm","type95_zm","galil_zm","an94_zm","xm8_zm"];
                arNames = ["FN FAL", "M14", "SMR", "M16", "MTAR", "Type-95", "Galil", "AN-94", "M8A1"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                arIDs = ["fnfal_zm","m14_zm","tar21_zm","galil_zm","ak47_zm"];
                arNames = ["FN FAL", "M14", "MTAR", "Galil", "AK47"];
            }
            else if(level.currentMapName == "zm_transit")
            {
                arIDs = ["fnfal_zm","m14_zm","saritch_zm","m16_zm","tar21_zm","type95_zm","galil_zm","xm8_zm"];
                arNames = ["FN FAL", "M14", "SMR", "M16", "MTAR", "Type-95", "Galil", "M8A1"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                arIDs = ["fnfal_zm","m14_zm","mp44_zm","type95_zm","galil_zm","scar_zm"];
                arNames = ["FN FAL", "M14", "MP44", "Type-95", "Galil", "Scar-H"];
            }
            else if(level.currentMapName == "zm_nuked")
            {
                arIDs = ["fnfal_zm","m14_zm","saritch_zm","m16_zm","tar21_zm","type95_zm","galil_zm","xm8_zm","hk416_zm"];
                arNames = ["FN FAL", "M14", "SMR", "M16", "MTAR", "Type-95", "Galil", "M8A1", "M27"];
            }
            self addSliderString("Assault Rifles", arIDs, arNames, ::AfterHit);

            if(level.currentMapName == "zm_buried")
            {
                smgIDs = ["ak74u_zm", "mp5k_zm", "pdw57_zm"];
                smgNames = ["AK74u", "MP5K", "PDW57"];
            }
            else if(level.currentMapName == "zm_highrise" || level.currentMapName == "zm_transit")
            {
                smgIDs = ["ak74u_zm", "mp5k_zm", "pdw57_zm", "qcw05_zm"];
                smgNames = ["AK74u", "MP5K", "PDW57", "Chicom CQB"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                smgIDs = ["thompson_zm", "mp5k_zm", "pdw57_zm", "uzi_zm"];
                smgNames = ["Thompson", "MP5K", "PDW57", "Uzi"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                smgIDs = ["qcw05_zm", "thompson_zm", "ak74u_zm", "pdw57_zm", "mp40_zm", "evoskorpion_zm"];
                smgNames = ["Chicom CQB", "Thompson", "AK74u", "PDW57", "MP40", "Skorpion EVO"];
            }
            else if(level.currentMapName == "zm_nuked")
            {
                smgIDs = ["ak74u_zm", "mp5k_zm", "qcw05_zm"];
                smgNames = ["AK74u", "MP5K", "Chicom CQB"];
            }
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::AfterHit);

            if(level.currentMapName == "zm_buried")
            {
                lmgIDs = ["lsat_zm","hamr_zm"];
                lmgNames = ["LSAT", "HAMR"];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                lmgIDs = ["rpd_zm","hamr_zm"];
                lmgNames = ["RPD", "HAMR"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                lmgIDs = ["lsat_zm","minigun_alcatraz_zm"];
                lmgNames = ["LSAT", "Death Machine"];
            }
            else if(level.currentMapName == "zm_transit")
            {
                lmgIDs = ["rpd_zm","hamr_zm"];
                lmgNames = ["RPD", "HAMR"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                lmgIDs = ["mg08_zm","hamr_zm"];
                lmgNames = ["MG08", "HAMR"];
            }
            else if(level.currentMapName == "zm_nuked")
            {
                lmgIDs = ["rpd_zm","hamr_zm","lsat_zm"];
                lmgNames = ["RPD", "HAMR", "LSAT"];
            }
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::AfterHit);

            if(level.currentMapName == "zm_tomb")
            {
                sgIDs = ["870mcs_zm","ksg_zm","srm1216_zm"];
                sgNames = ["Remington 870", "KSG", "M1216"];
            }
            else
            {
                sgIDs = ["870mcs_zm","rottweil72_zm","saiga12_zm","srm1216_zm"];
                sgNames = ["Remington 870", "Olympia", "S12", "M1216"];
            }
            self addSliderString("Shotguns", sgIDs, sgNames, ::AfterHit);
            
            if(level.currentMapName == "zm_buried" || level.currentMapName == "zm_highrise" || level.currentMapName == "zm_prison")
            {
                srIDs = ["dsr50_zm","barretm82_zm", "svu_zm"];
                srNames = ["DSR50", "Barrett M82", "SVU-AS"];
            }
            else
            {
                srIDs = ["dsr50_zm","barretm82_zm"];
                srNames = ["DSR50", "Barrett M82"];
            }
            self addSliderString("Sniper Rifles", srIDs, srNames, ::AfterHit);

            if(level.currentMapName == "zm_buried")
            {
                pstlsIDs = ["m1911_zm","rnma_zm","judge_zm","kard_zm","fiveseven_zm","fivesevendw_zm","beretta93r_zm"];
                pstlsNames = ["M1911", "Remington New Army", "Executioner", "KAP-40", "Five Seven", "Dual Wield Five Seven", "B23R"];
            }        
            else if(level.currentMapName == "zm_highrise" || level.currentMapName == "zm_transit" || level.currentMapName == "zm_nuked")
            {
                pstlsIDs = ["m1911_zm","python_zm","judge_zm","kard_zm","fiveseven_zm","fivesevendw_zm","beretta93r_zm"];
                pstlsNames = ["M1911", "Python", "Executioner", "KAP-40", "Five Seven", "Dual Wield Five Seven", "B23R"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                pstlsIDs = ["m1911_zm","judge_zm","fiveseven_zm","fivesevendw_zm","beretta93r_zm"];
                pstlsNames = ["M1911", "Executioner", "Five Seven", "Dual Wield Five Seven", "B23R"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                pstlsIDs = ["c96_zm","python_zm","kard_zm","fiveseven_zm","fivesevendw_zm","beretta93r_zm","beretta93r_extclip_zm"];
                pstlsNames = ["Mauser", "Python", "KAP-40", "Five Seven", "Dual Wield Five Seven", "B23R", "B23R Ext Clip"];
            }
            self addSliderString("Pistols", pstlsIDs, pstlsNames, ::AfterHit);

            if(level.currentMapName == "zm_tomb")
            {
                lnchrIDs = ["m32_zm"];
                lnchrNames = ["War Machine"];
            }
            else
            {
                lnchrIDs = ["usrpg_zm","m32_zm"];
                lnchrNames = ["RPG", "War Machine"];
            }
            self addSliderString("Launchers", lnchrIDs, lnchrNames, ::AfterHit);

            if(level.currentMapName == "zm_buried")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm","slowgun_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII", "Paralyzer"];
            }
            else if(level.currentMapName == "zm_highrise")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm","slipgun_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII", "Sliquifier"];
            }
            else if(level.currentMapName == "zm_prison")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm","blundergat_zm","blundersplat_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII", "Blunder Gat", "Acid Gat"];
            }
            else if(level.currentMapName == "zm_transit" || level.currentMapName == "zm_nuked")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII"];
            }
            else if(level.currentMapName == "zm_tomb")
            {
                wwIDs = ["ray_gun_zm","raygun_mark2_zm","staff_fire_zm","staff_water_zm","staff_air_zm","staff_lightning_zm","staff_revive_zm"];
                wwNames = ["Ray Gun", "Ray Gun MKII", "Fire Staff", "Ice Staff", "Air Staff", "Lightning Staff", "Revive Staff"];
            }
            self addSliderString("Wonder Weapons", wwIDs, wwNames, ::AfterHit);


            break;

            case "acc":
            self addMenu("acc", "Account Menu");
            self addOpt("Give 100k", ::give100k);

            break;

            case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);

            minDistVal = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);
            
            self addToggle("Freeze Zombies", self.zmFrozen, ::togglefreezeZombies);
            self addOpt("Teleport Zombies", ::TeleportZombies);
            break;
        }
        self clientOptions();
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

        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 125, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
        self resizeMenu();
    }