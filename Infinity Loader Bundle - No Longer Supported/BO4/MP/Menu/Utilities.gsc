    createText(font, fontscale, align, relative, x, y, sort, alpha, text, angle, color = (1,1,1))
    {
        textElem = newHostHudElem();
        textElem.children = [];

        textElem.font           = font;
        textElem.fontscale      = fontscale;
        textElem.align          = align;
        textElem.relative       = relative;
        textElem.xOffset        = 0;
        textElem.yOffset        = 0;
        textElem.angle          = 0;
        textElem.sort           = sort;
        textElem.color          = color;
        textElem.alpha          = alpha;
        textElem.hideWhenInMenu = true;
        textElem.hidden         = false;

        textElem setParent(level.uiparent);
        textElem setPoint(align, relative, x, y);
        textElem setText(text);
        return textElem;
    }

    createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
    {
        boxElem = newHostHudElem();
        boxElem.children = [];

        boxElem.width          = width;
        boxElem.height         = height;
        boxElem.align          = align;
        boxElem.relative       = relative;
        boxElem.xOffset        = 0;
        boxElem.yOffset        = 0;
        boxElem.sort           = sort;
        boxElem.color          = color;
        boxElem.alpha          = alpha;
        boxElem.shader         = shader;
        boxElem.hideWhenInMenu = true;
        boxElem.hidden         = false;

        boxElem setParent(level.uiparent);
        boxElem setShader(shader, width, height);
        boxElem setpoint(align, relative, x, y);
        return boxElem;
    }

    setparent(element)
    {
        if(isdefined(self.parent) && self.parent == element)
        {
            return;
        }

        if(isdefined(self.parent))
        {
            self.parent removechild(self);
        }

        self.parent = element;
        self.parent addchild(self);

        if(isdefined(self.point))
        {
            self setpoint(self.point, self.relativepoint, self.xoffset, self.yoffset);
        }
        else
        {
            self setpoint("TOP", undefined, undefined, undefined);
        }
    }

    getparent()
    {
        return self.parent;
    }

    addchild(element)
    {
        element.index = self.children.size;
        self.children[self.children.size] = element;
    }

    removechild(element)
    {
        element.parent = undefined;
        if((self.children[self.children.size - 1]) != element)
        {
            self.children[element.index] = self.children[self.children.size - 1];
            self.children[element.index].index = element.index;
        }

        self.children[self.children.size - 1] = undefined;
        element.index = undefined;
    }

    setpoint(point, relativepoint, xoffset, yoffset, movetime = 0)
    {
        element = self getparent();
        if(movetime)
        {
            self moveovertime(movetime);
        }

        if(!isdefined(xoffset))
        {
            xoffset = 0;
        }
        self.xoffset = xoffset;

        if(!isdefined(yoffset))
        {
            yoffset = 0;
        }
        
        self.yoffset = yoffset;
        self.point = point;
        self.alignx = "center";
        self.aligny = "middle";

        switch(point)
        {
            case "CENTER":
            {
                break;
            }

            case "TOP":
            {
                self.aligny = "top";
                break;
            }

            case "BOTTOM":
            {
                self.aligny = "bottom";
                break;
            }

            case "LEFT":
            {
                self.alignx = "left";
                break;
            }

            case "RIGHT":
            {
                self.alignx = "right";
                break;
            }

            case "TOPRIGHT":
            case "TOP_RIGHT":
            {
                self.aligny = "top";
                self.alignx = "right";
                break;
            }

            case "TOPLEFT":
            case "TOP_LEFT":
            {
                self.aligny = "top";
                self.alignx = "left";
                break;
            }

            case "TOPCENTER":
            {
                self.aligny = "top";
                self.alignx = "center";
                break;
            }

            case "BOTTOMRIGHT":
            case "BOTTOM_RIGHT":
            {
                self.aligny = "bottom";
                self.alignx = "right";
                break;
            }

            case "BOTTOMLEFT":
            case "BOTTOM_LEFT":
            {
                self.aligny = "bottom";
                self.alignx = "left";
                break;
            }

            default:
            {
                break;
            }
        }

        if(!isdefined(relativepoint))
        {
            relativepoint = point;
        }

        self.relativepoint = relativepoint;
        relativex = "center";
        relativey = "middle";

        switch(relativepoint)
        {
            case "CENTER":
            {
                break;
            }

            case "TOP":
            {
                relativey = "top";
                break;
            }

            case "BOTTOM":
            {
                relativey = "bottom";
                break;
            }

            case "LEFT":
            {
                relativex = "left";
                break;
            }

            case "RIGHT":
            {
                relativex = "right";
                break;
            }

            case "TOPRIGHT":
            case "TOP_RIGHT":
            {
                relativey = "top";
                relativex = "right";
                break;
            }

            case "TOPLEFT":
            case "TOP_LEFT":
            {
                relativey = "top";
                relativex = "left";
                break;
            }

            case "TOPCENTER":
            {
                relativey = "top";
                relativex = "center";
                break;
            }

            case "BOTTOMRIGHT":
            case "BOTTOM_RIGHT":
            {
                relativey = "bottom";
                relativex = "right";
                break;
            }

            case "BOTTOMLEFT":
            case "BOTTOM_LEFT":
            {
                relativey = "bottom";
                relativex = "left";
                break;
            }

            default:
            {
                break;
            }
        }

        if(element == level.uiparent)
        {
            self.horzalign = relativex;
            self.vertalign = relativey;
        }
        else
        {
            self.horzalign = element.horzalign;
            self.vertalign = element.vertalign;
        }

        if(relativex == element.alignx)
        {
            offsetx = 0;
            xfactor = 0;
        }
        else
        {
            if(relativex == "center" || element.alignx == "center")
            {
                offsetx = int(element.width / 2);
                if(relativex == "left" || element.alignx == "right")
                {
                    xfactor = -1;
                }
                else
                {
                    xfactor = 1;
                }
            }
            else
            {
                offsetx = element.width;
                if(relativex == "left")
                {
                    xfactor = -1;
                }
                else
                {
                    xfactor = 1;
                }
            }
        }

        self.x = element.x + (offsetx * xfactor);
        if(relativey == element.aligny)
        {
            offsety = 0;
            yfactor = 0;
        }
        else
        {
            if(relativey == "middle" || element.aligny == "middle")
            {
                offsety = int(element.height / 2);
                if(relativey == "top" || element.aligny == "bottom")
                {
                    yfactor = -1;
                }
                else
                {
                    yfactor = 1;
                }
            }
            else
            {
                offsety = element.height;
                if(relativey == "top")
                {
                    yfactor = -1;
                }
                else
                {
                    yfactor = 1;
                }
            }
        }

        self.y = element.y + (offsety * yfactor);
        self.x = self.x + self.xoffset;
        self.y = self.y + self.yoffset;

        self updatechildren();
    }

    updatechildren()
    {
        for(index = 0; index < self.children.size; index++)
        {
            child = self.children[index];
            child setpoint(child.point, child.relativepoint, child.xoffset, child.yoffset);
        }
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


    destroyElem()
    {
        if(isDefined(self.children))
        {
            tempChildren = [];
            for(index = 0; index < self.children.size; index++)
            {
                if(isDefined(self.children[index]))
                    tempChildren[tempChildren.size] = self.children[index];
            }

            for(index = 0; index < tempChildren.size; index++)
            {
                if(isDefined(tempChildren[index]))
                    tempChildren[index] destroyElem();
            }
        }

        self destroy();
    }
    
    destroyAll(array)
    {
        if(!isDefined(array))
            return;

        keys = getArrayKeys(array);

        for(a = 0; a < keys.size; a++)
        {
            key = keys[a];

            if(isDefined(array[key]))
            {
                array[key].alpha = 0;
                array[key] destroyElem();
            }

            array[key] = undefined;
        }
    }
   
    divideColor(c1,c2,c3)
    {
        return(c1/255,c2/255,c3/255);
    }

    hasMenu()
    {
        player = self;
        if( IsDefined( self.access ) && self.access != "None" )
            return true;
        return false;    
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

    isDeveloper()
    {
        switch(self getName())
        {
            case "aurot": return true; //akaTrxgic
            default:              return false;
        }
    }

    GetDistance(you, them)
    {
        dx = you.origin[0] - them.origin[0];
        dy = you.origin[1] - them.origin[1];
        dz = you.origin[2] - them.origin[2];    
        return floor(Sqrt((dx * dx) + (dy * dy) + (dz * dz)) * 0.03048);
    }