GiveKillstreak(streak, num, false, false )
{
    self thread maps\mp\gametypes\_hardpoints::giveKillstreak( streak, num, false, false );
}

kys()
{
    self suicide();
}
