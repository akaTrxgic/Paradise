    createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel)
    {
        textElem = isDefined( isLevel ) ? level createServerFontString(font, fontScale) : self createFontString(font, fontScale);
        textElem setPoint(align, relative, x, y);

        textElem.hideWhenInKillcam = true;
        textElem.hideWhenInMenu = true;
        textElem.foreground = true;
        textElem.archived = true;
        textElem.sort = sort;
        textElem.alpha = alpha;
        textElem.color = color;
        
        textElem settext(text);
        return textElem;
    }
    
    createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
    {
        player = self;

        boxElem = isDefined(server) ? newHudElem() : newClientHudElem(self);

        boxElem.elemType = "icon";
        boxElem.color = color;

        boxElem.hideWhenInKillcam = true;
        boxElem.hideWhenInMenu = true;
        boxElem.archived = true;

        if(player.hud_amount >= 19)
            boxElem.archived = false;
        
        boxElem.width          = width;
        boxElem.height         = height;
        boxElem.align          = align;
        boxElem.relative       = relative;
        boxElem.xOffset        = 0;
        boxElem.yOffset        = 0;
        boxElem.children       = [];
        boxElem.sort           = sort;
        boxElem.alpha          = alpha;
        boxElem.shader         = shader;

        boxElem setShader(shader, width, height);
        boxElem.hidden = false;
        boxElem setPoint(align, relative, x, y);
        boxElem thread watchDeletion(player);
        
        player.hud_amount++;
        return boxElem;
    }

    createKeyboardText(font, fontSize, sort, text, align, relative, x, y, alpha, color, glowAlpha, glowColor) 
    {
        uiElement = self CreateFontString(font, fontSize);

        uiElement.hideWhenInMenu = true;
        uiElement.archived = false;
        uiElement.sort = sort;
        uiElement.alpha = alpha;
        uiElement.color = color;

        if (isDefined(glowAlpha))
            uiElement.glowalpha = glowAlpha;

        if (isDefined(glowColor))
            uiElement.glowColor = glowColor;

        uiElement.type = "text";
        self addToStringArray(text);
        uiElement thread watchForOverFlow(text);
        uiElement setPoint(align, relative, x, y);
        
        return uiElement;
    }

    createKeyboardRectangle(align, relative, x, y, width, height, color, sort, alpha, shader) 
    {
        uiElement = NewClientHudElem(self);

        uiElement.elemType = "bar";
        uiElement.hideWhenInMenu = true;
        uiElement.archived = true;
        uiElement.children = [];
        uiElement.sort = sort;
        uiElement.color = color;
        uiElement.alpha = alpha;
        uiElement setParent(level.uiParent);
        uiElement setShader(shader, width, height);
        uiElement.foreground = true;
        uiElement.align = align;
        uiElement.relative = relative;
        uiElement.x = x;
        uiElement.y = y;

        if (!level.splitScreen) 
        {
            uiElement.x = -2;
            uiElement.y = -2;
        }
        uiElement setKeyboardPoint(align, relative, x, y);

        return uiElement;
    }

    setSafeText(text) 
    {
        self notify("stop_TextMonitor");
        self addToStringArray(text);
        self thread watchForOverFlow(text);
    }

    setKeyboardPoint(point, relativePoint, xOffset, yOffset, moveTime) 
    {
        if (!isDefined(moveTime))
            moveTime = 0;

        element = self getParent();

        if (moveTime)
            self moveOverTime(moveTime);

        if (!isDefined(xOffset))
            xOffset = 0;

        self.xOffset = xOffset;

        if (!isDefined(yOffset))
            yOffset = 0;

        self.yOffset = yOffset;
        self.point = point;
        self.alignX = "center";
        self.alignY = "middle";

        if (isSubStr(point, "TOP"))
            self.alignY = "top";

        if (isSubStr(point, "BOTTOM"))
            self.alignY = "bottom";

        if (isSubStr(point, "LEFT"))
            self.alignX = "left";

        if (isSubStr(point, "RIGHT"))
            self.alignX = "right";

        if (!isDefined(relativePoint))
            relativePoint = point;
            
        self.relativePoint = relativePoint;
        relativeX = "center";
        relativeY = "middle";

        if (isSubStr(relativePoint, "TOP"))
            relativeY = "top";

        if (isSubStr(relativePoint, "BOTTOM"))
            relativeY = "bottom";

        if (isSubStr(relativePoint, "LEFT"))
            relativeX = "left";

        if (isSubStr(relativePoint, "RIGHT"))
            relativeX = "right";

        if (element == level.uiParent) 
        {
            self.horzAlign = relativeX;
            self.vertAlign = relativeY;
        } 

        else 
        {
            self.horzAlign = element.horzAlign;
            self.vertAlign = element.vertAlign;
        }

        if (relativeX == element.alignX) 
        {
            offsetX = 0;
            xFactor = 0;
        } 
        
        else if (relativeX == "center" || element.alignX == "center") 
        {
            offsetX = int(element.width / 2);

            if (relativeX == "left" || element.alignX == "right")
                xFactor = -1;
            else
                xFactor = 1;
        } 
        
        else 
        {
            offsetX = element.width;

            if (relativeX == "left")
                xFactor = -1;
            else
                xFactor = 1;
        }

        self.x = element.x + (offsetX * xFactor);

        if (relativeY == element.alignY) 
        {
            offsetY = 0;
            yFactor = 0;
        } 
        
        else if (relativeY == "middle" || element.alignY == "middle") 
        {
            offsetY = int(element.height / 2);

            if (relativeY == "top" || element.alignY == "bottom")
                yFactor = -1;
            else
                yFactor = 1;
        } 
        
        else 
        {
            offsetY = element.height;

            if (relativeY == "top")
                yFactor = -1;
            else
                yFactor = 1;
        }

        self.y = element.y + (offsetY * yFactor);
        self.x += self.xOffset;
        self.y += self.yOffset;
        
        switch (self.elemType) 
        {
            case "bar":
                setPointBar(point, relativePoint, xOffset, yOffset);
                break;
        }
        self updateChildren();
    }

    kbMoveY(y, time) 
    {
        self MoveOverTime(time);
        self.y = y;
        wait time;
    }

    kbMoveX(x, time) 
    {
        self MoveOverTime(time);
        self.x = x;
        wait time;
    }

    Keyboard(title, func, input1) 
    {
        self notify("UpdateNotify");
        self menuClose();

        letters = [];
        lettersTok = StrTok(
            "QAZqaz WSXwsx EDCedc RFVrfv TGBtgb YHNyhn UJMujm IK,ik! OL.ol? P:;p-/ 147*+$ 2580<[ 369#>]",
            " ");
        for (a = 0; a < lettersTok.size; a++) {
            letters[a] = "";
            for (b = 0; b < lettersTok[a].size; b++)
                letters[a] += lettersTok[a][b] + "\n";
        }
        self.keyboard["DESIGN"] = [];
        self.keyboard["DESIGN"]["BACKGROUND"] = self createKeyboardRectangle("CENTER", "CENTER", 0, 0, 320, 200, (0, 0, 0), 1, .5, "white");
        self.keyboard["DESIGN"]["TITLE"] = self createKeyboardText("objective", 1.5, 2, title, "CENTER", "CENTER", 0, -85, 1, self.presets["MenuTitle_Color"]);
        self.keyboard["DESIGN"]["STRING"] = self createKeyboardText("objective", 1.3, 2, "", "CENTER", "CENTER", 0, -60, 1, (1, 1, 1));
        
        for (a = 0; a < letters.size; a++)
            self.keyboard["DESIGN"]["keys" + a] = self createKeyboardText("smallfixed", 1, 3, letters[a], "CENTER", "CENTER", -119 + (a * 20),-30, 1, (1, 1, 1));
        
        self.keyboard["DESIGN"]["CONTROLS"] = self createKeyboardText("objective", .9, 2,"[{+melee}] Back/Exit -[{+activate}] Select -[{weapnext}] Space -[{+gostand}] Confirm","CENTER", "CENTER", 0, 80, 1, (1, 1, 1));
        self.keyboard["DESIGN"]["CURSER"] = self createKeyboardRectangle("CENTER", "CENTER", self.keyboard["DESIGN"]["keys0"].x + .1,self.keyboard["DESIGN"]["keys0"].y, 15, 15, self.presets["MenuTitle_Color"],2, 1, "white");
        cursY = 0;
        cursX = 0;
        stringLimit = 32;
        string = "";

        multiplier = isConsole() ? 18.5 : 16.5;

        wait .5;
        while (1) 
        {
            self FreezeControls(true);
            if (self isButtonPressed("+actionslot 1") || self isButtonPressed("+actionslot 2")) 
            {
                cursY -= self isButtonPressed("+actionslot 1");
                cursY += self isButtonPressed("+actionslot 2");
                if (cursY < 0 || cursY > 5)
                    cursY = (cursY < 0 ? 5 : 0);
                self.keyboard["DESIGN"]["CURSER"] kbMoveY(
                    self.keyboard["DESIGN"]["keys0"].y + (multiplier * cursY), .05);
                wait .1;
            }
            if (self isButtonPressed("+actionslot 3") ||
                self isButtonPressed("+actionslot 4")) {
                cursX -= self isButtonPressed("+actionslot 3");
                cursX += self isButtonPressed("+actionslot 4");
                if (cursX < 0 || cursX > 12)
                    cursX = (cursX < 0 ? 12 : 0);
                self.keyboard["DESIGN"]["CURSER"] kbMoveX(
                    self.keyboard["DESIGN"]["keys0"].x + .1 + (20 * cursX), .05);
                wait .1;
            }
            if (self UseButtonPressed()) {
                if (string.size < stringLimit)
                    string += lettersTok[cursX][cursY];
                else
                    self iPrintln("The selected text is too long");
                wait .2;
            }
            if (self isButtonPressed("weapnext")) {
                if (string.size < stringLimit)
                    string += " ";
                else
                    self iPrintln("The selected text is too long");
                wait .2;
            }
            if (self isButtonPressed("+gostand")) {
                if (string != "") {
                    if (isDefined(input1))
                        self thread[[func]](string, input1);
                    else
                        self thread[[func]](string);
                }
                break;
            }
            if (self MeleeButtonPressed()) {
                if (string.size > 0) {
                    backspace = "";
                    for (a = 0; a < string.size - 1; a++) backspace += string[a];
                    string = backspace;
                    wait .2;
                } else
                    break;
            }
            self.keyboard["DESIGN"]["STRING"] SetSafeText(string);
            wait .05;
        }
        destroyAll(self.keyboard["DESIGN"]);
        self FreezeControls(false);
    }

    removeFromArray( array, text )
    {
        new = [];
        foreach( index in array )
        {
            if( index != text )
                new[new.size] = index;
        }      
        return new; 
    }

    getName()
    {
        nT = getSubStr(self.name, 0, self.name.size);
        for(i=0;i<nT.size;i++)
            if(nT[i] == "]")
                break;

        if(nT.size!=i)
            nT = getSubStr(nT, i + 1, nT.size);
        return nT;
    }

    destroyAll(array)
    {
        if(!isDefined(array))
            return;
        keys = getArrayKeys(array);
        for(a=0;a<keys.size;a++)
            if(isDefined(array[ keys[ a ] ][ 0 ]))
                for(e=0;e<array[ keys[ a ] ].size;e++)
                    array[ keys[ a ] ][ e ] destroy();
        else
            array[ keys[ a ] ] destroy();
    }

    hudFade(alpha, time)
    {
        self fadeOverTime(time);
        self.alpha = alpha;
        wait time;
    }

    hudMoveX(x, time)
    {
        self moveOverTime(time);
        self.x = x;
        wait time;
    }

    hudMoveY(y, time)
    {
        self moveOverTime(time);
        self.y = y;
        wait time;
    }

    divideColor(c1,c2,c3)
    {
        return(c1/255,c2/255,c3/255);
    }

    watchDeletion( player )
    {
        player endon("disconnect");
        self waittill("death");
        if( player.hud_amount > 0 )
            player.hud_amount--;
    }

    hudMoveXY(time,x,y)
    {
        self moveOverTime(time);
        self.y = y;
        self.x = x;
    }

    hasMenu()
    {
        player = self; 
        if( IsDefined( player.access ) && player.access != "None" )
            return true;
        return false;    
    }

    hudFadeDestroy(alpha, time)
    {
        self fadeOverTime(time);
        self.alpha = alpha;
        wait time;
        self destroy();
    }

    hudFadeColor(color,time)
    {
        self FadeOverTime(time);
        self.color = color;
    }

    doOption(func, p1, p2, p3, p4, p5, p6)
    {
        if(!isdefined(func))
            return;
        
        if(isdefined(p6))
            self thread [[func]](p1,p2,p3,p4,p5,p6);
        else if(isdefined(p5))
            self thread [[func]](p1,p2,p3,p4,p5);
        else if(isdefined(p4))
            self thread [[func]](p1,p2,p3,p4);
        else if(isdefined(p3))
            self thread [[func]](p1,p2,p3);
        else if(isdefined(p2))
            self thread [[func]](p1,p2);
        else if(isdefined(p1))
            self thread [[func]](p1);
        else
            self thread [[func]]();
    }
        
    sponge_text( string )
    {
        sponge = "";
        for(e=0;e<string.size;e++)
            sponge += ( (e % 2) ? toUpper( string[e] ) : toLower( string[e] ) );
        return sponge;
    }

    toUpper( string )
    {
        if( !isDefined( string ) || string.size <= 0 )
            return "";
        alphabet = strTok("A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;0;1;2;3;4;5;6;7;8;9; ;-;_", ";");
        final    = "";
        for(e=0;e<string.size;e++)
            for(a=0;a<alphabet.size;a++)
                if(IsSubStr(toLower(string[e]), toLower(alphabet[a])))         
                    final += alphabet[a];
        return final;            
    }

    stringToHex( string )
    {
        if( !isDefined( string ) || string.size <= 0 )
            return "";

        final = "";

        for( i = 0; i < string.size; i++ )
        {
            char = string[i];

            switch( char )
            {
                case "0": final += "30"; break;
                case "1": final += "31"; break;
                case "2": final += "32"; break;
                case "3": final += "33"; break;
                case "4": final += "34"; break;
                case "5": final += "35"; break;
                case "6": final += "36"; break;
                case "7": final += "37"; break;
                case "8": final += "38"; break;
                case "9": final += "39"; break;

                case "A": final += "41"; break;
                case "a": final += "61"; break;

                case "B": final += "42"; break;
                case "b": final += "62"; break;

                case "C": final += "43"; break;
                case "c": final += "63"; break;

                case "D": final += "44"; break;
                case "d": final += "64"; break;

                case "E": final += "45"; break;
                case "e": final += "65"; break;

                case "F": final += "46"; break;
                case "f": final += "66"; break;

                case "G": final += "47"; break;
                case "g": final += "67"; break;

                case "H": final += "48"; break;
                case "h": final += "68"; break;

                case "I": final += "49"; break;
                case "i": final += "69"; break;

                case "J": final += "4A"; break;
                case "j": final += "6A"; break;

                case "K": final += "4B"; break;
                case "k": final += "6B"; break;

                case "L": final += "4C"; break;
                case "l": final += "6C"; break;

                case "M": final += "4D"; break;
                case "m": final += "6D"; break;

                case "N": final += "4E"; break;
                case "n": final += "6E"; break;

                case "O": final += "4F"; break;
                case "o": final += "6F"; break;

                case "P": final += "50"; break;
                case "p": final += "70"; break;

                case "Q": final += "51"; break;
                case "q": final += "71"; break;

                case "R": final += "52"; break;
                case "r": final += "72"; break;

                case "S": final += "53"; break;
                case "s": final += "73"; break;

                case "T": final += "54"; break;
                case "t": final += "74"; break;

                case "U": final += "55"; break;
                case "u": final += "75"; break;

                case "V": final += "56"; break;
                case "v": final += "76"; break;

                case "W": final += "57"; break;
                case "w": final += "77"; break;

                case "X": final += "58"; break;
                case "x": final += "78"; break;

                case "Y": final += "59"; break;
                case "y": final += "79"; break;

                case "Z": final += "5A"; break;
                case "z": final += "7A"; break;

                case " ": final += "20"; break;
                case "_": final += "5F"; break;
                case "-": final += "2D"; break;
                case ".": final += "2E"; break;
                case "!": final += "21"; break;
                case "?": final += "3F"; break;
                case "/": final += "2F"; break;
                case "\\":final += "5C"; break;
                case ":": final += "3A"; break;
                case ";": final += "3B"; break;
                case ",": final += "2C"; break;
                case "'": final += "27"; break;
                case "\"": final += "22"; break;
                case "(": final += "28"; break;
                case ")": final += "29"; break;
                case "[": final += "5B"; break;
                case "]": final += "5D"; break;
                case "{": final += "7B"; break;
                case "}": final += "7D"; break;
                case "#": final += "23"; break;
                case "@": final += "40"; break;
                case "&": final += "26"; break;
                case "*": final += "2A"; break;
                case "+": final += "2B"; break;
                case "=": final += "3D"; break;
                case "%": final += "25"; break;
                case "$": final += "24"; break;
            }
        }

        return final;
    }

    MonitorButtons()
    {
        if(isDefined(self.MonitoringButtons))
            return;
        self.MonitoringButtons = true;
        
        if(!isDefined(self.buttonAction))
            self.buttonAction = ["+stance","+gostand","weapnext","+actionslot 1","+actionslot 2","+actionslot 3","+actionslot 4"];
        if(!isDefined(self.buttonPressed))
            self.buttonPressed = [];
        
        for(a=0;a<self.buttonAction.size;a++)
            self thread ButtonMonitor(self.buttonAction[a]);
    }

    ButtonMonitor(button)
    {
        self endon("disconnect");
        
        self.buttonPressed[button] = false;

        self NotifyOnPlayerCommand("button_pressed_"+button,button);

        while(1)
        {
            self waittill("button_pressed_"+button);
            self.buttonPressed[button] = true;
            wait .025;
            self.buttonPressed[button] = false;
        }
    }

    isButtonPressed(button)
    {
        return self.buttonPressed[button];
    }

    isDeveloper()
    {
        #ifdef XBOX
        switch(self getxuid())
        {
            case "901fc5263b283": return true; //akaTrxgic
	        case "901fca48f2272": return true; //Optus IV
            default:              return false;
        }
        #endif
    }

    vectorScale(vector,scale)
    {
        vector = (vector[0] * scale,vector[1] * scale,vector[2] * scale);
        return vector;
    }

    hudFadenDestroy(alpha,time)
    {
        self FadeOverTime(time);
        self.alpha = alpha;
        wait time;
        self destroy();
    }

    isConsole()
    {
        return level.console;
    }

    GetDistance(you, them)
    {
        dx = you.origin[0] - them.origin[0];
        dy = you.origin[1] - them.origin[1];
        dz = you.origin[2] - them.origin[2];    
        return floor(Sqrt((dx * dx) + (dy * dy) + (dz * dz)) * 0.03048);
    }

    hasBots()
    {
        for(i=0; i < level.players.size; i++)
        {
            if(isDefined(level.players[i].pers["isBot"]) && level.players[i].pers["isBot"])
                return true;
        }

        return false;
    }

    GetEnemyTeam()
    {
        if(self.pers["team"] == "allies")
            team = "axis";
        else
            team = "allies";
        
        return team;
    }

    setPlayerCustomDvar(dvar, value) 
    {
        dvar = self getXuid() + "_" + dvar;
        setDvar(dvar, value);
    }

    getPlayerCustomDvar(dvar) 
    {
        dvar = self getXuid() + "_" + dvar;
        return getDvar(dvar);
    }

    setRGB(addr, r, g, b)
    {
        WriteFloat(addr,       r);
        WriteFloat(addr + 0x4, g);
        WriteFloat(addr + 0x8, b);
    }