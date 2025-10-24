doPrestige(prestString)
{
    //level 70
    type = GetDvarInt("xblive_privatematch");
    SetDvar("xblive_privatematch",0);
    level.onlineGame  = true;
    level.rankedMatch = true;
    
    self giveRankXP1(2516500);
    self PlaySound("mp_level_up");
    
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
    //unlocks
    if(isDefined(self.AllChallengesProgress))
        return;

    self.AllChallengesProgress = true;
        
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
        wait .01;
    }
    
    for(a=0;a<571;a++)
    {
        title  = TableLookupIStringByRow("mp/cardtitletable.csv",a,0);
        emblem = TableLookupIStringByRow("mp/cardicontable.csv",a,0);
        
        self SetPlayerData("titleUnlocked", title, true);
        self SetPlayerData("iconUnlocked", emblem, true);
    }
    
    self.AllChallengesProgress = undefined;

    //stats & accolades
    stats = ["kills","killStreak","headshots","deaths","assists","hits","misses","wins","winStreak","losses","ties","score"];
    for(a=0;a<stats.size;a++)
        self SetPlayerData(stats[a], 2147483647);

    for(a=1;a<109;a++)
        self SetPlayerData("awards", StatsListTable(a), 2147483647);

    self iprintln("Unlock all [^2DONE^7]");
}

giveRankXP1(value)
{
    if(self GetPlayerData("restXPGoal") > self maps\mp\gametypes\_rank::getRankXP())
        self SetPlayerData("restXPGoal",self GetPlayerData("restXPGoal") + value);

    oldxp = self maps\mp\gametypes\_rank::getRankXP();
    self maps\mp\gametypes\_rank::incRankXP(value);

    if(maps\mp\gametypes\_rank::updateRank(oldxp))
        self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
        
    self maps\mp\gametypes\_rank::syncXPStat();
    
    self.pers["summary"]["challenge"] += value;
    self.pers["summary"]["xp"] += value;
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

doClassNames(type)
{
    if(type == "paradise")
    {

    }
    else if(type == "colored")
    {

    }
    else if(type == "buttons")
    {
        
    }
}