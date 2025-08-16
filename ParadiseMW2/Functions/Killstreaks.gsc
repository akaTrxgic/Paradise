doKillstreak(name)
{
    if (!isDefined(name))
        return;

    self giveKillstreak(name);
}

kys()
{
    self suicide();
}
