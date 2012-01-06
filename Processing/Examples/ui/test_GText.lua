background(230)

line(100,0,100,200)
line(0,100,200,100)

local gt1 = GText("Text1", {100,100}, {Alignment = cd.BASE_CENTER})
local gt2 = GText("2345689", {100,110}, {Alignment = cd.BASE_LEFT, FontName="Quartz", FontSize=9, })
local gt3 = GText("Text3", {100,120}, {Alignment = cd.BASE_RIGHT, FontStyle="Bold"})

gt1:render()
gt2:render()
gt3:render()