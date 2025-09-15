NoClip()
{
    if (self.ufo == true)
    {
        self notify("stop_ufo");
        self.ufo = false;
    }
    else
    {
        self thread onUfo();
        self.ufo = true;
    }
}

onUfo()
{
    self endon("stop_ufo");
    
    if (isdefined(self.N))
    self.N delete();
    
    self.N = spawn("script_origin", self.origin);
    self.On = 0;
    
    for (;;)
    {
        if (self SecondaryOffHandButtonPressed())
        {
            self.On = 1;
            self.N.origin = self.origin;
            self linkto(self.N);
        }
        else
        {
            self.On = 0;
            self unlink();
        }
        
        if (self.On == 1)
        {
            vec = anglestoforward(self getPlayerAngles());
            end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
            self.N.origin = self.N.origin + end;
        }
        
        wait 0.05;
    }
}

getprimary()
{
    class = self.class;
    class_num = int(class[class.size-1]) - 1;
    return self.custom_class[class_num]["primary"];
}

getsecondary()
{
    class = self.class;
    class_num = int(class[class.size-1]) - 1;
    return self.custom_class[class_num]["secondary"];
}

normalbounce()
{
    // Get the hit position where the player is aiming
    bouncePos = bullettrace(
        self gettagorigin("j_head"), 
        self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 10000, 
        0, 
        self
    )["position"] + (0, 0, 10);

    // Spawn the trampoline model at that position, rotated on its side
    trampoline = spawn("script_model", bouncePos);
    trampoline.angles = (0, 0, 90); // rotate 90 degrees roll
    trampoline setModel("com_plasticcase_beige_big");

    // Start monitoring player interaction with trampoline
    self thread monitortrampoline(trampoline);

    self iprintln("Bounce ^2Spawned!");
}

monitortrampoline(model)
{
    self endon("disconnect");
    level endon("game_ended");

    cooldown = false;

    for (;;)
    {
        playerPos = self.origin;
        modelPos = model.origin;

        deltaX = playerPos[0] - modelPos[0];
        deltaY = playerPos[1] - modelPos[1];
        horizontalDist = sqrt(deltaX * deltaX + deltaY * deltaY);

        verticalDist = abs(playerPos[2] - modelPos[2]);

        // Trigger bounce if close horizontally and vertically (walking or jumping on)
        if (!cooldown && horizontalDist < 85 && verticalDist < 50)
        {
            cooldown = true;

            startOrigin = self.origin;
            duration = 0.7;    // lift time in seconds
            steps = 20;        // number of interpolation steps
            stepTime = duration / steps;

            // Smoothly lift the player up 500 units
            for (i = 0; i <= steps; i++)
            {
                fraction = i / steps;
                newOrigin = startOrigin + (0, 0, 500 * fraction);
                self setOrigin(newOrigin);
                wait stepTime;
            }

            wait 1; // cooldown to prevent immediate repeat

            cooldown = false;
        }

        wait 0.01;
    }
}

slide() 
{
    self thread makeSlide(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"] + (0, 0, 20), self getPlayerAngles());
    self iPrintln("Slide ^2Spawned");
}

isInPos(sP) 
{
    if (distance(self.origin, sP) < 100)
        return true;
    else
        return false;
}

makeSlide(slidePos, direction)
{
    level endon("game_ended");
    self endon("disconnect");
    self endon("stop_slide");

    level.CP = spawn("script_model", slidePos);
    playngles = self getPlayerAngles();
    level.CP.angles = (0, playngles[1] + 90, 50);
    level.CP setModel("com_plasticcase_beige_big");

    for (;;)
    {
        foreach(player in level.players)
        {
            if (player isInPos(slidePos) && player meleeButtonPressed())
            {
                // Define starting and target positions
                startOrigin = player.origin;
                targetOrigin = startOrigin + (0, 0, 0);
                
                // Smooth movement parameters
                duration = 1.0; // Time in seconds to complete the movement
                steps = 20; // Number of interpolation steps
                stepTime = duration / steps; // Time per step

                // Move player smoothly over multiple frames
                for (i = 0; i <= steps; i++)
                {
                    // Calculate interpolated position
                    fraction = i / steps;
                    newOrigin = startOrigin + (0, 0, 500 * fraction);
                    player setOrigin(newOrigin);
                    wait stepTime; // Wait for the next frame
                }

                wait 1; // Cooldown to prevent spamming
            }
        }
        wait 0.05; // Frame wait for the main loop
    }
}
