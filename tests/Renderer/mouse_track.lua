class.CrossHair()
function CrossHair:_init()
	self.centerx=0
	self.centery = 0
end

function CrossHair:render()
	line(self.centerx-10, self.centery, self.centerx-2, self.centery);
	line(self.centerx+2, self.centery, self.centerx+10, self.centery);

	line(self.centerx, self.centery-10, self.centerx, self.centery-2)
	line(self.centerx, self.centery+2, self.centerx, self.centery+10)

	--rect(self.centerx-5, self.centery-5, 10, 10)
end

function CrossHair:SetCenter(x, y)
	self.centerx = x
	self.centery = y
end

local ch = CrossHair()

function setup()
	background(230)
end

function draw()
	background(230)

	stroke(0)
	line((width/2)-200,height/2,(width/2)+200,height/2)
	line(width/2, 0, width/2, height)

	rect((width/2)-100, (height/2)-100, 200, 200)

	textAlign(cd.CENTER)
	text(width/2, height/2, string.format("%d  %d", mouseX, mouseY))

	ch:SetCenter(mouseX, mouseY)
	ch:render()
end