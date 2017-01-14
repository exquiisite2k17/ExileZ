waitUntil {!(isNull (findDisplay 46))};
	disableSerialization;
	uiSleep 4;
	
	waitUntil {
		(!isNil {round (ExileClientPlayerAttributes select 3)}) && (!isNil {round (ExileClientPlayerAttributes select 2)});
	};
	
	sb_hideExileIcons = {
		
		waitUntil {(!isNil {uiNamespace getVariable "RscExileHUD"})};
		_display = uiNamespace getVariable "RscExileHUD";
		_ctrl = _display displayCtrl 1300;
		_ctrl ctrlSetPosition [-10,-10,0,0];
		_ctrl ctrlCommit 0;
		
	};
	
	TOGGLESTUFF = {
		if (player getVariable "infotoggled" isEqualTo true) then {
			player setVariable["infotoggled",false];
		} else {
			player setVariable["infotoggled",true];
		};
	};
	
	sb_maintainInfo = {
		_currentInfo = player getVariable "sb_info";
		_currentToggled = player getVariable "infotoggled";
		_w = 0.15;
		_h = _w * 3/4;
		_display = uiNamespace getVariable "StatusIcons"; 
		
		
		
		
			_health = round ((1 - (damage player)) * 100);
			_hunger = round (ExileClientPlayerAttributes select 2);
			_thirst = round (ExileClientPlayerAttributes select 3);
			
			_ctrl = _display displayCtrl 13382;
			_ctrl ctrlSetText format["%1%2",_health,'%'];
			_ctrl = _display displayCtrl 13383;
			_ctrl ctrlSetText format["%1%2",_hunger,'%'];
			_ctrl = _display displayCtrl 13384;
			_ctrl ctrlSetText format["%1%2",_thirst,'%'];
		
		
		_hideControl = {
			_idc = _this select 0;
			_ctrl = _display displayCtrl _idc;
			_y = (ctrlPosition _ctrl) select 1;
			_ctrl ctrlSetFade 1; 
			_ctrl ctrlSetPosition[0,_y,_w,_h]; 
			_ctrl ctrlCommit 0.25;
			player setVariable["sb_info",false];
		};
		_showControl = {
			_idc = _this select 0;
			_ctrl = _display displayCtrl _idc;
			_y = (ctrlPosition _ctrl) select 1;
			_ctrl ctrlSetFade 0; 
			_ctrl ctrlSetPosition[0.1,_y,_w,_h]; 
			_ctrl ctrlCommit 0.25;
			player setVariable["sb_info",true];
		};
		
		if (!(_currentInfo isEqualTo _currentToggled)) then {
			if (_currentToggled isEqualTo false) then {
				[13382] call _hideControl;
				[13383] call _hideControl;
				[13384] call _hideControl;
			} else {
				[13382] call _showControl;
				[13383] call _showControl;
				[13384] call _showControl;
			};
		};
	};
	
	sb_getIconBlood = {
		_value = _this select 0;
		_icon = "blood100";
		
		if (_value >= 100 ) then 					{ _icon ="blood100";	};
		if (_value <80 ) then 		{ _icon ="blood75";		};
		if (_value <60 ) then 		{ _icon ="blood50";		};
		if (_value <30 ) then 		{ _icon ="blood25";		};
		if (_value <20 ) then 		{ _icon ="blood10";		};
		if (_value <10 ) then 		{ _icon ="blood5";		};
		if (_value < 1 ) then 						{ _icon ="blood0";		};
		
		_icon
	};
	sb_getIconHunger = {
		_value = _this select 0;
		_icon = "hunger100";
		
		if (_value >= 100 ) then 					{ _icon ="hunger100";	};
		if (_value <80) then 		{ _icon ="hunger75";	};
		if (_value <60) then 		{ _icon ="hunger50";	};
		if (_value <30) then 		{ _icon ="hunger25";	};
		if (_value < 1 ) then 						{ _icon ="hunger0";		};
		
		_icon
	};
	sb_getIconThirst = {
		_value = _this select 0;
		_icon = "thirst100";
		
		if (_value >= 100 ) then 					{ _icon ="thirst100";	};
		if (_value < 80 ) then 		{ _icon ="thirst75";	};
		if (_value < 60 ) then 		{ _icon ="thirst50";	};
		if (_value < 30 ) then 		{ _icon ="thirst25";	};
		if (_value < 1 ) then 						{ _icon ="thirst0";		};
		
		_icon
	};


	sb_fadeIn = {
		_ctrl = _this select 0;
		//disappear
		_ctrl ctrlSetFade 1;
		_ctrl ctrlCommit 0;
		//fadein
		_ctrl ctrlSetFade 0;
		_ctrl ctrlCommit 1;
	
	};
	
	sb_fadeOut = {
		_ctrl = _this select 0;
		//disappear
		_ctrl ctrlSetFade 1;
		_ctrl ctrlCommit 1;
	
	};

	sb_checkTemp = {
			
			_display = (uiNamespace getVariable "StatusIcons");
			
			_bodyTemperature = [ExileClientPlayerAttributes select 5, 1] call ExileClient_util_math_round;
	
			if ( (_bodyTemperature< 36) && ((player getVariable "sb_isCold") isEqualTo false) ) then {
				player setVariable["sb_isCold",true];
				(_display displayCtrl 13375) ctrlSetText "statusIcons\icons\cold.paa";
				[(_display displayCtrl 13375)] call sb_fadeIn;
                [(_display displayCtrl 13395)] call sb_fadeIn;
			};
			
			if ((_bodyTemperature >= 36) && ((player getVariable "sb_isCold") isEqualTo true)) then {
				player setVariable["sb_isCold",false];
				[(_display displayCtrl 13375)] call sb_fadeOut;
                [(_display displayCtrl 13395)] call sb_fadeOut;
			};
	
	};
	
	sb_updateIcons = {

		_iconh = 			_this select 0;
		_iconf = 			_this select 1;
		_iconw = 			_this select 2;
		

		_display = (uiNamespace getVariable "StatusIcons");
		
		if (_iconh != "-1") then {
			(_display displayCtrl 13392) ctrlSetText format["statusIcons\circlebar\blood\%1.paa",_iconh];
			[(_display displayCtrl 13392)] call sb_fadeIn;
		};
		
		if (_iconf != "-1") then {
			(_display displayCtrl 13393) ctrlSetText format["statusIcons\circlebar\hunger\%1.paa",_iconf];
			[(_display displayCtrl 13393)] call sb_fadeIn;
		};
		
		if (_iconw != "-1") then {
			(_display displayCtrl 13394) ctrlSetText format["statusIcons\circlebar\thirst\%1.paa",_iconw];
			[(_display displayCtrl 13394)] call sb_fadeIn;
		};
		
	};
	
	
	sb_init = {
		waitUntil {
			(!isNil {round (ExileClientPlayerAttributes select 3)}) && (!isNil {round (ExileClientPlayerAttributes select 2)});
		};
		
		systemChat "Initialising DayZ Icons...";
		player setVariable["sb_info",true];
		player setVariable["infotoggled",false];
		_health = round ((1 - (damage player)) * 100);
		_hunger = round (ExileClientPlayerAttributes select 2);
		_thirst = round (ExileClientPlayerAttributes select 3);
		
		_hpIcon = [_health] call sb_getIconBlood;
		_hungerIcon = [_hunger] call sb_getIconHunger;
		_thirstIcon = [_thirst] call sb_getIconThirst;

		_lastHp = _health;
		_lastHunger = _hunger;
		_lastThirst = _thirst;
		
		player setVariable ["sb_lastArray", [_lastHp,_lastHunger,_lastThirst]];
		player setVariable ["sb_isCold",false];
		_rscLayer = "StatusIcons" call BIS_fnc_rscLayer;
		_rscLayer = cutRsc["StatusIcons","PLAIN",1,false];
		_initIcons = {
			_idc = _this select 0;
			_icon = _this select 1;
			_display = (uiNamespace getVariable "StatusIcons");
			_ctrl = _display displayCtrl _idc;
			_ctrl ctrlSetText format["statusIcons\icons\%1.paa",_icon];
		};
		[13372,"health"] call _initIcons;
		[13373,"hunger"] call _initIcons;
		[13374,"thirst"] call _initIcons;
		[13375,"cold"] call _initIcons;
		_display = (uiNamespace getVariable "StatusIcons");
		[(_display displayCtrl 13375)] call sb_fadeOut;
		[(_display displayCtrl 13395)] call sb_fadeOut;
		[_hpIcon,_hungerIcon,_thirstIcon,true] call sb_updateIcons;
		[] call sb_checkTemp;

		[] call sb_hideExileIcons;
		
	};
	
	
	sb_maintain = {
	
		if ((isNil {round (ExileClientPlayerAttributes select 3)}) || (isNil {round (ExileClientPlayerAttributes select 2)})) then {
			systemChat "Status variables are NIL, reinitialising...";
			[] call sb_init;
		} else {
		
			_health = round ((1 - (damage player)) * 100);
			_hunger = round (ExileClientPlayerAttributes select 2);
			_thirst = round (ExileClientPlayerAttributes select 3);
			
			_statchanged = false;
			
			_lastArray = player getVariable "sb_lastArray";
			_currentArray = [_health,_hunger,_thirst];
			
			_toUpdateBlood = [0,0,0];
			for "_i" from 0 to 2 do
			{
				_last = [(_lastArray select _i)] call sb_getIconBlood;
				_cur = [(_currentArray select _i)] call sb_getIconBlood;
				
				if (_last != _cur) then {
					_toUpdateBlood set [_i,1];
					_statchanged = true;
				};
				
			};
			_toUpdateHunger = [0,0,0];
			for "_i" from 0 to 2 do
			{
				_last = [(_lastArray select _i)] call sb_getIconHunger;
				_cur = [(_currentArray select _i)] call sb_getIconHunger;
				
				if (_last != _cur) then {
					_toUpdateHunger set [_i,1];
					_statchanged = true;
				};
				
			};
			_toUpdateThirst = [0,0,0];
			for "_i" from 0 to 2 do
			{
				_last = [(_lastArray select _i)] call sb_getIconThirst;
				_cur = [(_currentArray select _i)] call sb_getIconThirst;
				
				if (_last != _cur) then {
					_toUpdateThirst set [_i,1];
					_statchanged = true;
				};
				
			};
			
			
			
			if (_statchanged) then {
				
				player setVariable ["sb_lastArray", [_health,_hunger,_thirst]];
				
				_currentHp = [_health] call sb_getIconBlood;
				_currentFood =  [_hunger] call sb_getIconHunger;
				_currentThirst = [_thirst] call sb_getIconThirst;
				
				_upHp = "-1";
				_upHunger = "-1";
				_upThirst = "-1";
				
				if ((_toUpdateBlood select 0) == 1) then {
					_upHp = _currentHp;
				};
				if ((_toUpdateHunger select 1) == 1) then {
					_upHunger = _currentFood;
				};
				if ((_toUpdateThirst select 2) == 1) then {
					_upThirst = _currentThirst;
				};
			
				[_upHp,_upHunger,_upThirst] call sb_updateIcons;
				
			};
				[] call sb_checkTemp;
				[] call sb_maintainInfo;
				[] call sb_hideExileIcons;
				
				
				_disp = (uiNamespace getVariable "StatusIcons");
				if (isNull _disp) then {
					if (alive player) then {
					
					systemChat "DayZ Icons closed. Redrawing.";	
					_rscLayer = "StatusIcons" call BIS_fnc_rscLayer; 
					_rscLayer = cutRsc["StatusIcons","PLAIN",1,false];
					[] call sb_init;
					};
				};
				
		};
	};
	
	
	diag_log "starting DayZ icons";
	[] call sb_init;
	[0.5, sb_maintain, [], true] call ExileClient_system_thread_addtask;
	uiSleep 5;
	[] call sb_hideExileIcons;

