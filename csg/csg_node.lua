--require ("Class")

--[[
// # class Node

// Holds a node in a BSP tree. A BSP tree is built from a collection of polygons
// by picking a polygon to split along. That polygon (and all other coplanar
// polygons) are added directly to that node and the other polygons are added to
// the front and/or back subtrees. This is not a leafy BSP tree since there is
// no distinction between internal and leaf nodes.
--]]

-- Return a list of all polygons in this BSP tree.
function copytable(alist)
	return {unpack(alist)}
end


Node = inheritsFrom(nil)

function Node.new(polygons)
	local this = Node:create()

	this.plane = nil;
	this.front = nil;
	this.back = nil;
	this.polygons = {};

	if polygons ~= nil then
		this:build(polygons)
	end

	return this
end

function Node.clone(this)
    local node = Node.new()
	-- TODO
    if this.plane ~= nil then
		node.plane = this.plane.clone();
	end

    if this.front ~= nil then
		node.front = this.front.clone()
	end

    if this.back ~= nil then
		node.back = this.back.clone()
	end

	if this.polygons ~= nil then
		local polygons = {}
		for _,p in this.polygons do
			table.insert(polygons, p:clone())
		end
		node.polygons = polygons
	end

    return node;
end

-- Convert solid space to empty space and empty space to solid space.
function Node.invert(this)
	for  i,p in ipairs(this.polygons) do
		p:flip()
	end

    this.plane:flip()

	if this.front ~= nil then
		this.front:invert();
	end

	if this.back ~= nil  then
		this.back:invert();
    end

	local temp = this.front;
    this.front = this.back;
    this.back = temp;
end

-- Recursively remove all polygons in `polygons` that are inside this BSP
-- tree.

function Node.clipPolygons(this, polygons)
    if (nil == this.plane) then
		return copytable(polygons)
	end

    local front = {}
	local back = {}

	for i=1, #polygons do
      this.plane:splitPolygon(polygons[i], front, back, front, back);
    end

    if this.front ~= nil then
		front = this.front:clipPolygons(front);
	end

    if this.back ~= nil then
		back = this.back:clipPolygons(back);
    else
		back = {};
	end

	-- Add all the backs to the fronts
	for _,b in ipairs(back) do
		table.insert(front, b)
	end

    return front
end

-- Remove all polygons in this BSP tree that are inside the other BSP tree
-- `bsp`.
function Node.clipTo(this, bsp)
    this.polygons = bsp:clipPolygons(this.polygons);

	if this.front ~= nil then
		this.front:clipTo(bsp);
	end

    if this.back ~= nil then
		this.back:clipTo(bsp);
	end
end

function Node.allPolygons(this)
    local polygons = copytable(this.polygons)
    if this.front ~= nil then
		for _,p in ipairs(this.front:allPolygons()) do
			table.insert(polygons, p)
		end
    end

	if this.back ~= nil then
		for _,p in ipairs(this.back:allPolygons()) do
			table.insert(polygons, p)
		end
    end

	return polygons;
end

--[[
  // Build a BSP tree out of `polygons`. When called on an existing tree, the
  // new polygons are filtered down to the bottom of the tree and become new
  // nodes there. Each set of polygons is partitioned using the first polygon
  // (no heuristic is used to pick a good split).
--]]
function Node.build(this, polygons)

    if 0 == #polygons then
		return;
	end

    if nil == this.plane then
		this.plane = polygons[1].plane:clone();
	end

    local front = {}
	local back = {}

	for i=1, #polygons do
		this.plane:splitPolygon(polygons[i], this.polygons, this.polygons, front, back);
    end

    if #front > 0 then
		if nil == this.front then
			this.front = Node.new();
		end

		this.front:build(front);
    end

    if #back > 0 then
		if (nil == this.back) then
			this.back = Node.new();
		end
		this.back:build(back)
	end
end

