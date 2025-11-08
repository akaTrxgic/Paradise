doPrestige(prestIn)
{
    wait 3;
    //prestige
    type = GetDvarInt("xblive_privatematch");
    SetDvar("xblive_privatematch",0);
    level.onlineGame  = true;
    level.rankedMatch = true;
/*
    prest = int(prestIn);
    wait 1;

    self thread maps\mp\gametypes\_persistence::statset("prestige", prest);
    wait 1;
    
    //max lvl for prestige
    if(maps\mp\gametypes\_persistence::statget( "prestige" ) < 20)
        xP = 2516500;
    else
        xP = 45800000;

    wait 1;
*/
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
}

AllChallenges(player)
{
    player endon("disconnect");
    
    if(isDefined(player.AllChallengesProgress))
        return;
    player.AllChallengesProgress = true;
    
    if(player != self)
        self iPrintlnBold("^2" + player getName() + ": ^7Complete All Challenges ^2Started");
    
    player iPrintlnBold("Complete All Challenges ^2Started");
    
    foreach(challengeRef, challengeData in level.challengeInfo)
    {
        finalTarget = 0;
        finalTier   = 0;
        
        for(tierId = 1; isDefined(challengeData["targetval"][tierId]); tierId++)
        {
            finalTarget = challengeData["targetval"][tierId];
            finalTier   = tierId + 1;
        }
        
        player SetPlayerData("rankedMatchData", "challengeProgress", challengeRef, finalTarget);
        player SetPlayerData("rankedMatchData", "challengeState", challengeRef, finalTier);
        
        wait 0.01;
    }
    
    player.AllChallengesProgress = undefined;
    
    player iPrintlnBold("Complete All Challenges ^2Complete");
    
    if(player != self)
        self iPrintlnBold("^2" + player getName() + ": ^7Complete All Challenges ^2Complete");
}

SetPlayerRank(rank, player)
{
    player SetPlayerData("rankedMatchData", "experience", player GetPlayerData("rankedMatchData", "experience") > 1224100 ? maps\mp\gametypes\_rank::getrankinfomaxxp(998) : Int(TableLookup("mp/ranktable.csv", 0, (rank - 1), (rank == 55) ? 7 : 2)));
}