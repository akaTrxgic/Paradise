    CompleteChallenges()
    {
        #ifdef ZM
            merits = GetArrayKeys(level.var_B684);
            
            if(!isDefined(merits) || !merits.size)
                return;
            
            foreach(merit in merits)
            {
                targetVal       = level.var_B684[merit]["targetval"];
                currentState    = self GetPlayerData("cp", "meritState", merit);
                currentProgress = self GetPlayerData("cp", "meritProgress", merit);
                
                if(!isDefined(targetVal))
                    continue;
                
                if(currentState < targetVal.size || currentProgress < targetVal[(targetVal.size - 1)])
                {
                    if(currentProgress < targetVal[(targetVal.size - 1)])
                        self SetPlayerData("cp", "meritProgress", merit, targetVal[(targetVal.size - 1)]);
                    
                    if(currentState < targetVal.size)
                        self SetPlayerData("cp", "meritState", merit, targetVal.size);
                    
                    wait 0.01;
                }
            }
        #endif
        
        #ifdef MP
            challenges = GetArrayKeys(level.var_3C2C);
            
            if(!isDefined(challenges) || !challenges.size)
                return;
            
            foreach(challenge in challenges)
            {
                targetVal       = level.var_3C2C[challenge]["targetval"];
                currentState    = self GetPlayerData("mp", "challengeState", challenge);
                currentProgress = self GetPlayerData("mp", "challengeProgress", challenge);
                
                if(!isDefined(targetVal))
                    continue;
                
                if(currentState < targetVal.size || currentProgress < targetVal[(targetVal.size - 1)])
                {
                    if(currentProgress < targetVal[(targetVal.size - 1)])
                        self SetPlayerData("mp", "challengeProgress", challenge, targetVal[(targetVal.size - 1)]);
                    
                    if(currentState < targetVal.size)
                        self SetPlayerData("mp", "challengeState", challenge, targetVal.size);
                    
                    wait 0.01;
                }
            }
        #endif
    }

    CompleteActiveContracts()
    {
        contracts = GetArrayKeys(self.contracts);
        
        if(!isDefined(contracts) || !contracts.size)
            return;
        
        foreach(contract in contracts)
        {
            target = self.contracts[contract].target;
            
            #ifdef ZM
                mode = "cp";
            #endif
            
            #ifdef MP
                mode = "mp";
            #endif
            
            progress = self GetPlayerData(mode, "contracts", "challenges", contract, "progress");
            
            if(!isDefined(progress) || !isDefined(target) || progress >= target)
                continue;
            
            self SetPlayerData(mode, "contracts", "challenges", contract, "progress", target);
            self SetPlayerData(mode, "contracts", "challenges", contract, "completed", 1);
            
            wait 0.01;
        }
    }

    SetPlayerRank(rank)
    {
        rank = (rank - 1);
        
        #ifdef ZM
            mode  = "cp";
            table = "cp/zombies/rankTable.csv";
        #endif
        
        #ifdef MP
            mode  = "mp";
            table = "mp/rankTable.csv";
        #endif
        
        self SetPlayerData(mode, "progression", "playerLevel", "xp", Int(TableLookup(table, 0, rank, (rank == Int(TableLookup(table, 0, "maxrank", 1))) ? 7 : 2)));
    }

    SetPlayerPrestige(prestige)
    {
        #ifdef ZM
            mode = "cp";
        #endif
        
        #ifdef MP
            mode = "mp";
        #endif
        
        self SetPlayerData(mode, "progression", "playerLevel", "prestige", prestige);
    }

    SetPlayerMaxWeaponRanks()
    {
        for(a = 1; a < 62; a++)
        {
            weapon = TableLookup("mp/statstable.csv", 0, a, 4);
            
            if(!isDefined(weapon) || weapon == "")
                continue;
            
            #ifdef ZM
                mode = "cpXP";
            #endif
            
            #ifdef MP
                mode = "mpXP";
            #endif
            
            self SetPlayerData("common", "sharedProgression", "weaponLevel", weapon, mode, 54300);
            self SetPlayerData("common", "sharedProgression", "weaponLevel", weapon, "prestige", 3);
            
            wait 0.01;
        }
    }

    UnlockAllAchievements()
    {
        achievements = ["EUROPA", "PEARL", "MOON", "TITAN", "ROGUE", "HEIST", "YARD", "VETERAN", "SA_VIP", "SA_EMP", "SA_WOUNDED", "SA_ASSASSINATION", "ALL_SA", "JA_STATION", "JA_ASTEROID", "JA_WRECKAGE", "JA_TITAN", "JA_MINING", "ALL_JA", "SCAN_1_WEAPON", "SCAN_10_WEAPONS", "SCAN_ALL_WEAPONS", "FIND_MP_GUN", "CHANGE_LOADOUT", "FIRST_EQUIP_UPGRADE", "ALL_EQUIP_UPGRADES", "FIRST_JACKAL_ITEM", "ALL_JACKAL_ITEMS", "FIRST_WANTED_BOARD", "HALF_WANTED_BOARD", "ALL_WANTED_BOARD", "15_ZERO_G", "KILL_KOTCH", "CAPT_COMPUTER", "NEWSCAST", "NO_JUMPING", "DOOR_PEEK", "ANTI_GRAV_KILL", "KILL_C12S", "STICKER_COLLECTOR", "SOUL_KEY", "THE_BIGGER_THEY_ARE", "HOFF_THE_CHARTS", "ROCK_ON", "GET_PACKED", "BATTERIES_NOT_INCLUDED", "I_LOVE_THE_80_S", "INSERT_COIN", "BRAIN_DEAD", "DOMINION", "LOCKSMITH", "SUPER_SLACKER", "STICK_EM", "HALLUCINATION_NATION", "TABLES_TURNED", "RAVE_ON", "RIDE_FOR_YOUR_LIFE", "SCRAPBOOKING", "PUMP_IT_UP", "TOP_CAMPER", "BOOK_WORM", "COIN_OP", "BEAT_OF_THE_DRUM", "SLICED_AND_DICED", "PEST_CONTROL", "EXTERMINATOR", "SHAOLIN_SKILLS", "MESSAGE_RECEIVED", "SOUL_BROTHER", "SOME_ASSEMBLY_REQUIRED", "SOUL_LESS", "UNPLEASANT_DREAMS", "MISTRESS_OF_DARK", "QUARTER_MUNCHER", "BAIT_AND_SWITCH", "BELLY_OF_BEAST", "MAD_PROTO", "DEAR_DIARY", "BROKEN_RECORD", "CRACKING_SKULLS", "DOUBLE_FEATURE", "EGG_SLAYER", "ENCRYPT_DECRYPT", "FAILED_MAINTENANCE", "FRIENDS_FOREVER", "MESSAGE_SENT", "SUPER_DUPER_COMBO", "THE_END"];
        
        foreach(achievement in achievements)
            self GiveAchievement(achievement);
    }