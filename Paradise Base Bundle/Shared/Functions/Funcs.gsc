test()
{
    self iprintln("^" + randomintrange(1,8) + "TEST");
}

toggleTest()
{
    if(!self.toggleTest)
    {
        self.toggleTest = 1;
        self iprintln("^" + randomintrange(1,8) + "TEST");
    }
    else if(self.toggleTest)
        self.toggleTest = 0;
}

valueSliderTest(input)
{
    self iprintln("^" + randomintrange(1,8) + "TEST " + input);
}

stringSliderTest(input)
{
    self iprintln("^" + randomintrange(1,8) + "TEST " + input);
}