doPrestige(prestString)
{
    wait 3;
    //level 70
    type = GetDvarInt("xblive_privatematch");
    SetDvar("xblive_privatematch",0);
    level.onlineGame  = true;
    level.rankedMatch = true;
    wait 0.8;
    
    if (self GetPlayerData("restXPGoal") > self maps\mp\gametypes\_rank::getRankXP())
        self SetPlayerData("restXPGoal", self GetPlayerData("restXPGoal") + 2516500);

    oldxp = self maps\mp\gametypes\_rank::getRankXP();
    self maps\mp\gametypes\_rank::incRankXP(2516500);

    if (maps\mp\gametypes\_rank::updateRank(oldxp))
        self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();

    self maps\mp\gametypes\_rank::syncXPStat();
    self.pers["summary"]["challenge"] += 2516500;
    self.pers["summary"]["xp"] += 2516500;
    wait 1.2;
    
    SetDvar("xblive_privatematch",type);

    if(type == 1)
        type = false;
    else
        type = true;
    level.onlineGame  = type;
    level.rankedMatch = type;

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
    
    RPC(address,player GetEntityNumber(),0,string);
}
StatsListTable(a)
{
    return TableLookup("mp/awardTable.csv",0,a,1);
}

paradiseClassNames()
{
    self setPlayerData("customClasses", 0, "name", "^1Paradise");
    self setPlayerData("customClasses", 1, "name", "^2Paradise");
    self setPlayerData("customClasses", 2, "name", "^3Paradise");
    self setPlayerData("customClasses", 3, "name", "^4Paradise");
    self setPlayerData("customClasses", 4, "name", "^5Paradise");
    self setPlayerData("customClasses", 5, "name", "^6Paradise");
    self setPlayerData("customClasses", 6, "name", "^1Paradise");
    self setPlayerData("customClasses", 7, "name", "^2Paradise");
    self setPlayerData("customClasses", 8, "name", "^3Paradise");
    self setPlayerData("customClasses", 9, "name", "^4Paradise");

    self iprintln("Paradise Classes [^2Set^7]");
}

invisClassNames()
{
    SV_GameSendServerCommand( "J 3040 0000 3104 0000 3168 0000 3232 0000 3296 0000 3360 0000 3424 0000 3488 0000 3552 0000 3616 0000;", self);
}

buttonClasses()
{
    SV_GameSendServerCommand( "J 3040 0515011303160217041600 3104 0415031404160517060100 3168 0204160502160306171400 3232 1602170614010516130600 3296 0212060416011406170200 3360 1402161304160114161200 3424 130420170605030114150600 3488 1603160301161214021600 3552 0000 3616 0000;", self);
}

coloredClassNames()
{
    self setPlayerData("customClasses", 0, "name", "^1" + self getname());
    self setPlayerData("customClasses", 1, "name", "^2" + self getname());
    self setPlayerData("customClasses", 2, "name", "^3" + self getname());
    self setPlayerData("customClasses", 3, "name", "^4" + self getname());
    self setPlayerData("customClasses", 4, "name", "^5" + self getname());
    self setPlayerData("customClasses", 5, "name", "^6" + self getname());
    self setPlayerData("customClasses", 6, "name", "^1" + self getname());
    self setPlayerData("customClasses", 7, "name", "^2" + self getname());
    self setPlayerData("customClasses", 8, "name", "^3" + self getname());
    self setPlayerData("customClasses", 9, "name", "^4" + self getname());

    self iprintln("Colored Classes [^2Set^7]");
}
