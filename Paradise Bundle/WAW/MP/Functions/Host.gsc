changeTime(input)
{
    timeLeft       = GetDvar("scr_"+level.gametype+"_timelimit");
    timeLeftProper = int(timeLeft);

    if(input == "add")
    {  
        setTime = timeLeftProper + 1;
        self iPrintln("^2Added 1 minute");
    }
    else if(input == "sub")
    {
        setTime = timeLeftProper - 1;
        self iPrintln("^1Removed 1 minute"); 
    }
    SetDvar("scr_"+level.gametype+"_timelimit",setTime);
    time = setTime - getMinutesPassed();

    wait .05;
}
getMinutesPassed()
{
    
}