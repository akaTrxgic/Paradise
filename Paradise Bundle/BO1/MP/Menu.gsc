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
            self addToggle("Noclip [{+smoke}]", self.UFOMode, ::UFOMode);

            canOpts = ["Current","Infinite"];
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = ["Bounce","Platform","Crate"];
            spawnOptionsIDs     = ["bounce","platform","crate"];
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

   case "class":  // Class Menu
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

    smgIDs = ["mp5k_mp", "skorpion_mp", "mac11_mp", "ak74u_mp", "uzi_mp", "pm63_mp", "mpl_mp", "spectre_mp", "kiparis_mp"];
    smgNames = ["MP5K", "Skorpion", "MAC11", "AK74u", "Uzi", "PM63", "MPL", "Spectre", "Kiparis"];
    self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveuserweapon);

    arIDs = ["m16_mp", "enfield_mp", "m14_mp", "famas_mp", "galil_mp", "aug_mp", "fnfal_mp", "ak47_mp", "commando_mp", "g11_mp"];
    arNames = ["M16", "Enfield", "M14", "Famas", "Galil", "AUG", "FN FAL", "AK47", "Commando", "G11"];
    self addsliderstring("Assault Rifles", arIDs, arNames, ::giveuserweapon);

    sgIDs = ["rottweil72_mp", "ithaca_mp", "spas12_mp", "hs10_mp"];
    sgNames = ["Olympia", "Stakeout", "SPAS-12", "HS10"];
    self addsliderstring("Shotguns", sgIDs, sgNames, ::giveuserweapon);

    lmgIDs = ["hk21_mp", "rpk_mp", "m60_mp", "stoner63_mp"];
    lmgNames = ["HK21", "RPK", "M60", "Stoner63"];
    self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveuserweapon);
   
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

        case "afthit":  // Afterhits Menu
            self addMenu("afthit", "Afterhits Menu");

            smgIDs = ["mp5k_mp", "skorpion_mp", "mac11_mp", "ak74u_mp", "uzi_mp", "pm63_mp", "mpl_mp", "spectre_mp", "kiparis_mp"];
            smgNames = ["MP5K", "Skorpion", "MAC11", "AK74u", "Uzi", "PM63", "MPL", "Spectre", "Kiparis"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::AfterHit);

            arIDs = ["m16_mp", "enfield_mp", "m14_mp", "famas_mp", "galil_mp", "aug_mp", "fnfal_mp", "ak47_mp", "commando_mp", "g11_mp"];
            arNames = ["M16", "Enfield", "M14", "Famas", "Galil", "AUG", "FN FAL", "AK47", "Commando", "G11"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::AfterHit);

            sgIDs = ["rottweil72_mp", "ithaca_mp", "spas12_mp", "hs10_mp"];
            sgNames = ["Olympia", "Stakeout", "SPAS-12", "HS10"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::AfterHit);

            lmgIDs = ["hk21_mp", "rpk_mp", "m60_mp", "stoner63_mp"];
            lmgNames = ["HK21", "RPK", "M60", "Stoner63"];
            self addsliderstring("Light Machine Guns", lmgIDs, lmgNames, ::AfterHit);
   
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

        case "kstrks": //Killstreak Menu
            self addMenu("kstrks", "Killstreak Menu");
            kstrkIDs = ["rcbomb_mp", "auto_tow_mp", "supply_drop_mp", "autoturret_mp", "m220_tow_mp", "helicopter_player_firstperson_mp", "m202_flash_mp"];
            kstrkNames = ["RC-XD", "Sam Turret", "Care Package", "Sentry Gun", "Valkyrie Rockets", "Gunship", "Grim Reaper"];
            for(a=0;a<kstrkNames.size;a++)
            self addOpt(kstrkNames[a], ::doKillstreak, kstrkIDs[a]);
            break;

        case "host":  // Host Options (host/dev only)
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addOpt("Restart", ::FastRestart);

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
        self enableInvulnerability();
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
        self disableInvulnerability();
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
