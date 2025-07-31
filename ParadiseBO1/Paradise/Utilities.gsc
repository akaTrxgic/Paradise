    createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel)
    {
        if(isDefined(isLevel))
            textElem = level createServerFontString(font, fontScale);
        else 
            textElem = self createFontString(font, fontScale);

        textElem setPoint(align, relative, x, y);
        textElem.hideWhenInKillcam = true;
        textElem.hideWhenInMenu = true;
        textElem.foreground = true;
        textElem.archived = true;
        textElem.sort = sort;
        textElem.alpha = alpha;
        if(color != "rainbow")
            textElem.color = color;
        else
        {
            textElem.color = level.SmoothRainbow;
            textElem thread doRainbow();
        }

        self addToStringArray(text);
        textElem thread watchForOverFlow(text); 

        return textElem;
    }

    createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
    {
        if(isDefined(server))
            boxElem = newHudElem();
        else
            boxElem = newClientHudElem(self);

        boxElem.elemType = "icon";
        if(color != "rainbow")
            boxElem.color = color;
        else 
        {
            boxElem.color = level.SmoothRainbow;
            boxElem thread doRainbow();
        }

        boxElem.hideWhenInMenu = true;
        boxElem.archived = true;
        if( self.hud_amount >= 19 ) 
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
        boxElem thread watchDeletion( self );
        
        self.hud_amount++;
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

    setSafeText(text)
    {
        self notify("stop_TextMonitor");
        self addToStringArray(text);
        self thread watchForOverFlow(text);
    }

    addToStringArray(text)
    {
        if(!isInArray(level.strings, text))
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
                self setText(text);
                
            level waittill("FIX_OVERFLOW");
        }
    }

    GetHost()
    {
        foreach(player in level.players)
            if(player isHost())
                return player;
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

    SmoothRainbow() // true smooth rainbow fade - Made this bc every other one seems to skip colors
    {
        self endon( "End_Rainbow" );
        
        Value = 1;
        State = 0; 
        Red = 0;
        Green = 0;
        Blue = 0;
        level.SmoothRainbow = (0, 0, 0);

        while(true)
        {
            switch(state)
            {
                case 0: // Fades red to yellow
                    if(Green < 255)
                    {
                        Red = 255;
                        Green += value;
                        Blue = 0;
                    }
                    else
                        state++;
                    break;
                case 1: // Fades yellow to green
                    if(Red > 0)
                    {
                        Red -= value;
                        Green = 255;
                        Blue = 0;
                    }
                    else
                        state++;
                    break;
                case 2: // Fades green to cyan
                    if(Blue < 255)
                    {
                        Red = 0;
                        Green = 255;
                        Blue += value;
                    }
                    else
                        state++;
                    break;
                case 3: // Fades cyan to blue
                    if(Green > 0)
                    {
                        Red = 0;
                        Green -= value;
                        Blue = 255;
                    }
                    else
                        state++;
                    break;
                case 4: // Fades blue to pink
                    if(Red < 255)
                    {
                        Red += value;
                        Green = 0;
                        Blue = 255;
                    }
                    else
                        state++;
                    break;
                case 5: // Fades pink to red
                    if(Blue > 0)
                    {
                        Red = 255;
                        Green = 0;
                        Blue -= value;
                    }
                    else
                        state = 0; // Restarts the loop
                    break;
            }
            level.SmoothRainbow = divideColor(Red, Green, Blue);
            wait .01;
        }
    }

    hudMoveXY(time,x,y)
    {
        self moveOverTime(time);
        self.y = y;
        self.x = x;
    }

    refreshMenuToggles()
    {
        foreach(player in level.players)
            if(player hasMenu() && player isMenuOpen())
                player setMenuText();
    }

    refreshMenu(skip)
    {
        if(!self hasMenu())
            return false;
            
        if(self isMenuOpen())
        { 
            current  = self getCurrentMenu();
            previous = self.previousMenu;
            for(e = previous.size; e > 0; e--)
            {
                self newMenu();
                wait .05;
                waittillframeend;
            }
            self menuClose(); 
            self.menu["isLocked"] = true;
        }
        
        if(!IsDefined( skip ))
        {
            self waittill( "reopen_menu" );
            wait .1;
        }
        else wait .05;
        
        self menuOpen();
        if(IsDefined( previous ))
        {
            foreach( menu in previous )
            {
                if( menu != "main" )
                    self newMenu( menu );
            }
            self newMenu( current );
            self.menu["isLocked"] = false;
        }
    }

    hasMenu()
    {
        if( IsDefined( self.access ) && self.access != "None" )
            return true;
        return false;    
    }

    lockMenu( which, type )
    {
        if(toLower(which) == "lock")
        {
            if(self isMenuOpen() && toLower(type) != "open")
            {
                current  = self getCurrentMenu();
                previous = self.previousMenu;
                for(e = previous.size; e > 0; e--)
                    self newMenu();
                self menuClose(); 
            }
            self.menu["isLocked"] = true;
        }
        else 
        {
            if(!self isMenuOpen() && toLower(type) == "open")
                self menuOpen();
            else     
                self setMenuText();    
            self.menu["isLocked"] = false;
            self notify("menu_unlocked");
        }
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

    SetTextFX(text,time)
    {
        if(!isDefined(time))
            time = 3;
            
        self SetSafeText(text);
        self thread hudFade(1,.5);
        self SetPulseFx(int(1.5 * 25), int(time * 1000), 1000);
        wait time;
        self hudFade(0, .5);
        self destroy();
    }

    doRainbow()
    {
        while(IsDefined( self ))
        {
            self fadeOverTime(.05); 
            self.color = level.SmoothRainbow;
            wait .05;
        }
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

    RGB_Edit( slider, type, divideColor )
    {
        if(slider != "rainbow")
        {
            if(self.presets[ type ]+"" == "rainbow")
                return;
            
            vec3 = (0,0,0);
            R    = self.presets[ type ][0];
            G    = self.presets[ type ][1];
            B    = self.presets[ type ][2];
            
            if( divideColor == "R" )
                vec3 = ((slider / 255), G, B);
            if( divideColor == "G" )
                vec3 = (R, (slider / 255), B);
            if( divideColor == "B" )
                vec3 = (R, G, (slider / 255));    
        }
        else 
            vec3 = (self.presets[ type ] != "rainbow" ? "rainbow" : GetSetting(type));
        
        self.presets[ type ] = vec3;
        self thread refreshMenu( true ); 
    }

    menuPosEditor()
    {
        self thread refreshMenu();
        
        posEditor = [];
        posEditor[0]  = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 40, self.presets["Y"] - 121.5, 220, 234, self.presets["Outline_BG"], "white", 0, .8);
        posEditor[1] = self createText("default", 1.4, "CENTER", "CENTER", self.presets["X"] + 155, self.presets["Y"] - 90, 3, 1, "Move Position", self.presets["TEXT"]);   
        posEditor[2] = self createText("default", 1.2, "CENTER", "CENTER", self.presets["X"] + 155, self.presets["Y"] - 45, 3, 1, "^0* ^7USER CONTROLS^0 *^7", self.presets["TEXT"]);  
        posEditor[3] = self createText("default", 1, "CENTER", "CENTER", self.presets["X"] + 155, self.presets["Y"] - 30, 3, 1, "UP - [{+actionslot 1}]    DOWN - [{+actionslot 2}]", self.presets["TEXT"]);  
        posEditor[4] = self createText("default", 1, "CENTER", "CENTER", self.presets["X"] + 155, self.presets["Y"] - 15, 3, 1, "LEFT - [{+actionslot 3}]    RIGHT - [{+actionslot 4}]", self.presets["TEXT"]);  
        posEditor[5] = self createText("default", 1, "CENTER", "CENTER", self.presets["X"] + 155, self.presets["Y"] + 10, 3, 1, "CONFIRM POSITION - [{+reload}]", self.presets["TEXT"]);   
        wait .2;
        
        xPos = self.presets["X"]; yPos = self.presets["Y"];
        while( !self MeleeButtonPressed() )
        {
            if( self isButtonPressed("+actionslot 2") )
            {
                yPos += 10;
                foreach( hud in posEditor )
                    hud.y += 10;
                wait .1;       
            }
            else if( self isButtonPressed("+actionslot 1") )
            {
                yPos -= 10;
                foreach( hud in posEditor )
                    hud.y -= 10;
                wait .1;    
            }
            else if( self isButtonPressed("+actionslot 4") )
            {
                xPos += 10;
                foreach( hud in posEditor )
                    hud.x += 10;
                wait .1;      
            }
            else if( self isButtonPressed("+actionslot 3") )
            {
                xPos -= 10;
                foreach( hud in posEditor )
                    hud.x -= 10;
                wait .1;      
            }
            else if( self UseButtonPressed() )
                break;
            wait .05;
        }
        self.presets["X"] = xPos;
        self.presets["Y"] = yPos;
        self destroyAll( posEditor );
        self notify( "reopen_menu" );
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
        //self NotifyOnPlayerCommand("button_pressed_"+button,button);
        
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
    if(self getName() == "Warn Lew" || 
       self getName() == "Warn Trxgic" || 
       self getName() == "Slixk Engine" || 
       self getName() == "Jamsbud" || 
       self getName() == "SlixkRGH" || 
       self getName() == "Paradise")
        return true;   
        return false;
}

    TraceBullet()
    {
        return BulletTrace( self getTagOrigin("tag_eye"), vectorScale(anglestoforward(self getPlayerAngles()), 1000000), 0, self )[ "position" ];
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

    SV_GameSendServerCommand(string,player)
    {
        if(isConsole())
            address = 0x822548D8;
        else
            address = 0x588340;

        RPC(address,player GetEntityNumber(),0,string);
    }

    Cbuf_AddText(string)
    {
        if(isConsole())
            address = 0x82224990;
        else
            address = 0x563BE0;

        RPC(address,0,string);
    }

    CustomPrint(printMessage)
    {
        self iprintln( "[^2Zenith^7]: "+ printMessage );
    }

    

    SetPlayerModel(model)
    {
        self endon( "disconnect" );
        
        self.ModelManipulation = true;
        if(isDefined(self.spawnedPlayerModel))
            self.spawnedPlayerModel delete();
            
        wait .1;
        self.spawnedPlayerModel = Spawn( "script_model", self.origin );
        self.spawnedPlayerModel SetModel( model );
        //self HideAllParts();
        self customprint( "Model Set To: ^2"+ model );

        while(isDefined(self.ModelManipulation) && isAlive(self))
        {
            self.spawnedPlayerModel MoveTo( self.origin, .1 );
            self.spawnedPlayerModel RotateTo( self.angles, .1 );
            wait .1;
        }
        
        self resetPlayerModel();
    }

    ResetPlayerModel()
    {
        self.ModelManipulation = undefined;
        self.spawnedPlayerModel delete();
        self ShowAllParts();
    }

