----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
weapons = {
  {"AK-47","AK103","AK-103","AK103ammu"},
  {"M4","M4A1","M4A1","M4A1ammu"},
  {"Colt 45","pistol","M1911","pistolammu"},
  {"Deagle","glock","Glock 19","glockammu"},
  {"Rifle","winchester22","Winchester 22","winchester22ammu"},
  {"Shotgun","remington870","Remington 870","remington870ammu"},
  {"Silenced","taser","Taser","taser"},
  {"Knife","faca","Faca","faca"},
} 
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo, ammoInClip)
  if source == localPlayer then
    local wpn = getWeaponNameFromID ( weapon )
    local weapID = getWeaponIDFromName ( wpn )
    if weapon then
      for i,v in ipairs (weapons) do
        if wpn == v[1] then
          if v[4] ~= "taser"  then
            exports.an_inventory:attitem2(v[4],"1","menos")
          end
        end
      end
    end
	end
end)
----------------------------------------------------------------------------------
function verifyarmsammu()
if not getElementData(localPlayer,"logado") then return end
  local wpon = getPedWeapon(localPlayer)
  if getWeaponNameFromID (wpon) ~= 'Fist' then
    for i,v in ipairs (weapons) do
      local getplydata = getElementData(localPlayer, v[2]) or 0
      local getplydata2 = getElementData(localPlayer, v[4]) or 0
      if (getplydata <= 0) or (getplydata2 <= 0) then
        local weapID = getWeaponIDFromName ( v[1] )
        triggerServerEvent ("removewpn", localPlayer,localPlayer,weapID)
      end
    end
  end
end
addEventHandler ( "onClientRender", getRootElement (), verifyarmsammu)
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------