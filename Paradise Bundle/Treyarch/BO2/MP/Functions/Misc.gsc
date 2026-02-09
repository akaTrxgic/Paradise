//Bots
spawnBots(num, team)
{
    if(!isDefined(team))
        team = "autoassign";

	for(a = 0; a < num; a++)
	{
		maps\mp\bots\_bot::spawn_bot(team);
        wait 0.1;
	}
}

//Killstreaks
doKillstreak(name)
{
    if (!isDefined(name))
        return;

    self giveKillstreak(name);
}

fillStreaks()
{
    maps\mp\gametypes\_globallogic_score::_setplayermomentum(self, 9999);
}