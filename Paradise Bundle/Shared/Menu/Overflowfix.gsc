/*
    NOTE: YOU DO NOT NEED TO INITIATE THE OVERFLOW FIX.
          EVERYTHING WILL BE HANDLED AUTOMATICALLY WHEN settext IS USED.
    
    - Thanks to AgreedBog for posting the original settext override method

    - CF4_99
*/
settext_hook(text, nsettext = false) overrides settext
{
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
    if(!inarray(level.strings, text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
}

watchForOverFlow(text)
{
    self endon("stop_TextMonitor");

    while(isDefined(self))
    {
        if(isDefined(text.size))
            self settext(text, true);
        else
        {
            self settext(undefined, true);
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