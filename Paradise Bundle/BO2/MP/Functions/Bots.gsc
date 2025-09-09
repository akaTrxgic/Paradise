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