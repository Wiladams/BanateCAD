local class = require "pl.class"

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
	stroke(0)

	ellipse(self.centerx, self.centery, self.width, self.height)
	textFont("Quartz, 9")
	textAlign(cd.CENTER);
	text(self.centerx, self.centery, self.name)
end



class.StarCluster()

function StarCluster:_init(namelist, centerx, centery, radius, acolor)
	self.LabelList = {}
	self.centerx = centerx
	self.centery = centery

	local se = param_superellipse{XRadius = radius, ZRadius = radius}

	for i=1,#namelist do
		local u = i/#namelist
		local pos = se:GetProfileVertex(u)
		local label = EllipseLabel(namelist[i], pos[1]+self.centerx, pos[3]+centery, acolor)
		table.insert(self.LabelList, label)
	end
end

function StarCluster:render()
	-- Draw some interesting lines
	for _,label in ipairs(self.LabelList) do
		line(self.centerx, self.centery, label.centerx, label.centery)
	end

	for _,label in ipairs(self.LabelList) do
		label:render()
	end
end



function setup()
	size(800,400)
	background(230)
	local turquoise = color(0,255,255)

	local nodelist = {
		"168.10.20.1",
		"0.0.0.0",
		"255.255.255.255",
		"127.0.0.1",
		"192.168.0.1",
		"192.168.0.2",
		"192.168.0.3",
		"192.168.0.4",
		"192.168.0.5",
		"10.80.86.179",
		"10.80.86.180",
		"10.80.86.181",
		"10.80.86.182",
		"10.80.86.183",
		"10.80.86.184",
		"10.80.86.185",
		"10.80.86.186",
		"10.80.86.187",
		"10.80.86.188",
		"10.80.86.189",
		"10.80.86.190",
	}

	local cluster = StarCluster(nodelist, width/2, 300, 200, turquoise)

	cluster:render();
end
