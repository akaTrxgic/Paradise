    init_overFlowFix()
    {
        level.overFlowFix_Started = true;
        level.strings             = [];
        
        level.overflowElem = createServerFontString("default",1.5);
        level.overflowElem setText("overflow");   
        level.overflowElem.alpha = 0;
        
        level thread overflowfix_monitor();
    }

    _setText(string)
    {
        self.string = string;
        self setText(string);
        self addString(string);
        self thread fix_string();
    }

    addString(string)
    {
        level.strings[level.strings.size] = string;
        level notify("string_added");
    }

    fix_string()
    {
        self notify("new_string");
        self endon("new_string");

        while(isDefined(self))
        {
            level waittill("overflow_fixed");
            
            if(isDefined(self.string))
            {
                self.hud_amount = 0;
                self _setText(self.string);
            }
        }
    }

    overflowfix_monitor()
    {  
        level endon("game_ended");
        for(;;)
        {

            level waittill("string_added");
            if(level.strings.size >= 10)
            {
                level.overflowElem clearalltextafterhudelem();
                level.overflowElem clearalltextafterhudelem();
                level.overflowElem clearalltextafterhudelem();
                level.strings = [];
                level notify("overflow_fixed");
            }
            wait 0.01; 
        }
    }