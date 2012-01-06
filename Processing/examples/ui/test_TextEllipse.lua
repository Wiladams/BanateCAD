
class.EllipseLabel()

function EllipseLabel:_init(ipname, centerx, centery, acolor)
	self.centerx = centerx
	self.centery = centery
	self.color = acolor
	self.name = ipname
	self.width = 172
	self.height = 38

end

function EllipseLabel:render()
	strokeWeight(1)
	fill(self.color)

	ellipse(self.centerx, self.centery, self.width, self.height)
	textFont("Quartz, 9")
	textAlign(cd.CENTER);
	text(self.centerx, self.centery, self.name)
end



class.StarCluster()

function StarCluster:_init(namelist, centerx, centery, radius, acolor)
	self.LabelList = {}
	local stepAngle = 2*PI / #namelist

	for i=1,#namelist in ipairs(namelist) do
		local x = radius * cos(stepAngle*i)
		local y = radius * sin(stepAngle*i)
		local label = EllipseLabel(name, x, y, acolor)
		table.insert(self.LabelList, label)
	end
end

function StarCluster:render()
	-- Draw some interesting lines
	for _,label in ipairs(self.LabelList) do
		line(10, 250, label.centerx, label.centery)
	end

	for _,label in ipairs(self.LabelList) do
		label:render()
	end
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
