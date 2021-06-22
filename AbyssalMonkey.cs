#         AbyssalMonkey         #
using System;
using System.Drawing;
using System.Windows.Forms;
using System.Threading;
using System.Collections.Generic;
using System.Linq;
################################
using ISXEVEWrapper
using ISXEVE


namespace EVEAbyssalMonkey {
	public class AbyssalMonkey : Core
	{
	### Start Config
	private bool	_LocalCheck		= false; 
	
	# Filament Stuff
	int				_FilamentLimit	= 1;
	string			_FilamentName	= "Agitated Exotic Filament"; // Filament Used
	
	#Ship stuff
	private bool 	_PropMod		= false;
	private bool	_Hardners		= false; // for both shield and armor hardners
	private bool 	_PrimeWeapon	= false;
	private bool 	_Reps 			= false; // Keep false unless your in an active repped ship
	int 			_Maxtargets		= 5;
	
	# Ammo Stuff
	int 			_AmmoAMT		= 2000; // Amount of ammo to stock before each run
	string			_AmmoName		= "Scourge Fury Light Missle";
	
	# Drone Stuff
	int 			_DronesInShip	= 10;
	string			_DroneType 		= "Vespa II";
	
	# Bookmarks 
	string			_ABYBM			= "Abyssal Site";
	string 			_HomeBM 		= "HOME";
	
	# Breaktime
	int 			_BreakTime 		= 120; // Take a Break every Minutes
	int 			_BreakLimit		= 10; // Minutes for the break ( with random 0-10 additional )
	
	### End Config

	### Variables
	

	public void AbyssalRun()
		{ echo (Time() + "Starting Abyssal Monkey");
		// Initial checks
		
		while (true) { 
			if (_InSpaceCheck() == true) { _Dock(); }
			// Overall loop start here
			if (_StationCheck() == true) {
				_EmptyCargo();
				_LoadCargo();
				}
			if (_LocalCheck == true){ _Locals(); }
			_Undock();
			_WarpToBookmark();
			_UseFilament();
			
			// Combat Loop Stuff
			_Combat();
			_Loot();
			_UseAbyssGate(); 
			
			// Docking
			_Dock();
		}
		
		}
	#### Process Loop ####
	public void _InSpaceCheck()
	{
		if ($Me.InSpace = TRUE) { _DockUp();  }
	}
	public void _StationCheck()
	{}
	public void _Locals()
	{}
	public void _EmptyCargo()
	{}
	public void _LoadCargo()
	{}
	public void _Undock()
	{
		EVE:Execute[CmdExitStation]
		Client:Wait[10000]
	}
	public void _WarpToBookmark()
	{}
	public void _UseFilament() // includes activation
	{
		if ()	
	} 
	public void _Combat() 
	{}
	public void _Propmod()
	{}
	public void _Hardners()
	{}
	public void _SandAReppers() // Shield and Armor Reppers
	{}
	public void _Loot()
	{}
	public void _UseAbyssGate()
	{}
	public void _DockUp()
	{}
	

#### Utilities ####
public string Time()
        {
            string A = DateTime.Now.ToString("[hh:mm:ss] ");
            return A;
        }
	}
}
