// Add BIS_BAF and BIS_TK_GUE Air groups for Ambient Aircraft

	class West
	{
		name = "$STR_WEST";
		class BIS_BAF
		{
			class Air 
			{
				class BAF_CH47FFlight
				{
					name = "BAF_CH47FFlight";
					faction = "BIS_BAF";
					rarityGroup = 0.3;
					minAltitude = 60;
					maxAltitude = 150;
					class Unit0
					{
						side = 1;
						vehicle = "CH_47F_BAF";
						rank = "CAPTAIN";
						position[] = {0,0,0};
					};
				};
				class BAF_AW159LynxFlight
				{
					name = "BAF_AW159LynxFlight";
					faction = "BIS_BAF";
					rarityGroup = 0.3;
					minAltitude = 40;
					maxAltitude = 100;
					class Unit0
					{
						side = 1;
						vehicle = "AW159_Lynx_BAF";
						rank = "CAPTAIN";
						position[] = {0,0,0};
					};
				};
				class BAF_AH64DFlight
				{
					name = "BAF_AH1DApacheFlight";
					faction = "BIS_BAF";
					rarityGroup = 0.3;
					minAltitude = 40;
					maxAltitude = 100;
					class Unit0
					{
						side = 1;
						vehicle = "BAF_Apache_AH1_D";
						rank = "CAPTAIN";
						position[] = {0,0,0};
					};
				}
				class BAF_HC3DMerlinFlight
				{
					name = "BAF_HC3DMerlinFlight";
					faction = "BIS_BAF";
					rarityGroup = 0.3;
					minAltitude = 60;
					maxAltitude = 150;
					class Unit0
					{
						side = 1;
						vehicle = "BAF_Merlin_HC3_D";
						rank = "CAPTAIN";
						position[] = {0,0,0};
					};
				};
			};
		};
	};
	class Guerrila
	{
		name = "$STR_EP1_DN_CfgGroups_Guerrila";
		class BIS_TK_GUE
		{
			class Air
			{
				class TK_GUE_UH1HFlight
				{
					name = "TK_GUE_UH1HFlight";
					faction = "BIS_BAF";
					rarityGroup = 0.3;
					minAltitude = 60;
					maxAltitude = 150;
					class Unit0
					{
						side = 1;
						vehicle = "UH1H_TK_GUE_EP1";
						rank = "CAPTAIN";
						position[] = {0,0,0};
					};
				};
			};
		};
	};
