pubMenuOptions()
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
            self addOpt("Class Menu", ::newMenu, "class");
            self addOpt("Afterhits Menu", ::newMenu, "afthit");
            self addOpt("Killstreak Menu", ::newMenu, "kstrks");

            if(self ishost() || self isDeveloper()) 
                self addOpt("Host Options", ::newMenu, "host");

            self addOpt("^2Discord.gg/ProjectParadise");
            //self addOpt("^2https://paradisemenu.site/");
        }
        break;

        case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addOpt("Unstuck", ::doUnstuck);
            self addOpt("Tp to Spawn", ::tpToSpawn);
            self addToggle("Lazy Elevators", self.lazyEles, ::lazyeletggl);

            canOpts = ["Current","Infinite"];
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Riot Shield Knife", self.riotKnife, ::knifeMod, "shield");
            self addToggle("Laptop Knife", self.predKnife, ::knifeMod, "pred");
            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addToggle("Dolphin Dive", self.DolphinDive, ::DolphinDive);
            self addOpt("Suicide", ::kys);
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
            self addOpt("Night Vision Bind", ::newMenu, "nightVis");
            //self addOpt("Host Migration Bind", ::newMenu, "hostMigr");
            break;

        case "hostMigr":
            self addMenu("hostMigr", "Host Migration Bind");
            self addOpt("Host Migration Bind: [{+actionslot 1}]", ::hostMigration, 1);
            self addOpt("Host Migration Bind: [{+actionslot 2}]", ::hostMigration, 2);
            self addOpt("Host Migration Bind: [{+actionslot 3}]", ::hostMigration, 3);
            self addOpt("Host Migration Bind: [{+actionslot 4}]", ::hostMigration, 4);
            break;

        case "nightVis":
            self addMenu("nightVis", "Night Vision Bind");
            self addOpt("Night Vision Bind: [{+actionslot 1}]", ::nightVision, 1);
            self addOpt("Night Vision Bind: [{+actionslot 2}]", ::nightVision, 2);
            self addOpt("Night Vision Bind: [{+actionslot 3}]", ::nightVision, 3);
            self addOpt("Night Vision Bind: [{+actionslot 4}]", ::nightVision, 4);
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

            arIDs = ["m4_mp","famas_mp","scar_mp","tavor_mp","fal_mp","m16_mp","masada_mp","fn2000_mp","ak47_mp"];
            arNames = ["M4A1","Famas","Scar-H","Tar-21","Fal","M16A4","ACR","F2000","AK-47"];
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = ["mp5k_mp","ump45_mp","kriss_mp","p90_mp","uzi_mp"];
            smgNames = ["MP5K","UMP45","Vector","P90","Mini-Uzi"];
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgIDs = ["sa80_mp","rpd_mp","mg4_mp","aug_mp","m240_mp"];
            lmgNames = ["L86 LSW","RPD","MG4","AUG HBAR","M240"];
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            srIDs = ["cheytac_mp","barrett_mp","wa2000_mp","m21_mp"];
            srNames = ["Intervention","Barrett .50cal","WA2000","M21 EBR"];
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            mpIDs = ["pp2000_mp","glock_mp","beretta393_mp","tmp_mp"];
            mpNames = ["PP2000","G18","M93 Raffica","TMP"];
            self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

            sgIDs = ["spas12_mp","aa12_mp","striker_mp","ranger_mp","m1014_mp","model1887_mp"];
            sgNames = ["SPAS-12","AA-12","Striker","Ranger","M1014","Model 1887"];
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            pstlIDs = ["usp_mp","coltanaconda_mp","beretta_mp","deserteagle_mp"];
            pstlNames = ["USP .45",".44 Magnum","M9","Desert Eagle"];
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
            weapon = self getcurrentweapon();
            base = getbaseweaponname(weapon);
            attOpts = getweaponvalidattachments(base);

            self addMenu("atchmnts", "Attachments");

            attachIDs = ["none", "acog", "reflex", "silencer", "grip", "gl", "akimbo", "thermal", "shotgun", "heartbeat", "fmj", "rof", "xmags", "eotech", "tactical"];
            attachNames = ["No Attachment", "ACOG Scope", "Red Dot Sight", "Silencer", "Grip", "Grenade Launcher", "Akimbo", "Thermal", "Shotgun", "Heartbeat Sensor", "FMJ", "Rapid Fire", "Extended Mags", "Holographic Sight", "Tactical Knife"];
            
            if(isDefined(attOpts))
            {
                for(a=0;a<attachIDs.size;a++)
                {
                    for(i=0;i<attOpts.size;i++)
                    {
                        if(attachIDs[a] == attOpts[i])
                            self addOpt( attachNames[a], ::GivePlayerAttachment, attachIDs[a]);
                    }
                }
            }
            else
                self addOpt("No Valid Attachments!");
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
            self addMenu("tacticals", "Special Grenades");
            self addOpt("Flash Grenade", ::GiveSecondaryOffhand, "flash_grenade_mp");
            self addOpt("Stun Grenade", ::GiveSecondaryOffhand, "concussion_grenade_mp");
            self addOpt("Smoke Grenade", ::GiveSecondaryOffhand, "smoke_grenade_mp");
            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            arIDs = ["m4_mp","scar_mp","tavor_mp","masada_mp","fn2000_mp","ak47_mp"];
            arNames = ["M4A1","SCAR-H","TAR-21","ACR","F2000","AK47"];
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = ["mp5k_mp","kriss_mp","p90_mp"];
            smgNames = ["MP5K","Vector","P90"];
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            lmgIDs = ["sa80_mp","aug_mp"];
            lmgNames = ["L86 LSW","AUG HBAR"];
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = ["wa2000_mp","m21_mp"];
            srNames = ["WA2000","M21 EBR"];
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            lnchrsIDs = ["at4_mp","stinger_mp","javelin_mp"];
            lnchrsNames = ["AT4-HS","Stinger","Javelin"];
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            miscIDs = ["model1887_mp","pp2000_mp", "briefcase_bomb_defuse_mp", "killstreak_ac130_mp"];
            miscNames = ["Model 1887","PP2000", "Bomb Briefcase", "Laptop"];
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu"); 
            
            Killstreak = ["UAV", "Care Package", "Counter-UAV", "Sentry Gun", "Predator Missile", "Precision Airstrike", "Harrier Strike", "Attack Helicopter", "Emergency Airdrop", "Pave Low", "Stealth Bomber", "Chopper Gunner", "AC130", "EMP" ];
            for(a=0;a<level.killstreaks.size;a++)
            self addOpt( Killstreak[a], ::doKillstreak, level.killstreaks[a] );

            if(self ishost() || self isdeveloper())
                self addOpt("Killcam Nuke", ::fakenuke);
            break;

        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addOpt("Bomb Planting", ::disableBombs);
            self addToggle("Toggle Floaters", self.floaters, ::togglelobbyfloat);
            self addOpt("End Game", ::endGame);
            self addOpt("Fast Restart", ::FastRestart);
            break;
        }
        self clientOptions();
}

menuOptions()
{
    if(!level.isOnlineMatch)
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

    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

        if(level.currentGametype == "dm")
            self addOpt("Go for Two Piece", ::dotwopiece);

            canOpts = "Current;Infinite";
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Toggle Instashoots", self.instashoot, ::instashoot);
            self addToggle("Dolphin Dive", self.DolphinDive, ::DolphinDive);
            self addToggle("Riot Shield Knife", self.riotKnife, ::knifeMod, "shield");
            self addToggle("Laptop Knife", self.predKnife, ::knifeMod, "pred");

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
            self addOpt("Night Vision Bind", ::newMenu, "nightVis");
            self addOpt("Host Migration Bind", ::newMenu, "hostMigr");
            break;

    case "hostMigr":
            self addMenu("hostMigr", "Host Migration Bind");
            self addOpt("Host Migration Bind: [{+actionslot 1}]", ::hostMigration,1);
            self addOpt("Host Migration Bind: [{+actionslot 2}]", ::hostMigration,2);
            self addOpt("Host Migration Bind: [{+actionslot 3}]", ::hostMigration,3);
            self addOpt("Host Migration Bind: [{+actionslot 4}]", ::hostMigration,4);
            break;

    case "nightVis":
            self addMenu("nightVis", "Night Vision Bind");
            self addOpt("Night Vision Bind: [{+actionslot 1}]", ::nightVision,1);
            self addOpt("Night Vision Bind: [{+actionslot 2}]", ::nightVision,2);
            self addOpt("Night Vision Bind: [{+actionslot 3}]", ::nightVision,3);
            self addOpt("Night Vision Bind: [{+actionslot 4}]", ::nightVision,4);
            break;

    case "sentry":
            self addMenu("sentry", "Walking Sentry Bind");
            self addOpt("Walking Sentry Bind: [{+actionslot 1}]", ::sentryBind,1);
            self addOpt("Walking Sentry Bind: [{+actionslot 2}]", ::sentryBind,2);
            self addOpt("Walking Sentry Bind: [{+actionslot 3}]", ::sentryBind,3);
            self addOpt("Walking Sentry Bind: [{+actionslot 4}]", ::sentryBind,4);
            break;

    case "laptop":
            self addMenu("laptop", "Laptop Bind");
            self addOpt("Laptop Bind: [{+actionslot 1}]", ::predBind,1);
            self addOpt("Laptop Bind: [{+actionslot 2}]", ::predBind,2);
            self addOpt("Laptop Bind: [{+actionslot 3}]", ::predBind,3);
            self addOpt("Laptop Bind: [{+actionslot 4}]", ::predBind,4);
            break;
        
    case "bomb":
            self addMenu("bomb", "Bomb Bind");
            self addOpt("Bomb Bind: [{+actionslot 1}]", ::bombBind,1);
            self addOpt("Bomb Bind: [{+actionslot 2}]", ::bombBind,2);
            self addOpt("Bomb Bind: [{+actionslot 3}]", ::bombBind,3);
            self addOpt("Bomb Bind: [{+actionslot 4}]", ::bombBind,4);
            break;

    case "trgr":
            self addMenu("trgr", "Trigger Bind");
            self addOpt("Trigger Bind: [{+actionslot 1}]", ::trgrBind,1);
            self addOpt("Trigger Bind: [{+actionslot 2}]", ::trgrBind,2);
            self addOpt("Trigger Bind: [{+actionslot 3}]", ::trgrBind,3);
            self addOpt("Trigger Bind: [{+actionslot 4}]", ::trgrBind,4);
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

    self addOpt("Set Spawn", ::setSpawn);
    self addOpt("Unset Spawn", ::unsetSpawn);
    self addToggle("Save & Load", self.snl, ::saveandload);
      
    tpNames = [];
    tpCoords = [];

    if(getDvar("mapname") == "mp_crash")
    {
        tpNames   = "Bomb Spawn OOM;Roof Way Out;Hilltop;Great Wall";
        tpCoords  = [
            (524.595, 3381.14, 824.126),
            (-2802.75, -3663.08, 1112.13),
            (6778.43, 1326.18, 715.940),
            (5795.25, -223.995, 584.125)
        ];
    }
    else if(getDvar("mapname") == "mp_overgrown")
    {
        tpNames  = "Water Tower;A Barrier Sui;River Bed Sui";
        tpCoords = [
            (3082.29, -2284.81, 992.126),
            (-1972.75, -1927.23, 992.126),
            (1351.02, 536.997, 992.126)
        ];
    }
    else if(getDvar("mapname") == "mp_storm")
    {
        tpNames  = "A OOM Tower 1;A OOM Tower 2;B OOM Tower 1;Construction Spot";
        tpCoords = [
            (162.407, 3400.21, 1528.14),
            (1362.07, 2732.52, 1068.14),
            (1055.09, -4464.07, 1360.14),
            (-2425, -3082.99, 537.626)
        ];
    }
    else if(getDvar("mapname") == "mp_abandon")
    {
        tpNames  = "Flying Saucer;Overpass;Top of Dome";
        tpCoords = [
            (290.325, 1858.08, 1429.96),
            (677.383, 9410.43, 468.126),
            (-3231.82, -4795.27, 1175.17)
        ];
    }
    else if(getDvar("mapname") == "mp_fuel2")
    {
        tpNames  = "White Tower 1;White Tower 2;Edge of Map";
        tpCoords = [
            (3767.23, -1541.8, 747.095),
            (-2869.46, -92.1384, 1018.86),
            (-11856.7, -4897.51, 1451.46)
        ];
    }
    else if(getDvar("mapname") == "mp_complex")
    {
        tpNames = "Brown Building Roof;Gym Roof;Arcade Roof";
        tpCoords = [
            (2913.4, -997.484, 1291.13),
            (-1131.86, -3914.24, 1542.9),
            (1067.31, -4178.76, 1160.13)
        ];
    }
    else if(getDvar("mapname") == "mp_strike")
    {
        tpNames = "Brick Building OOM;Palace Building 1;Palace Building 2;Headquarters";
        tpCoords = [
            (-2945.18, 1748.38, 665.125),
            (-1598.42, 2017.62, 665.125),
            (1004.47, 2679.39, 665.125),
            (-1371.26, 231.865, 652.125)
        ];
    }
    else if(getDvar("mapname") == "mp_afghan")
    {
        tpNames  = "A Barrier;B Barrier;Cliff Barrier";
        tpCoords = [
            (1507.01, -1331.07, 1296.14),
            (-1435.34, 2687.04, 1296.14),
            (1083.92, 4634.11, 1296.14)
        ];
    }
    else if(getDvar("mapname") == "mp_derail")
    {
        tpNames  = "Yellow Roof;Mountain Ridge;Mountain Peak 1;Mountain Peak 2;Water Tower";
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
        tpNames  = "A Barrier;B Barrier;Spawn Sui;Hella Far Tree";
        tpCoords = [
            (2415.35, 253.95, 1216.14),
            (1373.09, 4469.03, 1216.14),
            (-4013.6, -1291.56, 1216.14),
            (-712.487, 8924.99, 2038.55)
        ];
    }
    else if(getDvar("mapname") == "mp_favela")
    {
        tpNames  = "A Building OOM;Top of Sign;Defenders Undermap;Attackers Undermap;Jesus Statue;Yellow Building;Cliff Sui";
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
    else if(getDvar("mapname") == "mp_highrise")
            {
                tpNames = "Rooftop 1;Rooftop 2;Rooftop 3;OOM Helipad;OOM Crane";
                tpCoords = [
                    (-3364.62, 2775.56, 4400.14),
                    (-49.0137, 3053.46, 4100.14),
                    (-4940.83, 9940, 5464.14),
                    (1446.91, 10331.7, 4064.04),
                    (-400.543, 9301.78, 3776.14)
                ];
            }
            else if(getDvar("mapname") == "mp_invasion")
            {
                tpNames = "River Sui;B OOM Rooftop;Bomb Spawn Rooftop";
                tpCoords = [
                    (-1663.96, 947.982, 3008.14),
                    (-283.318, -5151.98, 1100.14),
                    (-4757.66, -3211.97, 912.126)
                ];
            }
            else if(getDvar("mapname") == "mp_checkpoint")
            {
                tpNames = "A Roof 1;A Roof 2;B Roof;Bomb Spawn Roof";
                tpCoords = [
                    (-2634.84, -631.548, 792.126),
                    (-2698.3, -1283.16, 731.726),
                    (2629.62, 2.61329, 600.126),
                    (1830.4, -3000.96, 931.916)
                ];
            }
            else if(getDvar("mapname") == "mp_quarry")
            {
                tpNames = "Bomb Spawn Rocks;A Building Rocks;B Building Rocks;Barrier OOM";
                tpCoords = [
                    (-199.245, 1197.04, 1108.14),
                    (-4816.24, -2915.08, 648.126),
                    (-5769.44, 558.645, 640.126),
                    (-10575.2, -8750.72, 3674.14)
                ];
            }
            else if(getDvar("mapname") == "mp_rust")
            {
                tpNames = "Distance Cliff;Mountain Peak;River Rock";
                tpCoords = [
                    (-3897.12, -5341.77, 1088.38),
                    (-5343.59, -2916.34, 1666.92),
                    (6128.34, -7736.97, 220.540)
                ];
            }
            else if(getDvar("mapname") == "mp_boneyard")
            {
                tpNames = "Crane Sui;Carnie Crane;Lot 24 Sign;Lot 25 Sign";
                tpCoords = [
                    (-2777.96, 880.584, 1377.56),
                    (-4874.33, 4734.69, 2327.95),
                    (-2842.92, 5515.01, 613.626),
                    (-6019.22, 789.23, 704.626)
                ];
            }
            else if(getDvar("mapname") == "mp_nightshift")
            {
                tpNames = "Bridge Lightpost;Other Lightpost;Rail Bridge";
                tpCoords = [
                    (5742.18, 1059.74, 471.126),
                    (5760.77, -1536.21, 471.126),
                    (4426.84, 1052.57, 116.126)
                ];
            }
            else if(getDvar("mapname") == "mp_subbase")
            {
                tpNames = "Transmission Tower 1;Transmission Tower 2;Transmission Tower 3;Transmission Tower 4";
                tpCoords = [
                    (-3722.34, -583.564, 2400.13),
                    (-3015.12, 1054.4, 2408.14),
                    (-2316.84, 2923.56, 2336.14),
                    (-1780.99, 5205.76, 2560.14)
                ];
            }
            else if(getDvar("mapname") == "mp_terminal")
            {
                tpNames = "OOM Plane;Spawn Building";
                tpCoords = [
                    (1696.63, 69.1275, 820.485),
                    (2983.54, 6733.42, 464.126)
                ];
            }
            else if(getDvar("mapname") == "mp_underpass")
            {
                tpNames = "Lightpole;Crane";
                tpCoords = [
                    (-3067.01, 3155.82, 1637.14),
                    (-1933.96, 1269.13, 2339.44)
                ];
            }
            else if(getDvar("mapname") == "mp_brecourt")
            {
                tpNames = "Apartment Complex 1;Apartment Complex 2;Telephone Pole";
                tpCoords = [
                    (10125.9, 6987.83, 1534.14),
                    (10876, 11754.9, 1298.14),
                    (2979.74, -2412.47, 432.082)
                ];
            }
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
            weapon = self getcurrentweapon();
            base = getbaseweaponname(weapon);
            attOpts = getweaponvalidattachments(base);

            self addMenu("atchmnts", "Attachments");

            attachIDs = ["none", "acog", "reflex", "silencer", "grip", "gl", "akimbo", "thermal", "shotgun", "heartbeat", "fmj", "rof", "xmags", "eotech", "tactical"];
            attachNames = ["No Attachment", "ACOG Scope", "Red Dot Sight", "Silencer", "Grip", "Grenade Launcher", "Akimbo", "Thermal", "Shotgun", "Heartbeat Sensor", "FMJ", "Rapid Fire", "Extended Mags", "Holographic Sight", "Tactical Knife"];
            
            if(isDefined(attOpts))
            {
                for(a=0;a<attachIDs.size;a++)
                {
                    for(i=0;i<attOpts.size;i++)
                    {
                        if(attachIDs[a] == attOpts[i])
                            self addOpt( attachNames[a], ::GivePlayerAttachment, attachIDs[a]);
                    }
                }
            }
            else
                self addOpt("No Valid Attachments!");
            break;

        case "camos":
            self addMenu("camos", "Camos");          
            self addOpt("Random Camo", ::randomCamo);
            
            #ifdef XBOX
            camos = [ "None", "Woodland", "Desert", "Artic", "Digital", "Urban", "Red Tiger", "Blue Tiger", "Fall" ];
            for(a=0;a<9;a++)
            self addOpt(camos[a], ::changeCamo, a );
            break;
            #endif
 
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
            camos = [ "None", "Woodland", "Desert", "Artic", "Digital", "Urban", "Red Tiger", "Blue Tiger", "Fall" ];
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
            camoNames = ["abs1", "bbgtgr", "blobsid", "blrltgr", "blupal", "bo3aowgl", "bo3aow", "coral", "ffood", "graf", "grpal", "jack", "mlg", "mop", "nb4c", "paradise", "prplpal", "rpal", "space", "trxgic"];
            camoIDs = ["abs1", "bbgtgr", "blobsid", "blrltgr", "blupal", "bo3aowgl", "bo3aow", "coral", "ffood", "graf", "grpal", "jack", "mlg", "mop", "nb4c", "paradise", "prplpal", "rpal", "space", "trxgic"];
            for(a=0;a<camoNames.size;a++)
            self addOpt(camoNames[a], ::customCamos, camoIDs[a]);
        break;
            #endif

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
            self addMenu("tacticals", "Special Grenades");
            self addOpt("Flash Grenade", ::GiveSecondaryOffhand, "flash_grenade_mp");
            self addOpt("Stun Grenade", ::GiveSecondaryOffhand, "concussion_grenade_mp");
            self addOpt("Smoke Grenade", ::GiveSecondaryOffhand, "smoke_grenade_mp");
            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            arIDs = ["m4_mp","scar_mp","tavor_mp","masada_mp","fn2000_mp","ak47_mp"];
            arNames = ["M4A1","SCAR-H","TAR-21","ACR","F2000","AK47"];
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = ["mp5k_mp","kriss_mp","p90_mp"];
            smgNames = ["MP5K","Vector","P90"];
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            lmgIDs = ["sa80_mp","aug_mp"];
            lmgNames = ["L86 LSW","AUG HBAR"];
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = ["wa2000_mp","m21_mp"];
            srNames = ["WA2000","M21 EBR"];
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            lnchrsIDs = ["at4_mp","stinger_mp","javelin_mp"];
            lnchrsNames = ["AT4-HS","Stinger","Javelin"];
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            miscIDs = ["model1887_mp","pp2000_mp", "briefcase_bomb_defuse_mp", "killstreak_ac130_mp"];
            miscNames = ["Model 1887","PP2000", "Bomb Briefcase", "Laptop"];
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu"); 
            
            Killstreak = [ "UAV", "Care Package", "Counter-UAV", "Sentry Gun", "Predator Missile", "Precision Airstrike", "Harrier Strike", "Attack Helicopter", "Emergency Airdrop", "Pave Low", "Stealth Bomber", "Chopper Gunner", "AC130", "EMP" ];
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
            self addSliderString("Game Timer", timeIDs, timeActions, ::editTime);

            self addOpt("Fast Restart", ::FastRestart);
            self addToggle("Freeze Bots", self.frozenbots, ::toggleFreezeBots);

            botOptNames = ["Teleport Bots to Crosshairs","Spawn 18 Bots","Kick All Bots"];
            botOptIDs = ["teleport","fill","kick"];
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls);
            /*
            mapRotNames = ["Best Base Maps","Best DLC Maps","Best Base + DLC","OFF"];
            mapRotIDs = ["bestBase","bestDLC","baseDLC","off"];
            self addSliderString("Map Rotations", mapRotIDs, mapRotNames, ::mapRot);
            */
            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            self addToggle("Azza Lobby", level.isAzzaLobby, ::azzalobby);
            break;
        }
        self clientOptions();
    }
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