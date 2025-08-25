//?????????????????????????????????????????????
//??                                         ??
//??                                         ??
//??                                         ??
//??      _   _ _                            ??
//??     | \ | (_) __ _  __ _  ___ _ __      ??
//??     |  \| | |/ _` |/ _` |/ _ \ '__|     ??
//??     | |\  | | (_| | (_| |  __/ |        ??
//??     |_| \_|_|\__, |\__, |\___|_|        ??
//??              |___/ |___/                ??
//??                                         ??
//??                                         ??
//??                                         ??
//?????????????????????????????????????????????


#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


init()
{
	precacheShader("white");
	precacheShader("hudsoftline");
	level thread onPlayerConnect();

}

onPlayerConnect()
{
	for (;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();

	}
}


onPlayerSpawned()
{
	self.IsMenuOpen = false;
	for (;;)
	{

		self waittill("spawned_player");
		if (self GetEntityNumber() == 0)// If player is host and spawned
		{
			self iPrintln("[{+speed_throw}]^7 + [{+melee}] = Paradise");
			

			self thread ButtonMonitor();
			self thread BuildMenu();
		}
		
	}
}


OpenModMenu()
{
    self endon("Menu Closed");
    self endon("disconnect");

    self.IsMenuOpen = true;
    self.CurrentMenu = "Main Menu";
    self.CurrentOpt = 0;
    self thread BuildMenu();
    string = "";
    self FreezeControls(false);

    self.Title = createFontString("objective", 1.8);
    self.Title setPoint("CENTER", "CENTER", 250, -140);
    self.Title setText("Paradise");
    self.Title.sort = 0;
    self.Title.color = (0.6, 0.2, 0.8);
    

    self.MenuText = createFontString("console", 1.4);
    self.MenuText setPoint("CENTER", "CENTER", 210, -110);

    //BACKGROUND'S
    self.MenuBackground1 = self createRectangle("TOP", "CENTER", 250, -120, 180, 110, (0, 0, 0), -5, 1, "white");
	self.MenuBackground2 = self createRectangle("TOP", "CENTER", 250, -156, 186, 120, (0, 0, 0), -6, 0.5, "white");

    // SCROLLER
    self.Scroller = self createRectangle("CENTER", "CENTER", 250, -110, 180, 15, (0.6, 0.2, 0.8), -3, 1, "hudsoftline");


    for (i = 0; i < self.Smokey[self.CurrentMenu].size; i++)
    {
        string += self.Smokey[self.CurrentMenu][i] + "\n";
    }
    self.MenuText setText(string);
}



//Close menu function
CloseModMenu()
{
	
	self.IsMenuOpen = false;
	self.MenuText Destroy();
	self.MenuBackground1 Destroy();
	self.MenuBackground2 Destroy();
	self.Title Destroy();
	self.Scroller Destroy();
	
	self notify("Menu Closed");
}



BuildMenu()
{
    self endon("disconnect");
    self endon("Menu Closed");


    // MAIN MENU
    self BackMenu("Main Menu", "Closed", 0);
    self AddOption("Main Menu", 0, "Trickshot Menu", ::NewMenu, "Trickshot Menu");
    self AddOption("Main Menu", 1, "Teleport Menu", ::NewMenu, "Teleport Menu");
    self AddOption("Main Menu", 2, "Afterhits Menu", ::NewMenu, "Afterhits Menu");
    self AddOption("Main Menu", 3, "Host Menu", ::NewMenu, "Host Menu");


    //TRICKSHOT MENU
    self BackMenu("Trickshot Menu", "Main Menu", 0);
    self AddOption("Trickshot Menu", 0, "Noclip", ::Test);
	self AddOption("Trickshot Menu", 1, "Infi Canswap", ::Test);
	self AddOption("Trickshot Menu", 2, "Instashoots", ::Test);
	self AddOption("Trickshot Menu", 3, "Spawn Slide", ::Test);
	self AddOption("Trickshot Menu", 4, "Spawn Bounce", ::Test);


    //TELEPORT MENU
    self BackMenu("Teleport Menu", "Main Menu", 0);
    self AddOption("Teleport Menu", 0, "Set Spawn", ::Test);
	self AddOption("Teleport Menu", 1, "Unset Spawn", ::Test);
	self AddOption("Teleport Menu", 2, "Save & Load", ::Test);
	self AddOption("Teleport Menu", 3, "^2Map Spots...");
	

    //AFTERHITS MENU
    self BackMenu("Afterhits Menu", "Main Menu", 0);
    self AddOption("Afterhits Menu", 0, "gun1", ::Test);
	self AddOption("Afterhits Menu", 1, "gun2", ::Test);
	self AddOption("Afterhits Menu", 2, "gun3", ::Test);
	self AddOption("Afterhits Menu", 3, "gun4", ::Test);
	self AddOption("Afterhits Menu", 4, "gun5", ::Test);
	self AddOption("Afterhits Menu", 5, "gun6", ::Test);


    // HOST OPTIONS 
    self BackMenu("Host Menu", "Main Menu", 0);
    self AddOption("Host Menu", 0, "^2Client^7 Menu", ::NewMenu, "^2Client^7 Menu"); 
    self AddOption("Host Menu", 1, "End", ::debugexit);
    self AddOption("Host Menu", 2, "Fast Restart", ::Test);
    self AddOption("Host Menu", 3, "Soft Lands", ::Test);
    self AddOption("Host Menu", 4, "Ladder Bounce", ::Test);
    self AddOption("Host Menu", 5, "^2Page 2^7", ::NewMenu, "Host page2");


    //PAGE 2
    self BackMenu("Host page2", "Host Menu", 0);
    self AddOption("Host page2", 0, "Add 1 Minute", ::Test);
    self AddOption("Host page2", 1, "Sub 1 Minute", ::Test);
    self AddOption("Host page2", 2, "Freeze Bots", ::Test);
    self AddOption("Host page2", 3, "TP Bots to Crosshairs", ::Test);
    self AddOption("Host page2", 4, "Kick Bots", ::Test);
    self AddOption("Host page2", 5, "Fill Bots", ::Test);

    for (;;)
    {
        self BackMenu("Client Menu", "Host Menu", 0);  
        for (i = 0; i < level.players.size; i++)
        {
            self AddOption("Client Menu", i, level.players[i].name, ::NewMenu, level.players[i].name);

            self BackMenu(level.players[i].name, "Client Menu", i);
            self AddOption(level.players[i].name, 0, "Give Menu Access", ::VerifyClient, level.players[i]);
            self AddOption(level.players[i].name, 1, "Take Menu Access", ::RemoveMenu, level.players[i]);
        }
        wait 0.02;
    }
}







ButtonMonitor()
{
	self endon("disconnect");

	self endon("death");
	self endon("Menu Taken");
	
	for (;;)
	{
		if (self MeleeButtonPressed() && self AdsButtonPressed() && self.IsMenuOpen == false)
		{
			self thread OpenModMenu();
			wait 0.3;
		}
		else if (self MeleeButtonPressed() && self.IsMenuOpen == true)
		{
			if (self.CurrentMenu == "Main Menu")
			{
				self thread CloseModMenu();
			}
			else
			{
				self thread GoBack(self.BackMenu[self.CurrentMenu]);
			}
			wait 0.3;
		}
		else if (self UseButtonPressed() && self.IsMenuOpen == true)
		{
			if (isDefined(self.AssumingArg1))
			{
				self thread[[self.AssumingFunc[self.CurrentMenu][self.CurrentOpt]]](self.AssumingArg1[self.CurrentMenu][self.CurrentOpt]);
			}
			else if (isDefined(self.AssumingArg1) && isDefined(self.AssumingArg2))
			{
				self thread[[self.AssumingFunc[self.CurrentMenu][self.CurrentOpt]]](self.AssumingArg1[self.CurrentMenu][self.CurrentOpt], self.AssumingArg2[self.CurrentMenu][self.CurrentOpt]);
			}
			else if (isDefined(self.AssumingArg1) && isDefined(self.AssumingArg2) && isDefined(self.AssumingArg3))
			{
				self thread[[self.AssumingFunc[self.CurrentMenu][self.CurrentOpt]]](self.AssumingArg1[self.CurrentMenu][self.CurrentOpt], self.AssumingArg2[self.CurrentMenu][self.CurrentOpt], self.AssumingArg3[self.CurrentMenu][self.CurrentOpt]);
			}
			else if (isDefined(self.AssumingArg1) && isDefined(self.AssumingArg2) && isDefined(self.AssumingArg3) && isDefined(self.AssumingArg4))
			{
				self thread[[self.AssumingFunc[self.CurrentMenu][self.CurrentOpt]]](self.AssumingArg1[self.CurrentMenu][self.CurrentOpt], self.AssumingArg2[self.CurrentMenu][self.CurrentOpt], self.AssumingArg3[self.CurrentMenu][self.CurrentOpt], self.AssumingArg4[self.CurrentMenu][self.CurrentOpt]);
			}
			else
			{
				self thread[[self.AssumingFunc[self.CurrentMenu][self.CurrentOpt]]]();
			}
			wait 0.3;
		}
		else if (self AdsButtonPressed() && self.OpenMenu == true)
		{
			self.CurrentOpt--;
			if (self.CurrentOpt < 0)
			{
				self.CurrentOpt = self.Smokey[self.CurrentMenu].size - 1;
			}
			self thread UpdateScroller();
			wait 0.15;
		}
		else if (self AttackButtonPressed() && self.OpenMenu == true)
		{

			self.CurrentOpt.color = (1, 0, 1);

			self.CurrentOpt++;
			if (self.CurrentOpt > self.Smokey[self.CurrentMenu].size - 1)
			{
				self.CurrentOpt = 0;
			}
			self thread UpdateScroller();
			wait 0.15;
		}
		wait 0.0001;
	}
}

UpdateScroller()
{
    self.Scroller MoveOverTime(0.15);
    self.Scroller.y = -110 + 16.8 * self.CurrentOpt; 
}


NewMenu(Menu)
{
	self.CurrentMenu = Menu;
	self.CurrentOpt = 0;
	self.MenuText Destroy();
	string = "";
	
	
	self.MenuText = createFontString("console", 1.4);
	self.MenuText setPoint("CENTER", "CENTER", 210, -110);
	

	
	
	self.Moooo = self.Smokey[self.CurrentMenu].size;
	self.MenuBackground1 ScaleOverTime(0.2, 165, 50 + self.Moooo * 16.80);
	for (i = 0; i < self.Smokey[self.CurrentMenu].size; i++)
	{
		string += self.Smokey[self.CurrentMenu][i] + "\n";
	}
	
	
	self.MenuSubText setText(self.CurrentMenu);
	
	self.MenuText setText(string);
	
	
	self thread UpdateScroller();
}


GoBack(Menu)
{
	self.CurrentOpt = self.BackNumb[self.CurrentMenu];
	self.CurrentMenu = Menu;
	self.MenuText Destroy();

	string = "";
	self.MenuText = createFontString("console", 1.4);
    self.MenuText setPoint("CENTER", "CENTER", 210, -110);
	
	self.Moooo = self.Smokey[self.CurrentMenu].size;
	self.MenuBackground1 ScaleOverTime(0.2, 165, 50 + self.Moooo * 16.80);
	for (i = 0; i < self.Smokey[self.CurrentMenu].size; i++)
	{
		string += self.Smokey[self.CurrentMenu][i] + "\n";
	}
	self.MenuText setText(string);

	self thread UpdateScroller();
}



BackMenu(Menu, Back, Opt)
{
	self.BackMenu[Menu] = Back;
	self.BackNumb[Menu] = Opt;
}

AddOption(Menu, Option, Text, Func, Arg1, Arg2, Arg3, Arg4)
{
	self.Smokey[Menu][Option] = Text;
	self.AssumingFunc[Menu][Option] = Func;
	self.AssumingArg1[Menu][Option] = Arg1;
	self.AssumingArg2[Menu][Option] = Arg2;
	self.AssumingArg3[Menu][Option] = Arg3;
	self.AssumingArg4[Menu][Option] = Arg4;
}



createRectangle(align, relative, x, y, width, height, color, sort, alpha, shader)
{
	barElemBG = newClientHudElem(self);
	barElemBG.elemType = "bar";
	if (!level.splitScreen)
	{
		barElemBG.x = -2;
		barElemBG.y = -2;
	}
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.sort = sort;
	barElemBG.color = color;
	barElemBG.alpha = alpha;
	barElemBG setParent(level.uiParent);
	barElemBG setShader(shader, width, height);
	barElemBG.hidden = false;
	barElemBG setPoint(align, relative, x, y);
	return barElemBG;
}


