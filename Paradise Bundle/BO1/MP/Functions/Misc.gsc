//Killstreaks
doKillstreak(killstreak)
{
    self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    self iprintln("Given ^2" + killstreak);
}

//Bots
spawnEnemyBot() 
{
    team = self.pers["team"];
    bot = addtestclient();
    bot.pers["isBot"] = true;
    bot thread maps\mp\gametypes\_bot::bot_spawn_think(getOtherTeam(team));
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