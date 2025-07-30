doKillstreak(killstreak)
{
    self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    self iprintln("Given ^2" + killstreak);
}


fillStreaks()
{
    maps\mp\gametypes\_globallogic_score::_setplayermomentum(self, 9999);
}

kys()
{
    self suicide();
}
