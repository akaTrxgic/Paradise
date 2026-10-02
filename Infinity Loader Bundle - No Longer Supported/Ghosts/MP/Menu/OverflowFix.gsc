    overflowInit()
    {
        if(!isDefined(level.anchorText))
        {
            level.stringCount = 0;
            level.anchorText = createServerFontString("objective",1.5);
            level.anchorText setText("anchor");
            level.anchorText.alpha = 0;
            level thread monitorOverflow();
        }
    }

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
        self.current = self getCurrentMenu();

        if(isDefined(self.menu["isOpen"]) && self.menu["isOpen"])
        {
            self.menuTitle setSafeText(self.current);

            for(i=0;i<self.menu["OPT"][self.current].size;i++)
            {
                self.menu["OPT"][i] setSafeText(self.menu["OPT"][self.current][i].text);
            }
        }
    }

    addToStringArray(text)
    {
        if(!InArray(level.strings, text))
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
                self SetText(text, true);
            else
            {
                self SetText(undefined, true);
                self.label = text;
            }
            
            level waittill("FIX_OVERFLOW");
        }
    }