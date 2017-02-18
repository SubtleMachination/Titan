//
//  UserDefaultsUtility.swift
//  Hexbreaker
//
//  Created by Dusty Artifact on 11/21/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

enum DefaultsKey:String
{
    case firstTimeLaunched = "firstTime_launch",
            gameCounter = "game_count"
}

func keyExists(_ key:DefaultsKey) -> Bool
{
    return defaults().dictionaryRepresentation().keys.contains(key.rawValue)
}

func firstTimeLaunched() -> Bool
{
    let key = DefaultsKey.firstTimeLaunched
    
    if (!keyExists(key))
    {
        // Create one
        defaults().set(true, forKey:key.rawValue)
        return true
    }
    else
    {
        return defaults().bool(forKey: key.rawValue)
    }
}

func disableFirstTimeLaunched()
{
    defaults().set(false, forKey:DefaultsKey.firstTimeLaunched.rawValue)
}

func enableFirstTimeLaunched()
{
    defaults().set(true, forKey:DefaultsKey.firstTimeLaunched.rawValue)
}

func currentGameCount() -> Int
{
    let key = DefaultsKey.gameCounter
    
    if (!keyExists(key))
    {
        defaults().set(0, forKey:key.rawValue)
        return 0
    }
    else
    {
        let currentCount = defaults().integer(forKey: key.rawValue)
        return currentCount
    }
}

func incrementGameCounter()
{
    let key = DefaultsKey.gameCounter
    
    if (!keyExists(key))
    {
        defaults().set(1, forKey:key.rawValue)
    }
    else
    {
        let currentCount = defaults().integer(forKey: key.rawValue)
        defaults().set(currentCount+1, forKey:key.rawValue)
    }
}

func resetGameCounter()
{
    let key = DefaultsKey.gameCounter
    defaults().set(0, forKey:key.rawValue)
}

func defaults() -> UserDefaults
{
    return UserDefaults.standard
}
