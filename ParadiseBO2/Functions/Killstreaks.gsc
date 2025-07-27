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

kys()
{
    self suicide();
}