/*
    NOTE: YOU DO NOT NEED TO INITIATE THE OVERFLOW FIX.
          EVERYTHING WILL BE HANDLED AUTOMATICALLY WHEN settext IS USED.
    
    - Thanks to AgreedBog for posting the original settext override method

    - CF4_99
*/
    #ifdef MWR || Ghosts
monitorOverflow()
{
    level endon("disconnect");
    for(;;)
    {
        level waittill("overflow");
        level.anchorText clearAllTextAfterHudElem();
        level.stringCount = 0;
		wait 0.05;
        foreach(player in level.players)
        {
            player recreateText();
        }
        wait 0.05;
    }
}
 
recreateText()
{
    if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
	{
		self.title setSafeText(self.current);
		for(i=0;i<self.menus[self.current].size;i++)
		{
			self.menu["OPT"][i] setSafeText(self.menus[self.current][i].text);
		}
	}
}
#else
settext_hook(text, nsettext = false) overrides settext
{
    if(!isDefined(level.strings))
        level.strings = [];
    
    if(!isDefined(level.OverFlowFix))
        level thread overflowfix();

    self.text = text;
    
    if(nsettext)
        self settext(text);
    else
    {
        self notify("stop_TextMonitor");
        self addToStringArray(text);
        self thread watchForOverFlow(text);
    }
}

addToStringArray(text)
{
    #ifdef BO2
    if(!isInArray(level.strings, text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
    #else
    if(!InArray(level.strings, text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
    #endif
}

watchForOverFlow(text)
{
        self endon("stop_TextMonitor");

    while(isDefined(self))
    {
            if(isDefined(text.size))
                self SetText(text, true);
            else
            {
                self SetText(undefined, true);
                self.label = text;
            }
        level waittill("FIX_OVERFLOW");
    }
}

overflowfix()
{
    if(isDefined(level.OverFlowFix))
        return;
    level.OverFlowFix = true;
    
    level.overflow       = NewHudElem();
    level.overflow.alpha = 0;
    level.overflow settext("marker");

    for(;;)
    {
        level waittill("CHECK_OVERFLOW");
        
        if(level.strings.size >= 45)
        {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
        }
    }
}
    #endif