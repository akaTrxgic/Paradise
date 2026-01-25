pwpn()
{
    self iprintln("^1" + self getcurrentweapon());
}

menuOptions()
{
    player = self.selected_player;        
    menu = self getCurrentMenu();
    
    player_names = [];

    foreach( players in level.players ) player_names[player_names.size] = players.name;

    switch(menu)
    {
        case "main":
            if(self.access > 0)
            {
                self addMenu("main", "Main Menu");
                //self addOpt("Print Wpn Name", ::pwpn);
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
                self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

            if(level.currentGametype == "dm")
                self addOpt("Go for Two Piece", ::dotwopiece);

                canOpts = "Current;Infinite";
                self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

                self addToggle("Instashoots", self.instashoot, ::instashoot);

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
                self addOpt("Bomb Briefcase Bind", ::newMenu, "bomb");
                break;
            
        case "bomb":
                self addMenu("bomb", "Bomb Bind");
                self addOpt("Bomb Bind: [{+actionslot 1}]", ::bombBind, 1);
                self addOpt("Bomb Bind: [{+actionslot 2}]", ::bombBind, 2);
                self addOpt("Bomb Bind: [{+actionslot 3}]", ::bombBind, 3);
                self addOpt("Bomb Bind: [{+actionslot 4}]", ::bombBind, 4);
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
            self addOpt("Bind Class 1: [{+actionslot 2}]",  ::classBind,1);
            self addOpt("Bind Class 2: [{+actionslot 2}]",  ::classBind,2);
            self addOpt("Bind Class 3: [{+actionslot 2}]",  ::classBind,3);
            self addOpt("Bind Class 4: [{+actionslot 2}]",  ::classBind,4);
            self addOpt("Bind Class 5: [{+actionslot 2}]",  ::classBind,5);
            break;

        case "tp":
        self addMenu("tp", "Teleport Menu");

        self addOpt("Set Spawn", ::setSpawn);
        self addOpt("Unset Spawn", ::unsetSpawn);
        self addToggle("Save & Load", self.snl, ::saveandload);
        
        tpNames = [];
        tpCoords = [];

        if(getDvar("mapname") == "mp_convoy")
        {
            tpID = "Roof 1;Roof 2;Roof 3; Water Tower; Roof 4";
            tpCoords = [
                (-3324.6, 1091, 209),
                (3333.45, 286.406, 262),
                (-3611.36, 545.334, 215),
                (-4996.65, -1593.61, 1005),
                (833.212, 3168.46, 301)
            ];
        }
        else if(getDvar("mapname") == "mp_backlot")
        {
            tpID = "OOM Roof;Roof Barrier";
            tpCoords = [
                (152.727, -4319.96, 765),
                (2735.67, 145.16, 1030)
            ];
        }
        else if(getDvar("mapname") == "mp_bloc")
        {
            tpID = "Roof 1;Roof 2";
            tpCoords = [
                (5084.75, -6298.82, 1321),
                (-98.0987, -10996.9, 650)
            ];
        }
        else if(getDvar("mapname") == "mp_bog")
        {
            tpID = "Roof 1;Roof 2;Highway Sign;Roof 3";
            tpCoords = [ 
                (1210.42, 352.161, 460),
                (1514.04, -612.295, 408),
                (5985.11, 4013.33, 795),
                (5911.52, 6847.09, 694)
            ];
        }
        else if(getDvar("mapname") == "mp_bog_summer")
        {
            tpID = "Roof 1;Roof 2;Highway Sign;Roof 3";
            tpCoords = [ 
                (1210.42, 352.161, 460),
                (1514.04, -612.295, 408),
                (5985.11, 4013.33, 795),
                (8447.37, 2359.74, 809)
            ];
        }
        else if(getDvar("mapname") == "mp_countdown")
        {
            tpID = "Roof 1;Roof 2";
            tpCoords = [
                (627.775, 5046.09, 227.125),
                (2901.54, -2246.11, 212)
            ];
        }
        else if(getDvar("mapname") == "mp_crash" || getDvar("mapname") == "mp_crash_snow")
        {
            tpID = "Roof 1;Roof Ledge";
            tpCoords = [
                (-1759.95, 3082.42, 875),
                (-3681.95, -1688.14, 773)
            ];
        }
        else if(getDvar("mapname") == "mp_crossfire")
        {
            tpID = "Arch Barrier;Roof 1;Roof 2;Roof 3";
            tpCoords = [
                (3317.95, 214.137, 2817),
                (1851.86, -4002.45, 350),
                (10394.7, -6591.26, 645),
                (7752.83, -1682.19, 705)
            ];
        }
        else if(getDvar("mapname") == "mp_citystreets")
        {
            tpID = "Roof 1;Roof 2";
            tpCoords = [
                (7583.01, -107.11, 801),
                (4007.13, 3370.43, 897)
            ];
        }
        else if(getDvar("mapname") == "mp_farm")
        {
            tpID = "Barn Roof 1;Barn Roof 2;Roof 1";
            tpCoords = [
                (4657.43, 2267.37, 762),
                (-18022.4, -4800.22, 1025),
                (2933.97, -1506.9, 548)
            ];
        }
        else if(getDvar("mapname") == "mp_farm_spring")
        {
            tpID = "Barn Roof 1;Roof 1";
            tpCoords = [
                (4562.39, 2379.87, 610),
                (2933.97, -1506.9, 548)
            ];
        }
        else if(getDvar("mapname") == "mp_pipeline")
        {
            tpID = "Pipe Pillar;Warehouse Rafters";
            tpCoords = [
                (2439.66, 6253.07, 989),
                (841.095, 786.229, 399)
            ];
        }
        else if(getDvar("mapname") == "mp_shipment")
        {
            tpID = "Roof 1; Roof 2;Roof 3";
            tpCoords = [
                (-1403.65, -2688.75, 1516),
                (568.239, -3618.37, 1516),
                (4269.6, -4634.83, 1516)
            ];
        }
        else if(getDvar("mapname") == "mp_showdown")
        {
            tpID = "Roof Ledge 1;Roof Ledge 2;Roof Ledge 3";
            tpCoords = [
                (3159.01, 680.574, 823.625),
                (4716.71, -2397.68, 1095),
                (-3979.78, -57.2232, 1390)
            ];
        }
        else if(getDvar("mapname") == "mp_strike")
        {
            tpID = "Roof";
            tpCoords = [
                (1164.22, 4871.36, 500)
            ];
        }
        else if(getDvar("mapname") == "mp_vacant")
        {
            tpID = "Roof 1;Roof 2;Roof 3";
            tpCoords = [
                (9917.73, -338.348, 1033),
                (11030.4, -2785.04, 1177),
                (-5085.43, 2748.63, 1199)
            ];
        }
        else 
        {
            tpNames  = "No Custom Spots";
            tpCoords = [];
        }
        self addSliderString("Spots", tpCoords, tpID, ::tptospot);
        break;

        case "class":
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            //self addOpt("Attachments", ::newMenu, "atchmnts");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Akimbo Weapon", ::GivePlayerAttachment, "none");
            //self addOpt("Equipment", ::newMenu, "lethals");
            //self addOpt("Special Grenades", ::newMenu, "tacticals");
            self addToggle("Save Loadout", self.saveLoadoutEnabled, ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons Menu");

            arNames = ["M16A4","AK-47","M4 Carbine","G3","G36C", "M14", "MP44", "XM-LAR", "BOS14", "LYNX CQ300"];
            arIDs   = ["m16", "ak47", "m4", "g3", "g36c", "m14", "mp44", "xmlar", "aprast", "augast"];
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgNames = ["MP5","Skorpion","Mini-Uzi","AK-74u", "P90", "MAC-10", "FANG 45", "PK-PSD9"];
            smgIDs   = ["mp5", "skorpion", "uzi", "ak74u", "p90", "febsmg", "aprsmg", "augsmg"];
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgNames = ["M249 SAW", "RPD", "M60E4", "PKM", "Bered MK8"];
            lmgIDs   = ["saw", "rpd", "m60e4", "feblmg", "junlmg"];
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            srNames = ["M40A3","M21","Dragunov","R700","Barrett .50cal", "D25S", "S-TAC Aggressor"];
            srIDs   = ["m40a3", "m21", "dragunov", "remington700", "barrett", "febsnp", "junsnp"];
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            sgNames = ["W1200","M1014", "Kamchatka 12", "Rangers"];
            sgIDs   = ["winchester1200", "m1014", "kam12", "junsho"];
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            pstlNames = ["M9", "USP .45", "M1911 .45", "Desert Eagle", "Commander Desert Eagle", ".44 Magnum", "Prokolot", "BR9"];
            pstlIDs   = ["beretta", "usp", "colt45", "deserteagle", "deserteagle55", "janpst", "aprpst", "augpst"];
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            specNames = ["PP2000", "Galil", "Striker", "FAL", "Dragonuv", "M240", ".44 Magnum"];
            specIDs = ["pp2000", "galil", "striker", "fal", "vssvintorez", "m240", "coltanaconda"];
            self addSliderString("Specials", specIDs, specNames, ::giveSpecWeapon);

            meleeNames = ["Cleaver", "Machete", "Thug", "Tidal", "Shamrock Blade", "Sickle", "Brawler's Brew", "Point Knife", "Sarsaparilla", "Sawtooth", "Diabolical", "Bludgeon", "Nauticus", "Danger Close", "Tribal", "Barber", "Cliffhanger", "OMSK Hammer", "Scorpion", "Gravedigger", "Gladiator", "CQB Bayonet", "Enforce", "Mechanic", "Samurai", "Hatchetman", "Caveman", "Leprechaun"];
            meleeIDs = ["meleejun2", "meleeapr2", "meleefeb4", "meleejun4", "meleefeb2", "meleesickle", "meleebottle", "meleeaug3", "meleejun6", "meleeapr4", "meleeapr3", "meleejun1", "meleejun3", "meleeaug1", "meleejun5", "meleeaug2", "meleeicepick", "meleepaddle", "meleeblade", "meleeshovel", "meleegladius", "meleebayonet", "meleeaug4", "meleefeb1", "meleefeb3", "meleehatchet", "meleeapr1", "meleefeb5"];
            self addSliderString("Melee", meleeIDs, meleeNames, ::giveUserWeapon);
            break;

        
        case "atchmnts":
            self addMenu("atchmnts", "Attachments");
            
            attachmentIDs = ["none", "glmwr", "reflexmwr", "silencermwr", "acogmwr", "gripmwr"];
            attachmentNames = ["None", "Grenade Launcher", "Red Dot Sight", "Silencer", "ACOG", "Foregrip"];
            for(a=0;a<attachmentIDs.size;a++)
            self addOpt( attachmentNames[a], ::GivePlayerAttachment, attachmentIDs[a]);
            break;
        
        case "camos":
            self addMenu("camos", "Camos");          
            self addOpt("Random Camo", ::randomCamo);
            
            self addOpt("Base Camos", ::newMenu, "base");
            self addOpt("Treyarch Camos", ::newMenu, "3arc");
            self addOpt("Infinity Ward Camos", ::newMenu, "iw");
            self addOpt("Minecraft Camos", ::newMenu, "mc");
            self addOpt("Extra Camos", ::newMenu, "xtra");
            self addOpt("Test Camos", ::newMenu, "test");
            break;

        case "base":
            self addMenu("base", "Base Camos");
            for(a = 0; a < 368; a++)
                    self addOpt(CamoNameTable(a), ::equip_camo, a);
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

        case "test":
            self addMenu("test", "Test Camos");
            camoNames = ["abs1", "bbgtgr", "blobsid", "blrltgr", "blupal", "bo3aowgl", "bo3aow", "coral", "ffood", "graf", "grpal", "jack", "mlg", "mop", "nb4c", "paradise", "prplpal", "rpal", "space", "trxgic", "trxgic2"];
            camoIDs = ["abs1", "bbgtgr", "blobsid", "blrltgr", "blupal", "bo3aowgl", "bo3aow", "coral", "ffood", "graf", "grpal", "jack", "mlg", "mop", "nb4c", "paradise", "prplpal", "rpal", "space", "trxgic", "trxgic2"];
            for(a=0;a<camoNames.size;a++)
            self addOpt(camoNames[a], ::customCamos, camoIDs[a]);
        break;

        /*
        case "lethals":
            self addMenu("lethals", "Equipment");
            self addOpt("C4 x2", ::giveOffhand);
            self addOpt("RPG-7 x2", ::giveOffhand);
            self addOpt("Claymore x2", ::giveOffhand);
            break;

        case "tacticals":
            self addMenu("tacticals", "Special Grenades");  
            self addOpt("Flash Grenade", maps\mp\gametypes\_class::giveOffhand, "h1_flashgrenade_mp");
            self addOpt("Stun Grenade", maps\mp\gametypes\_class::giveOffhand, "h1_concussiongrenade_mp");
            self addOpt("Smoke Grenade", maps\mp\gametypes\_class::giveOffhand, "h1_smokegrenade_mp");
            break;
        */

        case "afthit":  // Afterhits Menu
            self addMenu("afthit", "Afterhits Menu");

            arNames = ["M16A4","AK-47","M4 Carbine","G3","G36C", "M14", "MP44", "XM-LAR", "BOS14", "LYNX CQ300"];
            arIDs   = ["m16", "ak47", "m4", "g3", "g36c", "m14", "mp44", "xmlar", "aprast", "augast"];
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgNames = ["MP5","Skorpion","Mini-Uzi","AK-74u", "P90", "MAC-10", "FANG 45", "PK-PSD9"];
            smgIDs   = ["mp5", "skorpion", "uzi", "ak74u", "p90", "febsmg", "aprsmg", "augsmg"];
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::afterhit);

            lmgNames = ["M249 SAW", "RPD", "M60E4", "PKM", "Bered MK8"];
            lmgIDs   = ["saw", "rpd", "m60e4", "feblmg", "junlmg"];
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srNames = ["M40A3","M21","Dragunov","R700","Barrett .50cal", "D25S", "S-TAC Aggressor"];
            srIDs   = ["m40a3", "m21", "dragunov", "remington700", "barrett", "febsnp", "junsnp"];
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::afterhit);

            sgNames = ["W1200","M1014", "Kamchatka 12", "Rangers"];
            sgIDs   = ["winchester1200", "m1014", "kam12", "junsho"];
            self addSliderstring("Shotguns", sgIDs, sgNames, ::afterhit);

            pstlNames = ["M9", "USP .45", "M1911 .45", "Desert Eagle", "Commander Desert Eagle", ".44 Magnum", "Prokolot", "BR9"];
            pstlIDs   = ["beretta", "usp", "colt45", "deserteagle", "deserteagle55", "janpst", "aprpst", "augpst"];
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::afterhit);

            meleeNames = ["Cleaver", "Machete", "Thug", "Tidal", "Shamrock Blade", "Sickle", "Brawler's Brew", "Point Knife", "Sarsaparilla", "Sawtooth", "Diabolical", "Bludgeon", "Nauticus", "Danger Close", "Tribal", "Barber", "Cliffhanger", "OMSK Hammer", "Scorpion", "Gravedigger", "Gladiator", "CQB Bayonet", "Enforce", "Mechanic", "Samurai", "Hatchetman", "Caveman", "Leprechaun"];
            meleeIDs = ["meleejun2", "meleeapr2", "meleefeb4", "meleejun4", "meleefeb2", "meleesickle", "meleebottle", "meleeaug3", "meleejun6", "meleeapr4", "meleeapr3", "meleejun1", "meleejun3", "meleeaug1", "meleejun5", "meleeaug2", "meleeicepick", "meleepaddle", "meleeblade", "meleeshovel", "meleegladius", "meleebayonet", "meleeaug4", "meleefeb1", "meleefeb3", "meleehatchet", "meleeapr1", "meleefeb5"];
            self addSliderString("Melee", meleeIDs, meleeNames, ::afterhit);
            break;

        case "acc":
            self addMenu("acc", "Account Menu");
            
            //prestID = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"];
            //self addsliderString("Set Prestige", prestID, undefined, ::doPrestige);

            self addOpt("Unlock All ", ::AllChallenges, self);
        break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);

            minDistVal = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);

            timeActions = ["Add 1 Minute","Remove 1 Minute"];
            timeIDs = ["add","sub"];
            self addSliderString("Game Timer", timeIDs, timeActions, ::editTime);

            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);

            botOptNames = ["TP Bots","Spawn 18 Bots","Kick All Bots"];
            botOptIDs = ["teleport","fill","kick"];
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);

            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
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

    self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
    self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
    self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
    self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
    self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
    resizeMenu();
}