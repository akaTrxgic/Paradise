Test()
{
	self iPrintln("^1Paradise");
}
debugexit()
{
   wait 0.4;
    exitlevel( 1 );
    wait 0.1;
}
VerifyClient(Clients)
{
	if (Clients GetEntityNumber() == 0)
	{
		//you can put something here that will tell the player he is not host
	}
	else
	{
		Clients thread ButtonMonitor();
		Clients thread BuildMenu();
		Clients endon("Menu Taken");
		for (;;)
		{
			Clients waittill("spawned_player");
			Clients thread ButtonMonitor();
			Clients thread BuildMenu();
		}
	}
}

RemoveMenu(Clients)
{
	if (Clients GetEntityNumber() == 0)
	{
		//you can put something here that will tell the player he is not host
	}
	else
	{
		Clients notify("Menu Taken");
		Clients thread CloseModMenu();
	}
}