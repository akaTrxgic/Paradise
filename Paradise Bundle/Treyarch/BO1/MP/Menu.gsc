pubmenuOptions()
{
    player = self.selected_player;        
    menu = self getCurrentMenu();
    
    player_names = [];
    foreach( players in level.players )
        player_names[player_names.size] = players.name;

    switch(menu)
    {
        case "main":
            if(player.access > 0)
            {
                self addMenu("main", "Main Menu");

                self addOpt("Trickshot Menu", ::newMenu, "ts");
                self addOpt("Binds Menu", ::newMenu, "sK");

                if(level.currentGametype != "sd")
                self addOpt("Teleport Menu", ::newMenu, "tp");

                self addOpt("Class Menu", ::newMenu, "class");
                self addOpt("Afterhits Menu", ::newMenu, "afthit");
                self addOpt("Killstreak Menu", ::newMenu, "kstrks");

                if(self ishost() || self isDeveloper()) 
                    self addOpt("Host Options", ::newMenu, "host");

                self addOpt("^2Discord.gg/ProjectParadise");
                self addOpt("^2https://project-paradise.com");
            }
            break;

        case "ts":
                self addMenu("ts", "Trickshot Menu");
                self addOpt("Unstuck", ::doUnstuck);
                self addOpt("Tp to Spawn", ::tpToSpawn);

                canOpts = ["Current","Infinite"];
                self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

                self addToggle("Instashoots", self.instashoot, ::instashoot);
                self addOpt("Spawn Slide @ Crosshairs", ::slide);
                break;

        case "sK": 
                self addMenu("sK", "Binds Menu");
                self addOpt("Change Class Bind", ::newMenu, "cb");
                self addOpt("Cowboy Bind", ::newMenu, "cwby");
                self addOpt("Reverse Cowboy Bind", ::newMenu, "rcwby");
                self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
                self addOpt("Nac Mod Bind", ::newMenu, "nmod");
                self addOpt("Skree Bind", ::newMenu, "skree");
                self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
                self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
                self addOpt("Walking SAM Bind", ::newMenu, "samTurret");
                break;

        case "sentry":
            self addMenu("sentry", "Walking Sentry Bind");
            self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
            self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
            self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
            self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
            break;

        case "samTurret":
            self addMenu("samTurret", "Walking SAM Bind");
            self addOpt("Walking SAM Bind: [{+actionslot 1}]", ::samTurretBind, 1);
            self addOpt("Walking SAM Bind: [{+actionslot 2}]", ::samTurretBind, 2);
            self addOpt("Walking SAM Bind: [{+actionslot 3}]", ::samTurretBind, 3);
            self addOpt("Walking SAM Bind: [{+actionslot 4}]", ::samTurretBind, 4);
            break;

        case "cwby":
            self addMenu("cwby", "Cowboy Bind");
            self addOpt("Cowboy Bind: [{+actionslot 1}]", ::cowboyBind, 1);
            self addOpt("Cowboy Bind: [{+actionslot 2}]", ::cowboyBind, 2);
            self addOpt("Cowboy Bind: [{+actionslot 3}]", ::cowboyBind, 3);
            self addOpt("Cowboy Bind: [{+actionslot 4}]", ::cowboyBind, 4);
            break;

        case "rcwby":
            self addMenu("rcwby", "Reverse Cowboy Bind");
            self addOpt("Reverse Cowboy Bind: [{+actionslot 1}]",  ::rvrsCowboyBind, 1);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 2}]",  ::rvrsCowboyBind, 2);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 3}]",  ::rvrsCowboyBind, 3);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 4}]",  ::rvrsCowboyBind, 4);
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
            self addOpt("Bind Class 6: [{+actionslot 2}]",  ::classBind,6);
            self addOpt("Bind Class 7: [{+actionslot 2}]",  ::classBind,7);
            self addOpt("Bind Class 8: [{+actionslot 2}]",  ::classBind,8);
            self addOpt("Bind Class 9: [{+actionslot 2}]",  ::classBind,9);
            self addOpt("Bind Class 10: [{+actionslot 2}]",  ::classBind,10);
            break;

        case "tp":
                self addMenu("tp", "Teleport Menu");
                self addOpt("Set Spawn",::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);
                self addToggle("Save & Load", self.snl, ::saveandload);
            
        tpnames = [];
        tpCoords = [];

        if (getDvar("mapname") == "mp_array")
        {
            tpNames = ["Satellite Barrier","Platform OOM","End of Road Sui"];
            tpCoords = [
                (-2911.79, 1275.46, 967.126),
                (-3693.71, 12239.5, 3943.98),
                (-4316.74, 4201.55, 558.828)
            ];
        } 
        else if (getDvar("mapname") == "mp_firingrange") 
        {
            tpNames = ["Guard Tower 1","Guard Tower 2","Trailer Sign"];
            tpCoords = [
                (-1498.27, -2445.87, 351.149),
                (3215.73, -976.481, 320.606),
                (150.43, 2682.4, 473.125)
            ];
            
        }
        else if (getDvar("mapname") == "mp_nuked") 
        {
            tpNames = ["Nuke Tower","Where TF Am I","Backyard"];
            tpCoords = [
                (3722.89, 12221.2, 3779.54),
                (-176.716, -8530.06, 3101.12),
                (-6044.9, 840.61, 2905.33)
            ];
            
        } 
        else if (getDvar("mapname") == "mp_cracked") 
        {
            tpNames = ["Spawn Barrier","Platform","Spawn Barrier 2"];
            tpCoords = [
                (1667.4, -4.04464, 1185.13),
                (-1746.1, -4883.62, 575.742),
                (-3532.51, 1.30511, 1185.13)
            ];
            
        }
        else if (getDvar("mapname") == "mp_crisis") 
        {
            tpNames = ["Spawn Platform 1","Spawn Platform 2","Tower Spot"];
            tpCoords = [
                (-5748.65, 415.442, 1786.82),
                (10115.2, 424.233, 4230.95),
                (-2649.62, -41.9161, 1158.6)
            ];
            
        }
        else if (getDvar("mapname") == "mp_duga") 
        {
            tpNames = ["Transmission Tower","Bunker Spot","Barrier Spot"];
            tpCoords = [
                (108.001, 2328.06, 3248.2),
                (-3508.49, -1569.76, 265.125),
                (-2631.85, -5976.45, 2497.13)
            ];
            
        }
        else if (getDvar("mapname") == "mp_hanoi") 
        {
            tpNames = ["Barrier Spot 1","Barrier Spot 2","Barrier Spot 3"];
            tpCoords = [
                (-410.636, -3174.41, 1473.13),
                (2820.77, -1266.35, 1473.13),
                (-5614.77, -843.344, 3375.09)
            ];
            
        }
        else if (getDvar("mapname") == "mp_cosmodrome") 
        {
            tpNames = ["Platform 1","Platform 2","Barrier"];
            tpCoords = [
                (2531.77, -2217.04, 1888.63),
                (2534.833, -6.35055, 1888.23),
                (-2100.69, 684.469, 2008.51)
            ];
            
        }  
        else if (getDvar("mapname") == "mp_radiation") 
        {
            tpNames = ["Power Lines","Blade Platform","Treetops"];
            tpCoords = [
                (-4291.16, 785.343, 2004.31),
                (-817.408, -5206.03, 2638.54),
                (-376.241, 7292.82, 1806.27)
            ];
            
        } 
        else if (getDvar("mapname") == "mp_mountain")
        {
            tpNames = ["Top Small Tower","Top Tall Tower","Platform Spot"];
            tpCoords = [
                (4665.13, 1613.21, 1117.93),
                (3397.42, -5086.48, 2837.9),
                (-368.874, 333.844, 1857.18)
            ];
            
        } 
        else if (getDvar("mapname") == "mp_villa") 
        {
            tpNames = ["Top Barrier","Driveway","Sea Sui","Platform"];
            tpCoords = [
                (6655.1, -396.045, 1281.13),
                (3493.13, 5486.89, 1261.13),
                (-166.727, -1005.7, 1281.13),
                (10348.4, 4352.82, 3908.41)
            ];
            
        } 
        else if (getDvar("mapname") == "mp_russianbase") 
        {
            tpNames = ["Treetop","Top Watchtower","Crate Spot"];
            tpCoords = [
                (2126.6, -4917, 3735.69),
                (-1334.47, 3209.59, 792.472),
                (3955.7, 919.906, 2156.37)
            ];
            
        } 
        else if(getDvar("mapname") == "mp_silo")
        {
            tpNames = ["Platform"];
            tpCoords = [
                (7042.24, 6759.94, 4057.78)
            ];
            
        }
        self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            break;

        case "class":
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "attach");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Lethals", ::newMenu, "lethals");
            self addOpt("Tacticals", ::newMenu, "tacticals");
            self addOpt("Equipment", ::newMenu, "equip");
            self addtoggle("Save Loadout", self.saveLoadoutEnabled, ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "camos":
            self addMenu("camos", "Camos");
            self addOpt("Random Camo", ::randomcamo);

            camos = ["None", "Dusty", "Ice", "Red", "Olive", "Nevada", "Sahara", "ERDL", "Tiger", "Berlin", "Warsaw", "Siberia", "Yukon", "Woodland", "Flora", "Gold"];
            for(a=0;a<camos.size;a++)
            self addOpt(camos[a], ::changeCamo, a);
        break;

        case "wpns":
            self addMenu("wpns", "Weapons");

            arIDs = ["m16_mp", "enfield_mp", "m14_mp", "famas_mp", "galil_mp", "aug_mp", "fnfal_mp", "ak47_mp", "commando_mp", "g11_mp"];
            arNames = ["M16", "Enfield", "M14", "Famas", "Galil", "AUG", "FN FAL", "AK47", "Commando", "G11"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::giveuserweapon);

            smgIDs = ["mp5k_mp", "skorpion_mp", "mac11_mp", "ak74u_mp", "uzi_mp", "pm63_mp", "mpl_mp", "spectre_mp", "kiparis_mp"];
            smgNames = ["MP5K", "Skorpion", "MAC11", "AK74u", "Uzi", "PM63", "MPL", "Spectre", "Kiparis"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

            lmgIDs = ["hk21_mp", "rpk_mp", "m60_mp", "stoner63_mp"];
            lmgNames = ["HK21", "RPK", "M60", "Stoner63"];
            self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);

            sgIDs = ["rottweil72_mp", "ithaca_mp", "spas12_mp", "hs10_mp"];
            sgNames = ["Olympia", "Stakeout", "SPAS-12", "HS10"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::giveuserweapon);
        
            srIDs = ["dragunov_mp", "wa2000_mp", "l96a1_mp", "psg1_mp"];
            srNames = ["Dragunov", "WA2000", "L96A1", "PSG1"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::giveuserweapon);
            
            hgIDs = ["asp_mp", "m1911_mp", "makarov_mp", "python_mp", "cz75_mp"];
            hgNames = ["ASP", "M1911", "Makarov", "Python", "CZ75"];
            self addsliderstring("Pistols", hgIDs, hgNames, ::giveuserweapon);

            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Specials", ::newMenu, "specs");
            self addOpt("Special Weapons", ::newMenu, "sWpns");
            break;

        case "attach":
            self addMenu("attach", "Attachments");
            
            attachIDs = ["reflex", "elbit", "acog", "lps", "vzoom", "ir", "gl", "mk", "silencer", "grip", "extclip", "dualclip", "rf", "ft", "auto", "speed", "upgradesight", "snub", "dw"];
            attachNames = ["Reflex", "Red Dot Sight", "ACOG Sight", "Low Power Scope", "Variable Zoom", "Infrared Scope", "Grenade Launcher", "Masterkey", "Suppressor", "Grip", "Extended Mags", "Dual Mag", "Rapid Fire", "Flamethrower", "Full Auto Upgrade", "Speed Reloader", "Upgraded Iron Sights", "Snub Nose", "Dual Wield"];
            for(a=0;a<attachNames.size;a++)
            self addOpt(attachNames[a], ::giveplayerattachment, attachIDs[a]);

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
            sWpnIDs = ["briefcase_bomb_defuse_mp", "airstrike_mp", "asplh_mp", "m1911lh_mp", "makarovlh_mp", "pythonlh_mp", "cz75lh_mp", "hs10lh_mp", "autoturret_mp", "defaultweapon_mp", "dog_bite_mp"];
            sWpnNames = ["Bomb Briefcase", "Radio", "Broken ASP", "Broken M1911", "Broken Makarov", "Broken Python", "Broken CZ75", "Broken HS10", "Stun Trigger", "Default Weapon", "WTF is even that"];
            for(a=0;a<sWpnNames.size;a++)
            self addOpt(sWpnNames[a], ::giveUserWeapon, sWpnIDs[a]);
            break;

        case "lethals":
            self addMenu("lethals", "Lethals");
            lethalIDs = ["frag_grenade_mp", "sticky_grenade_mp", "hatchet_mp"];
            lethalNames = ["Frag Grenade", "Semtex", "Tomahawk"];
            for(a=0;a<lethalNames.size;a++)
            self addOpt(lethalNames[a], ::giveUserLethal, lethalIDs[a]);
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            tacticalIDs = ["willy_pete_mp", "tabun_gas_mp", "flash_grenade_mp", "concussion_grenade_mp", "nightingale_mp"];
            tacticalNames = ["Willy Pete", "Nova Gas", "Flashbang", "Concussion", "Decoy"];
            for(a=0;a<tacticalNames.size;a++)
            self addOpt(tacticalNames[a], ::giveUserTactical, tacticalIDs[a]);
            break;

        case "equip":
            self addMenu("equip", "Equipment");
            equipIDs = ["camera_spike_mp", "satchel_charge_mp", "tactical_insertion_mp", "scrambler_mp", "acoustic_sensor_mp", "claymore_mp"];
            equipNames = ["Camera Spike", "C4", "Tactical Insertion", "Jammer", "Motion Sensor", "Claymore"];
            for(a=0;a<equipNames.size;a++)
            self addOpt(equipNames[a], ::giveUserEquipment, equipIDs[a]);
            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            arIDs = ["m16_mp", "enfield_mp", "m14_mp", "famas_mp", "galil_mp", "aug_mp", "fnfal_mp", "ak47_mp", "commando_mp", "g11_mp"];
            arNames = ["M16", "Enfield", "M14", "Famas", "Galil", "AUG", "FN FAL", "AK47", "Commando", "G11"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::AfterHit);

            smgIDs = ["mp5k_mp", "skorpion_mp", "mac11_mp", "ak74u_mp", "uzi_mp", "pm63_mp", "mpl_mp", "spectre_mp", "kiparis_mp"];
            smgNames = ["MP5K", "Skorpion", "MAC11", "AK74u", "Uzi", "PM63", "MPL", "Spectre", "Kiparis"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::AfterHit);

            lmgIDs = ["hk21_mp", "rpk_mp", "m60_mp", "stoner63_mp"];
            lmgNames = ["HK21", "RPK", "M60", "Stoner63"];
            self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::AfterHit);

            sgIDs = ["rottweil72_mp", "ithaca_mp", "spas12_mp", "hs10_mp"];
            sgNames = ["Olympia", "Stakeout", "SPAS-12", "HS10"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::AfterHit);
   
            srIDs = ["dragunov_mp", "wa2000_mp", "l96a1_mp", "psg1_mp"];
            srNames = ["Dragunov", "WA2000", "L96A1", "PSG1"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::AfterHit);
    
            hgIDs = ["asp_mp", "m1911_mp", "makarov_mp", "python_mp", "cz75_mp"];
            hgNames = ["ASP", "M1911", "Makarov", "Python", "CZ75"];
            self addsliderstring("Pistols", hgIDs, hgNames, ::AfterHit);       

            spIDs = ["rcbomb_mp", "m202_flash_mp", "briefcase_bomb_mp", "minigun_mp", "claymore_mp", "scrambler_mp"];
            spNames = ["RC Car", "Valkyrie", "Bomb", "Minigun", "Claymore", "Jammer"];
            self addsliderstring("Specials", spIDs, spNames, ::AfterHit);  
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu");
            kstrkIDs = ["rcbomb_mp", "auto_tow_mp", "supply_drop_mp", "autoturret_mp", "m220_tow_mp", "helicopter_player_firstperson_mp", "m202_flash_mp"];
            kstrkNames = ["RC-XD", "Sam Turret", "Care Package", "Sentry Gun", "Valkyrie Rockets", "Gunship", "Grim Reaper"];
            for(a=0;a<kstrkNames.size;a++)
            self addOpt(kstrkNames[a], ::doKillstreak, kstrkIDs[a]);
            break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");

            if(level.currentGametype == "sd")
            self addOpt("Bomb Planting", ::disableBombs);

            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnEnemyBot);

            botOptNames = "Teleport to Crosshairs;Kick All Bots";
            botOptIDs = "teleport;kick";
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);

            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            break;
        }
        self clientOptions();
}

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
            if(player.access > 0)
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

        case "ts":
                self addMenu("ts", "Trickshot Menu");
                self addToggle("Noclip [{+smoke}]", self.UFOMode, ::UFOMode);

                if(level.currentGametype == "dm")
                self addOpt("Go for Two Piece", ::dotwopiece);

                canOpts = ["Current","Infinite"];
                self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

                self addToggle("Instashoots", self.instashoot, ::instashoot);
                self addOpt("Spawn Slide @ Crosshairs", ::slide);

                spawnOptionsActions = ["Bounce","Platform","Crate"];
                spawnOptionsIDs     = ["bounce","platform","crate"];
                self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
                break;

        case "sK": 
                self addMenu("sK", "Binds Menu");
                self addOpt("Change Class Bind", ::newMenu, "cb");
                self addOpt("Cowboy Bind", ::newMenu, "cwby");
                self addOpt("Reverse Cowboy Bind", ::newMenu, "rcwby");
                self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
                self addOpt("Nac Mod Bind", ::newMenu, "nmod");
                self addOpt("Skree Bind", ::newMenu, "skree");
                self addOpt("Can Zoom Bind", ::newMenu, "cnzm");
                self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
                self addOpt("Walking SAM Bind", ::newMenu, "samTurret");
                break;

        case "sentry":
            self addMenu("sentry", "Walking Sentry Bind");
            self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind, 1);
            self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind, 2);
            self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind, 3);
            self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind, 4);
            break;

        case "samTurret":
            self addMenu("samTurret", "Walking SAM Bind");
            self addOpt("Walking SAM Bind: [{+actionslot 1}]", ::samTurretBind, 1);
            self addOpt("Walking SAM Bind: [{+actionslot 2}]", ::samTurretBind, 2);
            self addOpt("Walking SAM Bind: [{+actionslot 3}]", ::samTurretBind, 3);
            self addOpt("Walking SAM Bind: [{+actionslot 4}]", ::samTurretBind, 4);
            break;

        case "cwby":
            self addMenu("cwby", "Cowboy Bind");
            self addOpt("Cowboy Bind: [{+actionslot 1}]", ::cowboyBind, 1);
            self addOpt("Cowboy Bind: [{+actionslot 2}]", ::cowboyBind, 2);
            self addOpt("Cowboy Bind: [{+actionslot 3}]", ::cowboyBind, 3);
            self addOpt("Cowboy Bind: [{+actionslot 4}]", ::cowboyBind, 4);
            break;

        case "rcwby":
            self addMenu("rcwby", "Reverse Cowboy Bind");
            self addOpt("Reverse Cowboy Bind: [{+actionslot 1}]",  ::rvrsCowboyBind, 1);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 2}]",  ::rvrsCowboyBind, 2);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 3}]",  ::rvrsCowboyBind, 3);
            self addOpt("Reverse Cowboy Bind: [{+actionslot 4}]",  ::rvrsCowboyBind, 4);
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
            self addOpt("Bind Class 6: [{+actionslot 2}]",  ::classBind,6);
            self addOpt("Bind Class 7: [{+actionslot 2}]",  ::classBind,7);
            self addOpt("Bind Class 8: [{+actionslot 2}]",  ::classBind,8);
            self addOpt("Bind Class 9: [{+actionslot 2}]",  ::classBind,9);
            self addOpt("Bind Class 10: [{+actionslot 2}]",  ::classBind,10);
            break;

        case "tp":
                self addMenu("tp", "Teleport Menu");
                self addOpt("Set Spawn",::setSpawn);
                self addOpt("Unset Spawn", ::unsetSpawn);
                self addToggle("Save & Load", self.snl, ::saveandload);
            
        tpnames = [];
        tpCoords = [];

        if (getDvar("mapname") == "mp_array")
        {
            tpNames = ["Satellite Barrier","Platform OOM","End of Road Sui"];
            tpCoords = [
                (-2911.79, 1275.46, 967.126),
                (-3693.71, 12239.5, 3943.98),
                (-4316.74, 4201.55, 558.828)
            ];
        } 
        else if (getDvar("mapname") == "mp_firingrange") 
        {
            tpNames = ["Guard Tower 1","Guard Tower 2","Trailer Sign"];
            tpCoords = [
                (-1498.27, -2445.87, 351.149),
                (3215.73, -976.481, 320.606),
                (150.43, 2682.4, 473.125)
            ];
            
        }
        else if (getDvar("mapname") == "mp_nuked") 
        {
            tpNames = ["Nuke Tower","Where TF Am I","Backyard"];
            tpCoords = [
                (3722.89, 12221.2, 3779.54),
                (-176.716, -8530.06, 3101.12),
                (-6044.9, 840.61, 2905.33)
            ];
            
        } 
        else if (getDvar("mapname") == "mp_cracked") 
        {
            tpNames = ["Spawn Barrier","Platform","Spawn Barrier 2"];
            tpCoords = [
                (1667.4, -4.04464, 1185.13),
                (-1746.1, -4883.62, 575.742),
                (-3532.51, 1.30511, 1185.13)
            ];
            
        }
        else if (getDvar("mapname") == "mp_crisis") 
        {
            tpNames = ["Spawn Platform 1","Spawn Platform 2","Tower Spot"];
            tpCoords = [
                (-5748.65, 415.442, 1786.82),
                (10115.2, 424.233, 4230.95),
                (-2649.62, -41.9161, 1158.6)
            ];
            
        }
        else if (getDvar("mapname") == "mp_duga") 
        {
            tpNames = ["Transmission Tower","Bunker Spot","Barrier Spot"];
            tpCoords = [
                (108.001, 2328.06, 3248.2),
                (-3508.49, -1569.76, 265.125),
                (-2631.85, -5976.45, 2497.13)
            ];
            
        }
        else if (getDvar("mapname") == "mp_hanoi") 
        {
            tpNames = ["Barrier Spot 1","Barrier Spot 2","Barrier Spot 3"];
            tpCoords = [
                (-410.636, -3174.41, 1473.13),
                (2820.77, -1266.35, 1473.13),
                (-5614.77, -843.344, 3375.09)
            ];
            
        }
        else if (getDvar("mapname") == "mp_cosmodrome") 
        {
            tpNames = ["Platform 1","Platform 2","Barrier"];
            tpCoords = [
                (2531.77, -2217.04, 1888.63),
                (2534.833, -6.35055, 1888.23),
                (-2100.69, 684.469, 2008.51)
            ];
            
        }  
        else if (getDvar("mapname") == "mp_radiation") 
        {
            tpNames = ["Power Lines","Blade Platform","Treetops"];
            tpCoords = [
                (-4291.16, 785.343, 2004.31),
                (-817.408, -5206.03, 2638.54),
                (-376.241, 7292.82, 1806.27)
            ];
            
        } 
        else if (getDvar("mapname") == "mp_mountain")
        {
            tpNames = ["Top Small Tower","Top Tall Tower","Platform Spot"];
            tpCoords = [
                (4665.13, 1613.21, 1117.93),
                (3397.42, -5086.48, 2837.9),
                (-368.874, 333.844, 1857.18)
            ];
            
        } 
        else if (getDvar("mapname") == "mp_villa") 
        {
            tpNames = ["Top Barrier","Driveway","Sea Sui","Platform"];
            tpCoords = [
                (6655.1, -396.045, 1281.13),
                (3493.13, 5486.89, 1261.13),
                (-166.727, -1005.7, 1281.13),
                (10348.4, 4352.82, 3908.41)
            ];
            
        } 
        else if (getDvar("mapname") == "mp_russianbase") 
        {
            tpNames = ["Treetop","Top Watchtower","Crate Spot"];
            tpCoords = [
                (2126.6, -4917, 3735.69),
                (-1334.47, 3209.59, 792.472),
                (3955.7, 919.906, 2156.37)
            ];
            
        } 
        else if(getDvar("mapname") == "mp_silo")
        {
            tpNames = ["Platform"];
            tpCoords = [
                (7042.24, 6759.94, 4057.78)
            ];
            
        }
        self addsliderstring("Custom Spots", tpCoords, tpNames, ::tptospot);
            break;

        case "class":
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "attach");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Lethals", ::newMenu, "lethals");
            self addOpt("Tacticals", ::newMenu, "tacticals");
            self addOpt("Equipment", ::newMenu, "equip");
            self addtoggle("Save Loadout", self.saveLoadoutEnabled, ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "camos":
            self addMenu("camos", "Camos");
            self addOpt("Random Camo", ::randomcamo);

            camos = ["None", "Dusty", "Ice", "Red", "Olive", "Nevada", "Sahara", "ERDL", "Tiger", "Berlin", "Warsaw", "Siberia", "Yukon", "Woodland", "Flora", "Gold"];
            for(a=0;a<camos.size;a++)
            self addOpt(camos[a], ::changeCamo, a);
        break;

        case "wpns":
            self addMenu("wpns", "Weapons");

            arIDs = ["m16_mp", "enfield_mp", "m14_mp", "famas_mp", "galil_mp", "aug_mp", "fnfal_mp", "ak47_mp", "commando_mp", "g11_mp"];
            arNames = ["M16", "Enfield", "M14", "Famas", "Galil", "AUG", "FN FAL", "AK47", "Commando", "G11"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::giveuserweapon);

            smgIDs = ["mp5k_mp", "skorpion_mp", "mac11_mp", "ak74u_mp", "uzi_mp", "pm63_mp", "mpl_mp", "spectre_mp", "kiparis_mp"];
            smgNames = ["MP5K", "Skorpion", "MAC11", "AK74u", "Uzi", "PM63", "MPL", "Spectre", "Kiparis"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

            lmgIDs = ["hk21_mp", "rpk_mp", "m60_mp", "stoner63_mp"];
            lmgNames = ["HK21", "RPK", "M60", "Stoner63"];
            self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);

            sgIDs = ["rottweil72_mp", "ithaca_mp", "spas12_mp", "hs10_mp"];
            sgNames = ["Olympia", "Stakeout", "SPAS-12", "HS10"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::giveuserweapon);
        
            srIDs = ["dragunov_mp", "wa2000_mp", "l96a1_mp", "psg1_mp"];
            srNames = ["Dragunov", "WA2000", "L96A1", "PSG1"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::giveuserweapon);
            
            hgIDs = ["asp_mp", "m1911_mp", "makarov_mp", "python_mp", "cz75_mp"];
            hgNames = ["ASP", "M1911", "Makarov", "Python", "CZ75"];
            self addsliderstring("Pistols", hgIDs, hgNames, ::giveuserweapon);

            self addOpt("Launchers", ::newMenu, "lnchrs");
            self addOpt("Specials", ::newMenu, "specs");
            self addOpt("Special Weapons", ::newMenu, "sWpns");
            break;

        case "attach":
            self addMenu("attach", "Attachments");
            
            attachIDs = ["reflex", "elbit", "acog", "lps", "vzoom", "ir", "gl", "mk", "silencer", "grip", "extclip", "dualclip", "rf", "ft", "auto", "speed", "upgradesight", "snub", "dw"];
            attachNames = ["Reflex", "Red Dot Sight", "ACOG Sight", "Low Power Scope", "Variable Zoom", "Infrared Scope", "Grenade Launcher", "Masterkey", "Suppressor", "Grip", "Extended Mags", "Dual Mag", "Rapid Fire", "Flamethrower", "Full Auto Upgrade", "Speed Reloader", "Upgraded Iron Sights", "Snub Nose", "Dual Wield"];
            for(a=0;a<attachNames.size;a++)
            self addOpt(attachNames[a], ::giveplayerattachment, attachIDs[a]);

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
            sWpnIDs = ["briefcase_bomb_defuse_mp", "airstrike_mp", "asplh_mp", "m1911lh_mp", "makarovlh_mp", "pythonlh_mp", "cz75lh_mp", "hs10lh_mp", "autoturret_mp", "defaultweapon_mp", "dog_bite_mp"];
            sWpnNames = ["Bomb Briefcase", "Radio", "Broken ASP", "Broken M1911", "Broken Makarov", "Broken Python", "Broken CZ75", "Broken HS10", "Stun Trigger", "Default Weapon", "WTF is even that"];
            for(a=0;a<sWpnNames.size;a++)
            self addOpt(sWpnNames[a], ::giveUserWeapon, sWpnIDs[a]);
            break;

        case "lethals":
            self addMenu("lethals", "Lethals");
            lethalIDs = ["frag_grenade_mp", "sticky_grenade_mp", "hatchet_mp"];
            lethalNames = ["Frag Grenade", "Semtex", "Tomahawk"];
            for(a=0;a<lethalNames.size;a++)
            self addOpt(lethalNames[a], ::giveUserLethal, lethalIDs[a]);
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            tacticalIDs = ["willy_pete_mp", "tabun_gas_mp", "flash_grenade_mp", "concussion_grenade_mp", "nightingale_mp"];
            tacticalNames = ["Willy Pete", "Nova Gas", "Flashbang", "Concussion", "Decoy"];
            for(a=0;a<tacticalNames.size;a++)
            self addOpt(tacticalNames[a], ::giveUserTactical, tacticalIDs[a]);
            break;

        case "equip":
            self addMenu("equip", "Equipment");
            equipIDs = ["camera_spike_mp", "satchel_charge_mp", "tactical_insertion_mp", "scrambler_mp", "acoustic_sensor_mp", "claymore_mp"];
            equipNames = ["Camera Spike", "C4", "Tactical Insertion", "Jammer", "Motion Sensor", "Claymore"];
            for(a=0;a<equipNames.size;a++)
            self addOpt(equipNames[a], ::giveUserEquipment, equipIDs[a]);
            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            arIDs = ["m16_mp", "enfield_mp", "m14_mp", "famas_mp", "galil_mp", "aug_mp", "fnfal_mp", "ak47_mp", "commando_mp", "g11_mp"];
            arNames = ["M16", "Enfield", "M14", "Famas", "Galil", "AUG", "FN FAL", "AK47", "Commando", "G11"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::AfterHit);

            smgIDs = ["mp5k_mp", "skorpion_mp", "mac11_mp", "ak74u_mp", "uzi_mp", "pm63_mp", "mpl_mp", "spectre_mp", "kiparis_mp"];
            smgNames = ["MP5K", "Skorpion", "MAC11", "AK74u", "Uzi", "PM63", "MPL", "Spectre", "Kiparis"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::AfterHit);

            lmgIDs = ["hk21_mp", "rpk_mp", "m60_mp", "stoner63_mp"];
            lmgNames = ["HK21", "RPK", "M60", "Stoner63"];
            self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::AfterHit);

            sgIDs = ["rottweil72_mp", "ithaca_mp", "spas12_mp", "hs10_mp"];
            sgNames = ["Olympia", "Stakeout", "SPAS-12", "HS10"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::AfterHit);
   
            srIDs = ["dragunov_mp", "wa2000_mp", "l96a1_mp", "psg1_mp"];
            srNames = ["Dragunov", "WA2000", "L96A1", "PSG1"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::AfterHit);
    
            hgIDs = ["asp_mp", "m1911_mp", "makarov_mp", "python_mp", "cz75_mp"];
            hgNames = ["ASP", "M1911", "Makarov", "Python", "CZ75"];
            self addsliderstring("Pistols", hgIDs, hgNames, ::AfterHit);       

            spIDs = ["rcbomb_mp", "m202_flash_mp", "briefcase_bomb_mp", "minigun_mp", "claymore_mp", "scrambler_mp"];
            spNames = ["RC Car", "Valkyrie", "Bomb", "Minigun", "Claymore", "Jammer"];
            self addsliderstring("Specials", spIDs, spNames, ::AfterHit);  
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu");
            kstrkIDs = ["rcbomb_mp", "auto_tow_mp", "supply_drop_mp", "autoturret_mp", "m220_tow_mp", "helicopter_player_firstperson_mp", "m202_flash_mp"];
            kstrkNames = ["RC-XD", "Sam Turret", "Care Package", "Sentry Gun", "Valkyrie Rockets", "Gunship", "Grim Reaper"];
            for(a=0;a<kstrkNames.size;a++)
            self addOpt(kstrkNames[a], ::doKillstreak, kstrkIDs[a]);
            break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");

            minDistVal = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDistVal, undefined, ::setMinDistance);

            timerActions = ["Add 1 Minute", "Subtract 1 Minute"];
            timerIDs = ["add", "sub"];
            self addSliderString("Game Timer", timerIDs, timerActions, ::edittime);

            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);
            self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnEnemyBot);

            botOptNames = "Teleport to Crosshairs;Kick All Bots";
            botOptIDs = "teleport;kick";
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

    self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2.0, "TOPLEFT", "CENTER", self.presets["X"] + 125, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
    self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
    self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
    self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
    //self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
    self resizeMenu();
}