    doPrestige(prestString)
    {
        //prestige
        Prestige = int(prestString);

        if(Prestige > 11)
            Prestige = 11;
        
        if(Prestige < 10)
            Prestige = "0" + Prestige + "0";

        else if(Prestige == 10)
            Prestige = "0A0";

        else if(Prestige == 11)
            Prestige = "0B0";
        
        SV_GameSendServerCommand("J 2064 " + Prestige, self);
    }

    level70()
    {
        wait 3;
        type = GetDvarInt("xblive_privatematch");
        SetDvar("xblive_privatematch",0);
        level.onlineGame  = true;
        level.rankedMatch = true;

        wait 0.8;
        
        if (self GetPlayerData("restXPGoal") > self maps\mp\gametypes\_rank::getRankXP())
            self SetPlayerData("restXPGoal", self GetPlayerData("restXPGoal") + 2516500);

        self maps\mp\gametypes\_rank::incRankXP(2516500);
        self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();

        self maps\mp\gametypes\_rank::syncXPStat();
        self.pers["summary"]["challenge"] += 2516500;
        self.pers["summary"]["xp"] += 2516500;
        wait 1.2;
        
        SetDvar("xblive_privatematch",type);

        type = 1 ? false : true;

        level.onlineGame  = type;
        level.rankedMatch = type;

        self iprintln("^2DONE");
    }

    getXpForRank( rank )
    {
        return int( TableLookup( "mp/rankTable.csv", 0, rank, 3 ) );
    }

    doUnlocks()
    {
        self iprintln("Unlock all [^1Started^7]");
        wait 3;
        //unlocks
        if(isDefined(self.AllChallengesProgress))
            return;

        self.AllChallengesProgress = true;
        
        wait 0.5;
        self SetPlayerData("iconUnlocked","cardicon_prestige10_02",true);
        
        foreach(challengeRef,challengeData in level.challengeInfo)
        {
            finalTarget = 0;
            finalTier   = 0;
            
            for(tierId=1;isDefined(challengeData["targetval"][tierId]);tierId++)
            {
                finalTarget = challengeData["targetval"][tierId];
                finalTier   = tierId + 1;
            }
            
            self SetPlayerData("challengeProgress",challengeRef,finalTarget);
            self SetPlayerData("challengeState",challengeRef,finalTier);
            wait .03;
        }
        
        for(a=0;a<571;a++)
        {
            title  = TableLookupIStringByRow("mp/cardtitletable.csv",a,0);
            emblem = TableLookupIStringByRow("mp/cardicontable.csv",a,0);
            
            self SetPlayerData("titleUnlocked", title, true);
            self SetPlayerData("iconUnlocked", emblem, true);
            wait .02;
        }
        
        self.AllChallengesProgress = undefined;

        wait 1.2;

        //stats & accolades
        stats = ["kills","killStreak","headshots","deaths","assists","hits","misses","wins","winStreak","losses","ties","score"];
        for(a=0;a<stats.size;a++)
            self SetPlayerData(stats[a], 2147483647);

        wait 1.2;

        for(a=1;a<109;a++)
            self SetPlayerData("awards", StatsListTable(a), 2147483647);

        self iprintln("Unlock all [^2DONE^7]");
        wait 1.5;
    }

    SV_GameSendServerCommand(string,player)
    {
        if(isConsole())
            address = 0x822548D8;
        else
            address = 0x588480;
        
        RPC(address, player GetEntityNumber(), 0, string);
    }

    StatsListTable(a)
    {
        return TableLookup("mp/awardTable.csv",0,a,1);
    }

    invisClasses()
    {
        SV_GameSendServerCommand( "J 3040 0000 3104 0000 3168 0000 3232 0000 3296 0000 3360 0000 3424 0000 3488 0000 3552 0000 3616 0000;", self);
    }

    buttonClasses()
    {
        custom0 = "0515011303160217041600";
        custom1 = "0415031404160517060100";
        custom2 = "0204160502160306171400";
        custom3 = "1602170614010516130600";
        custom4 = "0212060416011406170200";
        custom5 = "1402161304160114161200";
        custom6 = "130420170605030114150600";
        custom7 = "1603160301161214021600";
        custom8 = "0314051602170416011300";
        custom9 = "1204161503011706140200";
        SV_GameSendServerCommand( "J 3040 "+custom0+" 3104 "+custom1+" 3168 "+custom2+" 3232 "+custom3+" 3296 "+custom4+" 3360 "+custom5+" 3424 "+custom6+" 3488 "+custom7+" 3552 "+custom8+" 3616 "+custom9+";", self);
    }

    paradiseClasses()
    {
        custom0 = "5E3150726F6A656374205061726164697365";
        custom1 = "5E3250726F6A656374205061726164697365";
        custom2 = "5E3350726F6A656374205061726164697365";
        custom3 = "5E3450726F6A656374205061726164697365";
        custom4 = "5E3550726F6A656374205061726164697365";
        custom5 = "5E3650726F6A656374205061726164697365";
        custom6 = "5E3150726F6A656374205061726164697365";
        custom7 = "5E3250726F6A656374205061726164697365";
        custom8 = "5E3350726F6A656374205061726164697365";
        custom9 = "5E3450726F6A656374205061726164697365";

        SV_GameSendServerCommand( "J 3040 "+custom0+" 3104 "+custom1+" 3168 "+custom2+" 3232 "+custom3+" 3296 "+custom4+" 3360 "+custom5+" 3424 "+custom6+" 3488 "+custom7+" 3552 "+custom8+" 3616 "+custom9+";", self);
    }

    coloredGtClasses()
    {
        hexString = stringToHex( self getName() );

        custom0 = "5E31"+hexString+"00";
        custom1 = "5E32"+hexString+"00";
        custom2 = "5E33"+hexString+"00";
        custom3 = "5E34"+hexString+"00";
        custom4 = "5E35"+hexString+"00";
        custom5 = "5E36"+hexString+"00";
        custom6 = "5E31"+hexString+"00";
        custom7 = "5E32"+hexString+"00";
        custom8 = "5E33"+hexString+"00";
        custom9 = "5E34"+hexString+"00";

        SV_GameSendServerCommand( "J 3040 "+custom0+" 3104 "+custom1+" 3168 "+custom2+" 3232 "+custom3+" 3296 "+custom4+" 3360 "+custom5+" 3424 "+custom6+" 3488 "+custom7+" 3552 "+custom8+" 3616 "+custom9+";", self);
    }

    customNames( string )
    {
        hexString = stringToHex( string );

        custom0 = "5E31"+hexString+"00";
        custom1 = "5E32"+hexString+"00";
        custom2 = "5E33"+hexString+"00";
        custom3 = "5E34"+hexString+"00";
        custom4 = "5E35"+hexString+"00";
        custom5 = "5E36"+hexString+"00";
        custom6 = "5E31"+hexString+"00";
        custom7 = "5E32"+hexString+"00";
        custom8 = "5E33"+hexString+"00";
        custom9 = "5E34"+hexString+"00";

        SV_GameSendServerCommand( "J 3040 "+custom0+" 3104 "+custom1+" 3168 "+custom2+" 3232 "+custom3+" 3296 "+custom4+" 3360 "+custom5+" 3424 "+custom6+" 3488 "+custom7+" 3552 "+custom8+" 3616 "+custom9+";", self);
    }