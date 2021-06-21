; Abyss.iss is origionally developed by kwevin from the isxgames discord
; i an currently updating and revising this for myselfand others.
; - Lost in Space ( isxgames Discord )

function getHighestStanding(pilot p)
{
    variable int highestStanding

    highestStanding:Set[0]

    if ${p.Standing.AllianceToAlliance} > ${highestStanding}
    {
        highestStanding:Set[${p.Standing.AllianceToAlliance}]
    }
    if ${p.Standing.AllianceToCorp} > ${highestStanding}
    {
        highestStanding:Set[${p.Standing.AllianceToCorp}]
    }
    if ${p.Standing.AllianceToPilot} > ${highestStanding}
    {
        highestStanding:Set[${p.Standing.AllianceToPilot}]
    }
    if ${p.Standing.CorpToAlliance} > ${highestStanding}
    {
        highestStanding:Set[${p.Standing.CorpToAlliance}]
    }
    if ${p.Standing.CorpToCorp} > ${highestStanding}
    {
        highestStanding:Set[${p.Standing.CorpToCorp}]
    }
    if ${p.Standing.CorpToPilot} > ${highestStanding}
    {
        highestStanding:Set[${p.Standing.CorpToPilot}]
    }
    if ${p.Standing.MeToAlliance.Equal[5]}
    {
        highestStanding:Set[5]
    }

    if ${p.Alliance.Equal[${Me.Alliance}]}
    {
        highestStanding:Set[11]
    }
    if ${p.Standing.MeToPilot.Equal[-10]}
    {
        highestStanding:Set[-10]
    }
    if ${p.Standing.CorpToAlliance.Equal[-10]}
    {
        highestStanding:Set[-10]
    }
    if ${p.Standing.CorpToCorp.Equal[-10]}
    {
        highestStanding:Set[-10]
    }

    ;echo ${p.Name}
    ;echo ${highestStanding}
    ;echo ${p.AllianceTicker}

    return ${highestStanding}
}

function checkLocal()
{
    variable index:pilot LocalPilots
    variable int counter
    variable bool allGood

    echo Checking Local

    EVE:GetLocalPilots[LocalPilots]
    counter:Set[1]
    allGood:Set[TRUE]

    while ${LocalPilots.Get[${counter}]}
    {
        call getHighestStanding ${LocalPilots.Get[${counter}]}
        if ${Return} < 0
        {
            allGood:Set[FALSE]
        }
        counter:Inc
    }

    return ${allGood}
}

function localClearWait()
{
    variable bool localClear

    call checkLocal
    localClear:Set[${Return}]

    while !${localClear}
    {
        wait 60

        wait ${Math.Rand[100]}

        call checkLocal
        localClear:Set[${Return}]
    }

    echo Clear!
}

function lootInv()
{
    variable index:eveinvchildwindow windows
    variable index:int64 ids
    variable index:item loot
    variable index:int64 lootIDs
    ;EVEWindow["Inventory"]:Minimize
    EVEWindow[byCaption,"Inventory"]:GetChildren[windows,ids]

    variable int counter=1
    while ${counter} < 50
    {
        if ${windows.Get[${counter}].Name.Equal["ItemWreck"]}
        {
            windows.Get[${counter}]:StackAll

            windows.Get[${counter}]:GetItems[loot]

            variable int counter2=1
            while ${loot.Get[${counter2}].ID}
            {
                lootIDs:Insert[${loot.Get[${counter2}].ID}]

                counter2:Inc
            }

            EVE:MoveItemsTo[lootIDs, ${MyShip.ID}, CargoHold]
        }

        counter:Inc
    }
}

function interactWreck()
{
    variable entity wreck
    variable index:entity SiteEntities
    variable int counter
    EVE:QueryEntities[SiteEntities]
    counter:Set[1]
    while ${SiteEntities.Get[${counter}]}
    {
        if ${SiteEntities.Get[${counter}].Name.Equal["Triglavian Bioadaptive Cache Wreck"]}
        {
            SiteEntities.Get[${counter}]:Open
        }

        counter:Inc
    }

    wait 30

}

function recallDroneWait()
{
    variable index:activedrone drones

    while TRUE
    {
        if ${Me:GetActiveDrones[drones]}
        {
            echo Recalling drones....

            EVE:Execute[CmdDronesReturnToBay]

            wait 10

            EVE:Execute[CmdDronesReturnToBay]

            wait 20
        }
        else
        {
            echo Drones Back

            break
        }
    }
}

function ifDronesIdle()
{
    variable index:activedrone activeDrones
    variable index:entity targets

    Me:GetActiveDrones[activeDrones]
    variable int counter1

    ;if no targets break

    Me:GetTargets[targets]
    if !${targets[1]}
    {
        return 0
    }

    counter1:Set[1]
    while ${activeDrones.Get[${counter1}]}
    {
        if ${activeDrones.Get[${counter1}].State.Equal[0]}
        {
            wait 20

            Me:GetActiveDrones[activeDrones]

            if ${activeDrones.Get[${counter1}].State.Equal[0]}
            {
                echo DRONES
                EVE:Execute[CmdDronesEngage]
            }
        }

        if ${activeDrones.Get[${counter1}].Target.Name.Equal["Vila Swarmer"]}
        {
            echo WRONG TRGET

            EVE:Execute[CmdDronesEngage]

            wait 20
        }

        if ${activeDrones.Get[${counter1}].Target.Name.Equal["Short-Range Deviant Automata Suppressor"]}
        {
            echo WRONG TRGET

            EVE:Execute[CmdDronesEngage]

            wait 20
        }

        if ${activeDrones.Get[${counter1}].Target.Name.Equal["Medium-Range Deviant Automata Suppressor"]}
        {
            echo WRONG TRGET

            EVE:Execute[CmdDronesEngage]

            wait 20
        }

        counter1:Inc
    }

    if ${counter1} < 3
    {
        call recallDroneWait

        wait 20

        MyShip:LaunchAllDrones
    }
}

function inSite()
{
    variable int counter=1
    variable index:entity SiteEntities
    variable index:entity blank
    variable bool enemExist

    SiteEntities:Set[blank]
	EVE:Toggle3DDisplay

    wait 20

    EVE:QueryEntities[SiteEntities]

    wait 20

    if !${SiteEntities.Get[${counter}]}
    {
        echo weewoo
        EVE:QueryEntities[SiteEntities]
    }

    wait 30

    MyShip:LaunchAllDrones

    MyShip.Module[MedSlot0]:Activate
    MyShip.Module[MedSlot1]:Activate
    MyShip.Module[MedSlot2]:Activate

    enemExist:Set[FALSE]

    while ${SiteEntities.Get[${counter}]}
    {
        if ${SiteEntities.Get[${counter}].Name.Equal["Triglavian Bioadaptive Cache"]}
        {
            SiteEntities.Get[${counter}]:Orbit[10000]

            wait 10

            wait ${Math.Rand[20]}

            SiteEntities.Get[${counter}]:Orbit[10000]

            wait 10

            wait ${Math.Rand[20]}

            SiteEntities.Get[${counter}]:Orbit[10000]
        }

        if ${SiteEntities.Get[${counter}].Group.Equal["Abyssal Spaceship Entities"]} || ${SiteEntities.Get[${counter}].Group.Equal["Abyssal Drone Entities"]}
        {
            if !${SiteEntities.Get[${counter}].Name.Equal["Vila Swarmer"]}
            {
                enemExist:Set[TRUE]
            }
        }

        counter:Inc
    }

    variable int counter3=1
    variable int counter4=1
    while ${enemExist}
    {
        echo Rats to kill - Starting main loop
        counter:Set[1]

        EVE:QueryEntities[SiteEntities]
        ;TODO Vila drones targeting and pylons
        wait 20
        enemExist:Set[FALSE]
        counter3:Set[1]
        while ${SiteEntities.Get[${counter3}]}
        {
            if ${SiteEntities.Get[${counter3}].Group.Equal["Abyssal Spaceship Entities"]} || ${SiteEntities.Get[${counter3}].Group.Equal["Abyssal Drone Entities"]}
            {
                if !${SiteEntities.Get[${counter3}].Name.Equal["Vila Swarmer"]}
                {
                    ;echo KILL ${SiteEntities.Get[${counter3}].Name}
                    enemExist:Set[TRUE]
                }
            }

            counter3:Inc
        }

        call ifDronesIdle

        wait 10
        if !${enemExist}
        {
            EVE:QueryEntities[SiteEntities]
        }
        counter4:Set[1]
        while ${SiteEntities.Get[${counter4}]}
        {
            if ${SiteEntities.Get[${counter4}].Group.Equal["Abyssal Spaceship Entities"]} || ${SiteEntities.Get[${counter4}].Group.Equal["Abyssal Drone Entities"]}
            {
                if !${SiteEntities.Get[${counter4}].Name.Equal["Vila Swarmer"]}
                {
                    ;echo KILL ${SiteEntities.Get[${counter4}].Name}
                    enemExist:Set[TRUE]
                }
            }

            counter4:Inc
        }

        ;lock management-------------------------------

        variable index:entity allLocks

        variable index:entity inProgressLock
        counter:Set[1]
        variable int lockCount
        lockCount:Set[0]

        Me:GetTargeting[inProgressLock]

        counter:Set[1]
        while ${inProgressLock.Get[${counter}].ID}
        {
            allLocks:Insert[${inProgressLock.Get[${counter}]}]

            counter:Inc
            lockCount:Inc
        }

        variable index:entity currentLocked

        Me:GetTargets[currentLocked]

        counter:Set[1]
        while ${currentLocked.Get[${counter}].ID}
        {
            allLocks:Insert[${currentLocked.Get[${counter}]}]

            counter:Inc
            lockCount:Inc
        }

        echo LOCK COUNT ${lockCount}

        ;max locked targets
        if ${lockCount} < 5
        {
            EVE:QueryEntities[SiteEntities]

            counter:Set[1]

            ;max locked targets
            while ${SiteEntities.Get[${counter}]}
            {
                if ${lockCount} < 4
                {
                    if ${SiteEntities.Get[${counter}].IsLockedTarget} || ${SiteEntities.Get[${counter}].BeingTargeted}
                    {

                    }
                    else
                    {
                        ;lock range
                        if ${SiteEntities.Get[${counter}].Distance} < 80000
                        {
                            if ${SiteEntities.Get[${counter}].Group.Equal["Abyssal Spaceship Entities"]} || ${SiteEntities.Get[${counter}].Group.Equal["Abyssal Drone Entities"]}
                            {
                                if !${SiteEntities.Get[${counter}].Name.Equal["Vila Swarmer"]}
                                {
                                    echo LOCKING ${SiteEntities.Get[${counter}].Name}
                                    echo LOCK COUNT ${lockCount}
                                    SiteEntities.Get[${counter}]:LockTarget
                                    lockCount:Inc
                                    wait 2
                                }
                            }
                        }
                    }
                }

                counter:Inc
            }
        }

        ;shoot management---------------------------
        ;TODO SHOOT
        ;echo GOT TO SHOOT
        ;if ${lockCount} > 0
        ;{
        ;    if !${MyShip.Module[HiSlot0].Get[1].IsActive}
        ;    {
        ;        echo PEW
        ;        MyShip.Module[HiSlot0]:Activate
        ;    }
        ;    call ifDronesIdle
        ;    echo AFTER DROENS
        ;}

        ;module management
        if !${MyShip.Module[MedSlot1].IsActive}
        {
            MyShip.Module[MedSlot1]:Activate

            wait 10
        }

        if !${MyShip.Module[MedSlot2].IsActive}
        {
            MyShip.Module[MedSlot2]:Activate

            wait 10
        }

        if !${MyShip.Module[MedSlot0].IsActive}
        {
            MyShip.Module[MedSlot0]:Activate

            wait 10
        }

        if ${enemExist}
        {
            echo ENEMIES
        }
        else
        {
            echo NONEEMMEMES
        }
    }

    ;cleared site

    ;double check

    SiteEntities:Set[blank]

    wait 10

    echo double checking

    EVE:QueryEntities[SiteEntities]
    ;TODO Vila drones targeting and pylons
    wait 20
    enemExist:Set[FALSE]
    counter3:Set[1]
    while ${SiteEntities.Get[${counter3}]}
    {
        if ${SiteEntities.Get[${counter3}].Group.Equal["Abyssal Spaceship Entities"]} || ${SiteEntities.Get[${counter3}].Group.Equal["Abyssal Drone Entities"]}
        {
            if !${SiteEntities.Get[${counter3}].Name.Equal["Vila Swarmer"]}
            {
                ;echo KILL ${SiteEntities.Get[${counter3}].Name}
                enemExist:Set[TRUE]
            }
        }

        counter3:Inc
    }

    wait 20

    if !${enemExist}
    {
        EVE:QueryEntities[SiteEntities]
    }
    counter3:Set[1]
    while ${SiteEntities.Get[${counter3}]}
    {
        if ${SiteEntities.Get[${counter3}].Group.Equal["Abyssal Spaceship Entities"]} || ${SiteEntities.Get[${counter3}].Group.Equal["Abyssal Drone Entities"]}
        {
            if !${SiteEntities.Get[${counter3}].Name.Equal["Vila Swarmer"]}
            {
                ;echo KILL ${SiteEntities.Get[${counter3}].Name}
                enemExist:Set[TRUE]
            }
        }

        counter3:Inc
    }

    if ${enemExist}
    {
        echo needed double check


        call inSite

        return 0
    }
    else
    {
        echo all good
    }

    ;lock + approach cahce

    EVE:QueryEntities[SiteEntities]
    counter:Set[1]
    while ${SiteEntities.Get[${counter}]}
    {
        if ${SiteEntities.Get[${counter}].Name.Equal["Triglavian Bioadaptive Cache"]}
        {
            SiteEntities.Get[${counter}]:Approach

            wait 20

            SiteEntities.Get[${counter}]:LockTarget
        }

        counter:Inc
    }

    ;kill cache

    wait 30

    EVE:Execute[CmdDronesEngage]

    wait 20

    Me:GetTargets[currentLocked]


    counter:Set[1]
    while ${currentLocked.Get[1].ID}
    {
        echo WAITING TO KILL CACHE
        wait 10

        if ${counter.Equal[15]}
        {
            EVE:Execute[CmdDronesEngage]
        }

        if ${counter.Equal[30]}
        {
            EVE:Execute[CmdDronesEngage]
        }

        if ${counter.Equal[47]}
        {
            EVE:Execute[CmdDronesEngage]
        }

        if ${counter.Equal[74]}
        {
            EVE:Execute[CmdDronesEngage]
        }

        counter:Inc
    }

    EVE:Execute[CmdDronesReturnToBay]

    wait 20

    ;approach wreck
    variable entity wreck
    EVE:QueryEntities[SiteEntities]
    counter:Set[1]
    while ${SiteEntities.Get[${counter}]}
    {
        if ${SiteEntities.Get[${counter}].Name.Equal["Triglavian Bioadaptive Cache Wreck"]}
        {
            SiteEntities.Get[${counter}]:Approach
            wreck:Set[${SiteEntities.Get[${counter}]}]
        }

        counter:Inc
    }

    echo DISTANCE TO WRECK ${wreck.DistanceTo[${MyShip.ID}]}
    while ${wreck.DistanceTo[${MyShip.ID}]} > 1500
    {
        echo WRECK TOO FAR
        wait 10
    }

    call interactWreck

    wait 20

    call lootInv

    wait 10




    ;approcah gate
    variable entity gate
    EVE:QueryEntities[SiteEntities]
    counter:Set[1]
    while ${SiteEntities.Get[${counter}]}
    {
        if ${SiteEntities.Get[${counter}].Name.Equal["Transfer Conduit (Triglavian)"]} || ${SiteEntities.Get[${counter}].Name.Equal["Origin Conduit (Triglavian)"]}
        {
            SiteEntities.Get[${counter}]:Approach
            gate:Set[${SiteEntities.Get[${counter}]}]
        }

        counter:Inc
    }

    wait 10

    if ${gate.DistanceTo[${MyShip.ID}]} > 5000
    {
        SiteEntities.Get[${counter}]:Approach
    }

    while ${gate.DistanceTo[${MyShip.ID}]} > 1500
    {
        wait 10
    }

    gate:Activate

    wait 10

    counter:Set[10]
    variable index:evewindow windows

    EVE:GetEVEWindows[windows]

    while ${counter} < 50
    {
        if ${windows.Get[${counter}].Text}
        {
            echo On Window Check

            EVEWindow[active]:Close

            call inSite
        }

        counter:Inc
    }

    wait 50

}

function waitEnemy()
{
    variable int counter=1
    variable index:entity SiteEntities
    variable bool enemExist

    enemExist:Set[FALSE]

    while !${enemExist}
    {
        counter:Set[1]
        EVE:QueryEntities[SiteEntities]
        enemExist:Set[FALSE]
        variable int counter3=1
        while ${SiteEntities.Get[${counter}]}
        {
            if ${SiteEntities.Get[${counter}].Group.Equal["Abyssal Spaceship Entities"]} || ${SiteEntities.Get[${counter}].Group.Equal["Abyssal Drone Entities"]}
            {
                if !${SiteEntities.Get[${counter}].Name.Equal["Vila Swarmer"]}
                {
                    echo KILL ${SiteEntities.Get[${counter}].Name}
                    enemExist:Set[TRUE]
                }
            }

            counter:Inc
        }
    }

    wait 20
}

function inAbyss()
{
    call inSite

    echo WAITING ENEMY

    call waitEnemy

    call inSite

    echo WAITING ENEMY

    call waitEnemy

    call inSite

    wait 20

    MyShip.Module[MedSlot0]:Deactivate
    MyShip.Module[MedSlot1]:Deactivate
    MyShip.Module[MedSlot2]:Deactivate
}

function acFilament()
{
    variable index:eveinvchildwindow windows
    variable index:int64 ids
    variable index:item loot
    variable index:int64 lootIDs
    ;EVEWindow["Inventory"]:Minimize
    EVEWindow[byCaption,"Inventory"]:GetChildren[windows,ids]

    variable int counter=1
    while ${counter} < 50
    {
        if ${windows.Get[${counter}].Name.Equal["ShipCargo"]}
        {
            windows.Get[${counter}]:GetItems[loot]

            variable int counter2=1
            while ${loot.Get[${counter2}].ID}
            {
                echo ${loot.Get[${counter2}].Name}
				echo Testing Point 000
                if ${loot.Get[${counter2}].Name.Equal["Agitated Exotic Filament"]}
                {
                    
					if ${loot.Get[${counter2}].Quantity.Equal[1]}
						{ 
						echo Useing Filament
						loot.Get[${counter2}]:UseAbyssalFilament
							
                        wait 30
						echo Activating Filament
						EVEWindow[ByCaption, "Agitated Exotic Filament"].Button[button]:Press

                        ;call enterFIlament
                        
                        return 0
                    }
                    else
                    {
                        return OOF
                    }
                }

                counter2:Inc
            }
        }

        counter:Inc
    }

    return NF
}

function enterFIlament()
{
    variable index:entity SiteEntities
    variable entity gate
    variable int counter=1
    EVE:QueryEntities[SiteEntities]
    counter:Set[1]
    while ${SiteEntities.Get[${counter}]}
    {
        if ${SiteEntities.Get[${counter}].Name.Equal["Abyssal Trace"]}
        {
            gate:Set[${SiteEntities.Get[${counter}]}]
        }

        counter:Inc
    }

    wait 20

    gate:Activate

    wait 20

    Keyboard:Press[enter]
}

function atFilaSpot()
{
    call acFilament

    wait 30

    call waitEnemy

    call inAbyss
}
;TODO WARPWAIT BROKEN - MODE NOT WORKING ON SCIPT EXECUTION
function warpWait()
{
    wait 100

    while ${MyShip.ToEntity.Mode.Equal[3]}
    {
        wait 10

        echo Warping.....
    }

    echo Done warping
}

function goToFilament()
{
    call localClearWait

    EVE:Execute[CmdExitStation]

    while !${Me.InSpace}
    {
        wait 10
    }

    wait 50

    variable index:bookmark bookmarks
    variable int counter

    EVE:GetBookmarks[bookmarks]

    counter:Set[1]
    while ${bookmarks.Get[${counter}].ID}
    {
        if ${bookmarks.Get[${counter}].Label.Equal["Abyssal Site"]} && ${bookmarks.Get[${counter}].JumpsTo.Equal[0]}
        {
            bookmarks.Get[${counter}]:WarpTo[0]

            break
        }

        counter:Inc
    }

    wait 500
}

function goFilamentBase()
{
    variable index:bookmark bookmarks
    variable int counter

    EVE:GetBookmarks[bookmarks]

    counter:Set[1]
    while ${bookmarks.Get[${counter}].ID}
    {
        if ${bookmarks.Get[${counter}].Label.Equal["Home"]} && ${bookmarks.Get[${counter}].JumpsTo.Equal[0]}
        {
            bookmarks.Get[${counter}].ToEntity:Dock

            break
        }

        counter:Inc
    }

    wait 500

    wait 30

    if ${Me.InSpace}
    {
        bookmarks.Get[${counter}].ToEntity:Dock
    }
}

function repairShip()
{
    MyShip.ToItem:GetRepairQuote

    wait 20

    wait ${Math.Rand[30]}

    EVEWindow["Repairshop"].Button[2]:Press

    wait 20

    wait ${Math.Rand[30]}

    Keyboard:Press[enter]

    wait 20

    EVEWindow["Repairshop"]:Close

    wait 20
}

function emptyShip()
{
    variable index:eveinvchildwindow windows
    variable index:int64 ids
    variable index:item loot
    variable index:int64 lootIDs
    ;EVEWindow["Inventory"]:Minimize
    EVEWindow[byCaption,"Inventory"]:GetChildren[windows,ids]

    variable int counter=1
    while ${counter} < 50
    {
        if ${windows.Get[${counter}].Name.Equal["ShipCargo"]}
        {
            windows.Get[${counter}]:GetItems[loot]

            variable int counter2=1
            while ${loot.Get[${counter2}].ID}
            {
                lootIDs:Insert[${loot.Get[${counter2}].ID}]

                counter2:Inc
            }

            EVE:MoveItemsTo[lootIDs, MyStationHangar, Hangar]
        }

        counter:Inc
    }

    wait 20

    EVE:StackItems[MyStationHangar, Hangar]

    wait 30

    ;repair ship

    call repairShip
}

function getFilaments()
{
    variable index:eveinvchildwindow windows
    variable index:int64 ids
    variable index:item loot
    variable index:int64 lootIDs
    ;EVEWindow["Inventory"]:Minimize
    EVEWindow[byCaption,"Inventory"]:GetChildren[windows,ids]

    variable int counter=1
    while ${counter} < 50
    {
        if ${windows.Get[${counter}].Name.Equal["StationItems"]}
        {
            windows.Get[${counter}]:GetItems[loot]

            variable int counter2=1
            while ${loot.Get[${counter2}].ID}
            {
                if ${loot.Get[${counter2}].Name.Equal["Agitated Exotic Filament"]}
                {
                    if ${loot.Get[${counter2}].Quantity} > 0
                    {
                        loot.Get[${counter2}]:MoveTo[${MyShip.ID}, CargoHold, 1]
                        return 0
                    }
                    else
                    { 
                        ;return NF
                    }
                }
				
                counter2:Inc
            }
        }

        counter:Inc
    }
}

function getDrones()
{
    variable index:eveinvchildwindow windows
    variable index:int64 ids
    variable index:item loot
    variable index:int64 lootIDs
    variable int dronesMissing=0
    ;EVEWindow["Inventory"]:Minimize

    EVE:Execute[OpenDroneBayOfActiveShip]

    wait 20

    echo ${MyShip.UsedDronebayCapacity}

    wait 20
    ;TODO close window better

    EVEWindow[ByCaption, "Drone Bay"]:Minimize

    wait 20

    EVEWindow[ByCaption, "Drone Bay"]:Maximize

    wait 10

    EVEWindow[active]:Close

    wait 20

    dronesMissing:Set[${Math.Calc[${MyShip.DronebayCapacity}-${MyShip.UsedDronebayCapacity}]}/10]
    echo ${dronesMissing}

    if ${dronesMissing.Equal[0]}
    {
        return 0
    }
    else
    {

        EVEWindow[byCaption,"Inventory"]:GetChildren[windows,ids]

        variable int counter=1
        while ${counter} < 50
        {
            if ${windows.Get[${counter}].Name.Equal["StationItems"]}
            {
                windows.Get[${counter}]:GetItems[loot]

                variable int counter2=1
                while ${loot.Get[${counter2}].ID}
                {
                    if ${loot.Get[${counter2}].Name.Equal["Vespa II"]}
                    {
                        if ${loot.Get[${counter2}].Quantity} > 0
                        {
                            loot.Get[${counter2}]:MoveTo[${MyShip.ID}, DroneBay, ${dronesMissing}]
                        }
                        else
                        {
                            return ND
                        }
                    }

                    counter2:Inc
                }
            }

            counter:Inc
        }
    }

    wait 10

    dronesMissing:Set[${Math.Calc[${MyShip.DronebayCapacity}-${MyShip.UsedDronebayCapacity}]}/10]

    if ${dronesMissing.Equal[0]}
    {
        return 0
    }
    else
    {
        call getDrones
    }
}

function fullLoop()
{
    call getFilaments
	
	wait 10

    call getDrones

    wait 10

    call goToFilament

    wait 20

    call atFilaSpot

    wait 200

    call goFilamentBase

    wait 100

    call emptyShip
}

function totalLoop()
{
    variable int counter=1

    while ${counter} < 10
    {
        call fullLoop

        wait 100

        counter:Inc
    }
}

function main()
{
    ;TODO repair
    ;TODO cap val check on reac mods
    ;TODO GATE LOCKED?
    call totalLoop
}