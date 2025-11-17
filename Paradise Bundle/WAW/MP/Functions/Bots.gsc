addTestClients() {
  wait 5;
  for(;;) {
    if(getdvarInt("scr_testclients") > 0) {
      break;
    }
    wait 1;
  }
  testclients = getdvarInt("scr_testclients");
  setDvar("scr_testclients", 0);
  for(i = 0; i < testclients; i++) {
    ent[i] = addtestclient();
    if(!isDefined(ent[i])) {
      println("Could not add test client");
      wait 1;
      continue;
    }
    ent[i].pers["isBot"] = true;
    ent[i] thread TestClient("autoassign");
  }
  thread addTestClients();
}

TestClient(team) {
  self endon("disconnect");
  while(!isDefined(self.pers["team"]))
    wait .05;
  self notify("menuresponse", game["menu_team"], team);
  wait 0.5;
  classes = getArrayKeys(level.classMap);
  okclasses = [];
  for(i = 0; i < classes.size; i++) {
    if(!issubstr(classes[i], "offline_class11_mp") && !issubstr(classes[i], "custom") && isDefined(level.default_perk[level.classMap[classes[i]]]))
      okclasses[okclasses.size] = classes[i];
  }
  assert(okclasses.size);
  while(1) {
    class = okclasses[randomint(okclasses.size)];
    if(!level.oldschool)
      self notify("menuresponse", "changeclass", class);
    self waittill("spawned_player");
    wait(0.10);
  }
}
