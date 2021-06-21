#         AbyssalMonkey         #
using System;
using System.Drawing;
using System.Windows.Forms;
using System.Threading;
using System.Collections.Generic;
using System.Linq;
#################################
#using isxevewrapper

namespace EVEAbyssalMonkey {
	public class AbyssalMonkey : Core
	{
	### Start Config
	private bool	_LocalCheck	= false; 
	private bool 	_PropMod	= false;
	private bool	_Hardners	= false;
	private bool _PrimeWeapon	= false;
	int 	_Maxtargets 		= 5;
	int		_FilamentLimit 		= 1;
	string	_FilamentName		= "Agitated Exotic Filament";
	int 	_AmmoAMT			= 2000;
	string	_AmmoName			= "Missle name goes here";
	int 	_DronesInShip		= 10;
	
	string	_ABYBM 				= "Abyssal Site";
	string 	_HomeBM 			= "HOME";
	int 	_BreakTime 			= 120; // Minutes
	
	### End Config

	public void AbyssalRun()
		{ echo (Time() + "Starting Abyssal Monkey");
		
		
		}
	#### Process Loop ####
	public void _InSpaceCheck()
	{}
	public void _StationCheck()
	{}
	public void _EmptyCargo()
	{}
	public void _LoadCargo()
	{}
	public void _Undock()
	{}
	public void _WarpToBookmark
	{}
	public void _UseFilament()
	{} 
	public void _Combat() // Includes looting and abyssalgate use
	{}
	public void _Propmod
	{}
	public void _Hardners
	{}
	public void _SandAReppers
	{}
	public void _Loot
	{}
	public void _UseAbyssGate
	{}
	public void _Dock()
	{}
	

#### Utilities ####
public string Time()
        {
            string A = DateTime.Now.ToString("[hh:mm:ss] ");
            return A;
        }
	}
}
