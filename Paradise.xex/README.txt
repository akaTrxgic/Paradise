* Take Paradise.xex and drop it on the root of your HDD

* Take the game folders and move each of the raw folders to the root of it's respective game path
ie HDD\Games\BO1\raw\mp\Paradise BO1.gsc

* Load the .xex via a module loader with a title launched

  COD4, WAW, BO1 and NX1: File must be a .gsc
  MW2 and MW3: File must be a .gscbin

* Files can be any name, single file support only !!

Custom GSC Funcs:

WriteByte("address", "value");
WriteShort("address", "value");
WriteInt("address", "value");
WriteFloat("address", "value");
WriteString("address", "value");
ReadByte("address");
ReadShort("address");
ReadInt("address");
ReadFloat("address");
ReadString("address");
RPC("address", "arg1", "arg2", "arg3", "arg4", "arg5", "arg6", "arg7", "arg8" );

bans.txt:
* If you want to have a set list of gamertags banned from being in your lobby, fill them out in the bans.txt (not case specific)

ie
Gamertag1 (can also be gamertag1)
Gamertag2
Gamertag3