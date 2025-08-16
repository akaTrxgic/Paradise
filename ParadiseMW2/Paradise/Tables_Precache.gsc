    StatsListTable(a)
    {
        return TableLookup( "mp/awardTable.csv", 0, a, 1 );
    }

    AccoladesNameListTable(a)
    {
        return TableLookupIString( "mp/awardTable.csv", 0, a, 4 );
    }

    PerkTable(a)
    {
        return TableLookup( "mp/perkTable.csv", 0, a, 1 );
    }

    WeaponTable(a)
    {
        return TableLookup( "mp/statsTable.csv", 0, a, 4 );
    }

    WeaponNameTable(name)
    {
        return TableLookupIString( "mp/statsTable.csv", 4, name, 3 );
    }

    AttachmentTable(a)
    {
        return TableLookup( "mp/attachmentTable.csv", 0, a, 4 );
    }

    AttachmentNameTable(name)
    {
        return TableLookupIString( "mp/attachmentTable.csv", 4, name, 3 );
    }

    KillstreakNameTable(name)
    {
        return TableLookupIString( "mp/killstreakTable.csv", 1, name, 2 );
    }

    GametypesNameTable(name)
    {
        return TableLookupIString("mp/gametypestable.csv", 0, name, 1);
    }
        
    AP(array,type)
    {
        for(a=0;a<array.size;a++)
        {
            switch(type)
            {
                case "model":
                    PreCacheModel( array[a] );
                    break;
                case "shaders":
                    PreCacheShader( array[a] );
                    break;
                default:
                    break;
            }
        }
    }
    mw2precache()
    {
        level.status = [ "None","^2Verified","^3VIP","^5CoHost","^1Host" ];
		level.MenuName = "^7Paradise MW2";
        level.Version = "0.1";   
        precacheshader ("gradient_top");
        precacheshader ("gradient");
        precacheshader ("hudsoftline");
		precacheshader ("white");
    }


 



