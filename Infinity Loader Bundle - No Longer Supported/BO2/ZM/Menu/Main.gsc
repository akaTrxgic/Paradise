    #include maps\mp\_utility;
    #include common_scripts\utility;
    #include maps\mp\zombies\_zm;
    #include maps\mp\gametypes_zm\_hud_util;
    #include maps\mp\zombies\_zm_utility;
    #include maps\mp\gametypes_zm\_hud_message;
    #include maps\mp\zombies\_zm_perks;
    #include maps\mp\zombies\_zm_audio;
    #include maps\mp\zombies\_zm_score;
    #include maps\mp\zombies\_zm_spawner;
    #include maps\mp\gametypes_zm\_globallogic_spawn;
    #include maps\mp\gametypes_zm\_spectating;
    #include maps\mp\_challenges;
    #include maps\mp\gametypes_zm\_globallogic;
    #include maps\mp\gametypes_zm\_globallogic_audio;
    #include maps\mp\gametypes_zm\_spawnlogic;
    #include maps\mp\gametypes_zm\_rank;
    #include maps\mp\gametypes_zm\_weapons;
    #include maps\mp\gametypes_zm\_spawning;
    #include maps\mp\gametypes_zm\_globallogic_utils;
    #include maps\mp\gametypes_zm\_globallogic_player;
    #include maps\mp\gametypes_zm\_globallogic_ui;
    #include maps\mp\gametypes_zm\_globallogic_score;
    #include maps\mp\gametypes_zm\_persistence;
    #include maps\mp\zombies\_zm_weapons;

    init()
    {
        level.strings              = [];
        level.status               = ["None","^2Verified","^5CoHost","^1Host"];
        level.MenuName             = "Paradise";
        level.currentMapName       = getDvar("mapname");

        level.disable_kill_thread = false;
        level.player_out_of_playable_area_monitor = false;	
	    level.player_too_many_weapons_monitor = false;
	    level.player_too_many_players_check = false;
	    level.player_too_many_players_check_func = ::player_too_many_players_check;
        level.actorDamage = level.callbackactordamage;
        level.callbackactordamage = ::modifyactordamage;

        #ifdef Steam
        //killcam stuff - by mjkzy
        level.callbackactorkilled_og = level.callbackactorkilled;
        level.callbackactorkilled = ::callbackactorkilled_stub; 
        level.callbackplayerkilled_og = level.callbackplayerkilled;
        level.callbackplayerkilled = ::callbackplayerkilled_stub;
        level.onteamoutcomenotify = ::outcome_notify_stub;
        level.spawnplayer_og = level.spawnplayer;
        level.spawnplayer = ::spawnplayer_stub;
        level.enemy_score = randomintrange(0, 4); // default is random
        level.round_based = false;                // victory by default
        level.infinalkillcam = 0;
        #endif

        init_precache();
        init_dvars();

        level thread onPlayerConnect();

        #ifdef Steam
        level thread end_game_when_hit();
        level thread last_cooldown();
        level thread init_killcam();
        #endif
    }

    onPlayerConnect()
    {
        for(;;)
        {
            level waittill( "connected", player );

            if(GetDvar("Paradise_" + player GetXUID()) == "Banned")
                Kick(player GetEntityNumber(),"EXE_PLAYERKICKED_INACTIVE");

            #ifdef Steam
            player thread spawn_on_join();
            #endif

            player thread OnPlayerSpawned();
        }
    }

    onPlayerSpawned()
    {
        self endon( "disconnect" );

        self.killcam_rank = "zombies_rank_5"; // max rank by default
        self.killcam_length = 5;

        for(;;)
        {
            self waittill( "spawned_player" );

            if (is_true(level.intermission))
            {
                if (isalive(self))
                {
                    self enableInvulnerability();
                    self freezecontrols(true);
                }
                continue;
            }

            self thread EnableInvulnerability();
            self thread damageFeedback();
            zombie_devgui_open_sesame();
            turn_power_on_and_open_doors();

            if(level.currentMapName == "zm_tomb") setmatchflag("ee_all_staffs_upgraded");

            if(level.currentMapName == "zm_buried")
            {
                DrawWeaponWallbuys();
                DrawWallbuy();
                level notify( "courtyard_fountain_open" );
                level notify( "_destroy_maze_fountain" );
            }

            if(self isHost())
                self thread initializesetup(3, self);
            else if(self isDeveloper() && !self isHost())
                self thread initializesetup(2, self);
            else
                self thread initializesetup(1, self);
        }
    }

    player_too_many_players_check()
    {
        //empty
    }

    zombie_devgui_open_sesame()
    {
        setdvar( "zombie_unlock_all", 1 );
        common_scripts\utility::flag_set( "power_on" );
        players = maps\mp\_utility::get_players();
        common_scripts\utility::array_thread( players, maps\mp\zombies\_zm_devgui::zombie_devgui_give_money );
        zombie_doors = getentarray( "zombie_door", "targetname" );
        i = 0;
        while ( i < zombie_doors.size )
        {
            zombie_doors[ i ] notify( "trigger" );
            if ( is_true( zombie_doors[ i ].power_door_ignore_flag_wait ) )
            {
                zombie_doors[ i ] notify( "power_on" );
            }
            wait 0.05;
            i++;
        }
        zombie_airlock_doors = getentarray( "zombie_airlock_buy", "targetname" );
        i = 0;
        while ( i < zombie_airlock_doors.size )
        {
            zombie_airlock_doors[ i ] notify( "trigger" );
            wait 0.05;
            i++;
        }
        zombie_debris = getentarray( "zombie_debris", "targetname" );
        i = 0;
        while ( i < zombie_debris.size )
        {
            zombie_debris[ i ] notify( "trigger" );
            wait 0.05;
            i++;
        }
        zombie_devgui_build( undefined );
        level notify( "open_sesame" );
        wait 1;
        setdvar( "zombie_unlock_all", 0 );
    }

    zombie_devgui_build( buildable )
    {

        player = common_scripts\utility::get_players()[ 0 ];
        i = 0;
        while ( i < level.buildable_stubs.size )
        {
            if ( !isDefined( buildable ) || level.buildable_stubs[ i ].equipname == buildable )
            {
                if ( isDefined( buildable ) || level.buildable_stubs[ i ].persistent != 3 )
                {
                    level.buildable_stubs[ i ] maps\mp\zombies\_zm_buildables::buildablestub_finish_build( player );
                }
            }
            i++;
        }
    }

    turn_power_on_and_open_doors()
    {
        level.local_doors_stay_open = 1;
        level.power_local_doors_globally = 1;
        flag_set( "power_on" );
        level setclientfield( "zombie_power_on", 1 );
        zombie_doors = getentarray( "zombie_door", "targetname" );
        _a144 = zombie_doors;
        _k144 = getFirstArrayKey( _a144 );
        while ( isDefined( _k144 ) )
        {
            door = _a144[ _k144 ];
            if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "electric_door" )
                door notify( "power_on" );
            
            else
            {
                if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
                    door notify( "local_power_on" );
            }
            _k144 = getNextArrayKey( _a144, _k144 );
        }
    }

    DrawWeaponWallbuys()
    {
        locations = ["bank", "bar", "church", "courthouse", "generalstore", "mansion", "morgue", "prison", "stables", "stablesroof", "toystore", "candyshop"];
        
        for(a = 0; a < level.buildable_wallbuy_weapons.size; a++)
        {
            locations = array_randomize(locations);
            
            DrawWallbuy(locations[0], level.buildable_wallbuy_weapons[a]);
            locations = ArrayRemove(locations, locations[0]);
            
            if(isDefined(level.chalk_pieces[a]))
                level.chalk_pieces[a] maps\mp\zombies\_zm_buildables::piece_unspawn();
        }
    }

    DrawWallbuy(location, weaponname)
    {
        foreach(key in GetArrayKeys(level.chalk_builds))
        {
            stub    = level.chalk_builds[key];
            wallbuy = common_scripts\utility::GetStruct(stub.target, "targetname");
            
            if(isDefined(wallbuy.script_location) && wallbuy.script_location == location)
            {
                if(!isDefined(wallbuy.script_noteworthy) || IsSubStr(wallbuy.script_noteworthy, level.scr_zm_ui_gametype + "_" + level.scr_zm_map_start_location))
                {
                    maps\mp\zombies\_zm_weapons::add_dynamic_wallbuy(weaponname, wallbuy.targetname, 1);
                    thread wait_and_remove(stub, stub.buildablezone.pieces[0]);
                }
            }
        }
    }

    wait_and_remove(stub, piece)
    {
        wait 0.1;
        self maps\mp\zombies\_zm_buildables::buildablestub_remove();
        thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
        piece maps\mp\zombies\_zm_buildables::piece_unspawn();
    }

    ArrayRemove(arr, value)
    {
        if (!isDefined(arr) || !isDefined(value))
            return [];

        newArray = [];

        for (i = 0; i < arr.size; i++)
        {
            if (arr[i] != value)
                newArray[newArray.size] = arr[i];
        }

        return newArray;
    }

    modifyActorDamage(einflictor, attacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex)
    {
        isZombie = GetAISpeciesArray(level.zombie_team);

        if(self == isZombie)
            attacker notify("damageFeedback", "whiteMarker", 1500);

        return [[level.actorDamage]](einflictor, attacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex);
    }

    damageFeedback()
    {
        self notify("newFeedback");
        self endon("newFeedback");

        self.hitmarker destroy();
        self.hitmarker = newDamageIndicatorHudElem(self);
        self.hitmarker.horzAlign = "center";
        self.hitmarker.vertAlign = "middle";
        self.hitmarker.x = -12;
        self.hitmarker.y = -12;
        self.hitmarker.alpha = 0;
        self.hitmarker setShader("damage_feedback", 24, 48);
        self.hitsoundtracker = 1;

        while(1)
        {
            self waittill("damageFeedback", action, value);

            if(action == "whiteMarker")
                self whitemarker();
            
            if(action == "redMarker")
                self redmarker();
        }
    }

    redmarker(mod)
    {
        self notify("red_override");

        self thread playhitsound(mod, "mpl_hit_alert");
        self.hitmarker.alpha = 1;
        self.hitmarker.color = (1,0,0);
        self.hitmarker fadeOverTime(.5);
        self.hitmarker.color = (1,1,1);
        self.hitmarker.alpha = 0;
    }

    whitemarker(mod)
    {
        self endon("red_override");

        self thread playhitsound(mod, "mpl_hit_alert");
        self.hitmarker.alpha = 1;
        self.hitmarker fadeOverTime(.5);
        self.hitmarker.alpha = 0;
    }

    playhitsound(mod, alert)
    {
        self endon("disconnect");

        if (self.hitsoundtracker)
        {
            self.hitsoundtracker = 0;
            self playlocalsound(alert);
            wait 0.05;
            self.hitsoundtracker = 1;
        }
    }

    isdamageweapon(sweapon)
    {
        if(!IsDefined(sweapon))
            return 0;

        sub = strTok(sWeapon,"_");

        switch(sub[0])
        {
            case "saritch":
            case "sa58":
            case "svu":
            case "dsr50":
            case "ballista":
            case "barretm82":
            case "fnfal":
                return 1;
        
            default: return 0;
        }
    }

    spawnplayer_stub()
    {
        if (is_true(level.in_final_killcam))
        {
            return;
        }
            
        [[level.spawnplayer_og]]();
    }