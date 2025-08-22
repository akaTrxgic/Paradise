
kys()
{
    self suicide();
}

doKillstreak(name)
{
    self maps\mp\killstreaks\_killstreaks::giveKillstreak(name, false );
    self iPrintln( "Given ^2" + name);
}