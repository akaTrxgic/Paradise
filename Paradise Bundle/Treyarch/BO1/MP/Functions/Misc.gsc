//Killstreaks
doKillstreak(killstreak)
{
    self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    self iprintln("Given ^2" + killstreak);
}

//Bots
spawnEnemyBot(num, team) 
{
    if(!isdefined(num))
        num = 1;

    if(!isDefined(team))
        team = self.pers["team"];
    
    bot = [];

    for(i=0;i<num;i++)
    {
        bot[i] = addtestclient();
        if(!isDefined(bot[i]))
        {
            wait 1.5;
            continue;
        }
        bot[i].pers["isBot"] = true;
        bot[i] thread maps\mp\gametypes\_bot::bot_spawn_think(getOtherTeam(team));
        wait .75;
    }
}

fillLobby()
{
    level.i = 0;

    while (level.i < 18) 
    {
        wait .125;
        spawnEnemyBot();
        level.i++;
        wait 0.5;
    }
    self iprintln("Lobby ^1filled");
}