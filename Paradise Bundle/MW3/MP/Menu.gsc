pubmenuOptions()
{
        if(level.isOnlineMatch)
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
            self addOpt("^2https://paradisemenu.site/");
        }
        break;

    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addOpt("Unstuck", ::doUnstuck);
            self addOpt("Tp to Spawn", ::tpToSpawn);
            self addToggle("Lazy Elevators", self.lazyEles, ::lazyeletggl);

            canOpts = "Current;Infinite";
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Instashoots", self.instashoot, ::instashoot);
            self addToggle("Dolphin Dive", self.DolphinDive, ::DolphinDive);       
            self addOpt("Suicide", ::kys);
            break;

    case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Laptop Bind", ::newMenu, "laptop");
            self addOpt("Trigger Bind", ::newMenu, "trgr");
            self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
            self addOpt("Walking IMS Bind", ::newMenu, "ims");
            self addOpt("Walking Remote Sentry Bind", ::newMenu, "remSentry");
            break;

    case "remSentry":
            self addMenu("remSentry", "Walking Remote Sentry Bind");
            self addOpt("Walking Remote Sentry Bind: [{+actionslot 1}]", ::remSentryBind, 1);
            self addOpt("Walking Remote Sentry Bind: [{+actionslot 2}]", ::remSentryBind, 2);
            self addOpt("Walking Remote Sentry Bind: [{+actionslot 3}]", ::remSentryBind, 3);
            self addOpt("Walking Remote Sentry Bind: [{+actionslot 4}]", ::remSentryBind, 4);
            break;

    case "ims":
            self addMenu("ims", "Walking IMS Bind");
            self addOpt("Walking IMS Bind: [{+actionslot 1}]", ::imsBind, 1);
            self addOpt("Walking IMS Bind: [{+actionslot 2}]", ::imsBind, 2);
            self addOpt("Walking IMS Bind: [{+actionslot 3}]", ::imsBind, 3);
            self addOpt("Walking IMS Bind: [{+actionslot 4}]", ::imsBind, 4);
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
            self addOpt("Bind Class 11: [{+actionslot 1}]",  ::classBind,11);
            self addOpt("Bind Class 12: [{+actionslot 1}]",  ::classBind,12);
            self addOpt("Bind Class 13: [{+actionslot 1}]",  ::classBind,13);
            self addOpt("Bind Class 14: [{+actionslot 1}]",  ::classBind,14);
            self addOpt("Bind Class 15: [{+actionslot 1}]",  ::classBind,15);
            break;

   case "class":
            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");
            self addOpt("Attachments", ::newMenu, "atchmnts");
            self addOpt("Camos", ::newMenu, "camos");
            self addOpt("Equipment", ::newMenu, "lethals");
            self addOpt("Special Grenades", ::newMenu, "tacticals");
            self addToggle("Give Quickdraw", self.quickdraw ,::giveQuickdrawKillstreak);
            self addtoggle("Save Loadout", self.saveLoadoutEnabled, ::saveloadouttoggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons Menu");

            arIDs = "iw5_m4_mp;iw5_m16_mp;iw5_scar_mp;iw5_cm901_mp;iw5_type95_mp;iw5_g36c_mp;iw5_acr_mp;iw5_mk14_mp;iw5_ak47_mp;iw5_fad_mp";
            arNames = "M4A1;M16A4;Scar-L;CM901;Type 95;G36C;ACR 6.8;MK14;AK-47;FAD";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = "iw5_mp5_mp;iw5_ump45_mp;iw5_pp90m1_mp;iw5_p90_mp;iw5_m9_mp;iw5_mp7_mp";
            smgNames = "MP5;UMP45;PP90M1;P90;PM-9;MP7";
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgIDs = "iw5_sa80_mp;iw5_mg36_mp;iw5_pecheneg_mp;iw5_mk46_mp;iw5_m60_mp";
            lmgNames = "L86 LSW;MG36;PKP Pecheneg;MK46;M60E4";
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            srIDs = "iw5_barrett_mp_barrettscope;iw5_barrett_mp;iw5_l96a1_mp_l96a1scope;iw5_l96a1_mp;iw5_dragonuv_mp_dragonuvscope;iw5_dragonuv_mp;iw5_as50_mp_as50scope;iw5_as50_mp;iw5_rsass_mp_rsassscope;iw5_rsass_mp;iw5_msr_mp_msrscope;iw5_msr_mp";
            srNames = "Barret .50cal;Scopeless Barrett .50cal;L118A;Scopeless L118A;Dragonuv;Scopeless Dragonuv;AS50;Scopeless AS50;RSASS;Scopeless RSASS;MSR;Scopeless MSR";
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            mpIDs = "iw5_fmg9_mp;iw5_mp9_mp;iw5_skorpion_mp;iw5_g18Att_mp";
            mpNames = "FMG9;MP9;Skorpion;G18";
            self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

            sgIDs = "iw5_usas12_mp;iw5_ksg_mp;iw5_spas12_mp;iw5_aa12_mp;iw5_striker_mp;iw5_1887_mp";
            sgNames = "USAS-12;KSG-12;SPAS-12;AA-12;Striker;Model 1887";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            pstlIDs = "iw5_usp45_mp;iw5_p99_mp;iw5_mp412_mp;iw5_44magnum_mp;iw5_fnfiveseven_mp;iw5_deserteagle_mp";
            pstlNames = "USP .45;P99;MP412;.44 Magnum;Five Seven;Desert Eagle";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            lnchrsIDs = "iw5_smaw_mp;javelin_mp;stinger_mp;xm25_mp;m320_mp;rpg_mp;at4_mp";
            lnchrsNames = "SMAW;Javelin;Stinger;XM25;M320;RPG;AT4";
            self addSliderstring("Launchers", lnchrsIDs, lnchrsNames, ::giveUserWeapon);

            self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "atchmnts":
            weapon = self getcurrentweapon();
            base = getbaseweaponname(weapon);
            attOpts = getweaponvalidattachments(base);

            self addMenu("atchmnts", "Attachments");
            
            attachIDs = ["none","acogsmg","acog","reflexsmg","reflexlmg","reflex","silencer","silencer02","silencer03","grip","gl","gp25","m320",
                        "akimbo","thermalsmg","thermal","shotgun","heartbeat","rof","xmags","eotechsmg","eotechlmg","eotech","tactical","vzscope",
                        "hamrhybrid","hybrid","zoomscope"];
            
            attachNames = ["None","ACOG","ACOG","Reflex","Reflex","Reflex","Silencer","Silencer","Silencer","Grip","Grenade Launcher","Grenade Launcher",
                           "Grenade Launcher","Akimbo","Thermal","Thermal","Shotgun","Heartbeat","Rapid Fire","Extended Mags","Holographic Sight",
                           "Holographic Sight","Holographic Sight","Tactical Knife","Variable Zoom","HAMR Scope","Hybrid Sight","Variable Zoom"];
            
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
            camos = ["None", "Classic", "Snow", "Multi", "Digital Urban", "Hex", "Choco", "Snake", "Blue", "Red", "Autumn", "Gold", "Marine", "Winter"];
            for(a=0;a<14;a++)
            self addOpt(camos[a], ::camoString, a);

            break;

        case "lethals":
            self addMenu("lethals", "Equipment");
            lthlIDs = ["frag_grenade_mp", "semtex_mp", "throwingknife_mp", "bouncingbetty_mp", "claymore_mp", "c4_mp"];
            lthlNames = ["Frag", "Semtex", "Throwing Knife", "Bouncing Betty", "Claymore", "C4"];
            for(a=0;a<lthlNames.size;a++)
            self addOpt(lthlNames[a], ::giveequipment, lthlIDs[a]);
            self addOpt("Glowstick", ::giveglowstick);
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            tctlIDs = ["flash_grenade_mp","concussion_grenade_mp","scrambler_mp","emp_grenade_mp",
                        "smoke_grenade_mp","trophy_mp","flare_mp","portable_radar_mp"];
            tctlNames = ["Flash Grenade", "Concussion Grenade", "Scrambler", "EMP Grenade", "Smoke Grenade", 
                        "Trophy System", "Tactical Insertion", "Portable Radar"];
            for(a=0;a<tctlNames.size;a++)
            self addOpt(tctlNames[a], ::givesecondaryoffhand, tctlIDs[a]);

            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            arIDs = "iw5_m4_mp;iw5_m16_mp;iw5_scar_mp;iw5_cm901_mp;iw5_type95_mp;iw5_g36c_mp;iw5_acr_mp;iw5_mk14_mp;iw5_ak47_mp;iw5_fad_mp";
            arNames = "M4A1;M16A4;Scar-L;CM901;Type 95;G36C;ACR 6.8;MK14;AK-47;FAD";
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = "iw5_mp5_mp;iw5_ump45_mp;iw5_pp90m1_mp;iw5_p90_mp;iw5_m9_mp;iw5_mp7_mp";
            smgNames = "MP5;UMP45;PP90M1;P90;PM-9;MP7";
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            lmgIDs = "iw5_sa80_mp;iw5_mg36_mp;iw5_pecheneg_mp;iw5_mk46_mp;iw5_m60_mp";
            lmgNames = "L86 LSW;MG36;PKP Pecheneg;MK46;M60E4";
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = "iw5_barrett_mp_barrettscope;iw5_barrett_mp;iw5_l96a1_mp_l96a1scope;iw5_l96a1_mp;iw5_dragonuv_mp_dragonuvscope;iw5_dragonuv_mp;iw5_as50_mp_as50scope;iw5_as50_mp;iw5_rsass_mp_rsassscope;iw5_rsass_mp;iw5_msr_mp_msrscope;iw5_msr_mp";
            srNames = "Barret .50cal;Scopeless Barrett .50cal;L118A;Scopeless L118A;Dragonuv;Scopeless Dragonuv;AS50;Scopeless AS50;RSASS;Scopeless RSASS;MSR;Scopeless MSR";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            lnchrsIDs = "iw5_smaw_mp;javelin_mp;stinger_mp;xm25_mp;m320_mp;rpg_mp;at4_mp";
            lnchrsNames = "SMAW;Javelin;Stinger;XM25;M320;RPG;AT4";
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            specIDs = "briefcase_bomb_defuse_mp;killstreak_ac130_mp";
            specNames = "Bomb Briefcase;Laptop";
            self addSliderString("Specials", specIDs, specNames, ::afterhit);
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu"); 

            Killstreak = ["UAV", "Ballistic Vests", "Care Package", "Counter UAV", "Sentry", "Predator Missile", "AC130", "EMP"];
            for(a=0;a<level.killstreaks.size;a++)
            self addOpt( Killstreak[a], ::doKillstreak, level.killstreaks[a] );

            if(self ishost() || self isdeveloper())
            self addOpt("Fake MOAB", ::fakenuke);
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
        if(self.access > 0)
        {
            self addMenu("main", "Main Menu");
            self addOpt("Trickshot Menu", ::newMenu, "ts");
            self addOpt("Binds Menu", ::newMenu, "sK");
            self addOpt("Teleport Menu", ::newMenu, "tp");
            self addOpt("Class Menu", ::newMenu, "class");
            self addOpt("Afterhits Menu", ::newMenu, "afthit");
            self addOpt("Killstreak Menu", ::newMenu, "kstrks");
            //self addOpt("Account Menu", ::newMenu, "acc");

            if(self ishost() || self isDeveloper()) 
                self addOpt("Host Options", ::newMenu, "host");
        }
        break;

    case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);
            self addOpt("Go for Two Piece", ::dotwopiece);

            canOpts = "Current;Infinite";
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode);

            self addToggle("Instashoots", self.instashoot, ::instashoot);
            self addToggle("Dolphin Dive", self.DolphinDive, ::DolphinDive);
            self addOpt("Spawn Slide @ Crosshairs", ::slide);

            spawnOptionsActions = "Bounce";//;Platform;Crate"; Broken on IL 09/19/25
            spawnOptionsIDs     = "bounce";//;platform;crate"
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption);
            
            break;

    case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            self addOpt("Laptop Bind", ::newMenu, "laptop");
            self addOpt("Trigger Bind", ::newMenu, "trgr");
            self addOpt("Walking Sentry Bind", ::newMenu, "sentry");
            self addOpt("Walking IMS Bind", ::newMenu, "ims");
            self addOpt("Walking Remote Sentry Bind", ::newMenu, "remSentry");
            break;

    case "remSentry":
            self addMenu("remSentry", "Walking Remote Sentry Bind");
            self addOpt("Walking Remote Sentry Bind: [{+actionslot 1}]", ::remSentryBind, 1);
            self addOpt("Walking Remote Sentry Bind: [{+actionslot 2}]", ::remSentryBind, 2);
            self addOpt("Walking Remote Sentry Bind: [{+actionslot 3}]", ::remSentryBind, 3);
            self addOpt("Walking Remote Sentry Bind: [{+actionslot 4}]", ::remSentryBind, 4);
            break;

    case "ims":
            self addMenu("ims", "Walking IMS Bind");
            self addOpt("Walking IMS Bind: [{+actionslot 1}]", ::imsBind, 1);
            self addOpt("Walking IMS Bind: [{+actionslot 2}]", ::imsBind, 2);
            self addOpt("Walking IMS Bind: [{+actionslot 3}]", ::imsBind, 3);
            self addOpt("Walking IMS Bind: [{+actionslot 4}]", ::imsBind, 4);
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

    if(getDvar("mapname") == "mp_seatown")
    {
        tpNames  = "Spawn Palm Tree;Castle Wall;B Building;Numbs Barrier;Owls Nest";
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
        tpNames  = "Top Antennae;Yellow Roof;Water Tower 1;Water Tower 2;Edge of Map";
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
        tpNames  = "A Building;Bomb Spawn Building;Parking Garage;Across the River 1;Across the River 2";
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
        tpNames  = "Ship Crane;Ship Spot 1;Ship Spot 2";
        tpCoords = [
            (918.131, -1659.42, 645.182),
            (-281.219, -1946.91, 648.426),
            (1514.71, -1932.56, 648.426)
        ];
    }
    else if(getDvar("mapname") == "mp_paris")
    {
        tpNames  = "Main Roof;A Bomb Roof;A Bomb Roof 2;B Bomb Roof";
        tpCoords = [
            (-3642.28, 117.656, 1066.87),
            (1782.94, 2696.29, 624.912),
            (2983.6, 335.537, 713.667),
            (-133.233, -1895.12, 794.639)
        ];
    }
    else if(getDvar("mapname") == "mp_exchange")
    {
        tpNames  = "Bomb Spawn Building 1;Bomb Spawn Building 2;Numbs Spot;Lew Undermap;Alley Building";
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
        tpNames  = "Blue Building 1;Blue Building 2;Brick Office Roof";
        tpCoords = [
            (-4080.15, -378.776, 956.126),
            (3289.45, -2758.55, 956.126),
            (2090.33, 1109.19, 1036.14)
        ];
    }
    else if(getDvar("mapname") == "mp_carbon")
    {
        tpNames  = "AC Unit;Undermap Sui;Green Building Sui;Red Building Sui";
        tpCoords = [
            (3061.9, 1690.39, 6145.64),
            (-172.453, 3938.83, 5327.63),
            (-5805.79, -2428, 3978.75),
            (-1351.91, -7515.63, 4801.99)
        ];
    }
    else if(getDvar("mapname") == "mp_hardhat")
    {
        tpNames  = "Rooftop 1;Rooftop 2;Rooftop 3;Skyscraper Roof 1;Pelo Skyscraper Roof";
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
        tpNames  = "B Tower;Cliff;Church Barrier";
        tpCoords = [
            (-1346.6, 965.642, 1012.14),
            (-372.082, -3659.82, 1558.4),
            (1090.95, 417.557, 1385.73)
        ];
    }
    else if(getDvar("mapname") == "mp_lambeth")
    {
        tpNames  = "Trxgic Barrier Spot;Bomb Spawn Sui;OOM Roof";
        tpCoords = [
            (-3212.41, 249.976, 1088.14),
            (-1414.2, 5897.66, 255.756),
            (3314.56, -3888.27, 52.2078)
        ];
    }
    else if(getDvar("mapname") == "mp_interchange")
    {
        tpNames  = "Way Out Building;Apartment Complex Roof 1;Apartment Complex Roof 2;Blue Warehouse";
        tpCoords = [
            (6514.65, 7136.91, 1210.14),
            (7588.21, -6157.47, 1947.14),
            (5003.22, -9595.72, 1933.14),
            (-9065.15, 3564.91, 1415.50)
        ];
    }
    else if(getDvar("mapname") == "mp_radar")
    {
        tpNames  = "Inside Cliff;Top Cliff;Way OOM;Tower Spot";
        tpCoords = [
            (-5754.85, -88.7475, 1746.14),
            (-6076.27, 344.81, 2991.65),
            (-3916.54, 14554.8, 3757.35),
            (-11290.5, 2712.13, 2953.53)
        ];
    }
    else if(getDvar("mapname") == "mp_underground")
    {
        tpNames  = "Carnie Roof;Office Roof;Parking Garage Roof;Skyscraper Roof";
        tpCoords = [
            (-1121.87, -5498.32, 1044.14),
            (-465.589, 5825.38, 896.126),
            (-1395.61, 3749.47, 412.126),
            (-11553.3, -4204.02, 5124.14)
        ];
    }
    else if(getDvar("mapname") == "mp_courtyard_ss")
    {
        tpNames  = "Top of Well;Top of Pillars;Top Orange Wall";
        tpCoords = [
            (-1550.86, -1112.25, 440.126),
            (-2935.49, 849.618, 994.126),
            (334.478, 1660.46, 807.390)
        ];
    }
    else if(getDvar("mapname") == "mp_aground_ss")
    {
        tpNames  = "A Side Cliff;B Side Cliff;Top of Crane;Way Out Cliff;Top of Boat";
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
        tpNames  = "OOM Plane;Spawn Roof";
        tpCoords = [
            (1694.41, 54.7374, 820.359),
            (2998.43, 6732.3, 464.126)
        ];
    }
    else if(getDvar("mapname") == "mp_italy")
    {
        tpNames = "Cliff Sui;Way Out Building;White Building Roof";
        tpCoords = [
            (-10705.4, -1547.49, 1678.39),
            (-674.493, 17378.9, 7757.13),
            (-5228.65, 1867.19, 1857.13)
        ];
    }
    else if(getDvar("mapname") == "mp_park")
    {
        tpNames = "Building Ledge 1;Building Ledge 2;Roof;Skyscraper Ledge";
        tpCoords = [
            (-9307.38, 14720.1, 4785.13),
            (-15220.1, -4924.6, 8099.13),
            (-11827.2, 7796.5, 7017.13),
            (-14433.8, -1409.4, 8663.63)
        ];
    }
    else if(getDvar("mapname") == "mp_overwatch")
    {
        tpNames = "Skyscraper Ledge;Crane Sui 1;Crane Sui 2; Mid Sui";
        tpCoords = [
            (-4482.75, 15098.9, 18309.1),
            (-1378.76, -969.656, 13734.1),
            (-1751.32, 2522.13, 14149.1),
            (-46.1258, -0.350276, 13507.1)
        ];
    }
    else if(getDvar("mapname") == "mp_morningwood")
    {
        tpNames = "Top of Plane";
        tpCoords = [
            (2077.9, -2410.5, 1332.62)
        ];
    }
    else if(getDvar("mapname") == "mp_cement")
    {
        tpNames = "Silla Cement Building;Blue Roof";
        tpCoords = [
            (1830.88, -561.661, 1255.47),
            (-146.733, 2776.96, 799.865)
        ];
    }
    else if(getDvar("mapname") == "mp_qadeem")
    {
        tpNames = "Rooftop;Glass Building Roof;Inside Building Barrier";
        tpCoords = [
            (126.945, 4623.63, 1449.13),
            (10399.3, 3487.91, 2061.13),
            (128.76, 5243.63, 1209.12)
        ];
    }
    else if(getDvar("mapname") == "mp_hillside_ss")
    {
        tpNames = "Hillside House;Glass House";
        tpCoords = [
            (-3586.21, -2610.54, 4004.13),
            (-3871.97, 596, 3578.63)
        ];
    }
    else if(getDvar("mapname") == "mp_six_ss")
    {
        tpNames = "Barn Roof 1;Barn Roof 2;Way Out Silo";
        tpCoords = [
            (3459.9, -7192.55, 1084.54), 
            (4409.77, 4565.5, 1276.55),
            (9851.93, -322.705, 1220.62)
        ];
    }
    else if(getDvar("mapname") == "mp_crosswalk_ss")
    {
        tpNames = "Bridge Spot;Roof Spot 1;Roof Spot 2";
        tpCoords = [
            (7277.88, 788.631, 5891.38),
            (1056.44, 832.929, 1661.13),
            (-4210.05, 156.849, 1757.13)
        ];
    }
    else if(getDvar("mapname") == "mp_moab")
    {
        tpNames = "Rock Wall 1;Rock Wall 2;Way OOM Ledge";
        tpCoords = [
            (-970.434, 5818.52, 1981.81),
            (2502.22, 213.805, 1669.36),
            (-10704.3, -138.587, 1403.79)
        ];
    }
    else if(getDvar("mapname") == "mp_nola")
    {
        tpNames = "Long Building Roof 1;Long Building Roof 2;Brick Apartments Roof;Building Ledge";
        tpCoords = [
            (-2586.91, -3657.49, 559.644),
            (2652.88, -3703.37, 585.067),
            (3730.12, 602.36, 777.125),
            (-4019.16, 272.979, 529.083)
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
            self addToggle("Give Quickdraw", self.quickdraw ,::giveQuickdrawKillstreak);
            self addtoggle("Save Loadout", self.saveLoadoutEnabled, ::saveloadouttoggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

        case "wpns":
            self addMenu("wpns", "Weapons Menu");

            arIDs = "iw5_m4_mp;iw5_m16_mp;iw5_scar_mp;iw5_cm901_mp;iw5_type95_mp;iw5_g36c_mp;iw5_acr_mp;iw5_mk14_mp;iw5_ak47_mp;iw5_fad_mp";
            arNames = "M4A1;M16A4;Scar-L;CM901;Type 95;G36C;ACR 6.8;MK14;AK-47;FAD";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveUserWeapon);

            smgIDs = "iw5_mp5_mp;iw5_ump45_mp;iw5_pp90m1_mp;iw5_p90_mp;iw5_m9_mp;iw5_mp7_mp";
            smgNames = "MP5;UMP45;PP90M1;P90;PM-9;MP7";
            self addSliderString("Sub Machine Guns", smgIDs, smgNames, ::giveUserWeapon);

            lmgIDs = "iw5_sa80_mp;iw5_mg36_mp;iw5_pecheneg_mp;iw5_mk46_mp;iw5_m60_mp";
            lmgNames = "L86 LSW;MG36;PKP Pecheneg;MK46;M60E4";
            self addSliderstring("Light Machine Guns", lmgIDs, lmgNames, ::giveUserWeapon);

            srIDs = "iw5_barrett_mp_barrettscope;iw5_barrett_mp;iw5_l96a1_mp_l96a1scope;iw5_l96a1_mp;iw5_dragonuv_mp_dragonuvscope;iw5_dragonuv_mp;iw5_as50_mp_as50scope;iw5_as50_mp;iw5_rsass_mp_rsassscope;iw5_rsass_mp;iw5_msr_mp_msrscope;iw5_msr_mp";
            srNames = "Barret .50cal;Scopeless Barrett .50cal;L118A;Scopeless L118A;Dragonuv;Scopeless Dragonuv;AS50;Scopeless AS50;RSASS;Scopeless RSASS;MSR;Scopeless MSR";
            self addSliderstring("Sniper Rifles", srIDs, srNames, ::giveUserWeapon);

            mpIDs = "iw5_fmg9_mp;iw5_mp9_mp;iw5_skorpion_mp;iw5_g18Att_mp";
            mpNames = "FMG9;MP9;Skorpion;G18";
            self addSliderstring("Machine Pistols", mpIDs, mpNames, ::giveUserWeapon);

            sgIDs = "iw5_usas12_mp;iw5_ksg_mp;iw5_spas12_mp;iw5_aa12_mp;iw5_striker_mp;iw5_1887_mp";
            sgNames = "USAS-12;KSG-12;SPAS-12;AA-12;Striker;Model 1887";
            self addSliderstring("Shotguns", sgIDs, sgNames, ::giveUserWeapon);

            pstlIDs = "iw5_usp45_mp;iw5_p99_mp;iw5_mp412_mp;iw5_44magnum_mp;iw5_fnfiveseven_mp;iw5_deserteagle_mp";
            pstlNames = "USP .45;P99;MP412;.44 Magnum;Five Seven;Desert Eagle";
            self addSliderstring("Pistols", pstlIDs, pstlNames, ::giveUserWeapon);

            lnchrsIDs = "iw5_smaw_mp;javelin_mp;stinger_mp;xm25_mp;m320_mp;rpg_mp;at4_mp";
            lnchrsNames = "SMAW;Javelin;Stinger;XM25;M320;RPG;AT4";
            self addSliderstring("Launchers", lnchrsIDs, lnchrsNames, ::giveUserWeapon);

            self addOpt("Riot Shield", ::giveUserWeapon, "riotshield_mp");
            break;

        case "atchmnts":
            weapon = self getcurrentweapon();
            base = getbaseweaponname(weapon);
            attOpts = getweaponvalidattachments(base);

            self addMenu("atchmnts", "Attachments");
            
            attachIDs = ["none","acogsmg","acog","reflexsmg","reflexlmg","reflex","silencer","silencer02","silencer03","grip","gl","gp25","m320","akimbo",
                        "thermalsmg","thermal","shotgun","heartbeat","rof","xmags","eotechsmg","eotechlmg","eotech","tactical","vzscope","hamrhybrid","hybrid","zoomscope"];
            
            attachNames = ["None","ACOG","ACOG","Reflex","Reflex","Reflex","Silencer","Silencer","Silencer","Grip","Grenade Launcher","Grenade Launcher",
                           "Grenade Launcher","Akimbo","Thermal","Thermal","Shotgun","Heartbeat","Rapid Fire","Extended Mags","Holographic Sight",
                           "Holographic Sight","Holographic Sight","Tactical Knife","Variable Zoom","HAMR Scope","Hybrid Sight","Variable Zoom"];
            
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
            camos = ["None", "Classic", "Snow", "Multi", "Digital Urban", "Hex", "Choco", "Snake", "Blue", "Red", "Autumn", "Gold", "Marine", "Winter"];
            for(a=0;a<14;a++)
            self addOpt(camos[a], ::camoString, a);
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
            camos = ["None", "Classic", "Snow", "Multi", "Digital Urban", "Hex", "Choco", "Snake", "Blue", "Red", "Autumn", "Gold", "Marine", "Winter"];
            for(a=0;a<14;a++)
            self addOpt(camos[a], ::camoString, a);
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
            lthlIDs = ["frag_grenade_mp", "semtex_mp", "throwingknife_mp", "bouncingbetty_mp", "claymore_mp", "c4_mp"];
            lthlNames = ["Frag", "Semtex", "Throwing Knife", "Bouncing Betty", "Claymore", "C4"];
            for(a=0;a<lthlNames.size;a++)
            self addOpt(lthlNames[a], ::giveequipment, lthlIDs[a]);
            self addOpt("Glowstick", ::giveglowstick);
            break;

        case "tacticals":
            self addMenu("tacticals", "Tacticals");
            tctlIDs = ["flash_grenade_mp","concussion_grenade_mp","scrambler_mp","emp_grenade_mp",
                        "smoke_grenade_mp","trophy_mp","flare_mp","portable_radar_mp"];
            tctlNames = ["Flash Grenade", "Concussion Grenade", "Scrambler", "EMP Grenade", "Smoke Grenade", 
                        "Trophy System", "Tactical Insertion", "Portable Radar"];
            for(a=0;a<tctlNames.size;a++)
            self addOpt(tctlNames[a], ::givesecondaryoffhand, tctlIDs[a]);

            break;

        case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            arIDs = "iw5_m4_mp;iw5_m16_mp;iw5_scar_mp;iw5_cm901_mp;iw5_type95_mp;iw5_g36c_mp;iw5_acr_mp;iw5_mk14_mp;iw5_ak47_mp;iw5_fad_mp";
            arNames = "M4A1;M16A4;Scar-L;CM901;Type 95;G36C;ACR 6.8;MK14;AK-47;FAD";
            self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

            smgIDs = "iw5_mp5_mp;iw5_ump45_mp;iw5_pp90m1_mp;iw5_p90_mp;iw5_m9_mp;iw5_mp7_mp";
            smgNames = "MP5;UMP45;PP90M1;P90;PM-9;MP7";
            self addSliderString("Submachine Guns", smgIDs, smgNames, ::afterhit);

            lmgIDs = "iw5_sa80_mp;iw5_mg36_mp;iw5_pecheneg_mp;iw5_mk46_mp;iw5_m60_mp";
            lmgNames = "L86 LSW;MG36;PKP Pecheneg;MK46;M60E4";
            self addSliderString("Light Machine Guns", lmgIDs, lmgNames, ::afterhit);

            srIDs = "iw5_barrett_mp_barrettscope;iw5_barrett_mp;iw5_l96a1_mp_l96a1scope;iw5_l96a1_mp;iw5_dragonuv_mp_dragonuvscope;iw5_dragonuv_mp;iw5_as50_mp_as50scope;iw5_as50_mp;iw5_rsass_mp_rsassscope;iw5_rsass_mp;iw5_msr_mp_msrscope;iw5_msr_mp";
            srNames = "Barret .50cal;Scopeless Barrett .50cal;L118A;Scopeless L118A;Dragonuv;Scopeless Dragonuv;AS50;Scopeless AS50;RSASS;Scopeless RSASS;MSR;Scopeless MSR";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

            lnchrsIDs = "iw5_smaw_mp;javelin_mp;stinger_mp;xm25_mp;m320_mp;rpg_mp;at4_mp";
            lnchrsNames = "SMAW;Javelin;Stinger;XM25;M320;RPG;AT4";
            self addSliderString("Launchers", lnchrsIDs, lnchrsNames, ::afterhit);

            specIDs = "briefcase_bomb_defuse_mp;killstreak_ac130_mp";
            specNames = "Bomb Briefcase;Laptop";
            self addSliderString("Specials", specIDs, specNames, ::afterhit);
            break;

        case "kstrks":
            self addMenu("kstrks", "Killstreak Menu"); 

            Killstreak = ["UAV", "Ballistic Vests", "Care Package", "Counter UAV", "Sentry", "Predator Missile", "AC130", "EMP"];
            for(a=0;a<level.killstreaks.size;a++)
            self addOpt( Killstreak[a], ::doKillstreak, level.killstreaks[a] );

            if(self ishost() || self isdeveloper())
            self addOpt("Fake MOAB", ::fakenuke);
            break;
    /*
        case "acc":
        self addMenu("acc", "Account Menu");
                    
        prestIDs = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21"];
        self addsliderString("Set Prestige", prestIDs, undefined, ::doPrestige);

        self addOpt("Unlock All + Max Stats", ::doUnlocks);
        
        //self addOpt("Paradise Class Names", ::paradiseclassnames);
        //self addOpt("Button Class Names", ::buttonclasses);
        //self addOpt("Colored Class Names", ::coloredClassNames);
        break;
    */
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
            
            botOptNames = "Teleport to Crosshairs;Spawn 18 Bots;Kick All Bots";
            botOptIDs = "teleport;fill;kick";
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