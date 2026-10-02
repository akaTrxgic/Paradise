    pwpn()
    {   
        weapon = self getcurrentweapon();
        self iprintln("^1" + weapon.name);
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
            if(self.access > 0) //Verified
            {
                self addMenu("main", "Main Menu");
                //self addOpt("Print Weapon", ::pwpn, undefined, undefined);
                self addOpt("Trickshot Menu", ::newMenu, "ts", undefined);
                self addOpt("Binds Menu", ::newMenu, "sK", undefined);
                self addOpt("Teleport Menu", ::newMenu, "tp", undefined);
                self addOpt("Class Menu", ::newMenu, "class", undefined);
                self addOpt("Afterhits Menu", ::newMenu, "afthit", undefined);
                self addOpt("Killstreak Menu", ::newMenu, "kstrks", undefined);
                self addOpt("Customization Menu", ::newMenu, "custom", undefined);

                if(self ishost() || self isDeveloper()) 
                    self addOpt("Host Options", ::newMenu, "host", undefined);
            }
            break;

            case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);
            self addOpt("Go for Two Piece", ::dotwopiece, undefined, undefined);

            canOpts = ["Current", "Infinite"];
            self addSliderString("Canswaps", canOpts, canOpts, ::SetCanswapMode, undefined, undefined);

            self addToggle("Instashoots", self.instashoot, ::instashoot);
            self addOpt("Spawn Slide @ Crosshairs", ::slide, undefined, undefined);

            spawnOptionsActions = ["Bounce","Platform","Crate"];
            spawnOptionsIDs     = ["bounce","platform","crate"];
            self addSliderString("Spawn @ Feet", spawnOptionsIDs, spawnOptionsActions, ::doSpawnOption, undefined, undefined);
            break;

            case "sK":
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb", undefined);
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip", undefined);
            self addOpt("Nac Mod Bind", ::newMenu, "nmod", undefined);
            self addOpt("Skree Bind", ::newMenu, "skree", undefined);
            break;

            case "gflip":
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]", ::gFlipBind, 1, undefined);
            self addOpt("GFlip: [{+actionslot 2}]", ::gFlipBind, 2, undefined);
            self addOpt("GFlip: [{+actionslot 3}]", ::gFlipBind, 3, undefined);
            self addOpt("GFlip: [{+actionslot 4}]", ::gFlipBind, 4, undefined);
            break;

            case "nmod":
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1, undefined);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2, undefined);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind, 1, undefined);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind, 2, undefined);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind, 3, undefined);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind, 4, undefined);
            break;

            case "skree":
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1, undefined);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2, undefined);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind, 1, undefined);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind, 2, undefined);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind, 3, undefined);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind, 4, undefined);
            break;

            case "cb":
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 2}]", ::classBind, 1, undefined);
            self addOpt("Bind Class 2: [{+actionslot 2}]", ::classBind, 2, undefined);
            self addOpt("Bind Class 3: [{+actionslot 2}]", ::classBind, 3, undefined);
            self addOpt("Bind Class 4: [{+actionslot 2}]", ::classBind, 4, undefined);
            self addOpt("Bind Class 5: [{+actionslot 2}]", ::classBind, 5, undefined);
            break;

            case "tp":
            self addMenu("tp", "Teleport Menu");
            self addOpt("Set Spawn",::setSpawn, undefined, undefined);
            self addOpt("Unset Spawn", ::unsetSpawn, undefined, undefined);
            self addToggle("Save & Load", self.snl, ::saveandload);

            if( level.currentMapName == "mp_biodome" )
            {
                tpNames = ["Distance Fence","Concrete Ledge","Road Sign","Lightpost"];

                tpCoords = [
                    (9071.18, -2848.3, 319.408),
                    (5052.97, -7951.18, 160.125),
                    (5233.57, 899.168, 414.865),
                    (4995.55, 695.1, 461.121)
                ];
            }

            else if( level.currentMapName == "mp_sector" )
            {
                tpNames = ["Under Map","Cliff Edge"];

                tpCoords = [
                (-1841.01, -1772.07, 152.125),
                (348.922, -3747.41, 182.929)
                ];
            }

            else if( level.currentMapName == "mp_apartments" )
            {
                tpNames = ["Top of Ship","Ship Wing"];

                tpCoords = [
                    (-6174.4, -2708.61, 1835.89),
                    (-5862.93, -2469.59, 1534.71)
                ];
            }
            
            else if( level.currentMapName == "mp_chinatown" )
            {
                tpNames = ["Distance Sign","Bridge Railing"];

                tpCoords = [
                    (-11650.3, -7111.92, 234.125),
                    (-5324.59, 3090.32, -28.7998)
                ];
            }

            else if( level.currentMapName == "mp_veiled" )
            {
                tpNames = ["Barn Roof","Red Trailer","Church Roof"];

                tpCoords = [
                    (3068.01, -1240.27, 454.662),
                    (1083.99, -3099.18, 129.664),
                    (453.785, 3408.26, 322.414)
                ];
            }

            else if( level.currentMapName == "mp_havoc" )
            {
                tpNames = ["HQ Roof","Under Map"];

                tpCoords = [
                    (-10.8744, -3449.19, 3507.13),
                    (-6185.9, -1932.75, -88.0004)
                ];
            }

            else if( level.currentMapName == "mp_ethiopia" )
            {
                tpNames = ["OOM Road","OOM Road 2"];

                tpCoords = [
                    (-5809.33, 2828.04, -37.875),
                    (2623.64, -2696.5, -96.3527)
                ];
            }

            else if( level.currentMapName == "mp_infection" )
            {
                tpNames = ["Spawn Capsule","Cliff Ledge","Cliff Ledge 2","Snow Ledge"];

                tpCoords = [
                    (-390.253, -3695.64, 443),
                    (792.259, -4553.15, -2.35484),
                    (92.866, 3892.1, 306.56),
                    (110.839, 3612.21, 2450.2)
                ];
            }

            else if( level.currentMapName == "mp_metro" )
            {
                tpNames = ["Distance Pier","Spawn Pier","Spawn Pier 2"];

                tpCoords = [
                    (9045.81, -1104.35, -95.875),
                    (-118.411, 6853.1, -47.875),
                    (-485.548, -7407.19, -47.875)
                ];
            }

            else if( level.currentMapName == "mp_stronghold" )
            {
                tpNames = ["House Roof","Shed Roof"];

                tpCoords = [
                    (858.378, 4763.79, 357.787),
                    (554.134, 5810.52, 282.007)
                ];
            }

            else if( level.currentMapName == "mp_nuketown_x" )
            {
                tpNames = ["Good Luck"];

                tpCoords = [
                    (67.7112, -32746.8, 2107.87)
                ];
            }

            else if( level.currentMapName == "mp_veiled_heyday" )
            {
                tpNames = ["Church Roof","Top of Train","Barn Roof"];

                tpCoords = [
                    (428.901, 3339.95, 285.112),
                    (4104.22, 1109.31, 193.125),
                    (3064.53, -1202.62, 465.329)
                ];
            }

            if( isDefined( tpNames ) && isDefined( tpCoords ))
                self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot, undefined, undefined);
            
            else
                self addOpt("No Custom Spots", undefined, undefined, undefined);

            break;

            case "class":
            self addMenu("class", "Class Menu");
            self addOpt("Weapons", ::newMenu, "wpns", undefined);
            self addOpt("Attachments", ::newMenu, "attach", undefined);
            //self addOpt("Camos", ::newMenu, "camos", undefined);
            self addOpt("Lethals", ::newMenu, "lethals", undefined);
            self addOpt("Tacticals", ::newMenu, "tacticals", undefined);
            self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
            self addOpt("Take Weapon", ::takewpn, undefined, undefined);
            self addOpt("Drop Weapon", ::dropWpn, undefined, undefined);
            break;

            case "wpns":
            self addMenu("wpns", "Weapons");

            smgIDs = ["smg_standard","smg_versatile","smg_capacity","smg_fastfire","smg_burst","smg_longrange","smg_mp40","smg_nailgun","smg_rechamber","smg_ppsh","smg_ak74u","smg_msmc","smg_sten2"];
            smgNames = ["Kuda","VMP","Weevil","Vesper","Pharo","Razorback","HG-40","DIY 11 Renovator","HLX 4","PPSH-41","AK-74u","XMC","Sten"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::giveuserweapon, undefined, undefined);

            arIDs = ["ar_standard","ar_fastburst","ar_cqb","ar_accurate","ar_damage","ar_marksman","ar_longburst","ar_garand","ar_famas","ar_peacekeeper","ar_pulse","ar_m16","ar_galil","ar_an94","ar_m14"];
            arNames = ["KN-44","XR-2","HVK-30","ICR-1","Man-O-War","Sheiva","M8A7","MX Garand","FFAR","Peacekeeper MK2","LV8 Basilisk","M16","Galil","KVK 99m","M14"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::giveuserweapon, undefined, undefined);

            sgIDs = ["shotgun_pump","shotgun_semiauto","shotgun_fullauto","shotgun_precision","shotgun_energy","shotgun_olympia"];
            sgNames = ["KRM-262","205 Brecci","Haymaker 12","Argus","Banshii","Olympia"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::giveuserweapon, undefined, undefined);

            lmgIDs = ["lmg_light","lmg_cqb","lmg_slowfire","lmg_heavy","lmg_infinite","lmg_rpk"];
            lmgNames = ["BRM","Dingo","Gorgon","48 Dredge","R70 Ajax","RPK"];
            self addsliderstring("Lightmachine Guns", lmgIDs, lmgNames, ::giveuserweapon, undefined, undefined);

            srIDs = ["sniper_fastsemi","sniper_fastbolt","sniper_chargeshot","sniper_powerbolt","sniper_quickscope","sniper_double","sniper_xpr50","sniper_mosin"];
            srNames = ["Drakon","Locus","P-06","SVG-100","RSA Interdiction","DBSR-50","XPR-50","Dragoon"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::giveuserweapon, undefined, undefined);

            pstlIDs = ["pistol_standard","pistol_burst","pistol_fullauto","pistol_shotgun","pistol_energy","pistol_m1911"];
            pstlNames = ["MR6","RK5","L-CAR 9","Marshal 16","Rift E9","1911"];
            self addsliderstring("Pistols", pstlIDs, pstlNames, ::giveuserweapon, undefined, undefined);

            lnchrIDs = ["launcher_standard","launcher_lockonly","launcher_multi","launcher_ex41"];
            lnchrNames = ["XM-53","Blackcell","L4 Siege","MAX GL"];
            self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::giveuserweapon, undefined, undefined);

            meleeIDs = ["knife_loadout","bare_hands","melee_boxing","melee_butterfly","melee_wrench","melee_knuckles","melee_crowbar","melee_sword","melee_bat","melee_dagger","melee_bowie","melee_mace","melee_fireaxe","melee_boneglass","melee_improvise","melee_shockbaton","melee_nunchuks","melee_katana","melee_shovel","melee_prosthetic","melee_chainsaw","melee_crescent"];
            meleeNames = ["Combat Knife","Bare Hands","Prizefighters","Butterfly Knife","Wrench","Brass Knuckles","Iron Jim","Fury's Song","MVP","Malice","Carver","Skull Splitter","Slash n Burn","Nightbreaker","Buzz Cut","Enforcer","Nunchuks","Path of Sorrows","Ace of Spades","L3ft E.","Bushwhacker","Ravens Eye"];
            self addsliderstring("Melee", meleeIDs, meleeNames, ::giveuserweapon, undefined, undefined);

            specIDs = ["special_crossbow","special_discgun","knife_ballistic"];
            specNames = ["NX Shadowclaw","D13 Sector","Ballistic Knife"];
            self addsliderstring("Specials", specIDs, specNames, ::giveuserweapon, undefined, undefined);

            heroIDs = ["hero_annihilator","hero_chemicalgelgun","hero_flamethrower","hero_minigun_body3","hero_minigun","hero_pineapplegun"];
            heroNames = ["Annihilator","HIVE","Purifier","White Scythe","Default Scythe","War Machine"];
            self addSliderString("Specialist Weapons", heroIDs, heroNames, ::giveuserweapon, undefined, undefined);

            miscIDs = ["baseweapon","ball","defaultweapon","ball_world","bowie_knife"];
            miscNames = ["Baseweapon","Uplink Ball","Default Weapon","Ball Offhand","Bowie as Melee"];
            self addsliderstring("Miscellaneous", miscIDs, miscNames, ::giveuserweapon, undefined, undefined);
            break;

            case "attach":
                self addMenu("attach", "Attachments");
                for(a=0;a<44;a++)
                    if(TableLookup("gamedata/weapons/common/attachmenttable.csv", 0, a, 1) != "camo")
                        if(TableLookup("gamedata/weapons/common/attachmenttable.csv", 0, a, 2) != "mod")
                            self addOpt(TableLookupIString("gamedata/weapons/common/attachmenttable.csv", 0, a, 3), ::givePlayerAttachment, TableLookup("gamedata/weapons/common/attachmenttable.csv", 0, a, 4), undefined);
            break;

            case "camos":
                self addMenu("camos", "Camos");
                for(a=0;a<138;a++)
                    if(TableLookup("gamedata/weapons/common/attachmenttable.csv", 0, a, 1) == "camo")
                        if(TableLookupIString("gamedata/weapons/common/attachmenttable.csv", 0, a, 3) != "")
                            self addOpt(TableLookupIString("gamedata/weapons/common/attachmenttable.csv", 0, a, 3), ::changeCamo, a, undefined);
            break;

            case "lethals":
            self addMenu("lethals", "Lethals");
            
            lthlIDs = ["frag_grenade","sticky_grenade","bouncingbetty","hatchet","satchel_charge"];
            lthlNames = ["Frag","Semtex","Trip Mine", "Thermite","Combat Axe","C4"];
            
            for(a=0;a<lthlIDs.size;a++)
            self addOpt(lthlNames[a], ::GiveLethalEquipment, lthlIDs[a], undefined);
            break;

            case "tacticals":
            self addMenu("tacticals", "Tacticals");

            tacIDs = ["concussion_grenade","willy_pete","emp_grenade","trophy_system","proximity_grenade_aoe","flash_grenade","pda_hack"];
            tacNames = ["Concussion","Smoke Screen","EMP","Trophy System","Shock Charge","Flashbang","Black Hat"];

            for(a=0;a<tacIDs.size;a++)
            self addOpt(tacNames[a], ::GiveTacticalEquipment, tacIDs[a], undefined);
            break;

            case "afthit":
            self addMenu("afthit", "Afterhits Menu");

            smgIDs = ["smg_standard","smg_versatile","smg_capacity","smg_fastfire","smg_burst","smg_longrange","smg_mp40","smg_nailgun","smg_rechamber","smg_ppsh","smg_ak74u","smg_msmc","smg_sten2"];
            smgNames = ["Kuda","VMP","Weevil","Vesper","Pharo","Razorback","HG-40","DIY 11 Renovator","HLX 4","PPSH-41","AK-74u","XMC","Sten"];
            self addsliderstring("Submachine Guns", smgIDs, smgNames, ::AfterHit, undefined, undefined);

            arIDs = ["ar_standard","ar_fastburst","ar_cqb","ar_accurate","ar_damage","ar_marksman","ar_longburst","ar_garand","ar_famas","ar_peacekeeper","ar_pulse","ar_m16","ar_galil","ar_an94","ar_m14"];
            arNames = ["KN-44","XR-2","HVK-30","ICR-1","Man-O-War","Sheiva","M8A7","MX Garand","FFAR","Peacekeeper MK2","LV8 Basilisk","M16","Galil","KVK 99m","M14"];
            self addsliderstring("Assault Rifles", arIDs, arNames, ::AfterHit, undefined, undefined);

            sgIDs = ["shotgun_pump","shotgun_semiauto","shotgun_fullauto","shotgun_precision","shotgun_energy","shotgun_olympia"];
            sgNames = ["KRM-262","205 Brecci","Haymaker 12","Argus","Banshii","Olympia"];
            self addsliderstring("Shotguns", sgIDs, sgNames, ::AfterHit, undefined, undefined);

            lmgIDs = ["lmg_light","lmg_cqb","lmg_slowfire","lmg_heavy","lmg_infinite","lmg_rpk"];
            lmgNames = ["BRM","Dingo","Gorgon","48 Dredge","R70 Ajax","RPK"];
            self addsliderstring("Lightmachine Guns", lmgIDs, lmgNames, ::AfterHit, undefined, undefined);

            srIDs = ["sniper_fastsemi","sniper_fastbolt","sniper_chargeshot","sniper_powerbolt","sniper_quickscope","sniper_double","sniper_xpr50","sniper_mosin"];
            srNames = ["Drakon","Locus","P-06","SVG-100","RSA Interdiction","DBSR-50","XPR-50","Dragoon"];
            self addsliderstring("Sniper Rifles", srIDs, srNames, ::AfterHit, undefined, undefined);

            pstlIDs = ["pistol_standard","pistol_burst","pistol_fullauto","pistol_shotgun","pistol_energy","pistol_m1911"];
            pstlNames = ["MR6","RK5","L-CAR 9","Marshal 16","Rift E9","1911"];
            self addsliderstring("Pistols", pstlIDs, pstlNames, ::AfterHit, undefined, undefined);

            lnchrIDs = ["launcher_standard","launcher_lockonly","launcher_multi","launcher_ex41"];
            lnchrNames = ["XM-53","Blackcell","L4 Siege","MAX GL"];
            self addsliderstring("Launchers", lnchrIDs, lnchrNames, ::AfterHit, undefined, undefined);

            meleeIDs = ["knife_loadout","melee_boxing","melee_butterfly","melee_wrench","melee_knuckles","melee_crowbar","melee_sword","melee_bat","melee_dagger","melee_bowie","melee_mace","melee_fireaxe","melee_boneglass","melee_improvise","melee_shockbaton","melee_nunchuks","melee_katana","melee_shovel","melee_prosthetic","melee_chainsaw","melee_crescent"];
            meleeNames = ["Combat Knife","Prizefighters","Butterfly Knife","Wrench","Brass Knuckles","Iron Jim","Fury's Song","MVP","Malice","Carver","Skull Splitter","Slash n Burn","Nightbreaker","Buzz Cut","Enforcer","Nunchuks","Path of Sorrows","Ace of Spades","L3ft E.","Bushwhacker","Ravens Eye"];
            self addsliderstring("Melee", meleeIDs, meleeNames, ::AfterHit, undefined, undefined);

            specIDs = ["special_crossbow","special_discgun","knife_ballistic"];
            specNames = ["NX Shadowclaw","D13 Sector","Ballistic Knife"];
            self addsliderstring("Specials", specIDs, specNames, ::AfterHit, undefined, undefined);

            heroIDs = ["hero_annihilator","hero_chemicalgelgun","hero_flamethrower","hero_minigun_body3","hero_minigun","hero_pineapplegun"];
            heroNames = ["Annihilator","HIVE","Purifier","White Scythe","Default Scythe","War Machine"];
            self addSliderString("Specialist Weapons", heroIDs, heroNames, ::AfterHit, undefined, undefined);

            miscIDs = ["baseweapon","ball","defaultweapon"];
            miscNames = ["Baseweapon","Uplink Ball","Default Weapon"];
            self addsliderstring("Miscellaneous", miscIDs, miscNames, ::AfterHit, undefined, undefined);
            break;

            case "kstrks":
            self addMenu("kstrks", "Killstreaks");

            self addOpt("Fill Streaks", ::fillStreaks, undefined, undefined);

            level.KillstreakName = ["HC-XD", "UAV", "Care Package", "Counter-UAV", "Dart", "Guardian", "Lightning Strike", "Hellstorm", "Hardened Sentry", "Cerberus", "Rolling Thunder", "Talon", "Wraith", "H.A.T.R", "Power Core", "R.A.P.S", "G.I Unit", "Mothership"];
            level.Killstreak = ["rcbomb", "uav", "supply_drop", "counteruav", "dart", "microwave_turret", "planemortar", "remote_missile", "autoturret", "ai_tank_drop", "drone_strike", "sentinel", "helicopter_comlink", "satellite", "emp", "raps", "combat_robot", "helicopter_gunner"];
            for( a = 0; a < level.Killstreak.size; a++ )
                self addOpt( level.KillstreakName[ a ], ::doKillstreak, level.Killstreak[ a ], undefined );
            break;

            case "custom":
            self addMenu("custom", "Customization Menu");

            bindIDs = ["+speed_throw","+smoke","+attack","+frag","+actionslot 1","+actionslot 2","+actionslot 3","+actionslot 4","+melee"];
            bindNames = ["[{+speed_throw}]","[{+smoke}]","[{+attack}]","[{+frag}]","[{+actionslot 1}]","[{+actionslot 2}]","[{+actionslot 3}]","[{+actionslot 4}]","[{+melee}]"];
            self addSliderString("Menu Bind 1", bindIDs, bindNames, ::updatePreset, "menuBindOne", undefined);
            
            bind2IDs = ["+speed_throw","+smoke","+attack","+frag","+actionslot 1","+actionslot 2","+actionslot 3","+actionslot 4","+melee","none"];
            bind2Names = ["[{+speed_throw}]","[{+smoke}]","[{+attack}]","[{+frag}]","[{+actionslot 1}]","[{+actionslot 2}]","[{+actionslot 3}]","[{+actionslot 4}]","[{+melee}]","None"];
            self addSliderString("Menu Bind 2", bind2IDs, bind2Names, ::updatePreset, "menuBindTwo", undefined);
            
            self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
            self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX", undefined );
            self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY", undefined );
            self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "168" ) ), 0, 255, 15, ::updatePreset, "menuColorRed", undefined );
            self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "14" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen", undefined );
            self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "78" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue", undefined );
            break;

            case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify", undefined);
            self addOpt("Lobby Settings", ::newMenu, "lobby", undefined);
            self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::spawnBots, undefined, undefined);
            self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);
            
            botOptIDs = ["teleport","kick"];
            botOptNames = ["Teleport to Crosshairs","Kick All Bots"];
            self addSliderString("Bot Controls", botOptIDs, botOptNames, ::botControls, undefined, undefined);
            
            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            break;

            case "lobby":
            self addMenu("lobby", "Lobby Settings");

            minDist = ["15","25","50","100","150","200","250"];
            self addsliderstring("Minimum Distance", minDist, minDist, ::setMinDistance, undefined, undefined);

            self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime, undefined, undefined);
            self addOpt("Fast Restart", ::FastRestart, undefined, undefined);
            break;
        }   
        self clientoptions();
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

                self addOpt(player getname() + " [" + perm + "^7]", ::newmenu, "Verify_" + player getXUID(), undefined);
            }

            foreach(player in level.players)
            {
                if (isDefined(player.pers) && isDefined(player.pers["isBot"]) && player.pers["isBot"])
                    continue;

                perm = "None";

                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm2 = level.status[player.access];

                self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
                self addOpt("Change Access Level", ::newMenu, "access", undefined);
                self addOpt("Give 29 Kills", ::fastLast, player, undefined);
                self addOpt("Ban Player", ::banSped, player, undefined);
                self addOpt("Kick Player", ::kickSped, player, undefined);  
                self addOpt("Teleport to Crosshairs", ::teleportToCrosshair, player, undefined);  
                
                self addMenu("access", "Change Access Level");
                for(a=0;a<level.status.size-1;a++)
                    self addOpt("Give: " + level.status[a], ::initializesetup, a, player);
            }
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

        self.menu["UI"]["MENU_TITLE"] = self createtext("default", 3, "TOPLEFT", "CENTER", self.presets["X"] + 115, self.presets["Y"] - 110, 5, 1, level.MenuName, self.presets["MenuTitle_Color"], undefined);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1, undefined);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7, undefined); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1, undefined); 
        self resizeMenu();
    }

    menuMonitor()
    {
        self endon("disconnect");
        self endon("end_menu");

        while(player.access != 0)
        {
            if(!self.menu["isOpen"])
            {
                if( isDefined( self.presets["BindTwo"] ) && self.presets["BindTwo"] != "none" )
                {
                    if( self bindButtonPressed( self.presets["BindOne"] ) && self bindButtonPressed( self.presets["BindTwo"] ) )
                    {
                        self menuOpen();
                        wait .2;
                    }
                }

                else
                {
                    if( self bindButtonPressed( self.presets["BindOne"] ) )
                    {
                        self menuOpen();
                        wait .2;
                    }
                }
            }

            else
            {
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

                else if( self useButtonPressed() )
                {
                    player = self.selected_player;
                    menu = self.eMenu[self getCursor()];

                    if( player != self && self isHost() )
                    {
                        player.was_edited = true;
                        self iPrintLnBold( menu.opt + " Has Been Activated" );
                    }
                    
                    if( self.eMenu[ self getCursor() ].func == ::newMenu && self != player )
                        self iPrintLnBold( "^1ERROR: ^7Cannot Access Menus While In A Selected Player" );
                    else if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ])){
                        slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                        slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                        player thread doOption( menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5 );
                    }
                    else 
                        player thread doOption( menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5, undefined );

                    wait .05;
                    if(IsDefined( menu.toggle ))
                        self setMenuText();
                    if( player != self )
                        self.menu["OPT"]["MENU_TITLE"] settextstring( self.menuTitle + " ("+ player getName() +")");
                    wait .15;
                    if( isDefined(player.was_edited) && self isHost() )
                        player.was_edited = undefined;
                }
                else if( self meleeButtonPressed() )
                {
                    if( self.selected_player != self )
                    {
                        self.selected_player = self;
                        self setMenuText();
                        self refreshTitle();
                    }
                    else if( self getCurrentMenu() == "main" )
                        self menuClose();
                    else 
                        self newMenu(undefined);
                    wait .2;
                }
            }
            wait .05;
        }
    }

    menuOpen()
    {
        self.menu["isOpen"] = true;
        
        self menuoptions();
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

    drawText()
    {
        self destroyAll(self.menu["OPT"]);

        if(!isDefined(self.menu["OPT"]))
            self.menu["OPT"] = [];

        for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText(self.presets["Option_Font"], self.presets["Font_Scale"], "LEFT", "CENTER", self.presets["X"] + 5, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"], undefined);
    }

    refreshTitle()
    {
        self.menu["UI"]["MENU_TITLE"] settextstring(level.MenuName);
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
        //self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);
        
        size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
        height     = int(15 * size); // 18
        math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
        position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    } 

    setMenuText()
    {
        self endon("disconnect");

        self menuoptions();
        self resizeMenu();

        ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;  
        self destroyAll(self.menu["UI_TOG"]);
        self destroyAll(self.menu["UI_SLIDE"]);
        
        for(e=0;e<10;e++)
        {
            self.menu["OPT"][e].x = self.presets["X"] + 61; 
            
            if(isDefined(self.eMenu[ ary + e ].opt))
                self.menu["OPT"][e] settextstring( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] settextstring("");
                
            if(IsDefined( self.eMenu[ ary + e ].toggle ))
            {
                self.menu["OPT"][e].x += 0; 
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ ary + e ].toggle) ? self.presets["Toggle_BG"] : dividecolor(150, 150, 150), "white", 5, 1, undefined);
            }
            
            if(IsDefined( self.eMenu[ ary + e ].val ))
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1, undefined);
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1, undefined);
                if( self getCursor() == ( ary + e ) )
                    self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["Text"], undefined);
                
                self updateSlider( "", e, ary + e );
            }

            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                    
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"], undefined);
                self updateSlider( "", e, ary + e );
            }

            if(self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            {
                self.menu["UI_SLIDE"]["SUBMENU"+e] = self createtext("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y - 0.75, 5, 1, ">", (1,1,1), undefined);
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