script_name('SKRIPT')
script_author('SHAMAN')
script_description('GO')

require 'lib.moonloader' -- подключение библиотеки

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

local update_url = "https://raw.githubusercontent.com/Forestshaman/Shamanforse/main/update.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/update.ini" -- и тут свою ссылку

local script_url = "https://github.com/Forestshaman/Shamanforse/blob/main/SHAMAN_FORSE.luac?raw=true" -- тут свою ссылку
local script_path = thisScript().path


local config = { accent = { active = true, activR = false, zvanie = 0, patrulZ = 0, ClistZ = 0, cameraZ = 0},}
local ClistArr = { u8'[1] Зеленый', u8'[2] Светло-Зеленый', u8'[3] Ярко-Зеленый', u8'[4] Бирюзовый', u8'[5] Желто-Зеленый', u8'[6] Темно-Зеленый', u8'[7] Серо-Зеленый',
u8'[8] Красный', u8'[9] Ярко-красный', u8'[10] Оранженвый', u8'[11] Коричневый', u8'[12] Тёмно-красный', u8'[13] Серо-красный', u8'[14] Жёлто-оранжевый', u8'[15] Малиновый',
u8'[16] Розовый', u8'[17] Синий', u8'[18] Голубой', u8'[19] Синяя сталь', u8'[20] Сине-зелёный', u8'[21] Темно-синий', u8'[22] Фиолетовый', u8'[23] Индиго', u8'[24] Серо-синий', u8'[25] Желтый', u8'[26] Кукурузный', u8'[27] Золотой', u8'[28] Старое золото', u8'[29] Оливковый', u8'[30] Серый', u8'[31] Серебро', u8'[32] Черный'
}


function kvadrat()
    local KV = {
        [1] = "А",
        [2] = "Б",
        [3] = "В",
        [4] = "Г",
        [5] = "Д",
        [6] = "Ж",
        [7] = "З",
        [8] = "И",
        [9] = "К",
        [10] = "Л",
        [11] = "М",
        [12] = "Н",
        [13] = "О",
        [14] = "П",
        [15] = "Р",
        [16] = "С",
        [17] = "Т",
        [18] = "У",
        [19] = "Ф",
        [20] = "Х",
        [21] = "Ц",
        [22] = "Ч",
        [23] = "Ш",
        [24] = "Я",
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
                sampAddChatMessage("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
     
    

    sampAddChatMessage( tag.. ' Шаман приветствует тебя', 0xFFFFFF)
	sampRegisterChatCommand('r', function(text) if activR.v then sampSendChat('/r ['..arr_str[zvanie.v +1].. ' • ' ..u8:decode(PdTeg.v)..']: '..text) else sampSendChat('/r '..text) end end)
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
                    sampAddChatMessage("Скрипт успешно обновлен! Версия 1.05", -1)
                    thisScript():reload()
                end
            end)
            break
        end
        

    if isKeyJustPressed(0x54 --[[VK_T]]) and not sampIsDialogActive() then -- БЫСТРЫЙ ЧАТ НА [T]
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
     

		if isKeyDown(VK_X) and wasKeyPressed(key.VK_1) then -- 10-0	ВСЁ СПОКОЙНО. X + 1
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' • ' ..u8:decode(PdTeg.v)..']:'..arr_str2[patrulZ.v +1]..', 10-0 '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v))
		end
		if isKeyDown(VK_X) and wasKeyPressed(key.VK_2) then -- 10-1	ВЫЕХАЛ С ТЕРРИТОРИИ ДЕПАРТАМЕНТА.. X + 2
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' • ' ..u8:decode(PdTeg.v)..']:'..arr_str2[patrulZ.v +1]..', 10-1 '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v))
		end
		if isKeyDown(VK_X) and wasKeyPressed(key.VK_3) then -- 10-2	ВОЗВРАЩАЮСЬ НА ТЕРРИТОРИЮ ДЕПАРТАМЕНТА. X + 3
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' • ' ..u8:decode(PdTeg.v)..']:'..arr_str2[patrulZ.v +1]..', 10-2 '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v))
		end
		if isKeyDown(VK_B) and wasKeyPressed(key.VK_1) then --	10-13	ВЫСТРЕЛ В УКАЗАННЫХ КООРДИНАТАХ, ТРЕБУЕТСЯ ПОМОЩЬ. ОФИЦЕР ПОД ОГНЕМ. B + 1
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' • ' ..u8:decode(PdTeg.v)..']: 10-13, Нужна поддержка! Местоположение -  '..kvadrat())
		end

		if isKeyDown(VK_B) and wasKeyPressed(key.VK_2) then --10-34   СУЩЕСТВУЕТ РИСК НАПАДЕНИЯ НА ОФИЦЕРОВ ПОЛИЦИИ, СОВЕРШЕНИЯ ПРЕСТУПЛЕНИЯ. B + 2
			sampSendChat('/r ['..arr_str[zvanie.v +1].. ' • ' ..u8:decode(PdTeg.v)..']: 10-34, Нужна поддержка! Местоположение -'..kvadrat())
		end

        if isKeyDown(VK_B) and wasKeyPressed(key.VK_5) then -- 10-81 ПЕШАЯ ПОГОНЯ ЗА НАРУШИТЕЛЕМ.
           sampSendChat('/r ['..arr_str[zvanie.v +1].. ' • ' ..u8:decode(PdTeg.v)..']: 10-81, Пешая погоня за преступником! -'..kvadrat())
        end
        
        if isKeyDown(VK_B) and wasKeyPressed(key.VK_6) then -- 10-81 ПЕШАЯ ПОГОНЯ ЗА НАРУШИТЕЛЕМ.
           sampSendChat('/me на ' ..cameraArr[cameraZ.v +1].. ' рукой нажал на кнопку "запись видео"')
           wait(1500)
           sampSendChat('/do '..cameraArr[cameraZ.v +1]..' ведет видеозапись на удалённый сервер')
        end

        

    -- 10-55 ОСТАНОВКА. ПРОВЕДЕНИЕ ТРАФИК-СТОПА.
    -- 10-57 ЗАПРОС ПРОВЕРКИ АВТОМОБИЛЯ ПО НОМЕРАМ ИЛИ ЖЕ ГРАЖДАНСКОГО ПО ПАСПОРТУ.
    -- 10-80 ПОГОНЯ ЗА НАРУШИТЕЛЕМ.	
    -- 10-99 СИТУАЦИЯ УРЕГУЛИРОВАНА.

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

    if isKeyJustPressed(89) and not avto_menu.v and not msk_menu.v  then --  ВЕСТИ ЗА СОБОЙ
        validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
            local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/follow '.. id)
                wait(1000)
                sampSendChat('/me заломал руку преступника и ведет за собой' )
                actionId = id
            end
        end
    end

    if isKeyJustPressed(88) and not avto_menu.v and not msk_menu.v  then --  ЗАТАЩИТЬ В МАШИНУ
        validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
            local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/cput '.. id)
                wait(1000)
                sampSendChat('/me открыл дверь машины и затолкал туда преступника' )
                actionId = id
            end
        end
    end

    if isKeyJustPressed(90) and not avto_menu.v and not msk_menu.v  then --  ОБЫСКАТЬ
        validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
            local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/me достает перчатки из подсумка, натягивает их на руки' )
                wait(1000)
                sampSendChat('/me начинает обыскивать карманы '..sampGetPlayerNickname(id)..', выкладывая содержимое' )
                wait(1000)
                sampSendChat('/frisk '.. id)
                actionId = id
            end
        end
    end

    if isKeyJustPressed(71) and not avto_menu.v and not msk_menu.v  then --  ПОСАДИТЬ В КПЗ
          validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
        if validtar and doesCharExist(pedtar) then
              local result, id = sampGetPlayerIdByCharHandle(pedtar)
            if result then
                sampSendChat('/do На тактическом поясе висит связка ключей' )
                wait(1000)
                sampSendChat('/me нашёл нужный ключ, после чего вставил его в замочную скважину' )
                wait(1000)
                sampSendChat('/me открыл дверь КПЗ' )
                wait(1000)
                sampSendChat('/todo Располагайтесь*заталкивая нарушителя в КПЗ')
                wait(1000)
                sampSendChat('/arrest '.. id)
                wait(1000)
                sampSendChat('/me закрыл дверь КПЗ')
				actionId = id
            end
        end
    end

    if wasKeyPressed(49) and isKeyDown(2) then
            local veh, ped = storeClosestEntities(PLAYER_PED)
            local _, id = sampGetPlayerIdByCharHandle(ped)
            if id then
                    if id == -1 then sampAddChatMessage('[Ошибка] Рядом никого нет!', 0x6495ED) else
                       sampSendChat('/ceject '..id)
                    end
            end
        end
	--if isKeyJustPressed(49) and not avto_menu.v then     -- ВЫСАДИТЬ ИЗ МАШИНЫ
	--	validtar, pedtar = getCharPlayerIsTargeting(playerHandle)
	--	if validtar and doesCharExist(pedtar) then
	--	    local result, id = sampGetPlayerIdByCharHandle(pedtar)
	--	    if result then
	--	        SampSendChat('/ceject '..id)
    --            wait(1000)
    --            sampSendChat('/me Вытащил преступника из машины')
	--	        actionId = id
	--	    end
	--	end
	--end

	if isKeyJustPressed(66) then
	validtar, pedtar = getCharPlayerIsTargeting(playerHandle)  -- АРЕСТ
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
           renderFontDrawText(my_font, 'E - Надеть наручники\nQ - Снять наручники\nY - Вести за собой\nX - Посадить в машину\nZ - Обыскать\nB - Объявить в розыск\nShift - Быстрый PS\n1 - Вытащить из машины', 300, 800, 0xFFFFFFFF)
        end
    end
    if isKeyDown(88) then
       renderFontDrawText(my_font, '[1] - Состояние патруля - 10.0. Напарник: '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v)..'\n[2] - Выезжаю в патруль - 10.1. Напарник: '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v)..' \n[3] - Возвращаюсь в гараж - 10.2. Напарник: '..u8:decode(Fighter.v)..' '..u8:decode(Fighter_2.v)..'', 300, 800, 0xFFFFFFFF)
    end
    if isKeyDown(66) then
       renderFontDrawText(my_font, '[1] 10-13 - В меня стреляют\n[2]  10-34 - Возможно нападение на офицера\n[5]  10-81 - Пешая погоня\n[6] Включить видеозапись', 300, 800, 0xFFFFFFFF)
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
                  --КНОПКА МЕНЮ --
		   imgui.BeginChild('0', imgui.ImVec2(200, 500), true, imgui.WindowFlags.NoScrollbar)
           imgui.PushItemWidth(120)
           imgui.SetCursorPos(imgui.ImVec2(10, 10))
		if imgui.Button(u8'Основное Меню', imgui.ImVec2(180, 70)) then selected = 1 end
		   imgui.SetCursorPos(imgui.ImVec2(10, 90))
	    if imgui.Button(u8'Функции', imgui.ImVec2(180, 70)) then selected = 2 end
		   imgui.SetCursorPos(imgui.ImVec2(10, 170))
	    if imgui.Button(u8'Инфо', imgui.ImVec2(180, 70)) then selected = 3 end
           imgui.SetCursorPos(imgui.ImVec2(10, 250))
        if imgui.Button(u8'Обновление', imgui.ImVec2(180, 70)) then selected = 4 end

         -- КНОКА СОХРАНИТЬ НАСТРОЙКИ --
		   imgui.SetCursorPos(imgui.ImVec2(10, 420))
        if imgui.Button(u8'Сохранить настройки', imgui.ImVec2(180, 70)) then
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
		   imgui.BeginChild('меню должности', imgui.ImVec2(270, 130), true)
		   imgui.SetCursorPos(imgui.ImVec2(10, 60))
		   imgui.Combo(u8'Цвет', ClistZ, ClistArr) -- ЦВЕТ
		   imgui.PushItemWidth(140)
  	       cfg.accent.ClistZ = ClistZ.v
           inicfg.save(config, 'ShamanSetting.ini')
	       imgui.SetCursorPos(imgui.ImVec2(10, 35))
  	       imgui.Combo(u8'Должность', zvanie, arr_str) -- Должность
		   imgui.PushItemWidth(140)
  	       cfg.accent.zvanie = zvanie.v
           inicfg.save(config, 'ShamanSetting.ini')
           imgui.SetCursorPos(imgui.ImVec2(10, 10))
           imgui.InputText(u8'Позывной', PdTeg) -- ПОЗЫВНОЙ
		   imgui.PushItemWidth(140)
  	       imgui.SetCursorPos(imgui.ImVec2(10, 100))
		   imgui.Checkbox(u8'Активация', activR)
           imgui.EndChild()
           imgui.SameLine()
		   imgui.BeginChild('меню патруль', imgui.ImVec2(270, 130), true)
           imgui.PushItemWidth(140)
		   imgui.SetCursorPos(imgui.ImVec2(10, 10))
           imgui.Combo(u8'Маркировка', patrulZ, arr_str2) -- Маркировка
  	       cfg.accent.patrulZ = patrulZ.v
           inicfg.save(config, 'ShamanSetting.ini')
           imgui.PushItemWidth(140)
           imgui.SetCursorPos(imgui.ImVec2(10, 35))
		   imgui.InputText(u8'Боец 1', Fighter)
		   cfg.accent.Fighter = Fighter.v
           imgui.PushItemWidth(140)
           imgui.TextQuestion(u8'Прмечание: Перед позывным ставить # (#Позывной)')
           imgui.SetCursorPos(imgui.ImVec2(10, 60))
		   imgui.InputText(u8'Боец 2', Fighter_2)
		   cfg.accent.Fighter_2 = Fighter_2.v
           imgui.PushItemWidth(140)
           imgui.TextQuestion(u8'Прмечание: Перед позывным ставить # (#Позывной)')
           imgui.EndChild()

		   imgui.BeginChild('меню 12', imgui.ImVec2(555, 400), true)
           imgui.Combo(u8'Устройство видео', cameraZ, cameraArr)
           cfg.accent.cameraZ = cameraZ.v
		   imgui.EndChild()


		   imgui.EndChild()
	    end
	    if  selected == 2 then
		        imgui.BeginChild('2', imgui.ImVec2(600, 500), true, imgui.WindowFlags.NoScrollbar)
		    if  imgui.Button(u8'Арест', imgui.ImVec2(180, 20)) then Selectfunction = 1 end
		        imgui.SameLine()
		    if  imgui.Button(u8'Погоня', imgui.ImVec2(180, 20)) then Selectfunction = 2 end
		        imgui.SameLine()
		    if  imgui.Button(u8'Тен-коды', imgui.ImVec2(180, 20)) then Selectfunction = 3 end
            if  imgui.Button(u8'Функции', imgui.ImVec2(180, 20)) then Selectfunction = 4 end
	
            if Selectfunction == 1 then -- АРЕСТ
		        imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
                imgui.Button(u8'ПКМ + E', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'НАДЕТЬ НАРУЧНИКИ')
                imgui.Button(u8'ПКМ + Q', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'СНЯТЬ НАРУЧНИКИ')
                imgui.Button(u8'ПКМ + Y', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'ВЕСТИ ЗА СОБОЙ ')
                imgui.Button(u8'ПКМ + X', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'ПОСАДИТЬ В МАШИНУ')
                imgui.Button(u8'ПКМ + Z', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'ОБЫСКАТЬ')
                imgui.Button(u8'ПКМ + B', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'ОБЪЯВИТЬ В РОЗЫСК')
                imgui.Button(u8'ПКМ + SHIFT', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'ОТПРАВИТЬ /PS')
                imgui.Button(u8'ПКМ + 1', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'Вытащить из машины(Водителя)')
                imgui.Button(u8'ПКМ + ALT', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'/TAZER')
		        imgui.EndChild()
	        end

		    if  Selectfunction == 2 then -- ПОГОНЯ
		        imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
		        imgui.TextWrapped(u8'Этот пункт пока пустой.')

			    imgui.EndChild()
			end

		    if Selectfunction == 3 then -- ТЕН КОДЫ
			    imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
			    imgui.Button(u8'X + 1', imgui.ImVec2(100, 25))
			    imgui.SameLine()
		        imgui.TextWrapped(u8'10-0	ВСЁ СПОКОЙНО')
		        imgui.Button(u8'X + 2', imgui.ImVec2(100, 25))
			    imgui.SameLine()
			    imgui.TextWrapped(u8'10-1	ВЫЕХАЛ С ТЕРРИТОРИИ ДЕПАРТАМЕНТА')
			    imgui.Button(u8'X + 3', imgui.ImVec2(100, 25))
			    imgui.SameLine()
			    imgui.TextWrapped(u8'10-2	ВОЗВРАЩАЮСЬ НА ТЕРРИТОРИЮ ДЕПАРТАМЕНТА')
                imgui.Button(u8'B + 1', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'10-13 ТРЕБУЕТСЯ ПОМОЩЬ. ОФИЦЕР ПОД ОГНЕМ.')
                imgui.Button(u8'B + 2', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'10-34 СУЩЕСТВУЕТ РИСК НАПАДЕНИЯ НА ОФИЦЕРОВ ПОЛИЦИИ, СОВЕРШЕНИЯ ПРЕСТУПЛЕНИЯ')
                imgui.Button(u8'B + 5', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'10-81 ПЕШАЯ ПОГОНЯ')

                imgui.EndChild()
		    end
            if Selectfunction == 4 then -- ФУНКЦИИ
                imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
                imgui.Button(u8'rr', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'Быстрая рация')
                imgui.Button(u8't', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'Быстрый чат')
                imgui.Button(u8'mm', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'Меню масок')
                imgui.Button(u8'mem', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'Members')
                imgui.Button(u8'ppp', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'/patrul - Быстрый патруль')
                imgui.Button(u8'md', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'Быстрый MDC')
                imgui.Button(u8'oop', imgui.ImVec2(100, 25))
                imgui.SameLine()
                imgui.TextWrapped(u8'/wanted 1')
		   
                imgui.EndChild()
            end
                imgui.EndChild()
		end

	   if selected == 3 then
		            imgui.BeginChild('2', imgui.ImVec2(600, 500), true, imgui.WindowFlags.NoScrollbar)
		        if  imgui.Button(u8'ФП', imgui.ImVec2(180, 20)) then SelectInfo = 1 
                end
		            imgui.SameLine()
		        if  imgui.Button(u8'ЕГКС', imgui.ImVec2(180, 20)) then SelectInfo = 2 
                end
		            imgui.SameLine()
		        if imgui.Button(u8'Конституция', imgui.ImVec2(180, 20)) then SelectInfo = 3 
                end
                if imgui.Button(u8'Тен-Коды', imgui.ImVec2(180, 20)) then SelectInfo = 3 
                end


        if SelectInfo == 1 then
		 imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
         imgui.TextWrapped(u8'ФЕДЕРАЛЬНОЕ ПОСТАНОВЛЕНИЕ.')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'1.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Федеральный закон определяет обязанности, ограничения и привилегии государственных структур, обеспечивающих общественную безопасность и территориальную целостность республики.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'1.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Действие закона распространяется на силовые структуры: FBI, SAPD, Army.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'1.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Государственные гражданские структуры (Mayor, MoH, Instructors) несут ответственность по всей строгости действующего законодательства.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'1.4 ')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Официальное сокращение наименования закона - ФП.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'РАЗДЕЛ №2 ')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'« ОБЯЗАННОСТИ СИЛОВЫХ СТРУКТУР ГОСУДАРСТВЕННОЙ БЕЗОПАСНОСТИ » ')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8' Вооруженные силы:')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.1.1')
 		 imgui.SameLine()
 		 imgui.TextWrapped(u8'Обеспечение охраны секретных объектов на территории республики.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.1.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Обеспечение снабжения силовых структур боеприпасами и снаряжением.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.1.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Обеспечение силовой поддержки остальным силовым структурам (ПД, ФБР) при осуществлении их профессиональной деятельности.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Полицейские департаменты:')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Контроль исполнения законодательства гражданами, представителями гражданских структур, а так же представителями силовых структур, не находящихся при исполнении должностных обязанностей:')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Обеспечение общественного порядка и безопасности граждан республики.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Обеспечение охраны полицейских участков и следственных изоляторов.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.4')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Обеспечение безопасности дорожного движения.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.6')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Реализация мер по противодействию организованной преступности и борьбе с терроризмом.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.7')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Организация оперативно-розыскных мероприятий по выявлению и задержанию лиц, обвиняемых или подозреваемых в нарушении законодательства.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.2.8')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Обеспечение силовой поддержки ФБР при проведении спецопераций.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Федеральное бюро расследований:')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Контроль исполнения законодательства гражданами, государственными и государственными гражданскими служащими.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Контроль за исполнением своих обязанностей полицейскими департаментами и армиями, гражданскими государственными организациями.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Борьба с незаконным оборотом оружия и наркотиков.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.4')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Расследование и пресечение деятельности организованной преступности.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.5')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Противодействие коррупции в государственных структурах.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.6')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Организация оперативно-розыскных мероприятий по выявлению и задержанию особо опасных преступников.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.7')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Координация деятельности силовых структур в области борьбы с преступностью.')
		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'2.3.8')

		 imgui.SameLine()
		 imgui.TextWrapped(u8'Проведение инспекционных проверок, направленных на оценку качества работы ')
		 imgui.TextWrapped(u8'            государственных организаций.')
		 imgui.TextQuestion(u8'Примечание: Для проверки организации достаточного только уведомить и согласовать с руководством проверяемой организации.')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'РАЗДЕЛ №3')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'« ЗАПРЕТЫ ДЛЯ СИЛОВЫХ СТРУКТУР »')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.1 ')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено нарушать конституцию республики, законы республики, внутренние уставы силовых структур, постановления Мэрии и ФБР')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.2')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено вступать в сговор или связь с представителями криминальных организаций(мафии, банды, байкеры')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.3 ')
         imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено превышение должностных полномочий')
		 imgui.TextQuestion(u8'Примечание: Запрещено осуществлять служебную деятельность не предусмотренную Федеральным Постановлением, ЕКГС, Конституцией округа, запрещено выдавать себя за сотрудников отделов, членом которых вы не являетесь. Запрещено осуществление спец. операций, шпионажа, кражи и продажи государственной информации. Исключение - одобрение деятельности ФБР')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение / Увольнение ')

	     imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.4')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено нарушать Правила Дорожного Движения')
		 imgui.TextQuestion(u8'Исключение: Водители транспортных средств с включенным проблесковым маячком и со специальным звуковым сигналом, выполняя неотложное служебное задание, могут отступать от требований данного пункта. Исключение касается служебных транспортных средств, сопровождающих транспортные средства с включенным проблесковым маячком со специальным звуковым сигналом. Исключение перестает действовать при явном нарушении правил дорожного движения в свою выгоду и с целью совершения ДТП.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение + Штраф / Выговор')



		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.5')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено открывать огонь без причины')
		 imgui.TextQuestion(u8'Исключение: необходимая оборона. Необходимой обороной считается противодействие насильственным действиям, совершаемым в отношении вас или других лиц, охраняемых законом интересов от общественно опасного посягательства. Применение огнестрельного оружия в случае с самообороной допустимо только при нападении с применением, огнестрельного, режущего, колющего, а также иного вида оружия (бита, трость, катана и тому подобное). ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.6')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещена стрельба по гос. сотрудникам ')
		 imgui.TextQuestion(u8'Исключение: необходимая оборона. Пояснение необходимой обороны прописано в пункте 3.5 ФП.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.7')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено использовать резиновые пули в перестрелках')
		 imgui.TextQuestion(u8'Примечание: Разрешено использовать во время перестрелки в ЗЗ и грубых РП нарушениях. / Если случайно оглушили преступника в перестрелке - подождите пока его разморозит, а потом действуйте.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.8')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено использовать нецензурную брань')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение / Увольнение ')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.9')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено оскорбление кого-либо')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение ')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.10')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено употребление алкоголя при исполнении должностных обязанностей')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение ')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.11')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено в рабочее время заниматься своими делами')
		 imgui.TextQuestion(u8'Исключение: Разрешение руководства. Сотрудник должен иметь доказательства разрешения для предоставления их при необходимости.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Понижение')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.12')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено употребление, хранение наркотических средств и хранение компонентов оружия, ключей от камер')
		 imgui.TextQuestion(u8'Примечание: Офицеры полиции могут иметь не более 1 ключа от камеры. (исключение: шериф департамента)')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Понижение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.13')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Служащим армий запрещено находится за пределами мест постоянной дислокации своей воинской части (Area 51, Naval Base 69, Los-Santos Port (склад боеприпасов))')
         imgui.TextQuestion(u8'Примечание: Исключение составляют служащие, осуществление своих обязанностей которыми осуществляется вне воинской части (взводы поставки, сопровождение, спец. отряды), офицеры со звания, предусмотренного уставом и лица, получившие официальное разрешение от командования армии.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение на две ступени / Увольнение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.14')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено брать/давать взятки, продавать военную униформу, ключи от камер, пропуски в полицейские участки ')
		 imgui.TextQuestion(u8'Примечание: Хранение ключей / формы в сейфе, багажнике транспорта приравнивается к распространению, т.к. предполагается возможное распространение в дальнейшем.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Увольнение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.15')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено проводить арест, предварительно не известив преступника о причине его задержания на месте задержания')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Выговор / Понижение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.16')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено нарушать правила строя')
		 imgui.TextQuestion(u8'Примечание: активно жестикулировать, смеяться, разговаривать без причины, использовать телефон или рацию без разрешения.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Выговор')


		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.17')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено не являться на построение')
		 imgui.TextQuestion(u8'Примечание: Разрешено лишь в случае, если вы предупредили старших сотрудников FBI / PD / Army об уходе до построения.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Выговор')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.18')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Сотрудникам полиции запрещено находиться и проводить служебную деятельность за пределами юрисдикции своего департамента')
		 imgui.TextQuestion(u8'Примечание: Более подробно про правила юрисдикции написано в разделе 7 ФП.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.19')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено вмешиваться в спецоперации без прямого приказа от руководящего операцией')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.20')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено объявление в розыск по статьям не предусмотренным в ЕКГС')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Выговор / Понижение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.21')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено объявлять в розыск людей, которые не нарушали ЕКГС ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.22')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено снимать розыск преступникам без весомой причины')
		 imgui.TextQuestion(u8'Исключение: Если вы выдали розыск случайно / чистосердечное признание преступника, при этом уведомить FBI в рацию департамента. ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.23')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено заходить в МО/АММО/Банк во время ограбления ')
		 imgui.TextQuestion(u8'Примечание: Если во время засады бандиты/мафии начинают выбегать из магазина/АММО, обстреливать вас и забегать обратно, при этом это повторяется несколько раз - разрешено штурмовать магазин/АММО (Нужно иметь док-ва обстрелов)')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Выговор / Понижение  ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.24')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено бездействие на нарушение Законов Республики')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.25')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено провоцировать гос. сотрудника на неправомерные действия ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.26')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено препятствовать служащим армии, сотрудникам полиции и ФБР при исполнении ими своих служебных обязанностей ')
		 imgui.TextQuestion(u8'Примечание: При явном нарушении требований законности, сотрудник ФБР имеет право пресечь неправомерное действие сотрудника полиции или служащего армии. При совершении незаконных действий сотрудником ФБР необходимо фиксировать данный факт и подавать жалобу руководству ФБР. ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.27')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено угрожать государственному служащему')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение  ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.28')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'За повышение сотрудника или восстановление (принятие) сотрудника в организацию, пониженного или уволенного уполномоченными сотрудниками ФБР или Мэрии за нарушение пунктов из 3 раздела ФП, до установленного действующим законодательством срока - одной недели (7 дней со дня применения санкции) после выдачи наказания - сотрудник, вернувший звание/должность или восстановивший(принявший) в организацию подлежит понижению, а повышенный - понижение на две ступени. ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.29')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено засорение волны департамента как при штатном режиме, так и режиме ЧС')
		 imgui.TextQuestion(u8'Примечание: В случае постоянных преднамеренных нарушений волны ЧС может последовать увольнение. Старший сотрудник смены обязан оповещать прибывших работников на работу о положении ЧС.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Выговор / Понижение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'3.30 Запрещено проводить арест государственного служащего без одобрения руководства Мэрии / агента ФБР')
		 imgui.TextQuestion(u8'Примечание: В случае постоянных преднамеренных нарушений волны ЧС может последовать увольнение. Старший сотрудник смены обязан оповещать прибывших работников на работу о положении ЧС. ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.30')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено проводить арест государственного служащего без одобрения руководства Мэрии / агента ФБР')
		 imgui.TextQuestion(u8'Примечание: Разбирательством во время задержания, а также одобрением ареста сотрудника Мэрии занимается его прямое руководство. Разбирательством во время задержания, а также одобрением ареста сотрудника силовых структур занимаются Агенты ФБР.В иных ситуациях - задержании сотрудников автошколы/медиков вызывается прямое руководство.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'3.31 Запрещено вести переговоры, руководить спец операцией на похищении/теракте, если вы не состоите в ФБР/HRT')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.32')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено уклоняться от проверок отдела DEA FBI, а также от инспекционных проверок FBI')
		 imgui.TextQuestion(u8'Примечание: Разрешено не присутствовать на проверке, в случае если вы уведомили агента и он разрешил вам.')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение ')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.33 ')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещен обыск заключенных в камерах полицейских департаментов')
		 imgui.TextQuestion(u8'Исключение: Преступники постпившые с ранениями, экстренно доставленные в камеру преступники, употребление запрещенных веществ, попытка передачи ключей. Примечание: После поступления раненого/экстренного доставленого человека в камеру,его имеет право обыскать тот, кто посадил преступника. Также допустим обыск путём передачи информации по рации внутри полиции/волне депортамента от сотрудника проводившего арест ')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'3.34')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено нарушать субординацию при общении с гос.служащими / гражданами')
		 imgui.TextQuestion(u8'Примечание: Разговаривать на ты , повышать тон, пытаться перебить')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Выговор / Понижение')

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'РАЗДЕЛ №4')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'« ПРИВИЛЕГИИ ГОСУДАРСТВЕННЫХ СЛУЖАЩИХ » ')
		 

		 imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.1')
		 imgui.SameLine()
		 imgui.TextWrapped(u8'Запрещено обманывать Агента ФБР и руководство Мэрии')
		 imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'Запрещено раскрывать маскировку Агента ФБР при любых обстоятельствах')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение / Увольнение ')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.3')
         imgui.SameLine()
         imgui.TextWrapped(u8'Запрещено нарушать субординацию при общении с сотрудником ФБР, руководством Мэрии')
         imgui.TextQuestion(u8'Примечание: Запрещено вести разговор на повышенных тонах, обращаться на "ты", игнорировать или не слушать, не реагировать на обращение к вам, вести разговор не касающийся рабочего процесса.')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.4')
         imgui.SameLine()
         imgui.TextWrapped(u8'Запрещено обыскивать Агента ФБР и руководство Мэрии')
         imgui.TextQuestion(u8'Исключение: Сотрудник нарушает законы, предусматривающие изъятие лицензий в тот момент, когда находится не при исполнении должностных обязанностей и не выполняет спец.задание; Проверка от DEA.')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Понижение')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.5')
         imgui.SameLine()
         imgui.TextWrapped(u8'Запрещено перечить законным требованиям Агентов ФБР и руководства Мэрии')
         
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Выговор / Понижение')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.6')
         imgui.SameLine()
         imgui.TextWrapped(u8'Запрещено находиться в офисе / на территории ФБР без вызова / разрешения Агента ФБР (6+)')
         imgui.TextQuestion(u8'Исключение: Старший офицер (Майор +) имеет право присутствовать на допросе сотрудника своей организации в офисе ФБР. Перед въездом на территорию офиса старший офицер обязан уведомить сотрудника ФБР, осуществляющего вызов, а так же соблюдать регламент проведения допроса и рамки поведения на нем, иначе исключение не действует и санкцию можно применять.')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Понижение')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.7')
         imgui.SameLine()
         imgui.TextWrapped(u8'Запрещено находиться на 5-ом этаже мэрии без вызова / разрешения мэра или его заместителя (6+)')
         
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'Предупреждение / Понижение')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.8')
         imgui.SameLine()
         imgui.TextWrapped(u8'Мэр и сотрудники ФБР, не ниже Главы CID / DEA, имеют право применять санкции при выявлении нарушения конституции республики, законов, постановлений мэрии или ФБР.')
        
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.9')
         imgui.SameLine()
         imgui.TextWrapped(u8'Сотрудник ФБР, не ниже Агента DEA / CID и Мэр вправе вызвать любого государственного служащего в Бюро / Мэрию без разъяснения причины (причина будет названа на месте).')
         imgui.TextQuestion(u8'Исключение: Если будет доказана неправомерность вызова сотрудника и установлен факт превышения полномочий сотрудника ФБР или Мэра, по отношению к последнему действует статья 3.3 федерального закона; руководителя государственной структуры имеет право вызывать только Директор ФБР и Мэр, старших офицеров и руководителей - не ниже Зам.Директора ФБР и Зам.Мэра.')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'4.10')
         imgui.SameLine()
         imgui.TextWrapped(u8'Сотрудник ФБР имеет право провести задержание любого государственного служащего (кроме старших офицеров силовых структур, и лиц, занимающих руководящие должности в гражданских ведомствах) при выявлении нарушения им норм конституции республики, ЕКГС, постановлений Мэрии или ФБР, норм внутренних уставов организации.')
         imgui.TextQuestion(u8'')
         imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'РАЗДЕЛ №5')
         imgui.SameLine()
         imgui.TextWrapped(u8'« ПРИМЕЧАНИЕ К ФЕДЕРАЛЬНОМУ ПОСТАНОВЛЕНИЮ » ')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'5.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'Федеральное постановление может быть изменено путем предложения законопроекта в парламент при абсолютном большинстве голосов представителей нижней палаты и одобрением сената республики.')
         imgui.TextQuestion(u8'Пример: Пункт Федерального постановления был написан в 18:00, а вступает в силу - в 00:01 следующего дня')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'5.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'Вид наказания к гос. сотруднику должен исполняться в следующей последовательности - Предупреждение / Выговор / Понижение / Увольнение')
         imgui.TextQuestion(u8'Примечание: В зависимости от тяжести нарушения, санкция может применяться в другом порядке.')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'РАЗДЕЛ №6')
         imgui.SameLine()
         imgui.TextWrapped(u8' « ПРАВИЛА ИСПОЛЬЗОВАНИЯ ОГНЕСТРЕЛЬНОГО ОРУЖИЯ » ')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'6.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'Огнестрельным оружием считается оружие, в котором используются боевые патроны.')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'6.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'Сотрудники SAPD/FBI/Army имеют право использовать огнестрельное оружие в следующих случаях:')
         imgui.TextWrapped(u8'- для защиты себя либо другого лица от посягательства, если это посягательство сопряжено с насилием, опасным для жизни или здоровья;')
         imgui.TextWrapped(u8'- для пресечения попытки завладения военными боеприпасами армии, специальной и боевой техникой, состоящими на вооружении армии;')
         imgui.TextWrapped(u8'- для задержания лица, застигнутого при совершении деяния, содержащего признаки особо тяжкого преступления против жизни, здоровья или собственности, и пытающегося скрыться, если иными средствами задержать это лицо не представляется возможным;')
         imgui.TextWrapped(u8'- для задержания лица, оказывающего вооруженное сопротивление, а также лица, отказывающегося выполнить законное требование государственного служащего о сдаче находящихся при нем оружия, боеприпасов, взрывчатых устройств;')
         imgui.TextWrapped(u8'- для освобождения заложников, при условии обеспечения безопасности самих заложников;')
         imgui.TextWrapped(u8'- для отражения группового или вооруженного нападения на здания, помещения, сооружения и иные объекты государственных органов, общественных объединений, организаций и граждан;')
         imgui.TextWrapped(u8'- для остановки транспортного средства путем его повреждения, если управляющее им лицо отказывается выполнить неоднократные требования сотрудника полиции, фбр, военнослужащего армии об остановке и пытается скрыться, создавая угрозу жизни и здоровью граждан;')
         imgui.TextWrapped(u8'- для производства предупредительного выстрела, подачи сигнала тревоги или вызова помощи путем производства выстрела вверх, или в ином безопасном направлении;')
         imgui.TextWrapped(u8'- для защиты, а так же для сохранения статуса секретности отдельных территорий или объектов республики, если при этом не выполняются законные требования покинуть данную территорию, разрешается произвести предупредительные выстрелы в воздух, при дальнейшем игнорировании требований, возможна ликвидация угрозы;')
         imgui.TextWrapped(u8'- на военных базах в случае нападения без использования огнестрельного,         режущего, колющего оружия военнослужащим разрешается ликвидация угрозы;')
         imgui.TextQuestion(u8'Примечание: Сотрудник полиции, ФБР, военнослужащий армии не имеет права применять огнестрельное оружие при значительном скоплении граждан, если в результате его применения могут пострадать случайные лица.Примечание: Вооруженным сопротивлением и вооруженным нападением, указанными в настоящей статьи, признаются сопротивление и нападение, совершаемые с использованием оружия любого вида, либо предметов, конструктивно схожих с настоящим оружием и внешне неотличимых от него, либо предметов, веществ и механизмов, при помощи которых могут быть причинены тяжкий вред здоровью или смерть. ')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'РАЗДЕЛ №7')
         imgui.SameLine()
         imgui.TextWrapped(u8'« ЮРИСДИКЦИЯ ПОЛИЦИИ »')
        

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'Юрисдикции полиции делятся в соответствии с картой регионов республики Сан-Андреас:')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.1.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'Юрисдикции Полиции ЛС принадлежит регион Los Santos и Red County.')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.1.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'Юрисдикции Полиции СФ принадлежит регион San Fierro и Whetstone.')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.1.3')
         imgui.SameLine()
         imgui.TextWrapped(u8'Юрисдикции Полиции ЛВ принадлежит регион Las Venturas и Bone County.')
     

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'Существует два смежных региона на которых могут одновременно находиться сразу два департамента:')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.2.1')
         imgui.SameLine()
         imgui.TextWrapped(u8'Юрисдикции Полиции ЛС и Полиции СФ принадлежит регион Flint County.')
         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.2.2')
         imgui.SameLine()
         imgui.TextWrapped(u8'Юрисдикции Полиции СФ и Полиции ЛВ принадлежит регион Tierra Robada.')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.3')
         imgui.SameLine()
         imgui.TextWrapped(u8'Юрисдикцию полиции разрешено нарушать с оповещением по волне департамента ФБР, в случае:')
         imgui.TextWrapped(u8'- работы по расследованию, имея санкции от старших Агентов ФБР (6+).')
         imgui.TextWrapped(u8'- проведения специальных операций / тренировок.')
         

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.4')
         imgui.SameLine()
         imgui.TextWrapped(u8'Юрисдикцию полиции разрешено нарушать без оповещения по волне департамента ФБР, в случае:')
         imgui.TextWrapped(u8'- погони за преступником.')
         imgui.TextWrapped(u8'- сопровождения колонны снабжения ЛВА.')
         imgui.TextWrapped(u8'- участия в специальной операции от ФБР.')
         imgui.TextWrapped(u8'- наличия специальных санкций от ФБР для спец.отрядов либо детективов.')
         imgui.TextWrapped(u8'- выезда на помощь по запросу в департамент от другой организации.')

         imgui.TextColored(imgui.ImVec4(1.00, 0.45, 0.1, 0.53), u8'7.5')
         imgui.SameLine()
         imgui.TextWrapped(u8'При работе в чужой юрисдикции запрещается создание помех работе местной полиции. В случае создания весомых помех работе местной полиции, местный шериф имеет право запретить находиться сотрудникам другого департамента у себя в юрисдикции. Данное правило не относится к смежным регионам.')
         imgui.TextWrapped(u8'- .')
         imgui.TextWrapped(u8'- .')
		 imgui.EndChild() -- ФП
		end

		if SelectInfo == 2 then -- 
				 imgui.BeginChild('2', imgui.ImVec2(570, 460), true)
			



				 imgui.EndChild()
			end


		   imgui.EndChild() 
	    end
        if selected == 4 then -- ОБНОВЛЕНИЕ
           imgui.BeginChild('1', imgui.ImVec2(600, 500), true, imgui.WindowFlags.NoScrollbar)
           imgui.TextWrapped(u8'SHAMAN FORSE, Версия 1.00')
           imgui.TextWrapped(u8'Это самая первыя версия моего скрипта, функционал еще очень маленький, но тем не менее уже есть чем похвастаться.')
           imgui.TextWrapped(u8'Данный скрипт разработан специально для SWAT SFPD и пока находиться в тестовом режиме.')
           imgui.TextWrapped(u8'Права на пользование определяет владелец скрипта')
           imgui.TextWrapped(u8'Скрипт обновляется автоматически. После первой установки вам больше ничего не придётся делать.')
           imgui.TextWrapped(u8'Планы на следующию версию:')
           imgui.TextWrapped(u8'- Сделать систему погони. На данный момент уже ведутся работы.')
           imgui.TextWrapped(u8'- Улучшить систему выдачи розыска. К сожалению, сейчас можно только одим способом выдать розыск(ПКМ+B). Это не всегда удобно, по этому эта система будет дорабатываться.')
           imgui.TextWrapped(u8'- Дополнить все мануалы и прочию информацию')
           imgui.TextWrapped(u8'- Так же в планах есть сделать биндер')
           imgui.TextWrapped(u8'- Сделать удобную систему взаимодействия с игроком. На это будет уделено особое внимание и скорее всего будет большая часть времени потрачено на эту функцию')
           imgui.TextWrapped(u8'- Добавить удобный ТАЗЕР')
           imgui.TextWrapped(u8'- Добавить функций быстрых кнопок')
           imgui.TextWrapped(u8'И многое друго.')
           imgui.TextWrapped(u8'С предложениями по улучшению скрипта можете обраться к автору. ')
           
           imgui.EndChild()
       end
           imgui.End()
end


if avto_menu.v then
    imgui.SetNextWindowSize(imgui.ImVec2(600, 70), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2((sw / 1.8), sh / 1.05 ), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'Команды', avto_menu, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)

    if imgui.Button(u8'Открыть/закрыть', imgui.ImVec2(100, 40)) then
      sampSendChat('/lock', 1000)
    end
        imgui.SameLine()
    if imgui.Button(u8'Починить авто', imgui.ImVec2(100, 40)) then
        sampSendChat('/rkt', 1000)
        avto_menu.v = false
    end
        imgui.SameLine()
    if imgui.Button(u8'Багажник авто', imgui.ImVec2(100, 40)) then
        sampSendChat('/trunk', 1000)
    end
        imgui.SameLine()
    if imgui.Button(u8'Замок багажника', imgui.ImVec2(100, 40)) then
        sampSendChat(u8'/tlock', 1000)
    end
       imgui.SameLine()
    if imgui.Button(u8'Инвентарь', imgui.ImVec2(100, 40)) then
       sampSendChat(u8'/i', 1000)
    end
        imgui.End()
end

if msk_menu.v then
    imgui.SetNextWindowSize(imgui.ImVec2(350, 70), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2((sw / 1.8), sh / 1.05 ), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8'Команды 2 ', msk_menu, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
    if imgui.Button(u8'Надеть Берет', imgui.ImVec2(100, 40)) then
       msk_menu.v = false
       thread:run('beret')
    end
       imgui.SameLine()
    if imgui.Button(u8'Надеть маску', imgui.ImVec2(100, 40)) then
       thread:run('maska')
       msk_menu.v = false
    end
       imgui.SameLine()
    if imgui.Button(u8'Отключить GPS', imgui.ImVec2(100, 40)) then
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

    if imgui.Button(u8'Статья 1 [Нарушение порядка]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 1 Статья 1 [Нарушение порядка]')
		cuff_menu.v = false
    end
     imgui.SameLine()
		imgui.Button(u8'[1]', imgui.ImVec2(30, 25))
    imgui.TextQuestion(u8'Действия, направленные на нарушение общественного порядка (залезание на крышу транспортного средства, остановки; порча государственного/личного имущества; удары по ТС; выкидывание людей из ТС; выкрики и флуд; неадекватное поведение, неприличные приставания к прохожим) и прочее хулиганство')



    if imgui.Button(u8'Статья 2. [Хранение ключей от камеры]', imgui.ImVec2(350, 25)) then
	    sampSendChat('/su '..actionId..' 2 Статья 2. [Хранение ключей от камеры]')
	    uff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.SameLine()
        imgui.TextQuestion(u8'Незаконное хранение, пользование ключами от камеры.')




    if	imgui.Button(u8'Статья 3. [Избиение]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 3. [Избиение]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
        imgui.TextQuestion(u8'Причинение вреда здоровью без использования огнестрельного оружия, с помощью холодного оружия, биты, кулака, кия, клюшки, и т.д.')

    if	imgui.Button(u8'Статья 4. [Ношение оружия в открытом виде].', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 4. [Ношение оружия в открытом виде]')
 	    cuff_menu.v = false
    end
        imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
        imgui.TextQuestion(u8'Наличие оружия в руках гражданина в общественных местах и игнорирование обязательного требования полицейского спрятать оружие')

    if	imgui.Button(u8'Статья 5. [Клевета]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 5. [Клевета]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Заведомо ложная порочащая информация или распространение заведомо ложных сведений, порочащих честь и достоинство другого лица или подрывающих его репутацию.')

	if	imgui.Button(u8'Статья 6. [Продажа оружия]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 6. [Продажа оружия]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Нелегальное распространение/изготовление оружия или его реклама')

	if	imgui.Button(u8'Статья 7. [Подделка]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 7. [Подделка]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Изготовление или использование не оригинальных специальных удостоверений, значков, пропусков, документов государственных служб, либо использование этих документов лицами, не имеющими специальных полномочий, дача ложных показаний')

	if	imgui.Button(u8'Cтатья 8. [Отказ от уплаты штрафа]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Cтатья 8. [Отказ от уплаты штрафа] ')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Отказ оплачивать штраф за административное правонарушение должностному лицу')

    if  imgui.Button(u8'Статья 9. [Манифестация].', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 9. [Манифестация]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Нарушение регламента проведения массовых мероприятий -> Федеральный закон №3 О манифестациях и экстремизме')

	if	imgui.Button(u8'Статья 10. [Повреждение чужого имущества]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 10. [Повреждение чужого имущества]')
 	    cuff_menu.v = false
    end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Повреждение/нанесение урона чужому имуществу посредством огнестрельного/телесного нанесения')

    if imgui.Button(u8'Статья 11. [Угон ТС]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 11. [Угон ТС]')
 	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Незаконное завладение чужим транспортным средством, а также попытка угона')

    if imgui.Button(u8'Статья 12. [Наезд на пешехода]', imgui.ImVec2(350, 25)) then
	    sampSendChat('/su '..actionId..' 2 Статья 12. [Наезд на пешехода]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Столкновение или наезд на пешехода транспортным средством')

    if imgui.Button(u8'Статья 13. [Выращивание наркотических веществ]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 13. [Выращивание наркотических веществ]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Посев или выращивание запрещенных к возделыванию растений, а также культивирование сортов конопли, мака или других растений, содержащих наркотические вещества Наказание: Запрет на услуги адвоката. 3 уровень розыска. Оцепление плантаций до полного уничтожения запрещенных растений')

    if imgui.Button(u8'Статья 14. [Проникновение на охраняемые, государственные владения]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 14. [Проникновение на охраняемые, государственные владения]')
	  cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Нахождение на территориях, закрытых для свободного посещения гражданскими лицами (территории военных баз, гаражей и участков ПД и ФБР и т.д). Примечание: Вся территория, обозначенная коричневым цветом на карте, включая территорию за ограждением базы, считается охраняемой территорией армии. Задерживать разрешается только после игнорирования гражданином предупреждения в мегафон о том, что он приближается к охраняемой территории. Так же под эту статью попадает проникновение на частную территорию, а именно дом или прилегающий участок к нему, если таковой имеется.')

	if	imgui.Button(u8'Статья 15. [Помеха]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 15. [Помеха]')
	  cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Создание помех правоохранительным органам при исполнении ими служебных обязанностей. Пример: помеха при задержании преступника')

	if	imgui.Button(u8'Статья 16. [Взятка]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 16. [Взятка]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Дача гражданином или получение должностным лицом денежного вознаграждения за действия либо бездействие в решении вопросов, касающихся служебной деятельности (например, дача взятки полицейскому за снятие розыска)')

	if	imgui.Button(u8'Статья 17. [Ношение оружия без лицензии]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 17. [Ношение оружия без лицензии]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Хранение оружия при себе / в сейфе дома без наличия лицензии на оружие.')

	if	imgui.Button(u8'Статья 18. [Оскорбление]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 18. [Оскорбление]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Умышленное унижение чести и достоинства личности, выраженное в грубой неприличной форме, в том числе в отношении сотрудника полиции, военного, ФБР, МЧС.')

	if	imgui.Button(u8'Статья 19. [Неподчинение сотруднику ПД/ФБР]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 19. [Неподчинение сотруднику ПД/ФБР]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Неповиновение законным требованиям сотрудников полиции, ФБР, службы охраны Мэрии на территории Мэрии или военнослужащим на территории военных баз и военкомата (покинуть территорию, выйти из ТС, показать документы и прочее)')

	if	imgui.Button(u8'Статья 20. [Продажа государственного имущества]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 20. [Продажа государственного имущества]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Передача за денежное вознаграждение ключей от камер военной формы гражданским лицом или иных государственных ценностей')

	if	imgui.Button(u8'Статья 21. [Продажа наркотиков]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 21. [Продажа наркотиков]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Распространение наркотических средств или реклама, пропаганда использования наркотических средств')

	if	imgui.Button(u8'Статья 22. [Хранение наркотиков/материалов]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 22. [Хранение наркотиков/материалов]')
	  cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Хранение материалов, деталей для незаконного изготовления оружия, а также хранение наркотических средств. 3 уровень розыска с изъятием обнаруженных запрещенных веществ. При добровольной сдаче, а так же при изъятии на приеме/призыве наказание не выдается')

	if	imgui.Button(u8'Статья 23. [Употребление наркотических веществ] ', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 2 Статья 23. [Употребление наркотических веществ]')
	  cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[2]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Употребление наркотических веществ, Наказание: 2 уровень розыска + изъятие наркотиков.')

	if	imgui.Button(u8'Статья 24. [Разбой]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 24. [Разбой]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Причинение вреда здоровью или угроза жизни гражданину с использованием оружия (направление оружия на человека), убийство, вымогательство, ограбление или провокации. Наказание: 3 уровень розыска + изъятие лицензии на оружие.')

	if	imgui.Button(u8'Статья 25. [Уход]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 25. [Уход]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Оказание сопротивления сотрудникам полиции или ФБР при попытке задержания и ухода от погони, или уход c места ДТП, Наказание: 3 уровень розыска + аннулирование водительского удостоверения.')

	if	imgui.Button(u8'Статья 26. [Кража]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 26. [Кража]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Незаконное завладение, скрытое хищение чужого имущества или денежных средств, в том числе кража, покупка, хранение военной формы и другого государственного имущества. Наказание: 3 уровень розыска + изъятие украденного имущества.')

	if	imgui.Button(u8'Статья 27. [Похищение]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 Статья 27. [Похищение]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Незаконное ограничение свободы лица, взятие в заложники с последующим требованием выкупа или без такого требования. Наказание: 4 уровень розыска + запрет на услуги адвоката.')

	if	imgui.Button(u8'Статья 28. [Побег]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 Статья 28. [Побег]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Незаконный выход из камер до истечения срока заключения с использованием ключей от камер или посредством незаконных действий адвоката. Наказание: 4 уровень розыска + изъятие ключей от камер.')


	if	imgui.Button(u8'Статья 29. [Нападение на военнослужащего]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 Статья 29. [Нападение на военнослужащего]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Убийство, причинение или угроза причинения вреда здоровью в отношении служащего армии. Наказание: 4 уровень розыска.')

	if	imgui.Button(u8'Статья 30. [Нападение на полицейского]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 5 Статья 30. [Нападение на полицейского]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[5]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Убийство, причинение или угроза причинения вреда здоровью в отношении сотрудника полиции. Наказание: 5 уровень розыска + изъятие лицензии на оружие.')

	if	imgui.Button(u8'Статья 31. [Нападение на Агента ФБР / Мэра]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 6 Статья 31. [Нападение на Агента ФБР / Мэра]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[6]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Убийство, причинение или угроза причинения вреда здоровью в отношении Агента ФБР / Мэра. Наказание: 6 уровень розыска + изъятие лицензии на оружие.')

	if	imgui.Button(u8'Статья 32. [Терроризм/Экстремизм]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 6 Статья 32. [Терроризм/Экстремизм]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[6]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Планирование, организация, угроза или исполнение террористического акта, либо убийство более чем трёх человек с использованием оружия. (Данную статью можно выдавать на читеров). В разделе мэрии указано более подробное описание экстремизма и список действий/материалов/движений подпадающих под данный пункт (Регулируется только сенатом или через конгресс) -> Федеральный закон №3 О манифестациях и экстремизме. Наказание: 6 уровень розыска + изъятие лицензии на оружие + запрет на услуги адвоката.')

	if	imgui.Button(u8'Статья 33. [Соучастие]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 33. [Соучастие]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Пособничество в совершении преступления, покрывательство преступника или создание помех правоохранительным органам при задержании преступника. Наказание: тот же уровень розыска, что и у преступника.')

	if	imgui.Button(u8'Статья 34. [Срыв спец.операции]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 Статья 34. [Срыв спец.операции]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Пособничество в развале спецопераций, создание помех правоохранительным органам при антитеррористической деятельности. Наказание: 4 уровень розыска')

	if	imgui.Button(u8'Статья 35. [Агитация]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 35. [Агитация]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Проведение агитационных мероприятий в период избирательной кампании с целью побудить избирателей к голосованию за кандидата, кандидатов, список кандидатов или против него (них) либо против всех кандидатов в несогласованное с сенатом Штата время. Наказание: 3 уровень розыска')

	if	imgui.Button(u8'Статья 36. [Организация занятия проституцией / занятие проституцией ]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 3 Статья 36. [Организация занятия проституцией / занятие проституцией ]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[3]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Деяния, направленные на организацию занятия проституцией другими лицами, а равно содержание притонов для занятия проституцией или систематическое предоставление помещений для занятия проституцией. Наказание: 3 уровень розыска, штраф организатору 10.000 вирт (независимо от проживания)')


	if	imgui.Button(u8'Статья 37. [Изнасилование]', imgui.ImVec2(350, 25)) then
		sampSendChat('/su '..actionId..' 4 Статья 37. [Изнасилование]')
	    cuff_menu.v = false
	end
		imgui.SameLine()
		imgui.Button(u8'[4]', imgui.ImVec2(30, 25))
		imgui.TextQuestion(u8'Изнасилование, то есть половое сношение или иные действия сексуального характера с применением насилия или с угрозой его применения к потерпевшему (потерпевшей) или к другим лицам либо с использованием беспомощного состояния потерпевшего (потерпевшей). Наказание: 4 уровень розыска.')

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
    sampSetChatInputText('/r ['..arr_str[zvanie.v +1].. ' • ' ..u8:decode(PdTeg.v)..']:'..arr_str2[patrulZ.v +1]..', 10-1 ') 

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
       sampSendChat('/me снял наручки')
    end

    if optimal == 'maska' then
       sampSendChat('/me Снял берет '..arr_str[zvanie.v +1]..' и положил в разгрузочный жилет')
       wait(1500)
       sampSendChat('/me надел маску')
       wait(1500)
       sampSendChat('/clist 32')
       wait(1500)
       sampSendChat('/do На голове маска, на руках перчатки, личность опознать невозможно')
    end

    if optimal == 'beret' then
      sampSendChat('/clist '..ClistZ.v +1)
      wait(1500)
      sampSendChat('/me Достал из разгрузочного жилета берет '..arr_str[zvanie.v +1]..' и надел на голову')
    end

    if optimal == 'gps0' then
      sampSendChat('/clist 0')
      wait(1500)
      sampSendChat('/seedo GPS-носитель отключён')
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


