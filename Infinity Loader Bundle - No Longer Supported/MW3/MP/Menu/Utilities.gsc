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

    GetEnemyTeam()
    {
        if(self.pers["team"] == "allies")
            team = "axis";
        else
            team = "allies";
        
        return team;
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