local ui = fu.UIManager
local disp = bmd.UIDispatcher(ui)
local width,height = 600,600
local clock = os.clock

function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end
win = disp:AddWindow({
	ID = 'MyWin',
	WindowTitle = 'youtube-dl',
	Geometry = {100,100,width,height},
	Spacing = 15,
	Margin = 20,

	ui:VGroup{
	ID = 'root',
	ui:HGroup{
	ui:LineEdit{ ID = "inputurl",
					PlaceholderText = "Enter a video's url",
					Text = "",
					Weight = 1.5,
					MinimumSize = {150, 24} },
	ui:Button{ID='geturl', Text='Get Formats', weight=1.5},
	
		},
	ui:HGroup{
	ui:TextEdit{ID='formats', Text = '[yt-dl] \n [info] Available formats (Choose an MP4)', ReadOnly = true,},
		},
		ui:HGroup{
		ui:LineEdit{ ID = "userformat",
					PlaceholderText = "Leave blank on stock sites",
					Text = "",
					Weight = 1.5,
					MinimumSize = {150, 24} },
		ui:Button{ID='getvidf', Text='Get video', weight=1.5},
		},

	},

})



	itm=win:GetItems()
	resolve = Resolve()
	projectManager = resolve:GetProjectManager()
	project = projectManager:GetCurrentProject()
	mediapool = project:GetMediaPool()
	folder = mediapool:GetCurrentFolder()
	mediastorage=resolve:GetMediaStorage()
	mtdvol=mediastorage:GetMountedVolumes()



function win.On.MyWin.Close(ev)
	disp:ExitLoop()
end

function win.On.geturl.Clicked(ev)
	url = tostring(itm.inputurl.Text)
	dump(url)
	lpath = tostring(mtdvol[1]).."/ytdl"
	dump(lpath)

	ytdlProgramPath = 'youtube-dl'


	ytformatcmd=ytdlProgramPath.." -F "..url
	formatproc=io.popen(ytformatcmd)
	local foutput = formatproc:read('*all')
	formatproc:close()
	dump(foutput)


	itm.formats.PlainText = foutput
		ytcommand=ytdlProgramPath.." "..url
	dump("Attempting to download ")
	dump(ytcommand)

	--propat=os.execute(ytcommand)
	--mediastorage:AddItemListToMediaPool(fpath)



	folder = mediapool:GetCurrentFolder()


end

function win.On.getvidf.Clicked(ev)
	

	url = tostring(itm.inputurl.Text)

	if itm.userformat.Text ~= "" then
		uformat = tostring(itm.userformat.Text)
		uwuformat = " -f "..uformat
		dump(uwuformat)
	else 
		uwuformat = " "
	dump("Inentionally blank ")
	end


	pname = project:GetName()
	ipath = mtdvol[1].."\\ytdl\\"..pname
	iqpath = "\""..mtdvol[1].."\\ytdl\\"..pname.."\""
	prelscomm = "dir \""..ipath.."\" /o-d /tc /b"
	dump(prelscomm)
	count = 0


		--[[for line in noutput:lines() do
			if count == 8 then
				noutput:close()
				preoutput = line
			end
			count = count+1
		end
		noutput:close()]]







	ytdlcomm ="youtube-dl"..uwuformat.." "..url.." -o \""..ipath.."\\%(title)s.%(ext)s\" --restrict-filenames"
	propat=os.execute(ytdlcomm)

	prenameproc = assert(io.popen(prelscomm))
	for line in prenameproc:lines() do
		
		if count == 0 then
			dump(line)
			fname = line
		end
		count = count +1
	end
	prenameproc:close()
	
		
		fpath = ipath.."\\"..fname
		dump(fpath)
	mediastorage:AddItemListToMediaPool(fpath)


end

win:Show()
disp:RunLoop()
win:Hide()