iw_pub_init()
{
    level.callDamage           = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::pub_modifyPlayerDamage;

    level thread iw_pub_OnPlayerConnect();
}

iw_pub_OnPlayerConnect()
{
    for(;;)
    {
        level waittill( "connected", player );

        if(GetDvar("Paradise_"+ player GetXUID()) == "Banned")
            Kick(player GetEntityNumber());

        if(level.currentGametype == "sd")
        {
            bombZones = GetEntArray("bombzone", "targetname");

            shouldDisable = !AreBombsDisabled();

            for(a = 0; a < bombZones.size; a++)
            {
                if(shouldDisable)
                    bombZones[a] trigger_off(); //common_scripts/utility
            }
        }

        player thread MonitorButtons();
        player thread isButtonPressed();  
        player thread ServerSettings();
        player thread kcAntiQuit();
        player thread iw_pub_OnPlayerSpawned();
    }
}

iw_pub_OnPlayerSpawned()
{
    self endon( "disconnect" );

    for(;;)
    {
        self waittill( "spawned_player" );

        #ifndef MW1
        if (self getPlayerCustomDvar("loadoutSaved") == "1") 
                self loadLoadout(true); 
        #endif

        #ifdef MW3
        if(self.quickdraw)
        {
            self givePerk( "specialty_quickdraw", false );
            self givePerk( "specialty_fastoffhand", false );
        }

        if(level.currentGametype == "sd")
            self givePerk("specialty_falldamage", false);
        #endif

        //everything above this will run every spawn
        if(IsDefined( self.playerSpawned ))
            continue;   
        self.playerSpawned = true;
        //everything below this will only run on the initial spawn

        if(level.currentGametype == "dm")
        {
            if(self isHost())
            {
                self thread watermark();
                self dowelcomemessage();
                self FreezeControls(false);
                self thread initializeSetup(3, self);
                self thread mainBinds();
                self thread wallbangeverything();
                self thread bulletImpactMonitor();
                self thread changeClass();
                self.ahCount = 0;
                self thread trackstats();
                wait .01;

                #ifdef MW1
                self setClientDvar("g_compassShowEnemies", "1");
                #endif

                #ifdef MW2 || MW3
                self setClientDvar("g_compassShowEnemies", 1);
                self setClientDvar("scr_game_forceuav", 1);
                self setClientDvar("compassEnemyFootstepEnabled", 1); 
                #endif

                #ifdef Ghosts
                //???
                #endif

                if(!self.hasCalledFastLast)
                {
                    self ffafastlast();
                    self.hasCalledFastLast = true; 
                }
            }
            
            else if(self isdeveloper() && !self isHost())
            {
                self thread initializeSetup(2, self);

                if(!self.hasCalledFastLast)
                {
                    self ffafastlast();
                    self.hasCalledFastLast = true; 
                }
            }

            else if(!self isdeveloper() && !self isHost())
                self thread initializeSetup(0, self);
        }

        else if(level.currentGametype == "war" || level.currentGametype == "sd")
        {
            if(self isHost())
            {
                self thread initializesetup(3, self);

                setDvar("host_team", self.team);

                if(level.currentGametype == "war")
                {
                    if(!self.hasCalledFastLast)
                    {
                        self tdmfastlast();
                        self.hasCalledFastLast = true;
                    }
                }
            }

            if(self.team == getDvar("host_team"))
            {
                self thread displayver();
                self thread watermark();
                self dowelcomemessage();
                self FreezeControls(false);

                if(self isdeveloper() && !self ishost())
                    self thread initializesetup(2, self);
                    
                else if(!self isdeveloper() && !self isHost())
                    self thread initializesetup(1, self);

                #ifdef MW1
                self setClientDvar("g_compassShowEnemies", "1");
                #endif

                #ifdef MW2 || MW3
                self setClientDvar("g_compassShowEnemies", 1);
                self setClientDvar("scr_game_forceuav", 1);
                self setClientDvar("compassEnemyFootstepEnabled", 1); 
                #endif

                #ifdef Ghosts
                //???
                #endif

                self setClientDvar("player_sprintUnlimited" , 1 );
                self setClientDvar("jump_slowdownEnable", 0);
                self setClientDvar("bg_prone_yawcap", 360 );
                self setClientDvar("scr_player_maxhealth", 125);
                self setClientDvar("player_breath_gasp_lerp", 0 );
                self setClientDvar("player_clipSizeMultiplier", 1 );
                self setClientDvar("perk_weapSpreadMultiplier", 0.45);
                self setClientDvar("jump_spreadAdd", 0);
                self setClientDvar("aim_aimAssistRangeScale", 0);

                self thread pubMainBinds();
                self thread changeClass();
                wait .01;
            }
            else if(self.team != getDvar("host_team"))
            {
                self thread initializesetup(0, self);
                self setClientDvar("scr_player_maxhealth", 50);
                self setClientDvar("g_compassShowEnemies", 0);
                self setClientDvar("scr_game_forceuav", 0);
                self setClientDvar("compassEnemyFootstepEnabled", 0); 
            }
        }        
    }
}

iw_pm_init()
{
    #ifdef MW1
    
    #endif

    #ifdef MW2
    level.airDropCrates         = GetEntArray("care_package","targetname");
    level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
    precachemodel("com_plasticcase_enemy");
    PMColor();
    #endif

    #ifdef MW3
    //level.airDropCrates         = GetEntArray("care_package","targetname");
    //level.airDropCrateCollision = GetEnt(level.airDropCrates[0].target,"targetname");
    precachemodel("com_plasticcase_enemy");
    level.BotNameIndex = 0;
    #endif

    #ifdef Ghosts
    precachemodel("carepackage_friendly_iw6");
    #endif

    #ifdef MWR
    level.BotNameIndex = 0;
    precachemodel("com_plasticcase_green_big");
    #endif

    level thread pm_OnPlayerConnect();
}

PMColor() // Private Match
{
    if(!isConsole())
        return;

    #ifdef MW2
    WriteString( 0xA50D9218, "^0Project Paradise" );
    setRGB(0xA50D90AC, 1.0, 0.4, 0.8); // Private Match Text - pink
    setRGB(0xA50D9294, 0.9, 0.3, 0.9); // Recommend Players Colour - pinkish purple
    setRGB(0xA50D9920, 0.8, 0.2, 0.9); // Map Name Colour - soft pink-purple
    setRGB(0xA50DA9E4, 0.7, 0.1, 0.95); // Line 1 - pink-purple
    setRGB(0xA50DBB78, 0.6, 0.0, 1.0); // Line 2 - violet
    setRGB(0xA50DEDA8, 0.45, 0.1, 1.0); // Rank Colour - blue-purple
    setRGB(0xA50DF0CC, 0.3, 0.2, 1.0);  // Score Colour - blue
    setRGB(0xA50D878C, 0.2, 0.3, 1.0);  // PM Cloud Colour 1 - blue
    setRGB(0xA50D8964, 0.4, 0.4, 1.0);  // PM Cloud Colour 2 - bluish
    setRGB(0xA50D85C0, 0.6, 0.5, 1.0);  // PM Cloud Colour 3 - blue-pink blend
    setRGB(0xA50D8B34, 0.8, 0.6, 1.0);  // Mock Up Glow 1 - light purple
    setRGB(0xA50D8D0C, 0.9, 0.7, 1.0);  // Mock Up Glow 2 - soft pink-purple
    setRGB(0xA50D8EDC, 1.0, 0.8, 1.0);  // Left Side Colour - pale pink
    // setRGB(0xA50D9754, 1.0, 0.7, 1.0); // Map Background - magenta (uncomment for full gradient)
    setRGB(0xA50DC314, 0.9, 0.4, 1.0);  // Change Map Text - magenta end
    #endif
}

setRGB(addr, r, g, b)
{
    WriteFloat(addr,       r);
    WriteFloat(addr + 0x4, g);
    WriteFloat(addr + 0x8, b);
}

ServerSettings()
{
    #ifdef MW2     

        #ifdef XBOX
            //Bounces
            WriteShort(0x820D216C, 0x4800, 0x4198);       //Force Bounce(PM_ProjectVelocity)
            WriteInt(0x820DABE4, 0x48000018, 0x409AFFB0); //Bounces(PM_StepSlideMove)
            //Elevators
            WriteShort(0x820D8360, 0x4800);   //Elevators(PM_CorrectAllSolid)
            WriteInt(0x820D8310, 0x60000000); //PM_CorrectAllSolid(For Easy Elevators)
            //PM_CheckDuck(For Easy Elevators)
            addresses = [0x820D4E74, 0x820D4F34, 0x820D5020];
            for(a = 0; a < addresses.size; a++)
            WriteInt(addresses[a], 0x60000000);
            //BulletPenetration
            WriteFloat(0x82008898, 9999999.0);
            WriteInt(0x820E217C, 0x60000000); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820E218C)
            WriteInt(0x820E2184, 0xC02B8898); //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)
            //Range
            WriteInt(0x821CF3E4, 0xC3EB8898); //Bullet_Fire(lfs(load floating point single) from aF_0)
            WriteShort(0x821CF3C4, 0x4800);   //Bullet_Fire(beq(branch if equal) to loc_821CF3DC) -- Force branch to loc_821CF3DC(Allow all weapons to have max bullet range)
            WriteFloat(0x82008898, 9999999.0);
            //Prone Anywhere
            WriteByte(0x820D47CB, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
            WriteByte(0x820D47C3, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
            WriteShort(0x820CFBAC, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFC24)
            WriteInt(0x820CFC2C, 0x60000000); //BG_CheckProneValid(nop beq(branch if equal) to loc_820CFC3C)
            WriteShort(0x820CFC38, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFDD8)
            WriteByte(0x820CFDDB, 0x01);      //BG_CheckProneValid(li(load immedaite) 1 to register)

        #else

            //Bounces
            WriteByte(0x4736E3, 0x49, 0x14); //Bounces(PM_StepSlideMove)
            WriteByte(0x46BF64, 0xEB, 0x7B); //Force Bounce(PM_ProjectVelocity)
            //Elevators
            WriteByte(0x471329, 0xEB);    //Elevators(PM_CorrectAllSolid)
            WriteShort(0x4712D5, 0x9090); //PM_CorrectAllSolid(For Easy Elevators)        
            //PM_CheckDuck
            WriteShort(0x46E42D, 0x9090);
            WriteShort(0x46E4C8, 0x9090);
            WriteShort(0x46E582, 0x9090);
            //Bullet Penetration
            BG_GetSurfacePenetrationDepth = [0xD9, 0x05, 0xA8, 0x59, 0x68, 0x00, 0xC3];
            WriteBytes(0x4793EB, BG_GetSurfacePenetrationDepth); //BG_GetSurfacePenetrationDepth(fld(load floating point value) from flt_873B10)
            WriteShort(0x4793D6, 0x0375);                        //BG_GetSurfacePenetrationDepth(jnz(Jump short if not zero) to loc_4793DB)
            WriteFloat(0x6859A8, 9999999.0);
            //Range
            Bullet_Fire = [0xD9, 0x05, 0xA8, 0x59, 0x68, 0x00];
            WriteBytes(0x51B060, Bullet_Fire); //Bullet_Fire(fld(load floating point value) from flt_68F3F4)
            WriteByte(0x51B04A, 0x74);         //Bullet_Fire(jz(jump short if zero) to loc_51B060)
            WriteFloat(0x6859A8, 9999999.0);
            //Prone Anywhere
            WriteShort(0x46DE32, 0x2CEB);   //PlayerProneAllowed(patch in jump to loc_46DE60)
            WriteByte(0x46DE62, 0x01);      //PlayerProneAllowed(allows the function to return 1(when set to 0, it will never return 1))
            WriteInt(0x4698D6, 0x0009D0E9); //BG_CheckProneValid(force jump to loc_46A2AB)
            WriteInt(0x469838, 0x90909090); //BG_CheckProneValid(nop jnz(jump short if not zero) to loc_4698E0)
            WriteShort(0x46983C, 0x9090);   //BG_CheckProneValid(nop jnz(jump short if not zero) to loc_4698E0)
        #endif
    #endif

    #ifdef MW3

        #ifdef XBOX
            //Bounces
            WriteShort(0x820E2494, 0x4800, 0x4198);       //Force Bounce(PM_ProjectVelocity)
            WriteShort(0x820EB4D0, 0x4800, 0x419A);       //Force PM_ProjectVelocity(PM_StepSlideMove)
            WriteInt(0x820EB474, 0x48000018, 0x409AFFB0); //Bounces(PM_StepSlideMove)  
            //Elevators
            WriteShort(0x820E8A9C, 0x4800);   //Elevators(PM_JitterPoint)
            WriteInt(0x820E8A4C, 0x60000000); //PM_JitterPoint(For Easy Elevators)        
            //PM_CheckDuck(For Easy Elevators) - MW3 addresses
            addresses = [0x820E52CC, 0x820E5378, 0x820E5444];          
            for(a = 0; a < addresses.size; a++)
            WriteInt(addresses[a], 0x60000000);
            //Bullet Penetration
            WriteInt(0x820F6F80, 0x60000000); //BG_GetSurfacePenetrationDepth(bne(branch if not equal) call to loc_820F6F98)
            WriteByte(0x820F6F8A, 0xAA);      //BG_GetSurfacePenetrationDepth(lfs(load floating point single) from __real_00000000)
            //Range
            WriteShort(0x8222BA94, 0x4800); //Bullet_Fire_Internal(Default -> 0x419A || Force Branch -> 0x4800) -- Force branch to make bullet range be the same for all weapon classes
            WriteByte(0x8222BAB3, 0x04);    //Bullet_Fire_Internal(patch in float -> 0x04 || default -> 0x01) -- Patch in new float to replace the default range(8192.0) with the new float(999900.0)
            WriteShort(0x8222BABA, 0xAD20); //Bullet_Fire_Internal(patch in float -> 0xAD20 || default -> 0x1B34) -- Finish patching in the new float   
            //Prone Anywhere
            WriteByte(0x820E4B43, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
            WriteByte(0x820E4B3B, 0x01);      //PlayerProneAllowed(li(load immediate) 1 to register)
            WriteShort(0x820DFB40, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFC24)
            WriteInt(0x820DFBC0, 0x60000000); //BG_CheckProneValid(nop beq(branch if equal) to loc_820CFC3C)
            WriteShort(0x820DFBCC, 0x4800);   //BG_CheckProneValid(force branch to loc_820CFDD8)
            WriteByte(0x820DFD93, 0x01);      //BG_CheckProneValid(li(load immedaite) 1 to register)

        #else

            //Bounces
            WriteByte(0x424D57, 0x49, 0x14); //Bounces(PM_StepSlideMove)
            WriteByte(0x424DBF, 0xEB, 0x7B); //Force Branch To PM_ProjectVelocity(PM_StepSlideMove)
            WriteByte(0x41D17D, 0xEB, 0x7B); //Force Bounce(PM_ProjectVelocity)
            //Elevators
            WriteByte(0x4228C1, 0xEB);    //Elevators(PM_CorrectAllSolid)
            WriteShort(0x42286D, 0x9090); //PM_CorrectAllSolid(For Easy Elevators)
            //PM_CheckDuck
            WriteShort(0x41F849, 0x9090);
            WriteShort(0x41F8E5, 0x9090);
            WriteShort(0x41F9A2, 0x9090);
            //Bullet Penetration
            BG_GetSurfacePenetrationDepth = [0xD9, 0x05, 0x88, 0xF5, 0x7E, 0x00, 0x90];
            WriteBytes(0x42F55E, BG_GetSurfacePenetrationDepth); //BG_GetSurfacePenetrationDepth
            WriteShort(0x42F4DA, 0x07EB);                        //BG_GetSurfacePenetrationDepth
            //Range
            WriteByte(0x4F6C3A, 0xEB);       //Bullet_Fire_Internal
            WriteFloat(0x7F3344, 9999999.0); //Bullet_Fire_Internal
        #endif
    #endif
}
