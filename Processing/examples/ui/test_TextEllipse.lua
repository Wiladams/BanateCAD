
class.IPEllipse()

function IPEllipse:_init(ipname, centerx, centery, acolor)
	self.centerx = centerx
	self.centery = centery
	self.color = acolor
	self.name = ipname
	self.sizex = 172
	self.sizey = 38

end

function IPEllipse:render()
	strokeWeight(1)
	fill(self.color)

	ellipse(self.centerx, self.centery, self.sizex, self.sizey)
	textFont("Quartz, 9")
	textAlign(cd.CENTER);
	text(self.centerx, self.centery, self.name)
end

function setup()
	size(600,400)
	background(230)
	local turquoise = color(0,255,255)

	local labels = {
		IPEllipse("168.10.20.1", 150, 150, turquoise),
		IPEllipse("0.0.0.0", 200, 200, turquoise),
		IPEllipse("255.255.255.255", 250, 250, turquoise),
		IPEllipse("127.0.0.1", 200, 300, turquoise),
		IPEllipse("192.168.0.1", 150, 350, turquoise),
	}

	drawLabels(labels);
end

function drawLabels(labs)
	-- Draw some interesting lines
	for i=1,#labs do
		line(10, 250, labs[i].centerx, labs[i].centery)
	end

	for i=1,#labs do
		labs[i]:render()
	end
end
