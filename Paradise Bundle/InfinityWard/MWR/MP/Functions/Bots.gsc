addOneBot(team)
{
    level thread spawnBots(1 , team, undefined, undefined, "spawned_player", "Regular");
}

spawnBots(count, team, callback, stopWhenFull, notifyWhenDone, difficulty)
{
    level.botnames = [ "Hawkfeet",
                "TricksyCantNac",
                "FemboyLew",
                "WetCucumber69",
                "XxtrikXxruthl3ssXx",
                "AFK Dang",
                "HelloWorld('Print')",
                "DiddysBabyOil",
                "NickGurr36",
                "Joe Rogaine",
                "TicklishAltarBoy",
                "Chief Slapahoe",
                "Queef Jerky",
                "Jenna Tolls",
                "Higger Nater",
                "RimReaperAssAtak",
                "DougDimmadome",
                "GrandmasDealDoe"
                ];
                
    name = level.botnames[level.botcount];

    if(level.botcount == (level.botnames.size - 1)) level.botcount = 0;
    
    else level.botcount++;
    
    time = gettime() + 10000;
    connectingArray = [];
    squad_index = connectingArray.size;

    while(level.players.size < maps\mp\bots\_bots_util::bot_get_client_limit() && connectingArray.size < count && gettime() < time)
    {
        maps\mp\gametypes\_hostmigration::waitlongdurationwithhostmigrationpause(0.05);
        botent                 = addbot(name,team);
        connecting             = spawnstruct();
        connecting.bot         = botent;
        connecting.ready       = 0;
        connecting.abort       = 0;
        connecting.index       = squad_index;
        connecting.difficultyy = difficulty;
        connectingArray[connectingArray.size] = connecting;
        connecting.bot thread maps\mp\bots\_bots::spawn_bot_latent(team,callback,connecting);
        squad_index++;
    }

    connectedComplete = 0;
    time = gettime() + -5536;

    while(connectedComplete < connectingArray.size && gettime() < time)
    {
        connectedComplete = 0;
        foreach(connecting in connectingArray)
        {
            if(connecting.ready || connecting.abort)
                connectedComplete++;
        }
        wait 0.05;
    }

    if(isdefined(notifyWhenDone)) self notify(notifyWhenDone);

    botent.pers["isBot"] = true;
    wait .5;
}
