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
	self.Scroller.y = -130 + 16.80 * self.CurrentOpt;
}

NewMenu(Menu)
{
    self.CurrentMenu = Menu;
    self.CurrentOpt = 0;
    self.MenuText Destroy();
    string = "";
    
    self.MenuText = createFontString("console", 1.4);
    self.MenuText setPoint("CENTER", "CENTER", 250, -130);
    
    self.Moooo = self.Smokey[self.CurrentMenu].size;
    self.MenuBackground1 ScaleOverTime(0.2, 165, 50 + self.Moooo * 16.80);

    for (i = 0; i < self.Smokey[self.CurrentMenu].size; i++)
        string += self.Smokey[self.CurrentMenu][i] + "\n";
    
    self.MenuText setText(string);
    self thread UpdateScroller();
}



GoBack(Menu)
{
	self.CurrentOpt = self.BackNumb[self.CurrentMenu];
	self.CurrentMenu = Menu;
	self.MenuText Destroy();
	self.MenuSubText Destroy();

	string = "";
	self.MenuText = createFontString("console", 1.4);
	self.MenuText setPoint("CENTER", "CENTER", 250, -130);
	
	
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
