/*==================================================================================================
script: WooziesSword1.pwn
author: Yifan_Wu
version: 1.0
description: samp server side custom melee weapon knife replacement oriental like, For sols request
==================================================================================================*/

#include <open.mp>
#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>

#define WOOZIES_SWORD_MODEL (19590)
#define SWORD_SLOT          (0)

new bool:gHasSword[MAX_PLAYERS];

public OnFilterScriptInit()
{
    print("WooziesSword1 loaded.");
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    gHasSword[playerid] = false;
    return 1;
}

CMD:wsword(playerid, params[])
{
    GivePlayerWeapon(playerid, WEAPON_KNIFE, 1);
    SetPlayerArmedWeapon(playerid, WEAPON_KNIFE);

    SetPlayerAttachedObject(playerid, SWORD_SLOT, WOOZIES_SWORD_MODEL, 6,
        0.081, 0.036, 0.0, //offset
        0.0, -90.0, 90,   // rotation
        1.0, 1.0, 1.0);  // scale

    gHasSword[playerid] = true;
    return 1;
}

new WEAPON:gPlayerCurrentWeapon[MAX_PLAYERS];

public OnPlayerUpdate(playerid)
{
    new WEAPON:weapon = GetPlayerWeapon(playerid); // Return the player's current weapon
    if (weapon != gPlayerCurrentWeapon[playerid]) // If he changed weapons since the last update
    {
        // Lets call a callback named OnPlayerWeaponChange
        CallLocalFunction("OnPlayerWeaponChange", "iii", playerid, gPlayerCurrentWeapon[playerid], weapon);
        gPlayerCurrentWeapon[playerid] = weapon; // Update the weapon variable
    }
    return 1; // Send this update to other players.
}

forward OnPlayerWeaponChange(playerid, WEAPON:oldWeapon, WEAPON:newWeapon);
public OnPlayerWeaponChange(playerid, WEAPON:oldWeapon, WEAPON:newWeapon)
{
    if (!gHasSword[playerid]) return 1;

    if (newWeapon != WEAPON_KNIFE)
    {
        RemovePlayerAttachedObject(playerid, SWORD_SLOT);
        gHasSword[playerid] = false;
    }
    return 1;
}