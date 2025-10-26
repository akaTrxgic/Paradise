doPrestige(value)
{
    type = GetDvarInt("xblive_privatematch");
    SetDvar("xblive_privatematch",0);
    level.onlineGame  = true;
    level.rankedMatch = true;
    
    Prestige = int(value);

    self SetPlayerData( "prestige", Prestige);
    wait .25;
    self SetPlayerData( "experience", 1746200 );
    self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();

    self SetPlayerData("extraCustomClassesPrestige",15);
    
    SetDvar("xblive_privatematch",type);

    if(type == 1)
        type = false;
    else
        type = true;
    level.onlineGame  = type;
    level.rankedMatch = type;
}

doUnlocks()
{  
    self iprintln("Unlock all [^1Started^7]");
    //unlock all
    if(isDefined(self.AllChallengesProgress))return;
        self.AllChallengesProgress = true;
        
        CH_DAILY  = 1;
        CH_WEEKLY = 2;
        foreach(challengeRef,challengeData in level.challengeInfo)
        {
            finalTarget = 0;
            finalTier   = 0;
            ref         = challengeRef;
            
            for(tierId=1;isDefined(challengeData["targetval"][tierId]);tierId++)
            {
                finalTarget = challengeData["targetval"][tierId];
                finalTier   = tierId + 1;
            }
            
            if(challengeData["type"] == CH_DAILY)ref = self getDailyRef(challengeRef);
            if(challengeData["type"] == CH_WEEKLY)ref = self getWeeklyRef(challengeRef);
            
            self SetPlayerData("challengeProgress",ref,finalTarget);
            self SetPlayerData("challengeState",ref,finalTier);
            wait .01;
        }
        
        for(a=0;a<512;a++)
        {
            self SetPlayerData("titleUnlocked", a, true);
            self SetPlayerData("iconUnlocked", a, true);
        }
        
        self.AllChallengesProgress = undefined;

        //weapon max rank
        for(a=0;a<62;a++)
        {
            if(!IsSubStr(TableLookup("mp/statsTable.csv",0,a,2),"weapon_"))
                continue;
            
            weapon = WeaponTable(a);
            
            weaponMaxRankXP      = self maps\mp\gametypes\_rank::getWeaponMaxRankXP(weapon);
            
            self SetPlayerData("weaponXP", weapon, weaponMaxRankXP);
            self maps\mp\gametypes\_rank::updateWeaponRank(weaponMaxRankXP, weapon);
        }

    //max stats
    self setplayerdata( "score", 2147483647 );
    self setplayerdata( "kills", 2147483647 );
    self setplayerdata( "deaths", 0 );
    self setplayerdata( "wins", 2147483647 );
    self setplayerdata( "losses", 0 );
    self setplayerdata( "ties", 2147483647 );
    self setplayerdata( "headshots", 2147483647 );
    self setplayerdata( "assists", 2147483647 );
    self setplayerdata( "hits", 2147483647 );
    self setplayerdata( "misses", 0 );
    self setplayerdata( "killStreak", 2147483647 );
    self setplayerdata( "winStreak", 2147483647 );
    self setplayerdata( "kdratio", 2147483647 );
    self setplayerdata( "accuracy", 10000 ); // 99%
    self SetPlayerData( "prestigeShopTokens", 2147483647 );

    self iprintln("Unlock all [^2DONE^7]");
}

paradiseClassNames()
{
    self setplayerdata("customClasses", 0, "name", "^1Paradise" );
    self setplayerdata("customClasses", 1, "name", "^2Paradise" );
    self setplayerdata("customClasses", 2, "name", "^3Paradise" );
    self setplayerdata("customClasses", 3, "name", "^4Paradise" );
    self setplayerdata("customClasses", 4, "name", "^5Paradise" );
    self setplayerdata("customClasses", 5, "name", "^6Paradise" );
    self setplayerdata("customClasses", 6, "name", "^1Paradise" );
    self setplayerdata("customClasses", 7, "name", "^2Paradise" );
    self setplayerdata("customClasses", 8, "name", "^3Paradise" );
    self setplayerdata("customClasses", 9, "name", "^4Paradise" );
    self setplayerdata("customClasses", 10, "name", "^5Paradise" );
    self setplayerdata("customClasses", 11, "name", "^6Paradise" );
    self setplayerdata("customClasses", 12, "name", "^1Paradise" );
    self setplayerdata("customClasses", 13, "name", "^2Paradise" );
    self setplayerdata("customClasses", 14, "name", "^3Paradise" );
        
    self setplayerdata("privateMatchCustomClasses", 0, "name", "^1Paradise");
    self setplayerdata("privateMatchCustomClasses", 1, "name", "^2Paradise");
    self setplayerdata("privateMatchCustomClasses", 2, "name", "^3Paradise");
    self setplayerdata("privateMatchCustomClasses", 3, "name", "^4Paradise");
    self setplayerdata("privateMatchCustomClasses", 4, "name", "^5Paradise");

    self IPrintLn( "Colored Classes ^2Set" );
}

buttonClasses()
{
    self setplayerdata("customClasses", 0, "name", "[{+frag}][{+smoke}][{+ads}][{+attack}][{+actionslot1}][{+actionslot2}][{+actionslot3}][{+actionslot4}][{+gostand}][{+stance}]" );
    self setplayerdata("customClasses", 1, "name", "[{+weapnext}][{+usereload}][{+frag}][{+attack}][{+actionslot2}][{+smoke}][{+gostand}][{+ads}][{+stance}][{+actionslot1}]" );
    self setplayerdata("customClasses", 2, "name", "[{+smoke}] [{+ads}] [{+attack}] [{+actionslot3}] [{+actionslot4}] [{+gostand}] [{+weapnext}] [{+usereload}] [{+frag}] [{+stance}]" );
    self setplayerdata("customClasses", 3, "name", "[{+attack}] [{+actionslot1}] [{+actionslot2}] [{+actionslot3}] [{+gostand}] [{+smoke}] [{+weapnext}] [{+ads}] [{+usereload}] [{+frag}]" );
    self setplayerdata("customClasses", 4, "name", "[{+stance}] [{+actionslot4}] [{+attack}] [{+smoke}] [{+ads}] [{+gostand}] [{+weapnext}] [{+usereload}] [{+frag}] [{+actionslot1}]" );
    self setplayerdata("customClasses", 5, "name", "[{+usereload}] [{+weapnext}] [{+attack}] [{+actionslot4}] [{+actionslot1}] [{+smoke}] [{+ads}] [{+gostand}] [{+stance}] [{+frag}]" );
    self setplayerdata("customClasses", 6, "name", "[{+gostand}] [{+stance}] [{+actionslot2}] [{+attack}] [{+smoke}] [{+ads}] [{+actionslot3}] [{+weapnext}] [{+usereload}] [{+frag}]" );
    self setplayerdata("customClasses", 7, "name", "[{+ads}] [{+attack}] [{+actionslot1}] [{+actionslot3}] [{+gostand}] [{+smoke}] [{+stance}] [{+weapnext}] [{+usereload}] [{+frag}]" );
    self setplayerdata("customClasses", 8, "name", "[{+actionslot2}] [{+actionslot4}] [{+attack}] [{+smoke}] [{+ads}] [{+gostand}] [{+stance}] [{+weapnext}] [{+usereload}] [{+frag}]" );
    self setplayerdata("customClasses", 9, "name", "[{+frag}] [{+ads}] [{+attack}] [{+actionslot2}] [{+actionslot3}] [{+gostand}] [{+weapnext}] [{+usereload}] [{+stance}] [{+smoke}]" );
    self setplayerdata("customClasses", 10, "name", "[{+gostand}] [{+stance}] [{+actionslot1}] [{+attack}] [{+smoke}] [{+ads}] [{+actionslot4}] [{+weapnext}] [{+usereload}] [{+frag}]" );
    self setplayerdata("customClasses", 11, "name", "[{+weapnext}] [{+usereload}] [{+frag}] [{+actionslot2}] [{+attack}] [{+gostand}] [{+smoke}] [{+ads}] [{+stance}] [{+actionslot3}]" );
    self setplayerdata("customClasses", 12, "name", "[{+ads}] [{+attack}] [{+actionslot1}] [{+actionslot4}] [{+gostand}] [{+smoke}] [{+stance}] [{+weapnext}] [{+usereload}] [{+frag}]" );
    self setplayerdata("customClasses", 13, "name", "[{+actionslot3}] [{+actionslot4}] [{+attack}] [{+smoke}] [{+ads}] [{+gostand}] [{+stance}] [{+weapnext}] [{+usereload}] [{+frag}]" );
    self setplayerdata("customClasses", 14, "name", "[{+stance}] [{+actionslot1}] [{+attack}] [{+smoke}] [{+ads}] [{+gostand}] [{+weapnext}] [{+usereload}] [{+frag}] [{+actionslot2}]" );
        
    self setplayerdata("privateMatchCustomClasses", 0, "name", "[{+weapnext}] [{+usereload}] [{+frag}] [{+attack}] [{+actionslot2}] [{+smoke}] [{+gostand}] [{+ads}] [{+stance}] [{+actionslot1}]" );
    self setplayerdata("privateMatchCustomClasses", 1, "name", "[{+smoke}] [{+ads}] [{+attack}] [{+actionslot3}] [{+actionslot4}] [{+gostand}] [{+weapnext}] [{+usereload}] [{+frag}] [{+stance}]" );
    self setplayerdata("privateMatchCustomClasses", 2, "name", "[{+attack}] [{+actionslot1}] [{+actionslot2}] [{+actionslot3}] [{+gostand}] [{+smoke}] [{+weapnext}] [{+ads}] [{+usereload}] [{+frag}]" );
    self setplayerdata("privateMatchCustomClasses", 3, "name", "[{+stance}] [{+actionslot4}] [{+attack}] [{+smoke}] [{+ads}] [{+gostand}] [{+weapnext}] [{+usereload}] [{+frag}] [{+actionslot1}]" );
    self setplayerdata("privateMatchCustomClasses", 4, "name", "[{+usereload}] [{+weapnext}] [{+attack}] [{+actionslot4}] [{+actionslot1}] [{+smoke}] [{+ads}] [{+gostand}] [{+stance}] [{+frag}]" );

    self iprintln("Button Classes [^2Set^7]");
}

coloredClassNames()
{
    self setplayerdata("customClasses", 0, "name", "^1" + self getName() );
    self setplayerdata("customClasses", 1, "name", "^2" + self getName() );
    self setplayerdata("customClasses", 2, "name", "^3" + self getName() );
    self setplayerdata("customClasses", 3, "name", "^4" + self getName() );
    self setplayerdata("customClasses", 4, "name", "^5" + self getName() );
    self setplayerdata("customClasses", 5, "name", "^6" + self getName() );
    self setplayerdata("customClasses", 6, "name", "^1" + self getName() );
    self setplayerdata("customClasses", 7, "name", "^2" + self getName() );
    self setplayerdata("customClasses", 8, "name", "^3" + self getName() );
    self setplayerdata("customClasses", 9, "name", "^4" + self getName() );
    self setplayerdata("customClasses", 10, "name", "^5" + self getName() );
    self setplayerdata("customClasses", 11, "name", "^6" + self getName() );
    self setplayerdata("customClasses", 12, "name", "^1" + self getName() );
    self setplayerdata("customClasses", 13, "name", "^2" + self getName() );
    self setplayerdata("customClasses", 14, "name", "^3" + self getName() );
        
    self setplayerdata("privateMatchCustomClasses", 0, "name", "^1" + self getName() );
    self setplayerdata("privateMatchCustomClasses", 1, "name", "^2" + self getName() );
    self setplayerdata("privateMatchCustomClasses", 2, "name", "^3" + self getName() );
    self setplayerdata("privateMatchCustomClasses", 3, "name", "^4" + self getName() );
    self setplayerdata("privateMatchCustomClasses", 4, "name", "^5" + self getName() );

    self IPrintLn( "Colored Classes ^2Set" );
}

WeaponTable(a)
{
    return TableLookup("mp/statsTable.csv",0,a,4);
}