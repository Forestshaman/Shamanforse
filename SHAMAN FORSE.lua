script_name('SKRIPT')
script_author('SHAMAN')
script_description('GO')

require 'lib.moonloader' -- ����������� ����������

local  tag = '[SHAMAN FORSE]'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local imgui = require 'imgui'
local sampev = require 'lib.samp.events'
local key = require 'vkeys'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "1.05"

local update_url = "https://raw.githubusercontent.com/Forestshaman/Shamanforse/main/update.ini" -- ��� ���� ���� ������
local update_path = getWorkingDirectory() .. "/update.ini" -- � ��� ���� ������

local script_url = "https://github.com/Forestshaman/Shamanforse/blob/main/SHAMAN_FORSE.luac?raw=true" -- ��� ���� ������
local script_path = thisScript().path


local config = { accent = { active = true, activR = false, zvanie = 0, patrulZ = 0, ClistZ = 0, cameraZ = 0},}
local ClistArr = { u8'[1] �������', u8'[2] ������-�������', u8'[3] ����-�������', u8'[4] ���������', u8'[5] �����-�������', u8'[6] �����-�������', u8'[7] ����-�������',
u8'[8] �������', u8'[9] ����-�������', u8'[10] ����������', u8'[11] ����������', u8'[12] Ҹ���-�������', u8'[13] ����-�������', u8'[14] Ƹ���-���������', u8'[15] ���������',
u8'[16] �������', u8'[17] �����', u8'[18] �������', u8'[19] ����� �����', u8'[20] ����-������', u8'[21] �����-�����', u8'[22] ����������', u8'[23] ������', u8'[24] ����-�����', u8'[25] ������', u8'[26] ����������', u8'[27] �������', u8'[28] ������ ������', u8'[29] ���������', u8'[30] �����', u8'[31] �������', u8'[32] ������'
}


function kvadrat()
    local KV = {
        [1] = "�",
        [2] = "�",
        [3] = "�",
        [4] = "�",
        [5] = "�",
        [6] = "�",
        [7] = "�",
        [8] = "�",
        [9] = "�",
        [10] = "�",
        [11] = "�",
        [12] = "�",
        [13] = "�",
        [14] = "�",
        [15] = "�",
        [16] = "�",
        [17] = "�",
        [18] = "�",
        [19] = "�",
        [20] = "�",
        [21] = "�",
        [22] = "�",
        [23] = "�",
        [24] = "�",
    }

    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end


	

local selected = 1
local SelectInfo = 1
local Selectfunction = 1

local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Verdana', 10, font_flag.BOLD + font_flag.SHADOW)

local cfg = inicfg.load(config, 'ShamanSetting.ini')
if not doesFileExist('moonloader/config/ShamanSetting.ini') then inicfg.save(config, 'ShamanSetting.ini') end

local PdTeg = imgui.ImBuffer(tostring(cfg.accent.PdTeg), 256)
local Fighter = imgui.ImBuffer(tostring(cfg.accent.Fighter), 256)
local Fighter_2 = imgui.ImBuffer(tostring(cfg.accent.Fighter_2), 256)
local activR = imgui.ImBool(cfg.accent.activR)
local zvanie = imgui.ImInt(cfg.accent.zvanie)
local patrulZ = imgui.ImInt(cfg.accent.patrulZ)
local ClistZ = imgui.ImInt(cfg.accent.ClistZ)
local cameraZ = imgui.ImInt(cfg.accent.cameraZ)

local cameraArr = { u8'iPhone 13 Pro', u8'iPhone 13 Pro Max', u8'iPhone 12', u8'iPhone 7 Plus', u8'Samsung Galaxy S21 Ultra', u8'Xiaomi POCO X3 GT', u8'GoPro HERO9 Black Edition', u8'GoPro Hero8', u8'Sony RX0 II', u8'Olympus Tough TG-6', u8'Sony FDR-X3000', u8'Siemens C65', u8'Nokia 7610'}
local arr_str = {'R.SWAT', 'F.SWAT', 'I.SWAT', 'Sgt.SWAT', 'Lt.SWAT', 'Cpt.SWAT' }
local arr_str2 = {'DAVID','DAVID-D','LINCOLN', 'ADAM', 'YANKEE', 'KING', 'MARY', 'AIR', 'HENRY', 'STAFF', 'ACADEM' }
local combo_select =imgui.ImInt(0)

local res           = pcall(require, 'lib.moonloader')                      assert(res, 'Lib MOONLOADER not found!')
local res           = pcall(require, 'lib.sampfuncs')                       assert(res, 'Lib SAMPFUNCS not found')
local res, hook     = pcall(require, 'lib.samp.events')                     assert(res, 'Lib SAMP Events not found')

local avto_menu = imgui.ImBool(false)
local msk_menu = imgui.ImBool(false)
local cuff_menu = imgui.ImBool(false)
local Hmenu = imgui.ImBool(false)

local sw, sh = getScreenResolution()





function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end

  downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("���� ����������! ������: " .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
     
    

    sampAddChatMessage( tag.. ' ����� ������������ ����', 0xFFFFFF)
	sampRegisterChatCommand('r', function(text) if activR.v then sampSendChat('/r ['..arr_str[zvanie.v +1].. ' � ' ..u8:decode(PdTeg.v)..']: '..text) else sampSendChat('/r '..text) end end)
    sampRegisterChatCommand('beret', function() thread:run('beret')end)
    sampRegisterChatCommand('gps0', cmd_gps0)
    sampRegisterChatCommand('shaman', cmd_shaman)
	sampRegisterChatCommand('suu', cmd_suu)
    sampRegisterChatCommand('go', cmd_go)


  imgui.Process = false

  thread = lua_thread.create_suspended(thread_funtion)

  while true do

    wait(0)


  if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("������ ������� ��������! ������ 1.05", -1)
                    thisScript():reload()
                end
            end)
            break
        end
        

    if isKeyJustPressed(0x54 --[[VK_T]]) and not sampIsDialogActive() then -- ������� ��� �� [T]
      sampSetChatInputEnabled(true)
    end
     if testCheat('rr') and not sampIsDialogActive() then 
        sampSetChatInputEnabled(true)
        sampSetChatInputText('/r ') 
     end

     if testCheat('ppp') and not sampIsDialogActive() then 
        sampSetChatInputEnabled(true)
        sampSetChatInputText('/patrul ') 
     end
     if testCheat('md') and not sampIsDialogActive() then 
        sampSetChatInputEnabled(true)
        sampSetChatInputText('/mdc ') 
     end
     
     if testCheat('oop') and not sampIsDialogActive() then 
        sampSendChat('/wanted 1') 
     end
     

		if isKeyDown(VK_X) and wasKeyPressed(key.VK_1) then -- 10-0	�Ѩ ��������. X + 1
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' � ' ..u8:decode(PdTeg.v)..']:'..arr_str2[patrulZ.v +1]..', 10-0 '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v))
		end
		if isKeyDown(VK_X) and wasKeyPressed(key.VK_2) then -- 10-1	������ � ���������� ������������.. X + 2
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' � ' ..u8:decode(PdTeg.v)..']:'..arr_str2[patrulZ.v +1]..', 10-1 '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v))
		end
		if isKeyDown(VK_X) and wasKeyPressed(key.VK_3) then -- 10-2	����������� �� ���������� ������������. X + 3
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' � ' ..u8:decode(PdTeg.v)..']:'..arr_str2[patrulZ.v +1]..', 10-2 '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v))
		end
		if isKeyDown(VK_B) and wasKeyPressed(key.VK_1) then --	10-13	������� � ��������� �����������, ��������� ������. ������ ��� �����. B + 1
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' � ' ..u8:decode(PdTeg.v)..']: 10-13, ����� ���������! �������������� -  '..kvadrat())
		end

		if isKeyDown(VK_B) and wasKeyPressed(key.VK_2) then --10-34   ���������� ���� ��������� �� �������� �������, ���������� ������������. B + 2
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' � ' ..u8:decode(PdTeg.v)..']: 10-34, ����� ���������! �������������� -'..kvadrat())
		end

        if isKeyDown(VK_B) and wasKeyPressed(key.VK_5) then -- 10-81 ����� ������ �� �����������.
           sampSendChat('/r ['..arr_str[zvanie.v +1].. ' � ' ..u8:decode(PdTeg.v)..']: 10-81, ����� ������ �� ������������! -'..kvadrat())
        end
        
        if isKeyDown(VK_B) and wasKeyPressed(key.VK_6) then -- 10-81 ����� ������ �� �����������.
           sampSendChat('/me �� ' ..cameraArr[cameraZ.v +1].. ' ����� ����� �� ������ "������ �����"')
           wait(1500)
           sampSendChat('/do '..cameraArr[cameraZ.v +1]..' ����� ����������� �� �������� ������')
        end

        

    -- 10-55 ���������. ���������� ������-�����.
    -- 10-57 ������ �������� ���������� �� ������� ��� �� ������������ �� ��������.
    -- 10-80 ������ �� �����������.	
    -- 10-99 �������� �������������.

    --------------------------------------------AREST-----------------------------------------------------------------------------------

    if isKeyJustPressed(16) and not avto_menu.v and not msk_menu.v  then --  /PS
          validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
              local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/ps '.. id)
                actionId = id
            end
        end
    end

    if isKeyJustPressed(69) and not avto_menu.v and not msk_menu.v  then --  /CUFF
          validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
              local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
               sampSendChat('/cuff '.. id)
                actionId = id
            end
        end
    end

    if isKeyJustPressed(81) and not avto_menu.v and not msk_menu.v  then --  /UNCUFF
        validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
            local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
               sampSendChat('/uncuff '.. id)
               actionId = id
            end
        end
    end

    if isKeyJustPressed(89) and not avto_menu.v and not msk_menu.v  then --  ����� �� �����
        validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
            local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/follow '.. id)
                wait(1000)
                sampSendChat('/me ������� ���� ����������� � ����� �� �����' )
                actionId = id
            end
        end
    end

    if isKeyJustPressed(88) and not avto_menu.v and not msk_menu.v  then --  �������� � ������
        validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
            local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/cput '.. id)
                wait(1000)
                sampSendChat('/me ������ ����� ������ � �������� ���� �����������' )
                actionId = id
            end
        end
    end

    if isKeyJustPressed(90) and not avto_menu.v and not msk_menu.v  then --  ��������
        validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
            local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/me ������� �������� �� ��������, ���������� �� �� ����' )
                wait(1000)
                sampSendChat('/me �������� ���������� ������� '..sampGetPlayerNickname(id)..', ���������� ����������' )
                wait(1000)
                sampSendChat('/frisk '.. id)
                actionId = id
            end
        end
    end

    if isKeyJustPressed(71) and not avto_menu.v and not msk_menu.v  then --  �������� � ���
          validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
              local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/do �� ����������� ����� ����� ������ ������' )
                wait(1000)
                sampSendChat('/me ����� ������ ����, ����� ���� ������� ��� � �������� ��������' )
                wait(1000)
                sampSendChat('/me ������ ����� ���' )
                wait(1000)
                sampSendChat('/todo ��������������*���������� ���������� � ���')
                wait(1000)
                sampSendChat('/arrest '.. id)
                wait(1000)
                sampSendChat('/me ������ ����� ���')
				actionId = id
            end
        end
    end

    if wasKeyPressed(49) and isKeyDown(2) then
            local veh, ped = storeClosestEntities(PLAYER_PED)
            local _, id = sampGetPlayerIdByCharHandle(ped)
            if id then
                    if id == -1 then sampAddChatMessage('[������] ����� ������ ���!', 0x6495ED) else
                       sampSendChat('/ceject '..id)
                    end
            end
        end
	--if isKeyJustPressed(49) and not avto_menu.v then     -- �������� �� ������
	--	validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
	--	if validtar and doesCharExist(pedtar) then
	--	    local result, id = sampGetPlayerIdByCharHandle(pedtar)
	--	    if result then
	--	        SampSendChat('/ceject '..id)
    --            wait(1000)
    --            sampSendChat('/me ������� ����������� �� ������')
	--	        actionId = id
	--	    end
	--	end
	--end

	if isKeyJustPressed(66) then
	validtar, pedtar = getCharPlayerIsTargeting(playerHandle)  -- �����
		if validtar and doesCharExist(pedtar) then
			local result, id = sampGetPlayerIdByCharHandle(pedtar)
			if result then
			    cuff_menu.v = true
				actionId = id
			end
		end
	end

    if isKeyDown(2) and isKeyJustPressed(18)  then
    sampSendChat('/tazer')
    

    end

    if isKeyDown(2) then
        validtar, pedtar = getCharPlayerIsTargeting(playerHandle) 
        if validtar and doesCharExist(pedtar) then
           renderFontDrawText(my_font, 'E - ������ ���������\nQ - ����� ���������\nY - ����� �� �����\nX - �������� � ������\nZ - ��������\nB - �������� � ������\nShift - ������� PS\n1 - �������� �� ������', 300, 800, 0xFFFFFFFF)
        end
    end
    if isKeyDown(88) then
       renderFontDrawText(my_font, '[1] - ��������� ������� - 10.0. ��������: '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v)..'\n[2] - ������� � ������� - 10.1. ��������: '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v)..' \n[3] - ����������� � ����� - 10.2. ��������: '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v)..'', 300, 800, 0xFFFFFFFF)
    end
    if isKeyDown(66) then
       renderFontDrawText(my_font, '[1] 10-13 - � ���� ��������\n[2]  10-34 - �������� ��������� �� �������\n[5]  10-81 - ����� ������\n[6] �������� �����������', 300, 800, 0xFFFFFFFF)
    end
    
   -------------------------------------------------------------------------------------------------------------------------------
    if isKeyDown(VK_MENU) and wasKeyPressed(key.VK_1) then
       avto_menu.v = not avto_menu.v
    end

    if testCheat('mm') then msk_menu.v = not msk_menu.v end
		if testCheat('321') then Hmenu.v = not Hmenu.v end
		if testCheat('mem') then sampSendChat('/members 1') end

        imgui.Process = avto_menu.v or msk_menu.v or cuff_menu.v or Hmenu.v
    end
end




function imgui.OnDrawFrame()
    if not avto_menu.v and not msk_menu.v and not cuff_menu.v and not Hmenu.v  then
       imgui.Process = false
    end

    if Hmenu.v then
       imgui.SetNextWindowSize(imgui.ImVec2(850, 620), imgui.Cond.FirstUseEver)
       imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2 ), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
       imgui.Begin(u8'SHAMAN FORSE - v1.05', Hmenu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
	   imgui.BeginChild('nick',imgui.ImVec2(800, 50), true)
        if imgui.Button(u8'[      S     W     A     T     ]', imgui.ImVec2(790, 30)) then
          sampAddChatMessage('SWAT - ELITE FORSE', -1)
        end
		imgui.EndChild()
                  --������ ���� --
		   imgui.BeginChild('0', imgui.ImVec2(200, 500), true, imgui.WindowFlags.NoScrollbar)
           imgui.PushItemWidth(120)
           imgui.SetCursorPos(imgui.ImVec2(10, 10))
		if imgui.Button(u8'�������� ����', imgui.ImVec2(180, 70)) then selected = 1 end
		   imgui.SetCursorPos(imgui.ImVec2(10, 90))
	    if imgui.Button(u8'�������', imgui.ImVec2(180, 70)) then selected = 2 end
		   imgui.SetCursorPos(imgui.ImVec2(10, 170))
	    if imgui.Button(u8'����', imgui.ImVec2(180, 70)) then selected = 3 end
           imgui.SetCursorPos(imgui.ImVec2(10, 250))
        if imgui.Button(u8'����������', imgui.ImVec2(180, 70)) then selected = 4 end

         -- ����� ��������� ��������� --
		   imgui.SetCursorPos(imgui.ImVec2(10, 420))
        if imgui.Button(u8'��������� ���������', imgui.ImVec2(180, 70)) then
           config.accent.PdTeg = PdTeg.v
           config.accent.Fighter = Fighter.v
           config.accent.Fighter_2 = Fighter_2.v
		   cfg.accent.activR = activR.v
		   cfg.accent.Fighter = Fighter.v
		   cfg.accent.Fighter = Fighter_2.v
		   inicfg.save(config, 'ShamanSetting.ini')
		   printStringNow('~g~Saved', 1500)
		   imgui.PushItemWidth(140)
	    end
           imgui.EndChild()
           imgui.SameLine()
        if selected == 1 then
		   imgui.BeginChild('1', imgui.ImVec2(600, 500), true, imgui.WindowFlags.NoScrollbar)
		   imgui.BeginChild('���� ���������', imgui.ImVec2(270, 130), true)
		   imgui.SetCursorPos(imgui.ImVec2(10, 60))
		   imgui.Combo(u8'����', ClistZ, ClistArr) -- ����
		   imgui.PushItemWidth(140)
  	       cfg.accent.ClistZ = ClistZ.v
           inicfg.save(config, 'ShamanSetting.ini')
	       imgui.SetCursorPos(imgui.ImVec2(10, 35))
  	       imgui.Combo(u8'���������', zvanie, arr_str) -- ���������
		   imgui.PushItemWidth(140)
  	       cfg.accent.zvanie = zvanie.v
           inicfg.save(config, 'ShamanSetting.ini')
           imgui.SetCursorPos(imgui.ImVec2(10, 10))
           imgui.InputText(u8'��������', PdTeg) -- ��������
		   imgui.PushItemWidth(140)
  	       imgui.SetCursorPos(imgui.ImVec2(10, 100))
		   imgui.Checkbox(u8'���������', activR)
           imgui.EndChild()
           imgui.SameLine()
		   imgui.BeginChild('���� �������', imgui.ImVec2(270, 130), true)
           imgui.PushItemWidth(140)
		   imgui.SetCursorPos(imgui.ImVec2(10, 10))
           imgui.Combo(u8'����������', patrulZ, arr_str2) -- ����������
  	       cfg.accent.patrulZ = patrulZ.v
           inicfg.save(config, 'ShamanSetting.ini')
           imgui.PushItemWidth(140)
           imgui.SetCursorPos(imgui.ImVec2(10, 35))
		   imgui.InputText(u8'���� 1', Fighter)
		   cfg.accent.Fighter = Fighter.v
           imgui.PushItemWidth(140)
           imgui.TextQuestion(u8'���������: ����� �������� ������� # (#��������)')
           imgui.SetCursorPos(imgui.ImVec2(10, 60))
		   imgui.InputText(u8'���� 2', Fighter_2)
		   cfg.accent.Fighter_2 = Fighter_2.v
           imgui.PushItemWidth(140)
           imgui.TextQuestion(u8'���������: ����� �������� ������� # (#��������)')
           imgui.EndChild()

		   imgui.BeginChild('���� 12', imgui.ImVec2(555, 400), true)
           imgui.Combo(u8'���������� �����', cameraZ, cameraArr)
           cfg.accent.cameraZ = cameraZ.v
		   imgui.EndChild()


		   imgui.EndChild()
	    end
	    if  selected == 2 then
		        imgui.BeginChild('2', imgui.ImVec2(600, 500), true, imgui.WindowFlags.NoScrollbar)
		    if  imgui.Button(u8'�����', imgui.ImVec2(180, 20)) then Selectfunction = 1 end
		        imgui.SameLine()
		    if  imgui.Button(u8'������', imgui.ImVec2(180, 20)) then Selectfunction = 2 end
		        imgui.SameLine()
		    if  imgui.Button(u8'���-����', imgui.ImVec2(180, 20)) then Selectfunction = 3 end
            if  imgui.Button(u8'�������', imgui.ImVec2(180, 20)) then Selectfunction = 4 end
	
            if Selectfunction == 1 then -- �����
		        imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
                imgui.Button(u8'��� + E', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'������ ���������')
                imgui.Button(u8'��� + Q', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'����� ���������')
                imgui.Button(u8'��� + Y', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'����� �� ����� ')
                imgui.Button(u8'��� + X', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'�������� � ������')
                imgui.Button(u8'��� + Z', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'��������')
                imgui.Button(u8'��� + B', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'�������� � ������')
                imgui.Button(u8'��� + SHIFT', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'��������� /PS')
                imgui.Button(u8'��� + 1', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'�������� �� ������(��������)')
                imgui.Button(u8'��� + ALT', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'/TAZER')
		        imgui.EndChild()
	        end

		    if  Selectfunction == 2 then -- ������
		        imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
		        imgui.TextWrapped(u8'���� ����� ���� ������.')

			    imgui.EndChild()
			end

		    if Selectfunction == 3 then -- ��� ����
			    imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
			    imgui.Button(u8'X + 1', imgui.ImVec2(100, 25))
			    imgui.SameLine()
		        imgui.TextWrapped(u8'10-0	�Ѩ ��������')
		        imgui.Button(u8'X + 2', imgui.ImVec2(100, 25))
			    imgui.SameLine()
			    imgui.TextWrapped(u8'10-1	������ � ���������� ������������')
			    imgui.Button(u8'X + 3', imgui.ImVec2(100, 25))
			    imgui.SameLine()
			    imgui.TextWrapped(u8'10-2	����������� �� ���������� ������������')
                imgui.Button(u8'B + 1', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'10-13 ��������� ������. ������ ��� �����.')
                imgui.Button(u8'B + 2', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'10-34 ���������� ���� ��������� �� �������� �������, ���������� ������������')
                imgui.Button(u8'B + 5', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'10-81 ����� ������')

                imgui.EndChild()
		    end
            if Selectfunction == 4 then -- �������
                imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
                imgui.Button(u8'rr', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'������� �����')
                imgui.Button(u8't', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'������� ���')
                imgui.Button(u8'mm', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'���� �����')
                imgui.Button(u8'mem', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'Members')
                imgui.Button(u8'ppp', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'/patrul - ������� �������')
                imgui.Button(u8'md', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'������� MDC')
                imgui.Button(u8'oop', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'/wanted 1')
		   
                imgui.EndChild()
            end
                imgui.EndChild()
		end

	   if selected == 3 then
		            imgui.BeginChild('2', imgui.ImVec2(600, 500), true, imgui.WindowFlags.NoScrollbar)
		        if  imgui.Button(u8'��', imgui.ImVec2(180, 20)) then SelectInfo = 1 
                end
		            imgui.SameLine()
		        if  imgui.Button(u8'����', imgui.ImVec2(180, 20)) then SelectInfo = 2 
                end
		            imgui.SameLine()
		        if imgui.Button(u8'�����������', imgui.ImVec2(180, 20)) then SelectInfo = 3 
                end
                if imgui.Button(u8'���-����', imgui.ImVec2(180, 20)) then SelectInfo = 3 
                end


        if SelectInfo == 1 then
		 imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
         imgui.TextWrapped(u8'����������� �������������.')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'1.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ����� ���������� �����������, ����������� � ���������� ��������������� ��������, �������������� ������������ ������������ � ��������������� ����������� ����������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'1.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'�������� ������ ���������������� �� ������� ���������: FBI, SAPD, Army.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'1.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������������� ����������� ��������� (Mayor, MoH, Instructors) ����� ��������������� �� ���� ��������� ������������ ����������������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'1.4 ')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ���������� ������������ ������ - ��.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'������ �2 ')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'� ����������� ������� �������� ��������������� ������������ � ')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8' ����������� ����:')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.1.1')
 		 imgui.SameLine()
 		 imgui.TextWrapped(u8'����������� ������ ��������� �������� �� ���������� ����������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.1.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ��������� ������� �������� ������������ � �����������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.1.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ������� ��������� ��������� ������� ���������� (��, ���) ��� ������������� �� ���������������� ������������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ������������:')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'�������� ���������� ���������������� ����������, ��������������� ����������� ��������, � ��� �� ��������������� ������� ��������, �� ����������� ��� ���������� ����������� ������������:')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ������������� ������� � ������������ ������� ����������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ������ ����������� �������� � ������������ ����������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.4')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ������������ ��������� ��������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.6')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'���������� ��� �� ��������������� �������������� ������������ � ������ � �����������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.7')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ����������-��������� ����������� �� ��������� � ���������� ���, ���������� ��� ������������� � ��������� ����������������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.8')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ������� ��������� ��� ��� ���������� ������������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ���� �������������:')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'�������� ���������� ���������������� ����������, ���������������� � ���������������� ������������ ���������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'�������� �� ����������� ����� ������������ ������������ �������������� � �������, ������������ ���������������� �������������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'������ � ���������� �������� ������ � ����������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.4')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'������������� � ���������� ������������ �������������� ������������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.5')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������������� ��������� � ��������������� ����������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.6')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ����������-��������� ����������� �� ��������� � ���������� ����� ������� ������������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.7')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ������������ ������� �������� � ������� ������ � �������������.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.8')

		 imgui.SameLine()
		 imgui.TextWrapped(u8'���������� ������������� ��������, ������������ �� ������ �������� ������ ')
		 imgui.TextWrapped(u8'            ��������������� �����������.')
		 imgui.TextQuestion(u8'����������: ��� �������� ����������� ������������ ������ ��������� � ����������� � ������������ ����������� �����������.')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'������ �3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'� ������� ��� ������� �������� �')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.1 ')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������� ����������� ����������, ������ ����������, ���������� ������ ������� ��������, ������������� ����� � ���')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������� � ������ ��� ����� � ��������������� ������������ �����������(�����, �����, �������')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.3 ')
         imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ���������� ����������� ����������')
		 imgui.TextQuestion(u8'����������: ��������� ������������ ��������� ������������ �� ��������������� ����������� ��������������, ����, ������������ ������, ��������� �������� ���� �� ����������� �������, ������ ������� �� �� ���������. ��������� ������������� ����. ��������, ��������, ����� � ������� ��������������� ����������. ���������� - ��������� ������������ ���')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� / ���������� ')

	     imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.4')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������� ������� ��������� ��������')
		 imgui.TextQuestion(u8'����������: �������� ������������ ������� � ���������� ������������ ������� � �� ����������� �������� ��������, �������� ���������� ��������� �������, ����� ��������� �� ���������� ������� ������. ���������� �������� ��������� ������������ �������, �������������� ������������ �������� � ���������� ������������ ������� �� ����������� �������� ��������. ���������� ��������� ����������� ��� ����� ��������� ������ ��������� �������� � ���� ������ � � ����� ���������� ���.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� + ����� / �������')



		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.5')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ��������� ����� ��� �������')
		 imgui.TextQuestion(u8'����������: ����������� �������. ����������� �������� ��������� ��������������� �������������� ���������, ����������� � ��������� ��� ��� ������ ���, ���������� ������� ��������� �� ����������� �������� ��������������. ���������� �������������� ������ � ������ � ������������ ��������� ������ ��� ��������� � �����������, ��������������, ��������, ��������, � ����� ����� ���� ������ (����, ������, ������ � ���� ��������). ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.6')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������� �� ���. ����������� ')
		 imgui.TextQuestion(u8'����������: ����������� �������. ��������� ����������� ������� ��������� � ������ 3.5 ��.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.7')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ������������ ��������� ���� � ������������')
		 imgui.TextQuestion(u8'����������: ��������� ������������ �� ����� ����������� � �� � ������ �� ����������. / ���� �������� �������� ����������� � ����������� - ��������� ���� ��� ����������, � ����� ����������.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.8')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ������������ ����������� �����')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� / ���������� ')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.9')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ����������� ����-����')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ���������� ')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.10')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ������������ �������� ��� ���������� ����������� ������������')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ���������� ')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.11')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� � ������� ����� ���������� ������ ������')
		 imgui.TextQuestion(u8'����������: ���������� �����������. ��������� ������ ����� �������������� ���������� ��� �������������� �� ��� �������������.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ���������')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.12')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ������������, �������� ������������� ������� � �������� ����������� ������, ������ �� �����')
		 imgui.TextQuestion(u8'����������: ������� ������� ����� ����� �� ����� 1 ����� �� ������. (����������: ����� ������������)')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ���������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.13')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'�������� ����� ��������� ��������� �� ��������� ���� ���������� ���������� ����� �������� ����� (Area 51, Naval Base 69, Los-Santos Port (����� �����������))')
         imgui.TextQuestion(u8'����������: ���������� ���������� ��������, ������������� ����� ������������ �������� �������������� ��� �������� ����� (������ ��������, �������������, ����. ������), ������� �� ������, ���������������� ������� � ����, ���������� ����������� ���������� �� ������������ �����.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� �� ��� ������� / ����������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.14')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �����/������ ������, ��������� ������� ��������, ����� �� �����, �������� � ����������� ������� ')
		 imgui.TextQuestion(u8'����������: �������� ������ / ����� � �����, ��������� ���������� �������������� � ���������������, �.�. �������������� ��������� ��������������� � ����������.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'����������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.15')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ��������� �����, �������������� �� �������� ����������� � ������� ��� ���������� �� ����� ����������')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ������� / ��������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.16')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������� ������� �����')
		 imgui.TextQuestion(u8'����������: ������� ���������������, ��������, ������������� ��� �������, ������������ ������� ��� ����� ��� ����������.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / �������')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.17')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �� �������� �� ����������')
		 imgui.TextQuestion(u8'����������: ��������� ���� � ������, ���� �� ������������ ������� ����������� FBI / PD / Army �� ����� �� ����������.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / �������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.18')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'����������� ������� ��������� ���������� � ��������� ��������� ������������ �� ��������� ���������� ������ ������������')
		 imgui.TextQuestion(u8'����������: ����� �������� ��� ������� ���������� �������� � ������� 7 ��.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ���������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.19')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ����������� � ������������ ��� ������� ������� �� ������������ ���������')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ����������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.20')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ���������� � ������ �� ������� �� ��������������� � ����')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ������� / ���������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.21')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ��������� � ������ �����, ������� �� �������� ���� ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ���������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.22')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ������� ������ ������������ ��� ������� �������')
		 imgui.TextQuestion(u8'����������: ���� �� ������ ������ �������� / �������������� ��������� �����������, ��� ���� ��������� FBI � ����� ������������. ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.23')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������� � ��/����/���� �� ����� ���������� ')
		 imgui.TextQuestion(u8'����������: ���� �� ����� ������ �������/����� �������� �������� �� ��������/����, ������������ ��� � �������� �������, ��� ���� ��� ����������� ��������� ��� - ��������� ���������� �������/���� (����� ����� ���-�� ���������)')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ������� / ���������  ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.24')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ����������� �� ��������� ������� ����������')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.25')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ������������� ���. ���������� �� ������������� �������� ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.26')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������������� �������� �����, ����������� ������� � ��� ��� ���������� ��� ����� ��������� ������������ ')
		 imgui.TextQuestion(u8'����������: ��� ����� ��������� ���������� ����������, ��������� ��� ����� ����� ������� ������������� �������� ���������� ������� ��� ��������� �����. ��� ���������� ���������� �������� ����������� ��� ���������� ����������� ������ ���� � �������� ������ ����������� ���. ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ���������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.27')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������� ���������������� ���������')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ���������  ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.28')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'�� ��������� ���������� ��� �������������� (��������) ���������� � �����������, ����������� ��� ���������� ��������������� ������������ ��� ��� ����� �� ��������� ������� �� 3 ������� ��, �� �������������� ����������� ����������������� ����� - ����� ������ (7 ���� �� ��� ���������� �������) ����� ������ ��������� - ���������, ��������� ������/��������� ��� ��������������(���������) � ����������� �������� ���������, � ���������� - ��������� �� ��� �������. ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.29')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ��������� ����� ������������ ��� ��� ������� ������, ��� � ������ ��')
		 imgui.TextQuestion(u8'����������: � ������ ���������� �������������� ��������� ����� �� ����� ����������� ����������. ������� ��������� ����� ������ ��������� ��������� ���������� �� ������ � ��������� ��.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ������� / ��������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'3.30 ��������� ��������� ����� ���������������� ��������� ��� ��������� ����������� ����� / ������ ���')
		 imgui.TextQuestion(u8'����������: � ������ ���������� �������������� ��������� ����� �� ����� ����������� ����������. ������� ��������� ����� ������ ��������� ��������� ���������� �� ������ � ��������� ��. ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.30')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ��������� ����� ���������������� ��������� ��� ��������� ����������� ����� / ������ ���')
		 imgui.TextQuestion(u8'����������: ���������������� �� ����� ����������, � ����� ���������� ������ ���������� ����� ���������� ��� ������ �����������. ���������������� �� ����� ����������, � ����� ���������� ������ ���������� ������� �������� ���������� ������ ���.� ���� ��������� - ���������� ����������� ���������/������� ���������� ������ �����������.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ��������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'3.31 ��������� ����� ����������, ���������� ���� ��������� �� ���������/�������, ���� �� �� �������� � ���/HRT')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ����������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.32')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ���������� �� �������� ������ DEA FBI, � ����� �� ������������� �������� FBI')
		 imgui.TextQuestion(u8'����������: ��������� �� �������������� �� ��������, � ������ ���� �� ��������� ������ � �� �������� ���.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.33 ')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'�������� ����� ����������� � ������� ����������� �������������')
		 imgui.TextQuestion(u8'����������: ����������� ���������� � ���������, ��������� ������������ � ������ �����������, ������������ ����������� �������, ������� �������� ������. ����������: ����� ����������� ��������/����������� ������������ �������� � ������,��� ����� ����� �������� ���, ��� ������� �����������. ����� �������� ����� ���� �������� ���������� �� ����� ������ �������/����� ������������ �� ���������� ������������ ����� ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ���������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.34')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� �������� ������������ ��� ������� � ���.��������� / ����������')
		 imgui.TextQuestion(u8'����������: ������������� �� �� , �������� ���, �������� ��������')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ������� / ���������')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'������ �4')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'� ���������� ��������������� �������� � ')
		 

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'��������� ���������� ������ ��� � ����������� �����')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ����������')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'��������� ���������� ���������� ������ ��� ��� ����� ���������������')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'��������� / ���������� ')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.3')
         imgui.SameLine()
         imgui.TextWrapped(u8'��������� �������� ������������ ��� ������� � ����������� ���, ������������ �����')
         imgui.TextQuestion(u8'����������: ��������� ����� �������� �� ���������� �����, ���������� �� "��", ������������ ��� �� �������, �� ����������� �� ��������� � ���, ����� �������� �� ���������� �������� ��������.')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ���������')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.4')
         imgui.SameLine()
         imgui.TextWrapped(u8'��������� ���������� ������ ��� � ����������� �����')
         imgui.TextQuestion(u8'����������: ��������� �������� ������, ����������������� ������� �������� � ��� ������, ����� ��������� �� ��� ���������� ����������� ������������ � �� ��������� ����.�������; �������� �� DEA.')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'���������')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.5')
         imgui.SameLine()
         imgui.TextWrapped(u8'��������� �������� �������� ����������� ������� ��� � ����������� �����')
         
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'������� / ���������')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.6')
         imgui.SameLine()
         imgui.TextWrapped(u8'��������� ���������� � ����� / �� ���������� ��� ��� ������ / ���������� ������ ��� (6+)')
         imgui.TextQuestion(u8'����������: ������� ������ (����� +) ����� ����� �������������� �� ������� ���������� ����� ����������� � ����� ���. ����� ������� �� ���������� ����� ������� ������ ������ ��������� ���������� ���, ��������������� �����, � ��� �� ��������� ��������� ���������� ������� � ����� ��������� �� ���, ����� ���������� �� ��������� � ������� ����� ���������.')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ���������')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.7')
         imgui.SameLine()
         imgui.TextWrapped(u8'��������� ���������� �� 5-�� ����� ����� ��� ������ / ���������� ���� ��� ��� ����������� (6+)')
         
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'�������������� / ���������')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.8')
         imgui.SameLine()
         imgui.TextWrapped(u8'��� � ���������� ���, �� ���� ����� CID / DEA, ����� ����� ��������� ������� ��� ��������� ��������� ����������� ����������, �������, ������������� ����� ��� ���.')
        
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.9')
         imgui.SameLine()
         imgui.TextWrapped(u8'��������� ���, �� ���� ������ DEA / CID � ��� ������ ������� ������ ���������������� ��������� � ���� / ����� ��� ����������� ������� (������� ����� ������� �� �����).')
         imgui.TextQuestion(u8'����������: ���� ����� �������� ��������������� ������ ���������� � ���������� ���� ���������� ���������� ���������� ��� ��� ����, �� ��������� � ���������� ��������� ������ 3.3 ������������ ������; ������������ ��������������� ��������� ����� ����� �������� ������ �������� ��� � ���, ������� �������� � ������������� - �� ���� ���.��������� ��� � ���.����.')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.10')
         imgui.SameLine()
         imgui.TextWrapped(u8'��������� ��� ����� ����� �������� ���������� ������ ���������������� ��������� (����� ������� �������� ������� ��������, � ���, ���������� ����������� ��������� � ����������� ����������) ��� ��������� ��������� �� ���� ����������� ����������, ����, ������������� ����� ��� ���, ���� ���������� ������� �����������.')
         imgui.TextQuestion(u8'')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'������ �5')
         imgui.SameLine()
         imgui.TextWrapped(u8'� ���������� � ������������ ������������� � ')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'5.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'����������� ������������� ����� ���� �������� ����� ����������� ������������� � ��������� ��� ���������� ����������� ������� �������������� ������ ������ � ���������� ������ ����������.')
         imgui.TextQuestion(u8'������: ����� ������������ ������������� ��� ������� � 18:00, � �������� � ���� - � 00:01 ���������� ���')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'5.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'��� ��������� � ���. ���������� ������ ����������� � ��������� ������������������ - �������������� / ������� / ��������� / ����������')
         imgui.TextQuestion(u8'����������: � ����������� �� ������� ���������, ������� ����� ����������� � ������ �������.')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'������ �6')
         imgui.SameLine()
         imgui.TextWrapped(u8' � ������� ������������� �������������� ������ � ')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'6.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'������������� ������� ��������� ������, � ������� ������������ ������ �������.')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'6.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� SAPD/FBI/Army ����� ����� ������������ ������������� ������ � ��������� �������:')
         imgui.TextWrapped(u8'- ��� ������ ���� ���� ������� ���� �� ��������������, ���� ��� �������������� ��������� � ��������, ������� ��� ����� ��� ��������;')
         imgui.TextWrapped(u8'- ��� ���������� ������� ���������� �������� ������������ �����, ����������� � ������ ��������, ���������� �� ���������� �����;')
         imgui.TextWrapped(u8'- ��� ���������� ����, ������������ ��� ���������� ������, ����������� �������� ����� ������� ������������ ������ �����, �������� ��� �������������, � ����������� ��������, ���� ����� ���������� ��������� ��� ���� �� �������������� ���������;')
         imgui.TextWrapped(u8'- ��� ���������� ����, ������������ ����������� �������������, � ����� ����, ��������������� ��������� �������� ���������� ���������������� ��������� � ����� ����������� ��� ��� ������, �����������, ���������� ���������;')
         imgui.TextWrapped(u8'- ��� ������������ ����������, ��� ������� ����������� ������������ ����� ����������;')
         imgui.TextWrapped(u8'- ��� ��������� ���������� ��� ������������ ��������� �� ������, ���������, ���������� � ���� ������� ��������������� �������, ������������ �����������, ����������� � �������;')
         imgui.TextWrapped(u8'- ��� ��������� ������������� �������� ����� ��� �����������, ���� ����������� �� ���� ������������ ��������� ������������� ���������� ���������� �������, ���, ��������������� ����� �� ��������� � �������� ��������, �������� ������ ����� � �������� �������;')
         imgui.TextWrapped(u8'- ��� ������������ ������������������ ��������, ������ ������� ������� ��� ������ ������ ����� ������������ �������� �����, ��� � ���� ���������� �����������;')
         imgui.TextWrapped(u8'- ��� ������, � ��� �� ��� ���������� ������� ����������� ��������� ���������� ��� �������� ����������, ���� ��� ���� �� ����������� �������� ���������� �������� ������ ����������, ����������� ���������� ����������������� �������� � ������, ��� ���������� ������������� ����������, �������� ���������� ������;')
         imgui.TextWrapped(u8'- �� ������� ����� � ������ ��������� ��� ������������� ��������������,         ��������, �������� ������ �������������� ����������� ���������� ������;')
         imgui.TextQuestion(u8'����������: ��������� �������, ���, �������������� ����� �� ����� ����� ��������� ������������� ������ ��� ������������ ��������� �������, ���� � ���������� ��� ���������� ����� ���������� ��������� ����.����������: ����������� �������������� � ����������� ����������, ���������� � ��������� ������, ���������� ������������� � ���������, ����������� � �������������� ������ ������ ����, ���� ���������, ������������� ������ � ��������� ������� � ������ ����������� �� ����, ���� ���������, ������� � ����������, ��� ������ ������� ����� ���� ��������� ������ ���� �������� ��� ������. ')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'������ �7')
         imgui.SameLine()
         imgui.TextWrapped(u8'� ���������� ������� �')
        

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ������� ������� � ������������ � ������ �������� ���������� ���-�������:')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.1.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ������� �� ����������� ������ Los Santos � Red County.')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.1.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ������� �� ����������� ������ San Fierro � Whetstone.')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.1.3')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ������� �� ����������� ������ Las Venturas � Bone County.')
     

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ��� ������� ������� �� ������� ����� ������������ ���������� ����� ��� ������������:')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.2.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ������� �� � ������� �� ����������� ������ Flint County.')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.2.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ������� �� � ������� �� ����������� ������ Tierra Robada.')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.3')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ������� ��������� �������� � ����������� �� ����� ������������ ���, � ������:')
         imgui.TextWrapped(u8'- ������ �� �������������, ���� ������� �� ������� ������� ��� (6+).')
         imgui.TextWrapped(u8'- ���������� ����������� �������� / ����������.')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.4')
         imgui.SameLine()
         imgui.TextWrapped(u8'���������� ������� ��������� �������� ��� ���������� �� ����� ������������ ���, � ������:')
         imgui.TextWrapped(u8'- ������ �� ������������.')
         imgui.TextWrapped(u8'- ������������� ������� ��������� ���.')
         imgui.TextWrapped(u8'- ������� � ����������� �������� �� ���.')
         imgui.TextWrapped(u8'- ������� ����������� ������� �� ��� ��� ����.������� ���� ����������.')
         imgui.TextWrapped(u8'- ������ �� ������ �� ������� � ����������� �� ������ �����������.')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.5')
         imgui.SameLine()
         imgui.TextWrapped(u8'��� ������ � ����� ���������� ����������� �������� ����� ������ ������� �������. � ������ �������� ������� ����� ������ ������� �������, ������� ����� ����� ����� ��������� ���������� ����������� ������� ������������ � ���� � ����������. ������ ������� �� ��������� � ������� ��������.')
         imgui.TextWrapped(u8'- .')
         imgui.TextWrapped(u8'- .')
		 imgui.EndChild() -- ��
		end

		if SelectInfo == 2 then -- 
				 imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
			



				 imgui.EndChild()
			end


		   imgui.EndChild() 
	    end
        if selected == 4 then -- ����������
           imgui.BeginChild('1', imgui.ImVec2(600, 500), true, imgui.WindowFlags.NoScrollbar)
           imgui.TextWrapped(u8'SHAMAN FORSE, ������ 1.00')
           imgui.TextWrapped(u8'��� ����� ������ ������ ����� �������, ���������� ��� ����� ���������, �� ��� �� ����� ��� ���� ��� ������������.')
           imgui.TextWrapped(u8'������ ������ ���������� ���������� ��� SWAT SFPD � ���� ���������� � �������� ������.')
           imgui.TextWrapped(u8'����� �� ����������� ���������� �������� �������')
           imgui.TextWrapped(u8'������ ����������� �������������. ����� ������ ��������� ��� ������ ������ �� ������� ������.')
           imgui.TextWrapped(u8'����� �� ��������� ������:')
           imgui.TextWrapped(u8'- ������� ������� ������. �� ������ ������ ��� ������� ������.')
           imgui.TextWrapped(u8'- �������� ������� ������ �������. � ���������, ������ ����� ������ ���� �������� ������ ������(���+B). ��� �� ������ ������, �� ����� ��� ������� ����� ��������������.')
           imgui.TextWrapped(u8'- ��������� ��� ������� � ������ ����������')
           imgui.TextWrapped(u8'- ��� �� � ������ ���� ������� ������')
           imgui.TextWrapped(u8'- ������� ������� ������� �������������� � �������. �� ��� ����� ������� ������ �������� � ������ ����� ����� ������� ����� ������� ��������� �� ��� �������')
           imgui.TextWrapped(u8'- �������� ������� �����')
           imgui.TextWrapped(u8'- �������� ������� ������� ������')
           imgui.TextWrapped(u8'� ������ �����.')
           imgui.TextWrapped(u8'� ������������� �� ��������� ������� ������ �������� � ������. ')
           
           imgui.EndChild()
       end
           imgui.End()
end


if avto_menu.v then
    imgui.SetNextWindowSize(imgui.ImVec2(600, 70), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2((sw / 1.8), sh / 1.05 ), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'�������', avto_menu, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)

    if imgui.Button(u8'�������/�������', imgui.ImVec2(100, 40)) then
      sampSendChat('/lock', 1000)
    end
        imgui.SameLine()
    if imgui.Button(u8'�������� ����', imgui.ImVec2(100, 40)) then
        sampSendChat('/rkt', 1000)
        avto_menu.v = false
    end
        imgui.SameLine()
    if imgui.Button(u8'�������� ����', imgui.ImVec2(100, 40)) then
        sampSendChat('/trunk', 1000)
    end
        imgui.SameLine()
    if imgui.Button(u8'����� ���������', imgui.ImVec2(100, 40)) then
        sampSendChat(u8'/tlock', 1000)
    end
       imgui.SameLine()
    if imgui.Button(u8'���������', imgui.ImVec2(100, 40)) then
       sampSendChat(u8'/i', 1000)
    end
        imgui.End()
end

if msk_menu.v then
    imgui.SetNextWindowSize(imgui.ImVec2(350, 70), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2((sw / 1.8), sh / 1.05 ), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'������� 2 ', msk_menu, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
    if imgui.Button(u8'������ �����', imgui.ImVec2(100, 40)) then
       msk_menu.v = false
       thread:run('beret')
    end
       imgui.SameLine()
    if imgui.Button(u8'������ �����', imgui.ImVec2(100, 40)) then
       thread:run('maska')
       msk_menu.v = false
    end
       imgui.SameLine()
    if imgui.Button(u8'��������� GPS', imgui.ImVec2(100, 40)) then
       thread:run('gps0')
       msk_menu.v = false
    end
    imgui.End()
end

if cuff_menu.v then
    imgui.SetNextWindowSize(imgui.ImVec2(500, 350), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2 ), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'SU', cuff_menu, imgui.WindowFlags.NoResize)
	imgui.BeginChild('223',imgui.ImVec2(460, 25), true)
	imgui.EndChild()
	imgui.BeginChild('2211',imgui.ImVec2(460, 240), true)

    if imgui.Button(u8'������ 1 [��������� �������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 1 ������ 1 [��������� �������]')
		cuff_menu.v = false
    end
     imgui.SameLine()
		imgui.Button(u8'[1]', imgui.ImVec2(30, 25))
    imgui.TextQuestion(u8'��������, ������������ �� ��������� ������������� ������� (��������� �� ����� ������������� ��������, ���������; ����� ����������������/������� ���������; ����� �� ��; ����������� ����� �� ��; ������� � ����; ������������ ���������, ����������� ����������� � ��������) � ������ �����������')



    if imgui.Button(u8'������ 2. [�������� ������ �� ������]', imgui.ImVec2(350, 25)) then
	    sampSendChat('/su '..actionId..' 2 ������ 2. [�������� ������ �� ������]')
	    uff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.SameLine()
        imgui.TextQuestion(u8'���������� ��������, ����������� ������� �� ������.')




    if	imgui.Button(u8'������ 3. [��������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 3. [��������]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
        imgui.TextQuestion(u8'���������� ����� �������� ��� ������������� �������������� ������, � ������� ��������� ������, ����, ������, ���, ������, � �.�.')

    if	imgui.Button(u8'������ 4. [������� ������ � �������� ����].', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 4. [������� ������ � �������� ����]')
 	    cuff_menu.v = false
    end
        imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
        imgui.TextQuestion(u8'������� ������ � ����� ���������� � ������������ ������ � ������������� ������������� ���������� ������������ �������� ������')

    if	imgui.Button(u8'������ 5. [�������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 5. [�������]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'�������� ������ ��������� ���������� ��� ��������������� �������� ������ ��������, ��������� ����� � ����������� ������� ���� ��� ����������� ��� ���������.')

	if	imgui.Button(u8'������ 6. [������� ������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 6. [������� ������]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'����������� ���������������/������������ ������ ��� ��� �������')

	if	imgui.Button(u8'������ 7. [��������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 7. [��������]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'������������ ��� ������������� �� ������������ ����������� �������������, �������, ���������, ���������� ��������������� �����, ���� ������������� ���� ���������� ������, �� �������� ����������� ����������, ���� ������ ���������')

	if	imgui.Button(u8'C����� 8. [����� �� ������ ������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 C����� 8. [����� �� ������ ������] ')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'����� ���������� ����� �� ���������������� �������������� ������������ ����')

    if  imgui.Button(u8'������ 9. [������������].', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 9. [������������]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'��������� ���������� ���������� �������� ����������� -> ����������� ����� �3 � ������������� � �����������')

	if	imgui.Button(u8'������ 10. [����������� ������ ���������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 10. [����������� ������ ���������]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'�����������/��������� ����� ������ ��������� ����������� ��������������/��������� ���������')

    if imgui.Button(u8'������ 11. [���� ��]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 11. [���� ��]')
 	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���������� ���������� ����� ������������ ���������, � ����� ������� �����')

    if imgui.Button(u8'������ 12. [����� �� ��������]', imgui.ImVec2(350, 25)) then
	    sampSendChat('/su '..actionId..' 2 ������ 12. [����� �� ��������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'������������ ��� ����� �� �������� ������������ ���������')

    if imgui.Button(u8'������ 13. [����������� ������������� �������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 13. [����������� ������������� �������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'����� ��� ����������� ����������� � ������������ ��������, � ����� ��������������� ������ �������, ���� ��� ������ ��������, ���������� ������������� �������� ���������: ������ �� ������ ��������. 3 ������� �������. ��������� ��������� �� ������� ����������� ����������� ��������')

    if imgui.Button(u8'������ 14. [������������� �� ����������, ��������������� ��������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 14. [������������� �� ����������, ��������������� ��������]')
	  cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���������� �� �����������, �������� ��� ���������� ��������� ������������ ������ (���������� ������� ���, ������� � �������� �� � ��� � �.�). ����������: ��� ����������, ������������ ���������� ������ �� �����, ������� ���������� �� ����������� ����, ��������� ���������� ����������� �����. ����������� ����������� ������ ����� ������������� ����������� �������������� � ������� � ���, ��� �� ������������ � ���������� ����������. ��� �� ��� ��� ������ �������� ������������� �� ������� ����������, � ������ ��� ��� ����������� ������� � ����, ���� ������� �������.')

	if	imgui.Button(u8'������ 15. [������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 15. [������]')
	  cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'�������� ����� ������������������ ������� ��� ���������� ��� ��������� ������������. ������: ������ ��� ���������� �����������')

	if	imgui.Button(u8'������ 16. [������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 16. [������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���� ����������� ��� ��������� ����������� ����� ��������� �������������� �� �������� ���� ����������� � ������� ��������, ���������� ��������� ������������ (��������, ���� ������ ������������ �� ������ �������)')

	if	imgui.Button(u8'������ 17. [������� ������ ��� ��������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 17. [������� ������ ��� ��������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'�������� ������ ��� ���� / � ����� ���� ��� ������� �������� �� ������.')

	if	imgui.Button(u8'������ 18. [�����������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 18. [�����������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���������� �������� ����� � ����������� ��������, ���������� � ������ ����������� �����, � ��� ����� � ��������� ���������� �������, ��������, ���, ���.')

	if	imgui.Button(u8'������ 19. [������������ ���������� ��/���]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 19. [������������ ���������� ��/���]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'������������� �������� ����������� ����������� �������, ���, ������ ������ ����� �� ���������� ����� ��� �������������� �� ���������� ������� ��� � ���������� (�������� ����������, ����� �� ��, �������� ��������� � ������)')

	if	imgui.Button(u8'������ 20. [������� ���������������� ���������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 20. [������� ���������������� ���������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'�������� �� �������� �������������� ������ �� ����� ������� ����� ����������� ����� ��� ���� ��������������� ���������')

	if	imgui.Button(u8'������ 21. [������� ����������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 21. [������� ����������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'��������������� ������������� ������� ��� �������, ���������� ������������� ������������� �������')

	if	imgui.Button(u8'������ 22. [�������� ����������/����������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 22. [�������� ����������/����������]')
	  cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'�������� ����������, ������� ��� ����������� ������������ ������, � ����� �������� ������������� �������. 3 ������� ������� � �������� ������������ ����������� �������. ��� ������������ �����, � ��� �� ��� ������� �� ������/������� ��������� �� ��������')

	if	imgui.Button(u8'������ 23. [������������ ������������� �������] ', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 ������ 23. [������������ ������������� �������]')
	  cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'������������ ������������� �������, ���������: 2 ������� ������� + ������� ����������.')

	if	imgui.Button(u8'������ 24. [������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 24. [������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���������� ����� �������� ��� ������ ����� ���������� � �������������� ������ (����������� ������ �� ��������), ��������, ��������������, ���������� ��� ����������. ���������: 3 ������� ������� + ������� �������� �� ������.')

	if	imgui.Button(u8'������ 25. [����]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 25. [����]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'�������� ������������� ����������� ������� ��� ��� ��� ������� ���������� � ����� �� ������, ��� ���� c ����� ���, ���������: 3 ������� ������� + ������������� ������������� �������������.')

	if	imgui.Button(u8'������ 26. [�����]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 26. [�����]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���������� ����������, ������� ������� ������ ��������� ��� �������� �������, � ��� ����� �����, �������, �������� ������� ����� � ������� ���������������� ���������. ���������: 3 ������� ������� + ������� ����������� ���������.')

	if	imgui.Button(u8'������ 27. [���������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 ������ 27. [���������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���������� ����������� ������� ����, ������ � ��������� � ����������� ����������� ������ ��� ��� ������ ����������. ���������: 4 ������� ������� + ������ �� ������ ��������.')

	if	imgui.Button(u8'������ 28. [�����]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 ������ 28. [�����]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���������� ����� �� ����� �� ��������� ����� ���������� � �������������� ������ �� ����� ��� ����������� ���������� �������� ��������. ���������: 4 ������� ������� + ������� ������ �� �����.')


	if	imgui.Button(u8'������ 29. [��������� �� ���������������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 ������ 29. [��������� �� ���������������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'��������, ���������� ��� ������ ���������� ����� �������� � ��������� ��������� �����. ���������: 4 ������� �������.')

	if	imgui.Button(u8'������ 30. [��������� �� ������������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 5 ������ 30. [��������� �� ������������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[5]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'��������, ���������� ��� ������ ���������� ����� �������� � ��������� ���������� �������. ���������: 5 ������� ������� + ������� �������� �� ������.')

	if	imgui.Button(u8'������ 31. [��������� �� ������ ��� / ����]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 6 ������ 31. [��������� �� ������ ��� / ����]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[6]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'��������, ���������� ��� ������ ���������� ����� �������� � ��������� ������ ��� / ����. ���������: 6 ������� ������� + ������� �������� �� ������.')

	if	imgui.Button(u8'������ 32. [���������/����������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 6 ������ 32. [���������/����������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[6]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'������������, �����������, ������ ��� ���������� ����������������� ����, ���� �������� ����� ��� ��� ������� � �������������� ������. (������ ������ ����� �������� �� �������). � ������� ����� ������� ����� ��������� �������� ����������� � ������ ��������/����������/�������� ����������� ��� ������ ����� (������������ ������ ������� ��� ����� ��������) -> ����������� ����� �3 � ������������� � �����������. ���������: 6 ������� ������� + ������� �������� �� ������ + ������ �� ������ ��������.')

	if	imgui.Button(u8'������ 33. [���������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 33. [���������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'������������� � ���������� ������������, ��������������� ����������� ��� �������� ����� ������������������ ������� ��� ���������� �����������. ���������: ��� �� ������� �������, ��� � � �����������.')

	if	imgui.Button(u8'������ 34. [���� ����.��������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 ������ 34. [���� ����.��������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'������������� � ������� ������������, �������� ����� ������������������ ������� ��� �������������������� ������������. ���������: 4 ������� �������')

	if	imgui.Button(u8'������ 35. [��������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 35. [��������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'���������� ������������ ����������� � ������ ������������� �������� � ����� �������� ����������� � ����������� �� ���������, ����������, ������ ���������� ��� ������ ���� (���) ���� ������ ���� ���������� � ��������������� � ������� ����� �����. ���������: 3 ������� �������')

	if	imgui.Button(u8'������ 36. [����������� ������� ������������ / ������� ������������ ]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 ������ 36. [����������� ������� ������������ / ������� ������������ ]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'������, ������������ �� ����������� ������� ������������ ������� ������, � ����� ���������� �������� ��� ������� ������������ ��� ��������������� �������������� ��������� ��� ������� ������������. ���������: 3 ������� �������, ����� ������������ 10.000 ���� (���������� �� ����������)')


	if	imgui.Button(u8'������ 37. [�������������]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 ������ 37. [�������������]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'�������������, �� ���� ������� �������� ��� ���� �������� ������������ ��������� � ����������� ������� ��� � ������� ��� ���������� � ������������ (�����������) ��� � ������ ����� ���� � �������������� ������������ ��������� ������������ (�����������). ���������: 4 ������� �������.')

		imgui.EndChild()
        imgui.End()
    end
end

function cmd_shaman()
   Hmenu.v = not Hmenu.v
   imgui.Process = Hmenu.v
end

function cmd_maska()
    thread:run('maska')
end

function cmd_gps0()
    thread:run('gps0')
end

function cmd_go()

    sampSetChatInputEnabled(true)
    sampSetChatInputText('/r ['..arr_str[zvanie.v +1].. ' � ' ..u8:decode(PdTeg.v)..']:'..arr_str2[patrulZ.v +1]..', 10-1 ') 

end


 
function imgui.TextQuestion(text)
        imgui.SameLine()
        imgui.TextDisabled('(?)')
    if  imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end




function thread_funtion(optimal)

    if optimal == 'cuff' then
       sampSendChat('/me ���� �������')
    end

    if optimal == 'maska' then
       sampSendChat('/me ���� ����� '..arr_str[zvanie.v +1]..' � ������� � ������������ �����')
       wait(1500)
       sampSendChat('/me ����� �����')
       wait(1500)
       sampSendChat('/clist 32')
       wait(1500)
       sampSendChat('/do �� ������ �����, �� ����� ��������, �������� �������� ����������')
    end

    if optimal == 'beret' then
      sampSendChat('/clist '..ClistZ.v +1)
      wait(1500)
      sampSendChat('/me ������ �� ������������� ������ ����� '..arr_str[zvanie.v +1]..' � ����� �� ������')
    end

    if optimal == 'gps0' then
      sampSendChat('/clist 0')
      wait(1500)
      sampSendChat('/seedo GPS-�������� ��������')
    end
end
--------------------------------------------------CLIST CHAT-------------------------------------------------------------------
function hook.onServerMessage(color, text)
    if text:find('%w+_%w+%[%d+%]%: .*') then
        local nick = text:match('(%w+_%w+)%[%d+%]%:')
        local hexcolorchat = bit.tohex(bit.rshift(color, 8), 6)
        local id = sampGetPlayerIdByNickname(nick)
        local hexplayercolor = ('%06X'):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
        text = text:gsub(nick, '{'..string.upper(hexplayercolor)..'}'..nick..'{'..string.upper(hexcolorchat)..'}')
        return {color, text}
    end
end
function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end
------------------------------------------------------------------------------------------------------------------------------------
    
 

-----------------------------------------------------------------------------------------------------------------------------------------------------
function apply_custom_style()
   imgui.SwitchContext()
   local style = imgui.GetStyle()
   local colors = style.Colors
   local clr = imgui.Col
   local ImVec4 = imgui.ImVec4
   local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 15.0
    style.FramePadding = ImVec2(5, 5)
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 15.0
    style.GrabMinSize = 15.0
    style.GrabRounding = 7.0
    style.ChildWindowRounding = 8.0
    style.FrameRounding = 6.0


      colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
      colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
      colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
      colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
      colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
      colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
      colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
      colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
      colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
      colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
      colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
      colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
      colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
      colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
      colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
      colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
      colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
      colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
      colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
      colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
      colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
      colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
      colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
      colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
      colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
      colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
      colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
      colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
      colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
      colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
      colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
      colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
      colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
      colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
      colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()


