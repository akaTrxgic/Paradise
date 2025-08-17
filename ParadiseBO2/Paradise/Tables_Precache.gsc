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
    bo2precache()
    {
        level.status = [ "None","^2Verified","^3VIP","^5CoHost","^1Host" ];
		level.MenuName = "^7Paradise BO2";
        level.Version = "0.1";   
        precacheshader ("gradient_top");
        precacheshader ("gradient");
        precacheshader ("hudsoftline");
		precacheshader ("white");
        precachemodel("t6_wpn_supply_drop_ally");
    }


 



