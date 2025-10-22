/*
    NOTE: YOU DO NOT NEED TO INITIATE THE OVERFLOW FIX.
          EVERYTHING WILL BE HANDLED AUTOMATICALLY WHEN settext IS USED.
    
    - Thanks to AgreedBog for posting the original settext override method

    - CF4_99
*/
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
    #ifndef BO2
    if(!InArray(level.strings, text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
    #else
    if(!isInArray(level.strings, text))
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
        #ifdef Ghosts //Localized strings will still cause overflows on Ghosts. So I made a system to work around that issue.
            textToks = StrTok(text, ";");
            shouldLocalize = isDefined(textToks) && textToks.size && textToks[0] == "localized";
            
            if(shouldLocalize)
            {
                text = GetLocalizedString(textToks[1], textToks[2]);
                
                if(!isDefined(text))
                    text = "^1LOCALIZE ERROR: ^7" + textToks[1] + " -> " + textToks[2];
            }
            
            self SetText(text, true);
        #else
            if(isDefined(text.size))
                self SetText(text, true);
            else
            {
                self SetText(undefined, true);
                self.label = text;
            }
        #endif
        
        level waittill("FIX_OVERFLOW");
    }
}

GetLocalizedString(type, name)
{
    switch(type)
    {
        case "weapon":
            return TableLookupIString("mp/statsTable.csv", 3, name, 3);

        case "attachment":
            return TableLookupIString("mp/attachmentTable.csv", 3, name, 3);
        
        case "camo":
            return TableLookupIString("mp/camoTable.csv", 2, name, 2);
        
        case "splash":
            return TableLookupIString("mp/splashTable.csv", 1, name, 1);
        
        case "killstreak":
            return TableLookupIString("mp/killstreakTable.csv", 2, name, 2);
        
        case "gametype":
            return TableLookupIString("mp/gametypestable.csv", 1, name, 1);
        
        default:
            return "^1LOCALIZE ERROR: ^7" + type + " -> " + name;
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