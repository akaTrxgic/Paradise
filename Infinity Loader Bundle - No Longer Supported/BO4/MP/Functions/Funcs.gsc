test()
{
    self iprintln("^" + randomintrange(1,8) + "TEST");
}

toggleTest()
{
    if(!isDefined(self.toggleTest) || !self.toggleTest)
        self.toggleTest = true;
        
    else
        self.toggleTest = false;
}

valueSliderTest(input)
{
    self iprintln("^" + randomintrange(1,8) + "TEST " + input);
}

stringSliderTest(input)
{
    self iprintln("^" + randomintrange(1,8) + "TEST " + input);
}