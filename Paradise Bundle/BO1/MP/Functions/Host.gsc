
editTime(type)
{
    if(type == "add")
        self add1min();

    else if(type == "sub")
        self sub1min();
}
add1Min()
{
    timeLeft       = GetDvar("scr_" + level.gametype + "_timelimit");
    timeLeftProper = int(timeLeft);
    setTime        = timeLeftProper + 1; 
    SetDvar("scr_" + level.gametype + "_timelimit", setTime);
    wait .05;
    self iPrintln("^2Added 1 Minute");
}
sub1Min()
{
    timeLeft       = GetDvar("scr_" + level.gametype + "_timelimit");
    timeLeftProper = int(timeLeft);
    setTime        = timeLeftProper - 1;
    SetDvar("scr_" + level.gametype + "_timelimit", setTime);
    wait .05;
    self iprintln("^1Removed 1 Minute");
}
