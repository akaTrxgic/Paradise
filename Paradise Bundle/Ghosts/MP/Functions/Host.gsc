endGame()
{
    level thread maps\mp\gametypes\_gamelogic::forceEnd();
}

AzzaLobby()
{
    if(!level.AzzaLobby)
    {
        SetDvar("xblive_privatematch",0);
        SetDvar("onlinegame",1);
        level.AzzaLobby = true;
        level thread menuFix();
        self iPrintln("Azza Lobby: [^2ON^7]");
    }
    else if(level.AzzaLobby)
    {
        SetDvar("xblive_privatematch",1);
        SetDvar("onlinegame",0);
        level.AzzaLobby = false;
        level notify("stopMenuFix");
        self iPrintln("Azza Lobby: [^1OFF^7]");
    }
}

