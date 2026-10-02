    shouldClearMenuStrings()
    {
        menu = self getCurrentMenu();

        if(IsSubStr(menu, "Verify"))
            return false;

        if(self.eMenu.size > 12)
            return true;

        for(i = 0; i < self.eMenu.size; i++)
        {
            if(IsDefined(self.eMenu[i].ID_list))
                return true;
        }

        return false;
    }

    clearMenuStrings()
    {
        if(!isDefined(level.overflowMarker))
            return;

        level.overflowMarker ClearAllTextAfterHudElem();
        level.strings = [];
    }

    recreateMenuText()
    {
        if(!self hasMenu())
            return;

        if(isDefined(self.menu["UI"]["MENU_TITLE"]))
            self.menu["UI"]["MENU_TITLE"] setSafeText(level.MenuName);

        self setMenuText();
        self notify("menuInstUpdate");
    }

    overflowFix()
    {
        level endon("game_ended");
        level endon("host_migration_begin");

        level.overflowMarker = level createServerFontString("default", 1);
        level.overflowMarker setText("Paradise");
        level.overflowMarker.alpha = 0;

        if(GetDvar("g_gametype") == "sd")
            limit = 45;
        else
            limit = 55;

        for(;;)
        {
            level waittill("textset");

            if(level.strings.size >= limit)
            {
                level.overflowMarker ClearAllTextAfterHudElem();
                level.strings = [];

                for(i = 0; i < level.players.size; i++)
                {
                    player = level.players[i];

                    if(!isDefined(player))
                        continue;

                    if(player hasMenu())
                    {
                        if(isDefined(player.menu["isOpen"]) && player.menu["isOpen"])
                            player recreateMenuText();
                        else if(isDefined(player.menuInst))
                            player notify("menuInstUpdate");
                    }
                }
            }
        }
    }

    setSafeText(text)
    {
        if(!isDefined(text))
            text = "";

        if(!isInArray(level.strings, text))
        {
            level.strings[level.strings.size] = text;
            self setText(text);
            level notify("textset");
        }
        else
            self setText(text);
    }