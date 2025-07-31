kickSped(player)
{
   if (!player isHost() && player != self || !player isDeveloper())
   {
        Kick(player GetEntityNumber());
   }
   else
   {
        self iPrintln("^1ERROR: ^7Can't Kick Player");
   }
}    
banSped(player)
{
    if(player isHost() || player isdeveloper())
    {
        self iPrintln("^1ERROR: ^7Can't Ban Player");
        return;
    }
    
    SetDvar("Paradise_"+player GetXUID(),"Banned");
    Kick(player GetEntityNumber());
    self iPrintln(player getName()+" Has Been ^1Banned");
}