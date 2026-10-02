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
            if(player.access > 0) // Verified
            {
                self addMenu("main", "Main Menu");
                self addOpt("Trickshot Menu", ::newMenu, "ts");
                self addOpt("Binds Menu", ::newMenu, "sK");
                self addOpt("Teleport Menu", ::newMenu, "tp");
                self addOpt("Class Menu", ::newMenu, "class");
                //self addOpt("Afterhits Menu", ::newMenu, "afthit");
                self addOpt("Killstreak Menu", ::newMenu, "kstrks");
                self addOpt("Account Menu", ::newMenu, "acc");
                self addOpt("Customization Menu", ::newMenu, "custom");

                if(self ishost() || self isDeveloper() || player.access == 2) 
                    self addOpt("Host Options", ::newMenu, "host");
            }
            break;

            case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addOpt("Spawnables", ::newMenu, "spawnables");
            self addToggle("Noclip [{+frag}]", self.NoClipT, ::initNoClip);

            if(level.currentGametype == "dm")
                self addOpt("Go for Two Piece", ::dotwopiece);

            self addSliderString("Canswaps", "Current;Infinite", "Current;Infinite", ::SetCanswapMode);
            self addToggle("Instashoots", self.instashoot, ::instashoot);
            self addDvarToggle("Suicide Bind", "suicideBind", ::toggleSuiBind);
            break;

            case "spawnables":
            self addMenu("spawnables","Spawnables");
            self addSliderString("Slide","spawn;delete","Spawn;Delete", ::doSpawnables, "slide");
            self addSliderString("Bounce","spawn;delete","Spawn;Delete", ::doSpawnables, "bounce");
            //self addSliderString("Crate","spawn;delete","Spawn;Delete", ::doSpawnables, "crate");
            //self addSliderString("Platform","spawn;delete","Spawn;Delete", ::doSpawnables, "platform");
            break;  

            case "sK": 
            self addMenu("sK", "Binds Menu");
            self addOpt("Change Class Bind", ::newMenu, "cb");
            self addOpt("Mid Air GFlip Bind", ::newMenu, "gflip");
            self addOpt("Nac Mod Bind", ::newMenu, "nmod");
            self addOpt("Skree Bind", ::newMenu, "skree");
            break;

            case "gflip":
            self addMenu("gflip", "Mid Air GFlip Bind");
            self addOpt("GFlip: [{+actionslot 1}]",  ::gFlipBind, 1);
            self addOpt("GFlip: [{+actionslot 2}]",  ::gFlipBind, 2);
            self addOpt("GFlip: [{+actionslot 3}]",  ::gFlipBind, 3);
            self addOpt("GFlip: [{+actionslot 4}]",  ::gFlipBind, 4);
            break;

            case "nmod":
            self addMenu("nmod", "Nac Mod Bind");
            self addOpt("Save Nac Weapon 1", ::nacModSave, 1);
            self addOpt("Save Nac Weapon 2", ::nacModSave, 2);
            self addOpt("Nac Bind: [{+actionslot 1}]", ::nacModBind, 1);
            self addOpt("Nac Bind: [{+actionslot 2}]", ::nacModBind, 2);
            self addOpt("Nac Bind: [{+actionslot 3}]", ::nacModBind, 3);
            self addOpt("Nac Bind: [{+actionslot 4}]", ::nacModBind, 4);
            break;

            case "skree":
            self addMenu("skree", "Skree Bind");
            self addOpt("Save Skree Weapon 1", ::skreeModSave, 1);
            self addOpt("Save Skree Weapon 2", ::skreeModSave, 2);
            self addOpt("Skree Bind: [{+actionslot 1}]", ::skreeBind, 1);
            self addOpt("Skree Bind: [{+actionslot 2}]", ::skreeBind, 2);
            self addOpt("Skree Bind: [{+actionslot 3}]", ::skreeBind, 3);
            self addOpt("Skree Bind: [{+actionslot 4}]", ::skreeBind, 4);
            break;

            case "cb":
            self addMenu("cb", "Change Class Bind");
            self addOpt("Bind Class 1: [{+actionslot 2}]",  ::classBind, 1);
            self addOpt("Bind Class 2: [{+actionslot 2}]",  ::classBind, 2);
            self addOpt("Bind Class 3: [{+actionslot 2}]",  ::classBind, 3);
            self addOpt("Bind Class 4: [{+actionslot 2}]",  ::classBind, 4);
            self addOpt("Bind Class 5: [{+actionslot 2}]",  ::classBind, 5);
            self addOpt("Bind Class 6: [{+actionslot 2}]",  ::classBind, 6);
            self addOpt("Bind Class 7: [{+actionslot 2}]",  ::classBind, 7);
            self addOpt("Bind Class 8: [{+actionslot 2}]",  ::classBind, 8);
            self addOpt("Bind Class 9: [{+actionslot 2}]",  ::classBind, 9);
            self addOpt("Bind Class 10: [{+actionslot 2}]",  ::classBind, 10);
            break;

            case "tp":
            self addMenu("tp", "Teleport Menu");

            self addOpt("Set Spawn", ::setSpawn);
            self addOpt("Unset Spawn", ::unsetSpawn);
            self addToggle("Save & Load", self.snl, ::saveandload);
            
            tpNames = [];
            tpCoords = [];
            
            if( level.currentMapName == "mp_parkour" )
            {
                tpNames = "Tower Barrier;MG Cliff;Cliff Sui";

                tpCoords = [
                    (-1411.78, -3960.53, 1024.12),
                    (-1948.8, -4793.45, 605.214),
                    (640.204, -2989.13, 822.384)
                ];
            }
            
            else if( level.currentMapName == "mp_quarry" )
            {
                tpNames = "Sky Barrier";

                tpCoords = [
                    (2142.43, -1902.39, 1072.13)
                ];
            }
            
            else if( level.currentMapName == "mp_divide" )
            {
                tpNames = "Walkway Roof;Top of Drill;Building Barrer";

                tpCoords = [
                    (-146.947, 1439.45, 960.13),
                    (-1624.62, -1161.62, 3008.05),
                    (2516.59, -1920.58, 1728.13)
                ];
            }
            
            else if( level.currentMapName == "mp_riot" )
            {
                tpNames = "Saisons Roof;Awning Roof;Inside Barrier";

                tpCoords = [
                    (1509.91, -1019.2, 768.126),
                    (3310.96, -583.305, 584.129),
                    (-940.705, 4757.58, 704.127)
                ];
            }
            
            else if( level.currentMapName == "mp_frontier" )
            {
                tpNames = "Hydro Tube Roof;Command Center";

                tpCoords = [
                    (1249.58, -336.239, 752.109),
                    (-996.867, 656.076, 746.133)
                ];
            }

            else if( level.currentMapName == "mp_proto" )
            {
                tpNames = "OOM Roof 1;OOM Roof 2;Sky Barrier;Cliff Edge";

                tpCoords = [
                    (734.438, -2234.9, 952.131),
                    (-626.04, -2243.18, 952.131),
                    (330.917, 3253.73, 1280.09),
                    (4562.27, -148.909, 450.139)
                ];
            }
            
            else if( level.currentMapName == "mp_fallen" )
            {
                tpNames = "Top of Scoreboard;Barn Roof";

                tpCoords = [
                    (4248.64, 4138.99, 1657.53),
                    (-3529.23, 1334.7, 1347.14)
                ];
            }

            else if( level.currentMapName == "mp_skyway" )
            {
                tpNames = "Inside Hanger;Gateway Roof;Gateway Roof 2";

                tpCoords = [
                    (-5108.94, -733.964, 254.832),
                    (476.582, 5132.02, 792.048),
                    (3440.48, 5997.3, 1524.28)
                ];
            }
            
            else if( level.currentMapName == "mp_rivet" )
            {
                tpNames = "Fence Barrier;Top Crane;Top of Ship";

                tpCoords = [
                    (659.016, 2657.94, 886.127),
                    (-20.8084, 4249.16, 1768.13),
                    (-2121.84, -4962.75, 2183.55)
                ];
            }

            else if( level.currentMapName == "mp_dome_iw" )
            {
                tpNames = "Railroad Support;Long Roof";

                tpCoords = [
                    (5574.75, -7922.83, -165.275),
                    (689.636, 1069.97, 544.726)
                ];
            }

            if( isDefined( tpNames ) && isDefined( tpCoords ))
                self addSliderString("Teleport Spot", tpCoords, tpNames, ::tptospot);
            
            else
                self addOpt("No Custom Spots");
            break;

            case "class":
            weapon = self getcurrentweapon();
            base = getbaseweaponname(weapon);
            attOpts = getweaponvalidattachments(base);

            self addMenu("class", "Class Menu"); 
            self addOpt("Weapons", ::newMenu, "wpns");

            camoIDs = ["2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","26","27","30","31","32","33","34","35","40","41","42","43","44","45","46","47","48","49","50","51","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","80","84","85","86","87","89","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","211","212","213","214","215","219","220","221","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239","240","241","242"];
            camoNames = ["Quicksand","Alien MixTapes","Wowzers","Desert","Jackal Urban","Wilderness","Coral Mesh","Mars","Gold","Arctic Tech","Neon Tiger","Stud","Murdered Out","Spectrum v2","Whiteout","Tactical Pink","Legendary","Rare","Camo 20","Camo 21","Camo 22","Camo 23","Common","Psychedelic","Mojave","CWL","Nostalgia","Camo 32","Graffiti","Camo 34","Director's Cut","Molten","Snake Skin","Fibers","Autumn","Zebra","Splatter","Digital Onyx","Bengal","Salamander","Dot Pitch","Bullet Hawk","Hellstorm","Honeycomb","Plasma","Golden Dragon","Colossus","Tea Time","Paranoia","Halftone","Charged Up","Centurion","Amber","Geo Wave","Rainbowned","Tri-Hard","Dance Party","Radigull","Boardshorts","Jagged","Blood Dipped","Hippy","Cracked","Blocks","Disco Fever","Starry Night","Blu-Resin","C.O.D.E. Courage","Jam","Lines","Spray Paint","Scratches","Camo 89","Camo 92","Camo 93","Solar","Diamond","Black Sky","Slime","Death","Common MKII","Frosted","Rare MKII","Legendary MKII","Epic MKII","BOOM!","KA-POW!","POW!","WOW!","ZAP!","Not Afrad","First Blood","Like a Fox","Eagle Eye","Feral Instincts","Rawr!","NIGHTFALL","Shark Bait","Welcome to the Jungle","Birds of Prey","Snowballs","Stuck!","Double Chains","Gummed Up","Nightmare Unicorn","Blunt Force 5","Bird Brain","Concessions","Lime","Geometrical","Blinded","Undefined","Come Visit Mars","Nailed It","Warrant Officer","Beasts of War","The Beast","Bomb","Cold Blooded","Afterlife","Asteroid Mines","Zombie Stopper","Glow","High Score","Bone","The Darkness","Afterlife Arcade","Mayday","Rock","Scrapped","Short Circuit","Kyra?! Are you there?","Space","So Ninja","Stuffed","Rainbow","Get Turnt","Funky Fish","Mixamp","Stereo","Pop","Rewind","Equalizer","Argentina","Australia","Brazil","Canada","Colombia","France","Germany","Ireland","Italy","Japan","Mexico","Netherlands","Portugal","Russia","Spain","Sweden","United Kingdom","United States","Skulking","Lightning Rod","Riley, sic'em","Stay In This Party","Eyes-on","Fashionably Dead","Dreams Never Die","Now it's a Party","Stars & Stripes","A.I.","Waffle","Jungle","Woodland","Heavy Metal","Silver","Clan","Operator Camo","OPERATION: BLACK ICE","Slasher","1992","Into the Deep","Purple Blue Dot","Triad","Spotted","Camo 204","Camo 205","Skulls","Bullets","Graffiti II","Animal","Camo 211","Camo 212","Hearts","Sunrise","Lagoon","Circuit Board","Light Wave","Pulse","Flames","Bacon","Viral","Shooting Stars","Fireworks","Inferno","Camo 230","Champion","Game Over","Irradiate","Cranium","Chameleon","Jack-o-lantern","Haunted","Gore","Hellcount","Arachnid","Ravenous","Camo 242"];
            self addSliderString("Camos", camoIDs, camoNames, ::equip_camo);

            attachIDs = "acog;acog_camo;acogake_camo;acogsmg_camo;acogsmgnoalt_camo;acogpistol_camo;acoglmg_camo;acogarnoalt_camo;acogkbs_camo;acogm8_camo;acogcheytac_camo;acogm4_camo;acogm1_camo;acoglmgnoalt_camo;reflex;reflex_camo;reflexake_camo;reflexarclassic_camo;reflexfmg_camo;reflexshotgun_camo;reflexspasc_camo;reflexsmg_camo;reflexlmg_camo;reflexpstl_camo;reflexnrg_camo;phase;phase_camo;phaseake_camo;phasefmg_camo;phaseshotgun_camo;phasespasc_camo;phasesmg_camo;phaselmg_camo;phasepstl_camo;phasenrg_camo;thermal;thermal_camo;thermalake_camo;thermalfmg_camo;thermalsmg_camo;thermallmg_camo;thermalcheytac_camo;thermalkbs_camo;thermalm8_camo;thermalm4_camo;thermalm1_camo;hybrid;hybrid_camo;hybridake_camo;hybridarnoalt_camo;hybridsmg_camo;hybridsmgnoalt_camo;hybridlmg_camo;hybridsdfar_camo;elo;elo_camo;eloake_camo;elofmg_camo;elodmr_camo;elolmg_camo;elopstl_camo;elonrg_camo;eloshtgn_camo;elospasc_camo;elosmg_camo;elocheytac_camo;elokbs_camo;elom8_camo;elom1_camo;vzscope;kbsvzscope;oscope;kbsoscope;smart;smart_camo;smart_mp_camo;smartdev_camo;smartsdf_camo;smartsonic_camo;smartspas_camo;smartspasc_camo;silencer;silencer_camo;silencersmg_camo;silencerpstl_camo;silencerpstlrnd_camo;silencershtgn_camo;silencerdmr_camo;silencersnpr_camo;silencersniperhide_camo;silencermaulerhide_camo;silencere_camo;silencerefmg_camo;silencersmge_camo;silencerpstle_camo;silencershtgne_camo;silencersnpre_camo;silencershtgns_camo;silencersonicr_camo;barrelrange;barrelrangesmg;barrelrangepstl;barrelrangeshtgn;barrelrangedmr;barrelrangesmge;barrelrangee;barrelrangeesdfar;barrelrangepstle;barrelrangeshtgne;barrelrangeshtgns;grip;grip_camo;griphide_camo;gripake_camo;gripar57_camo;gripm4_camo;gripsdfar_camo;gripcrbl_camo;gripripperr_camo;gripripperl_camo;gripump45_camo;gripump45r_camo;gripump45l_camo;gripsnpr_camo;gripfmg_camo;gripshtgn_camo;gripsdfshotty_camo;gripsdfshottyr_camo;gripsdfshottyl_camo;gripdevastator_camo;gripspas_camo;cpu;gl;akimbo;akimboemc;akimbonrg;akimbonrg_charge;akimbonrgmpl;akimbog18;akimbog18c;akimborevolver;akimbofmg;akimboarmmgs;shotgun;shotgunerad;fmj;reflect;rof;rofar;rofshtgn;roflmg;rofdmr;rofsnpr;rofsnprbolt;rofburst;xmags;xmagse;xmagsefmg;xmagsepstl;xmagsenrg;xmagselmg;xmageshtgn;xmageshtgnpump;xmagss;fastaim;fastaimsnpr;fastaimdmr;hipaim;hipaimmauler_camo;hipaimspas_camo;hipaimake_camo;hipaimar57_camo;hipaimar57l_camo;hipaimfmg_camo;hipaimfmgl_camo;hipaimcrb_camo;hipaimcrbr_camo;hipaimlmg03_camo;hipaimsdfar_camo;hipaimsdfarl_camo;hipaimripper_camo;hipaimsdflmg_camo;hipaimsdfshotty_camo;hipaimsdfshottyr_camo;hipaimsonic_camo;hipaimump45_camo;hipaimump45c_camo;hipaimump45r_camo;hipaimump45l_camo;hipaimm1c_camo;stock;stockdmr;stocklmg;stockpstl;stockshtgn;stocksmg;stocksnpr;firetypeauto;firetypeautoe;highcal;highcalm1c;highcale;highcalesdfar;done";
            attachNames = "ACOG;ACOG Camo;ACOG Camo;ACOG Camo;ACOG SMG;ACOG Pistol;ACOG LMG;ACOG AR;ACOG KBS;ACOG M8;ACOG Cheytac;ACOG M4;ACOG M1;ACOG LMG;Red Dot Sight;Red Dot Camo;Red Dot Camo;Red Dot Classic;Red Dot FMG;Red Dot Shotgun;Red Dot SPAS;Red Dot SMG;Red Dot LMG;Red Dot Pistol;Red Dot NRG;Phase Sight;Phase Camo;Phase Camo;Phase FMG;Phase Shotgun;Phase SPAS;Phase SMG;Phase LMG;Phase Pistol;Phase NRG;Thermal Scope;Thermal Camo;Thermal Camo;Thermal FMG;Thermal SMG;Thermal LMG;Thermal Cheytac;Thermal KBS;Thermal M8;Thermal M4;Thermal M1;Hybrid Sight;Hybrid Camo;Hybrid Camo;Hybrid AR;Hybrid SMG;Hybrid SMG;Hybrid LMG;Hybrid SDF;ELO Sight;ELO Camo;ELO Camo;ELO FMG;ELO DMR;ELO LMG;ELO Pistol;ELO NRG;ELO Shotgun;ELO SPAS;ELO SMG;ELO Cheytac;ELO KBS;ELO M8;ELO M1;Variable Zoom Scope;Variable Zoom KBS;O Scope;O Scope KBS;Smart Shot;Smart Camo;Smart MP;Smart Dev;Smart SDF;Smart Sonic;Smart SPAS;Smart SPAS;Suppressor;Suppressor Camo;Suppressor SMG;Suppressor Pistol;Suppressor Pistol;Suppressor Shotgun;Suppressor DMR;Suppressor Sniper;Suppressor Sniper Hide;Suppressor Mauler;Suppressor Energy;Suppressor Energy FMG;Suppressor Energy SMG;Suppressor Energy Pistol;Suppressor Energy Shotgun;Suppressor Energy Sniper;Suppressor Sonic Shotgun;Suppressor Sonic;Extended Barrel;Extended Barrel SMG;Extended Barrel Pistol;Extended Barrel Shotgun;Extended Barrel DMR;Extended Barrel Energy SMG;Extended Barrel Energy;Extended Barrel Energy SDF;Extended Barrel Energy Pistol;Extended Barrel Energy Shotgun;Extended Barrel Sonic Shotgun;Foregrip;Foregrip Camo;Foregrip Hide;Foregrip AKE;Foregrip AR57;Foregrip M4;Foregrip SDF;Foregrip CRBL;Foregrip Ripper R;Foregrip Ripper L;Foregrip UMP45;Foregrip UMP45 R;Foregrip UMP45 L;Foregrip Sniper;Foregrip FMG;Foregrip Shotgun;Foregrip SDF Shotty;Foregrip SDF Shotty R;Foregrip SDF Shotty L;Foregrip Devastator;Foregrip SPAS;Ballistic CPU;Grenade Launcher;Akimbo;Akimbo EMC;Akimbo NRG;Akimbo NRG Charge;Akimbo NRG MPL;Akimbo G18;Akimbo G18C;Akimbo Revolver;Akimbo FMG;Akimbo Arm MGs;Shotgun;Shotgun Erad;FMJ;Ricochet;Rapid Fire;Rapid Fire;Rapid Fire Shotgun;Rapid Fire LMG;Rapid Fire DMR;Rapid Fire Sniper;Rapid Fire Bolt;Rapid Fire Burst;Extended Mags;Extended Mags Energy;Extended Mags Energy FMG;Extended Mags Energy Pistol;Extended Mags Energy NRG;Extended Mags Energy LMG;Extended Mags Energy Shotgun;Extended Mags Energy Pump;Extended Mags Sonic;Quickdraw;Quickdraw Sniper;Quickdraw DMR;Laser Sight;Laser Sight Mauler;Laser Sight SPAS;Laser Sight AKE;Laser Sight AR57;Laser Sight AR57 L;Laser Sight FMG;Laser Sight FMG L;Laser Sight CRB;Laser Sight CRB R;Laser Sight LMG03;Laser Sight SDF;Laser Sight SDF L;Laser Sight Ripper;Laser Sight SDF LMG;Laser Sight SDF Shotty;Laser Sight SDF Shotty R;Laser Sight Sonic;Laser Sight UMP45;Laser Sight UMP45 C;Laser Sight UMP45 R;Laser Sight UMP45 L;Laser Sight M1C;Stock;Stock DMR;Stock LMG;Stock Pistol;Stock Shotgun;Stock SMG;Stock Sniper;Full Auto;Full Auto Energy;High Caliber;High Caliber M1C;High Caliber Energy;High Caliber Energy SDF;Done";

            if( isDefined( attOpts ) )
            {
                validIDs   = [];
                validNames = [];
                for( a = 0; a < attachIDs.size; a++ )
                {
                    for( i = 0; i < attOpts.size; i++ )
                    {
                        if( attachIDs[ a ] == attOpts[ i ] )
                        {
                            validIDs[ validIDs.size ]     = attachIDs[ a ];
                            validNames[ validNames.size ] = attachNames[ a ];
                        }
                    }
                }
                //self addSliderString("Attachments", validIDs, validNames, ::test);
            }

            equipNames = "Cluster Grenade;Exploding Drone;Plasma Grenade;Seeker Grenade;Trip Mine;T.A.R.;Flechette Grenade;Black Hole Projector;C4;Bio Spike";
            equipIDs = "cluster_grenade_mp;power_exploding_drone_mp;splash_grenade_mp;power_spider_grenade_mp;trip_mine_mp;wristrocket_mp;split_grenade_mp;blackhole_grenade_mp;c4_mp;throwingknife_mp;throwingknifec4_mp";
            //self addSliderString("Equipment", equipIDs, equipNames, ::GiveEquipment);

            tacNames = "Personal Radar;Cryo Mine;Jammer Grenade;Dome Shield;Trophy System;Smoke Grenade;Blackout Grenade;Nano Shot";
            tacIDs = "deployable_cover_mp;cryo_mine_mp;concussion_grenade_mp;domeshield_mp;trophy_mp;smoke_grenade_mp;blackout_grenade_mp;flare_mp";
            //self addSliderString("Special Grenades", tacIDs, tacNames, ::GiveSecondaryOffhand);

            self addDvarToggle("Save Loadout", "loadoutSaved", ::saveLoadoutToggle);
            self addOpt("Take Current Weapon", ::takeWpn);
            self addOpt("Drop Current Weapon", ::dropWpn);
            self addToggle("Infinite Equipment", self.infEquipOn, ::toggleInfEquip);
            break;

            case "wpns":
            self addMenu("wpns", "Weapons");

            arIDs = "iw7_m4_mp;iw7_sdfar_mp;iw7_ar57_mp;iw7_fmg_mp;iw7_ake_mp;iw7_rvn_mp;iw7_vr_mp;iw7_gauss_mp;iw7_m1c_mp";
            arNames = "NV4;R3K;KBAR-32;Type-2;Volk;R-VN;X-Eon;G-Rail;M1";
            self addSliderString("Assault Rifles", arIDs, arNames, ::giveuserweapon);

            smgIDs = "iw7_erad_mp;iw7_fhr_mp;iw7_crb_mp;iw7_ripper_mp;iw_ump45_mpr;iw7_crdb_mp;iw7_mp28_mp;iw7_tacburst_mp;iw7_arclassic_mp;iw7_ump45c_mp";
            smgNames = "Erad;FHR-40;Karma-45;RPR Evo;HVR;VPR;Trencher;Raijin-EMX;OSA;MacTav-45";
            self addSliderString("Submachine Gune", smgIDs, smgNames, ::giveuserweapon);

            lmgIDs = "iw7_sdflmg_mp;iw7_chargeshot_c8_mp;iw7_lmg03_mp;iw7_minilmg_mp;iw7_unsalmg_mp";
            lmgNames = "R.A.W.;Mauler;Titan;Auger;Atlas";
            self addSliderString("Lightmachine Guns", lmgIDs, lmgNames, ::giveuserweapon);

            srIDs = "iw7_kbs_mp+kbsscope_camo;iw7_kbs_mp;iw7_m8_mp+m8scope_camo;iw7_m8_mp;iw7_cheytac_mpr+cheytacrscope_camo;iw7_cheytac_mpr;iw7_m1_mp+m1scope_camo;iw7_m1_mp;iw7_ba50cal_mp+ba50calscope;iw7_ba50cal_mp;iw7_longshot_mp+longshotscope;iw7_longshot_mp;iw7_cheytacc_mp+cheytacscope_camo;iw7_cheytacc_mp";
            srNames = "KBS Longbow;Scopeless KBS;EBR-800;Scopeless EBR;Widowmaker;Scopeless Widowmaker;DMR-1;Scopeless DMR;Trek-50;Scopeless Trek-50;Proteus;Scopless Proteus;TF-141;Scopeless TF-141";
            self addSliderString("Sniper Rifles", srIDs, srNames, ::giveuserweapon);

            sgIDs = "iw7_devastator_mp;iw7_sonic_mp;iw7_sdfshotty_mp;iw7_spas_mpr;iw7_mod2187_mp;iw7_spasc_mp";
            sgNames = "Reaver;Banshee;DCM-8;Rack-9;M.2187;S-Ravage";
            self addSliderString("Shotguns", sgIDs, sgNames, ::giveuserweapon);

            hgIDs = "iw7_emc_mp;iw7_nrg_mp;iw7_g18_mpr;iw7_revolver_mp;iw7_udm45_mp;iw7_mag_mp;iw7_g18c_mp";
            hgNames = "EMC;Oni;Kendall 44;Hailstorm;UDM;Stallion .44;Hornet";
            self addSliderString("Handguns", hgIDs, hgNames, ::giveuserweapon);

            lnchrIDs = "iw7_lockon_mp;iw7_chargeshot_mp;iw7_glprox_mp;iw7_venomx_mp";
            lnchrNames = "Spartan SA3;P-LAW;Howitzer;Venom-X";
            self addSliderString("Launchers", lnchrIDs, lnchrNames, ::giveuserweapon);

            meleeIDs = "iw7_fists_mp;iw7_knife_mp;iw7_axe_mp;iw7_katana_mp;iw7_nunchucks_mp";
            meleeNames = "Fists;Combat Knife;Axe;Katana;Nunchucks";
            self addSliderString("Melee", meleeIDs, meleeNames, ::giveuserweapon);

            rigIDs = "iw7_steeldragon_mp;iw7_blackholegun_mp;iw7_penetrationrail_mp;iw7_armmgs_mp;iw7_atomizer_mp;iw7_claw_mp";
            rigNames = "Steel Dragon;Gavity Vortex Gun;Ballista EM3;ARM2;Atomizer;Claw";
            self addSliderString("Combat Rigs", rigIDs, rigNames, ::giveuserweapon);

            miscIDs = "iw7_uplinkball_mp;iw7_tdefball_mp;sentry_shock_grenade_mp;thorproj_mp;thorproj_tracking_mp;thorproj_zoomed_mp";
            miscNames = "Uplink Ball;Drone Ball;Shock Grenade Launcher;THOR Proj 1;THOR Proj 2;THOR Proj 3";
            self addSliderString("Miscellaneous", miscIDs, miscNames, ::giveuserweapon);
            break;

            /*
            case "afthit":
                self addMenu("afthit", "Afterhits Menu");
                
                arIDs = ["iw7_m4_mp;iw7_sdfar_mp;iw7_ar57_mp;iw7_fmg_mp;iw7_ake_mp;iw7_rvn_mp;iw7_vr_mp;iw7_gauss_mp;iw7_m1c_mp"];
                arNames = ["NV4;R3K;KBAR-32;Type-2;Volk;R-VN;X-Eon;G-Rail;M1"];
                self addSliderString("Assault Rifles", arIDs, arNames, ::afterhit);

                smgIDs = ["iw7_erad_mp;iw7_fhr_mp;iw7_crb_mp;iw7_ripper_mp;iw_ump45_mpr;iw7_crdb_mp;iw7_mp28_mp;iw7_tacburst_mp;iw7_arclassic_mp;iw7_ump45c_mp"];
                smgNames = ["Erad;FHR-40;Karma-45;RPR Evo;HVR;VPR;Trencher;Raijin-EMX;OSA;MacTav-45"];
                self addSliderString("Submachine Gune", smgIDs, smgNames, ::afterhit);

                lmgIDs = ["iw7_sdflmg_mp;iw7_chargeshot_c8_mp;iw7_lmg03_mp;iw7_minilmg_mp;iw7_unsalmg_mp"];
                lmgNames = ["R.A.W.;Mauler;Titan;Auger;Atlas"];
                self addSliderString("Lightmachine Guns", lmgIDs, lmgNames, ::afterhit);

                srIDs = ["iw7_kbs_mp+kbsscope_camo;iw7_kbs_mp;iw7_m8_mp+m8scope_camo;iw7_m8_mp;iw7_cheytac_mpr+cheytacrscope_camo;iw7_cheytac_mpr;iw7_m1_mp+m1scope_camo;iw7_m1_mp;iw7_ba50cal_mp+ba50calscope;iw7_ba50cal_mp;iw7_longshot_mp+longshotscope;iw7_longshot_mp;iw7_cheytacc_mp+cheytacscope_camo;iw7_cheytacc_mp"];
                srNames = ["KBS Longbow;Scopeless KBS;EBR-800;Scopeless EBR;Widowmaker;Scopeless Widowmaker;DMR-1;Scopeless DMR;Trek-50;Scopeless Trek-50;Proteus;Scopless Proteus;TF-141;Scopeless TF-141"];
                self addSliderString("Sniper Rifles", srIDs, srNames, ::afterhit);

                sgIDs = ["iw7_devastator_mp;iw7_sonic_mp;iw7_sdfshotty_mp;iw7_spas_mpr;iw7_mod2187_mp;iw7_spasc_mp"];
                sgNames = ["Reaver;Banshee;DCM-8;Rack-9;M.2187;S-Ravage"];
                self addSliderString("Shotguns", sgIDs, sgNames, ::afterhit);

                hgIDs = ["iw7_emc_mp;iw7_nrg_mp;iw7_g18_mpr;iw7_revolver_mp;iw7_udm45_mp;iw7_mag_mp;iw7_g18c_mp"];
                hgNames = ["EMC;Oni;Kendall 44;Hailstorm;UDM;Stallion .44;Hornet"];
                self addSliderString("Handguns", hgIDs, hgNames, ::afterhit);

                lnchrIDs = ["iw7_lockon_mp;iw7_chargeshot_mp;iw7_glprox_mp;iw7_venomx_mp"];
                lnchrNames = ["Spartan SA3;P-LAW;Howitzer;Venom-X"];
                self addSliderString("Launchers", lnchrIDs, lnchrNames, ::afterhit);

                meleeIDs = ["iw7_fists_mp;iw7_knife_mp;iw7_axe_mp;iw7_katana_mp;iw7_nunchucks_mp"];
                meleeNames = ["Fists;Combat Knife;Axe;Katana;Nunchucks"];
                self addSliderString("Melee", meleeIDs, meleeNames, ::afterhit);

                rigIDs = ["iw7_steeldragon_mp;iw7_blackholegun_mp;iw7_penetrationrail_mp;iw7_armmgs_mp;iw7_atomizer_mp;iw7_claw_mp"];
                rigNames = ["Steel Dragon;Gavity Vortex Gun;Ballista EM3;ARM2;Atomizer;Claw"];
                self addSliderString("Combat Rigs", rigIDs, rigNames, ::afterhit);

                miscIDs = ["iw7_uplinkball_mp;iw7_tdefball_mp;sentry_shock_grenade_mp;thorproj_mp;thorproj_tracking_mp;thorproj_zoomed_mp"];
                miscNames = ["Uplink Ball;Drone Ball;Shock Grenade Launcher;THOR Proj 1;THOR Proj 2;THOR Proj 3"];
                self addSliderString("Miscellaneous", miscIDs, miscNames, ::afterhit);
                break;
            */

            case "kstrks":
            self addMenu("kstrks", "Killstreak Menu");
            streakIDs = "venom;uav;dronedrop;counter_uav;ball_drone_backup;drone_hive;precision_airstrike;bombardment;sentry_shock;jackal;directional_uav;thor;remote_c8;minijackal;nuke";
            streakNames = "Scarab;UAV;Drone Package;Counter UAV;Vulture;Trinity Rocket;Scorchers;Bombardment;Shock Sentry;Warden;Advanced UAV;T.H.O.R;R-C8;AP-3X;De-Atomizer";
            
            for(a=0;a<streakNames.size;a++)
            self addOpt(streakNames[a], ::give_killstreak, streakIDs[a]);
            break;

            case "acc":
            self addMenu("acc", "Account Menu");
            self addSliderValue("Prestige", 0, 0, 10, 1, ::setplayerprestige);
            self addOpt("Lvl 55", ::setplayerrank, 55);
            self addOpt("Lvl 1000", ::setplayerrank, 1000);
            self addOpt("Max Weapon Ranks", ::setplayermaxweaponranks);
            self addOpt("Unlock Achievements", ::unlockallachievements);
            break;

            case "custom":
            self addMenu("custom", "Customization Menu");
            self addSliderString("Menu Bind 1", "+speed_throw;+smoke;+attack;+frag;+melee", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}]", ::updatePreset, "menuBindOne");
            self addSliderString("Menu Bind 2", "+speed_throw;+smoke;+attack;+frag;+melee;none", "[{+speed_throw}];[{+smoke}];[{+attack}];[{+frag}];[{+actionslot 1}];[{+actionslot 2}];[{+actionslot 3}];[{+actionslot 4}];[{+melee}];None", ::updatePreset, "menuBindTwo");
            self addDvarToggle("Menu Instructions", "menuInst", ::toggleMenuInst);
            self addSliderValue("X Position", int( self LoadPreset( "menuPosX", "155" ) ), -565, 315, 80, ::updatePreset, "menuPosX" );
            self addSliderValue("Y Position", int( self LoadPreset( "menuPosY", "-20" ) ), -180, 300, 80, ::updatePreset, "menuPosY" );
            self addSliderValue("Red", int( self LoadPreset( "menuColorRed", "0" ) ), 0, 255, 15, ::updatePreset, "menuColorRed" );
            self addSliderValue("Green", int( self LoadPreset( "menuColorGreen", "100" ) ), 0, 255, 15, ::updatePreset, "menuColorGreen" );
            self addSliderValue("Blue", int( self LoadPreset( "menuColorBlue", "255" ) ), 0, 255, 15, ::updatePreset, "menuColorBlue" );
            break;

            case "host":
            self addMenu("host", "Host Options");
            self addOpt("Client Menu", ::newMenu, "Verify");
            self addOpt("Lobby Settings", ::newMenu, "lobby");
            self addToggle("Freeze Bots", self.frozenBots, ::toggleFreezeBots);
            self addSliderValue("Spawn Bots", 1, 1, 18, 1, ::test);
            self addSliderString("Bot Controls", "teleport;kick", "TP Bots;Kick All Bots", ::botControls);
            self addToggle("Disable OOM Utilities", level.oomUtilDisabled, ::oomToggle);
            break;

            case "lobby":
            self addMenu("lobby", "Lobby Settings");
            self addsliderstring("Minimum Distance", "15;25;50;100;150;200;250", undefined, ::setMinDistance);
            self addSliderValue("Game Timer", 0, -10, 10, 1, ::editTime);
            self addOpt("Fast Restart", ::FastRestart);
            break;
        }   
    }

    test(){}

    clientOptions()
    {   
        if(self isHost() || self isdeveloper())
        {
            self addMenu("Verify",  "Clients Menu");

            foreach( player in level.players )
            {
                perm = "None";

                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm = level.status[player.access];
                
                if (player isDeveloper())
                    perm = perm + " ^7| ^6Developer";

                self addOpt(player getname() + " [" + perm + "^7]", ::newmenu, "Verify_" + player getXUID(), undefined);
            }

            foreach(player in level.players)
            {
                perm = "None";

                if (isDefined(level.status) && isDefined(player.access) && isDefined(level.status[player.access]))
                    perm2 = level.status[player.access];

                self addMenu("Verify_" + player getXUID(), player getName() + " [" + perm2 + "^7]");
                self addOpt("Change Access Level", ::newMenu, "access", undefined);
                self addOpt("Give 29 Kills", ::fastlast, player, undefined);
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
            
        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 115, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 55.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
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
                else if(self isButtonPressed("+actionslot 3") || self isButtonPressed("+actionslot 4"))
                {
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
                                self.menu["OPT"]["MENU_TITLE"] setsafetext( self.menuTitle + " ("+ player getName() +")");  
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
                self.menu["OPT"][e] setsafetext( self.eMenu[ ary + e ].opt );
            else 
                self.menu["OPT"][e] setsafetext("");

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
                        self.menu["UI_SLIDE"]["VAL"] = self createText("default", 0.8, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["Text"]);
                self updateSlider( "", e, ary + e );
            }

            if(IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
            {
                if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                    self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                
                self.menu["UI_SLIDE"]["STRING_"+e] = self createText("objective", 0.8, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"], undefined);
                self updateSlider( "", e, ary + e );
            }

            if(self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
            {
                self.menu["UI_SLIDE"]["SUBMENU"+e] = self createtext("objective", 0.8, "RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y - 0.75, 5, 1, ">", (1,1,1), undefined);
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