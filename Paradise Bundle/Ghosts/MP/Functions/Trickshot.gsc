test()
{
    self iprintln("paradise");
}

toggletest()
{
    if(!self.paradise)
    {
        self.paradise = 1;
        self iprintln("paradise");
    }
    else
        self.paradise = 0;
}