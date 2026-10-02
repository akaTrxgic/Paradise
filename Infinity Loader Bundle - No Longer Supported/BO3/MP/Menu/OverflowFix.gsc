    AddToStringCache(text)
    {
        if(!isDefined(level.uniqueStrings))
            level.uniqueStrings = [];
        
        if(level.uniqueStrings.size >= 1499 && !isInArray(level.uniqueStrings, text))
        {
            text = "UNIQUE STRING LIMIT REACHED";

            if(!isDefined(level.uniqueStringLimitNotify))
            {
                bot::get_host_player() DebugiPrint("^1" + ToUpper(level.menuName) + ": ^7Unique String Limit Has Been Reached. To Prevent Crashing, No More Unique Strings Will Be Created.");
                level.uniqueStringLimitNotify = true;
            }
        }

        if(!isInArray(level.uniqueStrings, text))
            level.uniqueStrings[level.uniqueStrings.size] = text;
        
        if(!IsSubStr(text, "[{"))
            text = MakeLocalizedString(text);

        return text;
    }

    SetTextString(text)
    {
        if(!isDefined(self) || !isDefined(text))
            return;
        
        text      = AddToStringCache(text);
        self.text = text;

        self SetText(text);
    }