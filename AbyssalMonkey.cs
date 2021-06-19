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
	int			_FilamentLimit 	= 1;
	int 		_AmmoAMT		= 2000;
	string 		_Drones			= "10";

	### End Config

	public void AbyssalRun()
		{ echo (Time() + "Starting Abyssal Monkey");
		
		
		}
	#### Processes ####
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