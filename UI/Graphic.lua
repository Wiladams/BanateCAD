local class = require "pl.class"

class.Graphic()

function Graphic:_init(name, x, y, w, h)
	self.Name = name;

    self.Origin = Point3D.new(0, 0);
    self.Dimension = Vector3D.new(w, h);

    self.Frame = Rectangle({x, y}, {w, h});

	self.Visible = true;
    self.Active = true;
    self.Enabled = false;

    self.Debug = false;
	self.HasFocus = false;

	self.WorldTransform = nil;
    self.LocalTransform = nil;

    self.Container = nil;
	self.Window = nil;
end

function Graphic.OnSetContainer(self)
	if (nil ~= self.Container) then
		self.Window = self.Container.Window;
	else
		self.Window = nil;
	end

	self:UpdateGeometryState();
end

function Graphic.OnSetLocalTransform(self)
end

function Graphic.OnSetWorldTransform(self)
end

function Graphic.Focus(self)
	self.HasFocus = true;

	self:OnGainedFocus();
end

function Graphic.OnGainedFocus(self)
end

function Graphic.LoseFocus(self)
	self.HasFocus = false;

	self:OnLostFocus();
end

function Graphic.OnLostFocus(self)
end

function Graphic.OnCompleted(self)
end

function Graphic.OnError(self, excep)
end

--[[
	Mouse Activity
--]]
-- MouseActivityArgs e
function Graphic.OnNextMouse(self, e)
	if e.ActivityType == MouseActivityType.MouseDown then
		self:OnMouseDown(e);
	elseif e.ActivityType == MouseActivityType.MouseMove then
		self:OnMouseMove(e);
	elseif e.ActivityType == MouseActivityType.MouseUp then
		self:OnMouseUp(e);
	elseif e.ActivityType == MouseActivityType.MouseEnter then
		self:OnMouseEnter(e);
	elseif e.ActivityType == MouseActivityType.MouseHover then
		self:OnMouseHover(e);
 	elseif e.ActivityType == MouseActivityType.MouseLeave then
		self:OnMouseLeave(e);
	elseif e.ActivityType == MouseActivityType.MouseWheel then
		OnMouseWheel(e);
	end
end

-- MouseActivityArgs e
function Graphic.OnMouseDown(self, e)
end

-- MouseActivityArgs e
function Graphic.OnMouseMove(self, e)
end

-- MouseActivityArgs e
function Graphic.OnMouseUp(self, e)
end

-- MouseActivityArgs e
function Graphic.OnMouseWheel(self, e)
end

-- MouseActivityArgs e
function Graphic.OnMouseEnter(self, e)
end

-- MouseActivityArgs e
function Graphic.OnMouseHover(self, e)
end

-- MouseActivityArgs e
function Graphic.OnMouseLeave(self, e)
end

--[[
	Keyboard Activity
--]]
-- KeyboardActivityArgs ke
function Graphic.OnNextKeyboard(self, ke)
	if ke.AcitivityType == KeyActivityType.KeyDown then
		self:OnKeyDown(ke);
	elseif ke.AcitivityType == KeyActivityType.KeyUp then
		self:OnKeyUp(ke);
	elseif ke.AcitivityType == KeyActivityType.KeyChar then
		self:OnKeyPress(ke);
	end
end

-- KeyboardActivityArgs ke
function Graphic.OnKeyDown(self, ke)
end

-- KeyboardActivityArgs ke
function Graphic.OnKeyUp(self, ke)
end

-- KeyboardActivityArgs ke
function Graphic.OnKeyPress(self, kpe)
end

--[[
        /// <summary>
        /// Determine whether a given point is within our frame.  The point is given in the
        /// coordinate system of the containing control, and so is measured against the frame
        /// and not against the ClientRectangle.
        /// </summary>
        /// <param name="x">The x-coordinate of the point of interest.</param>
        /// <param name="y">The y-coordinate of the point of interest.</param>
        /// <returns>Returns true if the point is contained within the bounding frame.</returns>
--]]
function Graphic.Contains(self, x, y)
	return self.Frame:Contains(x, y);
end

--[[
        /// <summary>
        /// Invalidate a portion of the client rectangle.
        /// </summary>
        /// <param name="partialFrame"></param>
--]]
function Graphic.Invalidate(self, portionOfClientRectangle)
    -- The portion to be invalidated is given in the coordinate space
    -- of the client rectangle.  That portion needs to be converted
    -- into the parent's space and sent to the parent for evaluation
	portionOfClientRectangle:Offset(self.Frame.Left, self.Frame.Top);

	if (nil ~= self.Container) then
		self.Container:Invalidate(portionOfClientRectangle);
	elseif (nil ~= self.Window) then
		self.Window:Invalidate(portionOfClientRectangle);
	end
end


-- Invalidate the entire client rectangle.
function Graphic.Invalidate(self)
	self:Invalidate(self.ClientRectangle);
end

function Graphic.UpdateBoundaryState(self)
end

--[[
/// <summary>
/// The Geometry state needs to be updated whenever there is a change to
/// the frame, or any other aspect of the geometry.  Here recalculations
/// that are dependent on the geometry will occur.
/// By default, the container is queried for its transform.
/// </summary>
--]]
function Graphic.UpdateGeometryState(self)
	-- Since we are a part of a container, we will create
	-- our own transform, starting with Identity
	local myTransform = Transformation();

	-- 1. Query the container for the world transform
	if (nil ~= Container) then
		-- If the container has a world transform, we want to start from
		-- that transform.
		local parentTransform = self.Container.WorldTransform;

		if (nil ~= parentTransform) then
			myTransform = Transformation(parentTransform);
		end
	end

	-- Add the frame offset as part of the world transform.
	myTransform:Translate(self.Frame.Left, self.Frame.Top);

	self.WorldTransform = myTransform;

	-- Let subclassers do the specifics they need to do
	self:OnUpdateGeometryState();
end

function Graphic.OnUpdateGeometryState(self)
end

-- Drawable things
function Graphic.Draw(self, devent)
	if (nil ~= self.WorldTransform) then
                -- Save the current graph port state
                --devent.GraphPort.SaveState();

                -- Set our world transform if we have one
                --devent.GraphPort.SetWorldTransform(WorldTransform);
	end

	-- Do the drawing
	self:OnDraw(devent);

	if (nil ~= self.WorldTransform) then
	-- Restore the graphics state
	-- devent.GraphPort.ResetState();
	end
end


-- DrawEvent devent
function Graphic.DrawBackground(self, devent)
end

-- DrawEvent devent
function Graphic.DrawSelf(self, devent)
end

-- DrawEvent devent
function Graphic.DrawForeground(self, devent)
end

-- DrawEvent devent
function Graphic.Render(self, devent)
	if (not self.Visible) then
		return;
	end

	self:DrawBackground(devent);
	self:DrawSelf(devent);
	self:DrawForeground(devent);

	-- If we're debugging, we want to see the outline
	--
	if (self.Debug) then
		self:OnDebug(devent);
	end
end

-- By default, debugging will just draw a red rectangle around the frame
-- DrawEvent devent
function Graphic.OnDebug(devent)
	local aRect = Rectangle(self.Origin.x, self.Origin.y, self.Dimension.x, self.Dimension.y);
	devent.GraphPort:DrawRectangle(GDICosmeticPen.Red, aRect);
end

function Graphic.MoveTo(self, x, y)
	local dx = x - self.Frame.Left;
	local dy = y - self.Frame.Top;

	self:MoveBy(dx, dy);
end

function Graphic.MoveBy(self, dx, dy)
	self.Frame:Offset(dx, dy);

	self:OnMoving(dx, dy);
	self:UpdateGeometryState();
end

function Graphic.OnMoving(self, dw, dh)
	if (nil ~= self.Window) then
		self.Window:Invalidate(self.Frame);
	end
end

function Graphic.ResizeTo(self, w, h)
	self.Frame = Rectangle({self.Frame.Left, self.Frame.Top}, {w, h});
	self.Dimension.x = w;
	self.Dimension.y = h;

	self:UpdateGeometryState();
end

function Graphic.ResizeBy(self, dw, dh)
	self.Frame = Rectangle(self.Frame.Left, self.Frame.Top,
                self.Frame.Width+dw, self.Frame.Height+dh);

	self.Dimension.x = self.Frame.Width;
	self.Dimension.y = self.Frame.Height;

	self:UpdateGeometryState();
end



--[=====[
        /// <summary>
        /// The Container tells you which GraphicGroup this graphic is a part of.
        /// When the container is set, there are a number of properties that the
        /// graphic gets from the container.
        /// </summary>
        public virtual IGraphicGroup Container
		{
			get { return fContainer; }
			set {
				fContainer = value;

                OnSetContainer();
			}
		}

        public virtual Transformation WorldTransform
        {
            get { return fWorldTransform; }
            set
            {
                fWorldTransform = value;
                OnSetWorldTransform();
            }
        }

        public virtual RectangleI ClientRectangle
        {
            get
            {
                RectangleI rect = new RectangleI((int)Origin.x, (int)Origin.y, (int)Dimension.x, (int)Dimension.y);
                return rect;
            }
        }

        public virtual RectangleI Frame
		{
			get{return fFrame;}
			set
			{
				fDimension = new Vector3D(value.Width, value.Height);
				fFrame = value;
                UpdateGeometryState();
			}
		}

		public virtual Vector3D Dimension
		{
			get { return fDimension; }
			set {
                fDimension = value;
                ResizeTo((int)fDimension.x, (int)fDimension.y);
            }
        }


		public virtual IWindow Window
		{
			get {
				if (fWindow != null)
					return fWindow;

				if (Container != null)
					return Container.Window;

				return null;
			}
			set { fWindow = value; }
        }

        public virtual Transformation LocalTransform
        {
            get { return fLocalTransform; }
            set
            {
                fLocalTransform = value;
                OnSetLocalTransform();
            }
        }
--]=====]
