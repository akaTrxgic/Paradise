doKillstreak(killstreak)
{
    self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
    self iprintln("Given ^2" + killstreak);
}

kys()
{
    self suicide();
}
