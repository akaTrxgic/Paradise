    init_precache()
    {
        precacheshader("white");
        precacheshader("line_horizontal");
        precacheshader("zombies_rank_1");
        precacheshader("zombies_rank_2");
        precacheshader("zombies_rank_3");
        precacheshader("zombies_rank_4");
        precacheshader("zombies_rank_5");
        precacheshader("emblem_bg_default");
        precacheshader("damage_feedback");
        precacheshader("hud_status_dead");
        precacheshader("specialty_instakill_zombies");
        precacheshader("menu_lobby_icon_twitter");
        precacheshader("faction_cia");
        precacheshader("faction_cdc");

        precachemodel("p6_anim_zm_magic_box");

        precacheitem("zombie_knuckle_crack");
        precacheitem("zombie_perk_bottle_jugg");
        precacheitem("zombie_perk_bottle_sleight");
        precacheitem("zombie_perk_bottle_doubletap");
        precacheitem("zombie_perk_bottle_deadshot");
        precacheitem("zombie_perk_bottle_tombstone");
        precacheitem("zombie_perk_bottle_additionalprimaryweapon");
        precacheitem("zombie_perk_bottle_revive");
        precacheitem("chalk_draw_zm");
        precacheitem("lightning_hands_zm");
    }

    init_dvars()
    {
        setdvar("bot_AllowMovement", 0);
        setdvar("bot_PressAttackBtn", 0);
        setdvar("bot_PressMeleeBtn", 0);
        setdvar("friendlyfire_enabled", 0);
        setdvar("g_friendlyfireDist", 0);
        setdvar("ui_friendlyfire", 1);
        setdvar("jump_slowdownEnable", 0);
        setdvar("sv_enableBounces", 1);
        setdvar("player_lastStandBleedoutTime", 9999);
        setdvar( "scr_fog_disable", "1" );
        setdvar( "r_fog_disable", "1" );
    }
    
    #ifdef Steam
    get_number_of_zombies()
    {
        return (maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total);
    }

    // birchy utils
    draw_text_2(text, align, relative, x, y, fontscale, font, color, alpha, sort)
    {
        //element = self createfontstring(font, fontscale);
        element = self createfontstring(font, fontscale);
        element setpoint(align, relative, x, y);
        element settext(text);
        element.hidewheninmenu = false;
        element.color = color;
        element.alpha = alpha;
        element.sort = sort;
        return element;
    }

    draw_shader(align, relative, x, y, shader, width, height, color, alpha, sort)
    {
        element = newclienthudelem(self);
        element.elemtype = "bar";
        element.hidewheninmenu = false;
        element.shader = shader;
        element.width = width;
        element.height = height;
        element.align = align;
        element.relative = relative;
        element.xoffset = 0;
        element.yoffset = 0;
        element.children = [];
        element.sort = sort;
        element.color = color;
        element.alpha = alpha;
        element setparent(level.uiparent);
        element setshader(shader, width, height);
        element setpoint(align, relative, x, y);
        return element;
    }

    end_game_when_hit()
    {
        level endon("game_ended");

        // inital black screen
        if (!flag("initial_blackscreen_passed"))
        {
            flag_wait("initial_blackscreen_passed");
        }

        // wait until a zombie has spawned, then run the loop
        enemies = get_number_of_zombies();
        while (enemies <= 0)
        {
            enemies = get_number_of_zombies();
            wait 0.5;
        }

        for(;;)
        {
            enemies = get_number_of_zombies();
            if (enemies < 1 && level.is_last)
            {
                if (int(getdvar("g_ai")) != 1)
                    setdvar("g_ai", 1);

                level thread custom_end_game();
                break;
            }

            wait 0.05;
        }
    }

    // MP endgame + parts of end_game from _zm
    custom_end_game()
    {
        winner = level.last_attacker.team;

        if (game["state"] == "postgame" || level.gameEnded) return;
        if (isdefined(level.onEndGame))
            [[level.onEndGame]](winner);

        // visionSetNaked("mpOutro", 2.0);

        setMatchFlag("enable_popups", 0);
        setmatchflag("cg_drawSpectatorMessages", 0);
        setmatchflag("game_ended", 1);

        players = get_players();
        setmatchflag("disableIngameMenu", 1);
        foreach(player in players)
        {
            
            player closeingamemenu();
            player enableinvulnerability();
            if (isdefined(player.revivetexthud))
                player.revivetexthud destroy();
        }

        level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
        level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
        level.zombie_vars["zombie_powerup_point_doubler_time"] = 0;

        game["state"] = "postgame";
        level.gameEndTime = getTime();
        level.gameEnded = true;
        SetDvar("g_gameEnded", 1);
        level.inGracePeriod = false;
        level notify("game_ended");
        //level notify("game_module_ended"); // is this even needed
        maps\mp\gametypes_zm\_globallogic_audio::flushDialog();

        if (!isdefined(game["overtime_round"]) || wasLastRound()) // Want to treat all overtime rounds as a single round
        {
            game["roundsplayed"]++;
            game["roundwinner"][game["roundsplayed"]] = winner;

            if (level.teambased)
            {
                game["roundswon"][winner]++;
            }
        }

        level.finalKillCam_winner = "none";
        if (isdefined(winner) && isdefined(level.teams[winner]))
        {
            level.finalKillCam_winner = winner;
        }

        level.finalKillCam_winnerPicked = true;

        setGameEndTime(0);

        maps\mp\gametypes_zm\_globallogic::updatePlacement();
        maps\mp\gametypes_zm\_globallogic::updateRankedMatch(winner);

        newTime = getTime();
        gameLength = getGameLength();

        SetMatchTalkFlag("EveryoneHearsEveryone", 1);

        bbGameOver = 0;
        if (isOneRound() || wasLastRound())
        {
            bbGameOver = 1;

            if (level.teambased)
            {
                if (winner == "tie")
                {
                    recordGameResult("draw");
                }
                else
                {
                    recordGameResult(winner);
                }
            }
            else
            {
                if (!isdefined(winner))
                {
                    recordGameResult("draw");
                }
                else
                {
                    recordGameResult(winner.team);
                }
            }
        }

        players = getplayers();
        foreach(player in players)
        {
            if (!isdefined(player))
                continue;

            player maps\mp\gametypes_zm\_globallogic_player::freezeplayerforroundend();
            player thread roundenddof(4.0);

            // zombies think they are tough because we can't move at all
            player enableinvulnerability();
            player maps\mp\gametypes_zm\_globallogic_ui::freeGameplayHudElems();
            player maps\mp\gametypes_zm\_weapons::updateWeaponTimings(newTime);
            player maps\mp\gametypes_zm\_globallogic::bbPlayerMatchEnd(gameLength, "", bbGameOver);

            if (isPregame())
            {
                index++;
                continue;
            }

            if (level.rankedMatch || level.wagerMatch || level.leagueMatch)
            {
                if (isdefined(player.setPromotion))
                {
                    player setDStat("AfterActionReportStats", "lobbyPopup", "promotion");
                }
                else
                {
                    player setDStat("AfterActionReportStats", "lobbyPopup", "summary");
                }
            }
        }

        maps\mp\_music::setmusicstate("SILENT");
        thread maps\mp\_challenges::roundEnd(winner);
        if (startNextRound(winner, " "))
        {
            return;
        }

        ///////////////////////////////////////////
        // After this the match is really ending //
        ///////////////////////////////////////////

        if (!isOneRound())
        {
            if (isdefined(level.onRoundEndGame))
            {
                winner = [[level.onRoundEndGame]](winner);
            }
        }

        skillUpdate(winner, level.teamBased);
        recordLeagueWinner(winner);

        maps\mp\gametypes_zm\_globallogic::setTopPlayerStats();
        thread maps\mp\_challenges::gameEnd(winner);

        displayGameEnd(winner);

        stopallrumbles();
        level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
        level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
        level.zombie_vars["zombie_powerup_point_doubler_time"] = 0;
        setmatchflag("disableIngameMenu", 1);

        // maps that crash reverting archive time
        level.skip_game_end = false;
        if (level.script == "zm_transit" || level.script == "zm_prison" || level.script == "zm_buried")
        {
            level.skip_game_end = true;
        }

        // load killcam here.
        postRoundFinalKillcam(); // call killcam here?
        while (level.in_final_killcam == 1)
        {
            wait 0.05;
        }

        level.intermission = true;

        //regain players array since some might've disconnected during the wait above
        players = getplayers();
        foreach(player in players)
        {
            if (!isdefined(player))
                continue;

            player closeInGameMenu();
            player notify ("reset_outcome");
            player thread [[level.spawnIntermission]]();
            player overlay(false);
            player setClientUIVisibilityFlag("hud_visible", 1);
        }

        level notify ("sfade");
        level notify("stop_intermission");
        logString("game ended");

        if (!isdefined(level.skip_game_end) || !level.skip_game_end)
            wait 10;

        exitlevel(false);
    }

    teamoutcomenotify(winner, isround, endreasontext)
    {
        self endon("disconnect");
        self notify("reset_outcome");
        team = level.last_attacker.team;

        while (self.doingnotify)
        {
            wait 0.05;
        }
        self endon("reset_outcome");
        headerfont = "extrabig";
        font = "default";
        if (self issplitscreen())
        {
            titlesize = 2;
            textsize = 1.5;
            iconsize = 30;
            spacing = 10;
        }
        else
        {
            titlesize = 3;
            textsize = 2;
            iconsize = 70;
            spacing = 25;
        }
        duration = 60000;
        outcometitle = createfontstring(headerfont, titlesize);
        outcometitle setpoint("TOP", undefined, 0, 30);
        outcometitle.glowalpha = 1;
        outcometitle.hidewheninmenu = 0;
        outcometitle.archived = 0;
        outcometitle.immunetodemogamehudsettings = 1;
        outcometitle.immunetodemofreecamera = 1;
        outcometext = createfontstring(font, 2);
        outcometext setparent(outcometitle);
        outcometext setpoint("TOP", "BOTTOM", 0, 0);
        outcometext.glowalpha = 1;
        outcometext.hidewheninmenu = 0;
        outcometext.archived = 0;
        outcometext.immunetodemogamehudsettings = 1;
        outcometext.immunetodemofreecamera = 1;

        if (level.round_based)
            outcometitle settext(game["strings"]["round_win"]);
        else
            outcometitle settext(game["strings"]["victory"]);
        outcometitle.color = (0.42, 0.68, 0.46);
        outcometext settext("Zombies Eliminated");
        outcometitle setcod7decodefx(200, duration, 600);
        outcometext setpulsefx(100, duration, 1000);
        iconspacing = 100;
        currentx = ((1 * -1) * iconspacing) / 2;
        teamicons = [];
        teamicons[team] = createicon(determineTeamLogo(), iconsize, iconsize);
        teamicons[team] setparent(outcometext);
        teamicons[team] setpoint("TOP", "BOTTOM", currentx, spacing);
        teamicons[team].hidewheninmenu = 0;
        teamicons[team].archived = 0;
        teamicons[team].alpha = 0;
        teamicons[team].immunetodemogamehudsettings = 1;
        teamicons[team].immunetodemofreecamera = 1;
        teamicons[team] fadeovertime(0.5);
        teamicons[team].alpha = 1;
        currentx += iconspacing;
        foreach(enemyteam in level.teams)
        {
            if (enemyteam != team)
            {
                teamicons[enemyteam] = createicon("hud_status_dead", iconsize, iconsize);
                teamicons[enemyteam] setparent(outcometext);
                teamicons[enemyteam] setpoint("TOP", "BOTTOM", currentx, spacing);
                teamicons[enemyteam].hidewheninmenu = 0;
                teamicons[enemyteam].archived = 0;
                teamicons[enemyteam].immunetodemogamehudsettings = 1;
                teamicons[enemyteam].immunetodemofreecamera = 1;
                teamicons[enemyteam] fadeovertime(0.5);
                teamicons[enemyteam].alpha = 1;
                currentx += iconspacing;
            }
        }
        teamscores = [];
        teamscores[team] = createfontstring(font, titlesize);
        teamscores[team] setparent(teamicons[team]);
        teamscores[team] setpoint("TOP", "BOTTOM", 0, spacing);
        teamscores[team].glowalpha = 1;
        if (level.round_based)
            teamscores[team] setvalue(randomintrange(0, 4));
        else
            teamscores[team] setvalue(4);
        teamscores[team].hidewheninmenu = 0;
        teamscores[team].archived = 0;
        teamscores[team].immunetodemogamehudsettings = 1;
        teamscores[team].immunetodemofreecamera = 1;
        teamscores[team] setpulsefx(100, duration, 1000);

        foreach(enemyteam in level.teams)
        {
            if (enemyteam != team)
            {
                teamscores[enemyteam] = createfontstring(headerfont, titlesize);
                teamscores[enemyteam] setparent(teamicons[enemyteam]);
                teamscores[enemyteam] setpoint("TOP", "BOTTOM", 0, spacing);
                teamscores[enemyteam].glowalpha = 1;
                teamscores[enemyteam] setvalue(level.enemy_score);
                teamscores[enemyteam].hidewheninmenu = 0;
                teamscores[enemyteam].archived = 0;
                teamscores[enemyteam].immunetodemogamehudsettings = 1;
                teamscores[enemyteam].immunetodemofreecamera = 1;
                teamscores[enemyteam] setpulsefx(100, duration, 1000);
            }
        }
        font = "objective";
        matchbonus = createfontstring(font, 2);
        matchbonus setparent(outcometext);
        matchbonus setpoint("TOP", "BOTTOM", 0, iconsize + (spacing * 3) + teamscores[team].height);
        matchbonus.glowalpha = 1;
        matchbonus.hidewheninmenu = 0;
        matchbonus.archived = 0;
        matchbonus.label = game["strings"]["match_bonus"];
        matchbonus setvalue(randomintrange(2000, 3500));
        self thread maps\mp\gametypes_zm\_hud_message::resetoutcomenotify(teamicons, teamscores, outcometitle, outcometext);
    }

    displayGameEnd(winner)
    {
        players = getplayers();
        foreach(player in players)
        {
            if (!isdefined(player))
                continue;

            player thread [[level.onTeamOutcomeNotify]](winner, false, "");
            player setClientUIVisibilityFlag("hud_visible", 0);
            player setClientUIVisibilityFlag("g_compassShowEnemies", 0);
        }

        roundEndWait(level.postRoundTime, true);
    }

    outcome_notify_stub(winner, isround, endreasontext)
    {
        self endon("disconnect");
        self notify("reset_outcome");
        team = level.last_attacker.team;

        while (self.doingnotify)
        {
            wait 0.05;
        }
        self endon("reset_outcome");
        headerfont = "extrabig";
        font = "default";
        if (self issplitscreen())
        {
            titlesize = 2;
            textsize = 1.5;
            iconsize = 30;
            spacing = 10;
        }
        else
        {
            titlesize = 3;
            textsize = 2;
            iconsize = 70;
            spacing = 25;
        }
        duration = 60000;
        outcometitle = createfontstring(headerfont, titlesize);
        outcometitle setpoint("TOP", undefined, 0, 30);
        outcometitle.glowalpha = 1;
        outcometitle.hidewheninmenu = 0;
        outcometitle.archived = 0;
        outcometitle.immunetodemogamehudsettings = 1;
        outcometitle.immunetodemofreecamera = 1;
        outcometext = createfontstring(font, 2);
        outcometext setparent(outcometitle);
        outcometext setpoint("TOP", "BOTTOM", 0, 0);
        outcometext.glowalpha = 1;
        outcometext.hidewheninmenu = 0;
        outcometext.archived = 0;
        outcometext.immunetodemogamehudsettings = 1;
        outcometext.immunetodemofreecamera = 1;

        if (level.round_based)
            outcometitle settext(game["strings"]["round_win"]);
        else
            outcometitle settext(game["strings"]["victory"]);
        outcometitle.color = (0.42, 0.68, 0.46);
        outcometext settext("Zombies Eliminated");
        outcometitle setcod7decodefx(200, duration, 600);
        outcometext setpulsefx(100, duration, 1000);
        iconspacing = 100;
        currentx = ((1 * -1) * iconspacing) / 2;

        teamicons = [];
        teamicons[team] = createicon(determineTeamLogo(), iconsize, iconsize);
        teamicons[team] setparent(outcometext);
        teamicons[team] setpoint("TOP", "BOTTOM", currentx, spacing);
        teamicons[team].hidewheninmenu = 0;
        teamicons[team].archived = 0;
        teamicons[team].alpha = 0;
        teamicons[team].immunetodemogamehudsettings = 1;
        teamicons[team].immunetodemofreecamera = 1;
        teamicons[team] fadeovertime(0.5);
        teamicons[team].alpha = 1;

        currentx += iconspacing;

        foreach(enemyteam in level.teams)
        {
            if (enemyteam != team)
            {
                teamicons[enemyteam] = createicon("hud_status_dead", iconsize, iconsize);
                teamicons[enemyteam] setparent(outcometext);
                teamicons[enemyteam] setpoint("TOP", "BOTTOM", currentx, spacing);
                teamicons[enemyteam].hidewheninmenu = 0;
                teamicons[enemyteam].archived = 0;
                teamicons[enemyteam].immunetodemogamehudsettings = 1;
                teamicons[enemyteam].immunetodemofreecamera = 1;
                teamicons[enemyteam] fadeovertime(0.5);
                teamicons[enemyteam].alpha = 1;

                currentx += iconspacing;
            }
        }
        teamscores = [];
        teamscores[team] = createfontstring(font, titlesize);
        teamscores[team] setparent(teamicons[team]);
        teamscores[team] setpoint("TOP", "BOTTOM", 0, spacing);
        teamscores[team].glowalpha = 1;
        if (level.round_based)
            teamscores[team] setvalue(randomintrange(0, 4));
        else
            teamscores[team] setvalue(4);
        teamscores[team].hidewheninmenu = 0;
        teamscores[team].archived = 0;
        teamscores[team].immunetodemogamehudsettings = 1;
        teamscores[team].immunetodemofreecamera = 1;
        teamscores[team] setpulsefx(100, duration, 1000);

        foreach(enemyteam in level.teams)
        {
            if (enemyteam != team)
            {
                teamscores[enemyteam] = createfontstring(headerfont, titlesize);
                teamscores[enemyteam] setparent(teamicons[enemyteam]);
                teamscores[enemyteam] setpoint("TOP", "BOTTOM", 0, spacing);
                teamscores[enemyteam].glowalpha = 1;
                teamscores[enemyteam] setvalue(level.enemy_score);
                teamscores[enemyteam].hidewheninmenu = 0;
                teamscores[enemyteam].archived = 0;
                teamscores[enemyteam].immunetodemogamehudsettings = 1;
                teamscores[enemyteam].immunetodemofreecamera = 1;
                teamscores[enemyteam] setpulsefx(100, duration, 1000);
            }
        }
        font = "objective";
        matchbonus = createfontstring(font, 2);
        matchbonus setparent(outcometext);
        matchbonus setpoint("TOP", "BOTTOM", 0, iconsize + (spacing * 3) + teamscores[team].height);
        matchbonus.glowalpha = 1;
        matchbonus.hidewheninmenu = 0;
        matchbonus.archived = 0;
        matchbonus.label = game["strings"]["match_bonus"];
        matchbonus setvalue(randomintrange(2000, 3500));
        self thread maps\mp\gametypes_zm\_hud_message::resetoutcomenotify(teamicons, teamscores, outcometitle, outcometext);
    }

    // shader, logos, team icons
    determineTeamLogo()
    {
        mapname = tolower(getdvar("mapname"));
        standard = maps\mp\zombies\_zm_utility::is_standard(); 		// not turned/other shit
        survival = (getDvar("ui_zm_gamemodegroup") == "zsurvival"); // survival (Nuketown, TranZit solos)
        classic = (getDvar("ui_zm_gamemodegroup") == "zclassic"); 	// TranZit, MOTD, Origins, Buried, Die Rise

        if (survival)
        {
            if (is_true(level.should_use_cia))
                return game["icons"]["axis"];
            else
                return game["icons"]["allies"];
        }
        else if (classic)
        {
            return self.killcam_rank;
        }

        if (standard)
            return "hud_status_dead";

        return "hud_status_dead";
    }

    custom_end_game_f()
    {
        level thread custom_end_game();
    }

    instantend()
    {
        return exitlevel(false);
    }

    last_cooldown()
    {
        level endon("game_ended");
        level endon("manual_end_game");

        level.is_last = false;

        // inital black screen
        if (!flag("initial_blackscreen_passed"))
        {
            flag_wait("initial_blackscreen_passed");
        }

        // wait until a zombie has spawned, then run the loop
        enemies = get_number_of_zombies();
        while (enemies <= 0)
        {
            enemies = get_number_of_zombies();
            wait 0.5;
        }

        for(;;)
        {
            enemies = get_number_of_zombies();
            if (is_false(level.is_last))
            {
                if (enemies > 0 && enemies <= 1)
                {
                    iprintln("you are at ^1last^7!");

                    level.is_last = true;

                    zombies = getaiarray(level.zombie_team);
                    foreach(zomb in zombies)
                    {
                        zomb.ignore_round_spawn_failsafe = true;
                    }
                }
            }
            if (enemies > 2 && is_true(level.is_last))
            {
                iprintln("last cooldown ^1reset^7! there is more than ^11^7 zombie");
                level.is_last = false;
            }
            wait 0.02;
        }
    }

    get_ai_number()
    {
        if (!isdefined(self.ai_number))
        {
            set_ai_number();
        }
        return self.ai_number;
    }

    set_ai_number()
    {
        if (!isdefined(level.ai_number))
        {
            level.ai_number = 0;
        }
        self.ai_number = level.ai_number;
        level.ai_number++;
    }

    get_the_player_name()
    {
        player_name = self.name;
        for(i = 0; i < self.name.size; i++)
        {
            if (self.name[i] == "]") break;
        }
        if (self.name.size != i)
            player_name = getSubStr(self.name, i + 1, self.name.size);
        return player_name;
    }

    spawn_on_join()
    {
        level endon("game_ended");
        self endon("disconnect");
        wait 5;
        if (self.sessionstate == "spectator")
        {
            self [[level.spawnplayer]]();
            thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
        }
    }
    
    init_killcam()
    {
        level.in_final_killcam = false;

        level.finalkillcamsettings = [];
        initfinalkillcamteam("none");
        foreach(team in level.teams)
        {
            initfinalkillcamteam(team);
        }
        level.finalkillcam_winner = undefined;

        level thread do_final_killcam();
    }

    record_killcam_settings_and_stuff(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime)
    {
        if (self == attacker)
            return;
        if (!isplayer(attacker))
            return;

        attacker = updateattacker(attacker, sweapon);
        if (!isplayer(attacker))
            return;

        einflictor = updateinflictor(einflictor);

        killcamentity = self getkillcamentity(attacker, einflictor, sweapon);
        killcamentityindex = -1;
        killcamentitystarttime = 0;
        if (isdefined(killcamentity))
        {
            killcamentityindex = killcamentity getentitynumber();
            if (isdefined(killcamentity.starttime))
                killcamentitystarttime = killcamentity.starttime;
            else
                killcamentitystarttime = killcamentity.birthtime;

            if (!isdefined(killcamentitystarttime))
                killcamentitystarttime = 0;
        }

        deathtimeoffset = 0;
        self.deathtime = gettime();

        // if this is not defined, everything will kinda die. oopsie :P
        level.last_attacker = attacker;

        level thread record_killcam_settings(attacker getentitynumber(), self getentitynumber(), sweapon, self.deathtime, deathtimeoffset, psoffsettime, killcamentityindex, killcamentitystarttime, attacker);
    }

    callbackactorkilled_stub(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime)
    {
        if ( maps\mp\gametypes_zm\_globallogic_utils::isheadshot( sweapon, shitloc, smeansofdeath, einflictor ) && isplayer( attacker ) )
		{
			attacker playlocalsound( "prj_bullet_impact_headshot_helmet_nodie_2d" );
			smeansofdeath = "MOD_HEAD_SHOT";
		}
        
        // call original
        thread [[level.callbackactorkilled_og]](einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime);

        self thread record_killcam_settings_and_stuff(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime);
    }

    callbackplayerkilled_stub(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
    {
        // call original
        thread [[level.callbackplayerkilled_og]](einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration);

        self thread record_killcam_settings_and_stuff(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime);
    }

    record_killcam_settings(spectatorclient, targetentityindex, sweapon, deathtime, deathtimeoffset, offsettime, entityindex, entitystarttime, attacker)
    {
        if (level.teambased && isdefined(attacker.team) && isdefined(level.teams[attacker.team]))
        {
            team = attacker.team;
            level.finalkillcamsettings[team].spectatorclient = spectatorclient;
            level.finalkillcamsettings[team].weapon = sweapon;
            level.finalkillcamsettings[team].deathtime = deathtime;
            level.finalkillcamsettings[team].deathtimeoffset = deathtimeoffset;
            level.finalkillcamsettings[team].offsettime = offsettime;
            level.finalkillcamsettings[team].entityindex = entityindex;
            level.finalkillcamsettings[team].targetentityindex = targetentityindex;
            level.finalkillcamsettings[team].entitystarttime = entitystarttime;
            level.finalkillcamsettings[team].attacker = attacker;
        }
        level.finalkillcamsettings["none"].spectatorclient = spectatorclient;
        level.finalkillcamsettings["none"].weapon = sweapon;
        level.finalkillcamsettings["none"].deathtime = deathtime;
        level.finalkillcamsettings["none"].deathtimeoffset = deathtimeoffset;
        level.finalkillcamsettings["none"].offsettime = offsettime;
        level.finalkillcamsettings["none"].entityindex = entityindex;
        level.finalkillcamsettings["none"].targetentityindex = targetentityindex;
        level.finalkillcamsettings["none"].entitystarttime = entitystarttime;
        level.finalkillcamsettings["none"].attacker = attacker;
    }

    final_killcam_waiter()
    {
        if (!isdefined(level.finalkillcam_winner))
        {
            return;
        }

        level waittill("final_killcam_done");
    }

    postroundfinalkillcam()
    {
        level notify("play_final_killcam");
        maps\mp\gametypes_zm\_globallogic::resetoutcomeforallplayers();
        final_killcam_waiter();
    }

    do_final_killcam()
    {
        level waittill("play_final_killcam");

        level.in_final_killcam = 1;

        winner = "none";
        if (isdefined(level.finalkillcam_winner))
        {
            winner = level.finalkillcam_winner;
        }

        settings = level.finalkillcamsettings[winner];
        if (!isdefined(settings.targetentityindex))
        {
            level notify("final_killcam_done");
            level.in_final_killcam = 0;
            return;
        }

        if (isdefined(settings.attacker))
        {
            maps\mp\_challenges::getfinalkill(level.finalkillcamsettings[winner].attacker);
        }

        visionsetnaked(getdvar("mapname"), 0);

        players = getplayers();
        foreach(player in players)
        {
            if (!isdefined(player))
                continue;

            player closemenu();
            player closeingamemenu();
            player thread final_killcam(winner);
        }

        wait 0.1;

        // wait for all killcams to finish watching killcam
        while (are_any_players_watching())
        {
            wait 0.05;
        }

        level notify("final_killcam_done");
        level.in_final_killcam = 0;
        map_restart();
    }

    are_any_players_watching()
    {
        players = getplayers();
        foreach(player in players)
        {
            if (!isdefined(player))
                continue;

            if (is_true(player.killcam))
            {
                return true;
            }
        }
        return false;
    }

    initfinalkillcamteam(team)
    {
        level.finalkillcamsettings[team] = spawnstruct();
        level.finalkillcamsettings[team].spectatorclient = undefined;
        level.finalkillcamsettings[team].weapon = undefined;
        level.finalkillcamsettings[team].deathtime = undefined;
        level.finalkillcamsettings[team].deathtimeoffset = undefined;
        level.finalkillcamsettings[team].offsettime = undefined;
        level.finalkillcamsettings[team].entityindex = undefined;
        level.finalkillcamsettings[team].targetentityindex = undefined;
        level.finalkillcamsettings[team].entitystarttime = undefined;
        level.finalkillcamsettings[team].killstreaks = undefined;
        level.finalkillcamsettings[team].attacker = undefined;
    }

    set_killcam_entity(killcamentityindex, delayms)
    {
        self endon("disconnect");
        self endon("end_killcam");
        self endon("spawned");
        if (delayms > 0)
        {
            wait (delayms / 1000);
        }
        self.killcamentity = killcamentityindex;
    }

    waitkillcamtime()
    {
        self endon("disconnect");
        self endon("end_killcam");
        wait (self.killcamlength - 0.05);
        self notify("end_killcam");
    }

    waitfinalkillcamslowdown(deathtime, starttime)
    {
        self endon("disconnect");
        self endon("end_killcam");
        secondsuntildeath = (deathtime - starttime) / 1000;
        deathtime = getTime() + (secondsuntildeath * 1000);
        waitbeforedeath = 1.65;
        maps\mp\_utility::setclientsysstate("levelNotify", "fkcb");
        wait max(0, secondsuntildeath - waitbeforedeath);
        setslowmotion(1, 0.25, waitbeforedeath);
        wait (waitbeforedeath + 0.5);
        setslowmotion(0.25, 1, 1);
        wait 2;
        maps\mp\_utility::setclientsysstate("levelNotify", "fkce");
    }

    waitteamchangeendkillcam()
    {
        self endon("disconnect");
        self endon("end_killcam");
        self waittill("changed_class");
        endkillcam(0);
    }

    waitskipkillcamsafespawnbutton()
    {
        self endon("disconnect");
        self endon("end_killcam");
        while (self fragbuttonpressed())
        {
            wait 0.05;
        }
        while (!self fragbuttonpressed())
        {
            wait 0.05;
        }
        self.wantsafespawn = 1;
        self notify("end_killcam");
    }

    endkillcam(final)
    {
        if (isdefined(self.kc_skiptext))
        {
            self.kc_skiptext.alpha = 0;
        }
        self.killcam = undefined;
        self thread maps\mp\gametypes_zm\_spectating::setspectatepermissions();
    }

    checkforabruptkillcamend()
    {
        self endon("disconnect");
        self endon("end_killcam");
        while (1)
        {
            if (self.archivetime <= 0)
            {
                break;
            }
            wait 0.05;
        }
        self notify("end_killcam");
    }

    spawnedkillcamcleanup()
    {
        self endon("end_killcam");
        self endon("disconnect");
        self waittill("spawned");
        self endkillcam(0);
    }

    spectatorkillcamcleanup(attacker)
    {
        self endon("end_killcam");
        self endon("disconnect");
        attacker endon("disconnect");
        attacker waittill("begin_killcam", attackerkcstarttime);
        waittime = max(0, attackerkcstarttime - self.deathtime - 50);
        wait waittime;
        self endkillcam(0);
    }

    endedkillcamcleanup()
    {
        self endon("end_killcam");
        self endon("disconnect");
        level waittill("game_ended");
        self endkillcam(0);
    }

    ended_final_killcam_cleanup()
    {
        self endon("end_killcam");
        self endon("disconnect");
        level waittill("game_ended");
        self endkillcam(1);
    }

    cancelkillcamusebutton()
    {
        return self usebuttonpressed();
    }

    cancelkillcamsafespawnbutton()
    {
        return self fragbuttonpressed();
    }

    cancelkillcamcallback()
    {
        self.cancelkillcam = 1;
    }

    cancelkillcamsafespawncallback()
    {
        self.cancelkillcam = 1;
        self.wantsafespawn = 1;
    }

    cancelkillcamonuse()
    {
        self thread cancelkillcamonuse_specificbutton(::cancelkillcamusebutton, ::cancelkillcamcallback);
    }

    cancelkillcamonuse_specificbutton(pressingbuttonfunc, finishedfunc)
    {
        self endon("death_delay_finished");
        self endon("disconnect");
        level endon("game_ended");
        for(;;)
        {
            if (!self [[pressingbuttonfunc]]())
            {
                wait 0.05;
                continue;
            }
            buttontime = 0;
            while (self [[pressingbuttonfunc]]())
            {
                buttontime += 0.05;
                wait 0.05;
            }
            if (buttontime >= 0.5)
            {
                continue;
            }
            buttontime = 0;
            while (!(self [[pressingbuttonfunc]]()) && buttontime < 0.5)
            {
                buttontime += 0.05;
                wait 0.05;
            }
            if (buttontime >= 0.5)
            {
                continue;
            }
            else
            {
                self [[finishedfunc]]();
                return;
            }
            wait 0.05;
        }
    }

    final_killcam(winner)
    {
        self endon("disconnect");
        level endon("game_ended");

        attacker = level.finalkillcamsettings[winner].attacker;

        setmatchflag("final_killcam", 1);

        killcamsettings = level.finalkillcamsettings[winner];
        postdeathdelay = (getTime() - killcamsettings.deathtime) / 1000;
        predelay = postdeathdelay + killcamsettings.deathtimeoffset;
        camtime = attacker calc_time(killcamsettings.weapon, killcamsettings.entitystarttime, predelay, 0, undefined);
        postdelay = 2.5;
        killcamoffset = camtime + predelay;
        killcamlength = (camtime + postdelay) - 0.05;
        killcamstarttime = getTime() - (killcamoffset * 1000);
        self notify("begin_killcam", getTime());
        self.sessionstate = "spectator";
        self.spectatorclient = killcamsettings.spectatorclient;
        self.killcamentity = -1;

        if (killcamsettings.entityindex >= 0)
            self thread set_killcam_entity(killcamsettings.entityindex, killcamsettings.entitystarttime - killcamstarttime - 100);

        self.killcamtargetentity = killcamsettings.targetentityindex;
        self.archivetime = killcamoffset;
        self.killcamlength = killcamlength;
        self.psoffsettime = killcamsettings.offsettime;

        self overlay(true, attacker, true); // killcam overlay

        foreach(team in level.teams)
        {
            self allowspectateteam(team, 1);
        }
        self allowspectateteam("freelook", 1);
        self allowspectateteam("none", 1);

        self thread ended_final_killcam_cleanup();

        // wait till the next server frame to allow code a chance to update archivetime if it needs trimming
        wait 0.05;

        if (self.archivetime <= predelay) // if we're not looking back in time far enough to even see the death, cancel
        {
            self.sessionstate = "dead";
            self.spectatorclient = -1;
            self.killcamentity = -1;
            if (is_false(level.skip_game_end))
                self.archivetime = 0;
            self.psoffsettime = 0;
            self overlay(false);
            self notify("end_killcam");
            return;
        }

        self thread checkforabruptkillcamend();

        self.killcam = 1;

        self thread waitkillcamtime();
        self thread waitfinalkillcamslowdown(level.finalkillcamsettings[winner].deathtime, killcamstarttime);

        self waittill("end_killcam");
        self endkillcam(1);

        setmatchflag("final_killcam", 0);
        setmatchflag("round_end_killcam", 0);
    }

    calc_time(sweapon, entitystarttime, predelay, respawn, maxtime)
    {
        camtime = self.killcam_length;
        if (isdefined(maxtime))
        {
            if (camtime > maxtime)
            {
                camtime = maxtime;
            }
            if (camtime < 0.05)
            {
                camtime = 0.05;
            }
        }
        return camtime;
    }

    // thanks to birchy for this :)
    overlay(on, attacker, final)
    {
        if (on)
        {
            name = attacker get_the_player_name();
            tag = "";
            prefix = -1;
            postfix = -1;
            color = (1,0,0);

            for(i = 0; i < attacker.name.size; i++)
            {
                if (attacker.name[i] == "[" && prefix == -1)
                {
                    prefix = i;
                }
                else if (attacker.name[i] == "]" && postfix == -1)
                {
                    postfix = i;
                }
            }

            if (prefix != -1 && postfix != -1)
            {
                tag = getsubstr(attacker.name, prefix, postfix + 1);
                name = getsubstr(attacker.name, postfix + 1);
            }
            if (final)
            {
                color = (0,0,0);
            }

            self.hud = [];
            self.hud[0] = self draw_shader("CENTER", "CENTER", 0, -200, "white", 854, 80, color, 0.2, 1); //top bar
            self.hud[1] = self draw_shader("CENTER", "CENTER", 0, 200, "white", 854, 80, color, 0.2, 1); //bot bar
            self.hud[2] = self draw_shader("CENTER", "CENTER", 0, 180, "emblem_bg_default", 160, 40, (1, 1, 1), 0.9, 2); //calling card
            self.hud[3] = self draw_shader("CENTER", "CENTER", 5, 188, attacker.killcam_rank, 16, 16, (1, 1, 1), 1, 3); //player rank
            self.hud[4] = self draw_text_2(name, "LEFT", "CENTER", -44, 171, 1.20, "default", (1,1,1), 1, 3); //player name
            self.hud[5] = self draw_text_2(killcam_type(final), "CENTER", "CENTER", 0, -180, 3.25, "default", (1,1,1), 0.9, 3); //top text
            for(i = 0; i < self.hud.size; i++)
            {
                self.hud[i].foreground = true;
                self.hud[i].hidewhendead = false;
                self.hud[i].hidewheninkillcam = false;
                self.hud[i].archived = false;
            }
        }
        else
        {
            foreach(hud in self.hud)
            {
                hud destroy();
            }
        }
    }

    killcam_type(final)
    {
        if (level.round_based)
            return "ROUND ENDING KILLCAM";

        return "FINAL KILLCAM";
    }

    changerank(index, custom)
    {
        if (!isdefined(custom))
            custom = false;

        if (is_false(custom))
        {
            if (!isdefined(index)) // random
            {
                rankindex = randomintrange(0, 5);
                self.killcam_rank = "zombies_rank_" + rankindex;
                self iprintln("killcam rank set to random rank ^1" + rankindex);
            }
            else // index specified
            {
                self.killcam_rank = "zombies_rank_" + index;
                self iprintln("killcam rank set to rank ^1" + index);
            }
        }
        else if (is_true(custom))
        {
            self.killcam_rank = index;
            self iprintln("killcam rank set to rank ^1" + index);
        }
    }

    changekctime(time, is_default)
    {
        if (is_true(is_default))
        {
            self.killcam_length = 5;
            self iprintln("killcam length set to ^15 ^7seconds (^2default^7)");
            return;
        }

        newtime = self.killcam_length + time; // new killcam time
        if (newtime < 5) // disable killcam time going below 5 seconds
        {
            self iprintln("cannot set killcam length below 5 seconds.");
            return;
        }

        self iprintln("killcam length set to ^1" + newtime + " ^7seconds");

        players = getplayers();
        foreach(player in players)
        {
            if (!isdefined(player))
                continue;

            if (self != player)
                player iprintln(self.name + " changed their killcam length to ^1" + newtime + " ^7seconds");
        }
        self.killcam_length = newtime;
    }

    #endif