local class = require "gl.class"
require "Graphic"

class.GraphicGroup(Graphic)

    public class GraphicGroup : Graphic, IGraphicGroup
    {
		private List<IGraphic> fChildList;
		private ILayoutManager fLayoutManager;
        bool fAutoGrow;

        #region Constructors
        public GraphicGroup(String name)
            : this(name, 0,0,0,0,LayoutManager.Empty)
        {
        }

        public GraphicGroup(String name, Rectangle rect)
            : this(name, rect.Left, rect.Top, rect.Width, rect.Height, LayoutManager.Empty)
        {
        }

        public GraphicGroup(String name, int x, int y, int width, int height)
            : this(name, x, y, width, height, LayoutManager.Empty)
        {
        }


function GraphicGroup:_init(name, x, y, w, h, layout)
	self:super(name, x, y, w, h)
    self.AutoGrow = true;
	self.LayoutManager = layout;
	self.GraphicChildren = {}
end


function GraphicGroup.SetLayoutHandler(self, value)
	self.LayoutManager = value;
	self.LayoutManager:Layout(self);
end

        protected override void OnSetContainer()
        {
            base.OnSetContainer();

            foreach (IGraphic g in GraphicChildren)
            {
                g.Container = this;
            }
        }

        // Drawable things
		public virtual void DrawChildren(DrawEvent devent)
		{
			foreach (IGraphic g in GraphicChildren)
			{
				devent.GraphPort.SaveState();

                // Make sure they don't draw outside their frame
                Rectangle f = g.Frame;
                f.Inflate(1, 1);
                devent.GraphPort.SetClipRectangle(f);

                // Translate before we draw so all drawing within a child has
                // 0,0 in it's upper left corner
                devent.GraphPort.TranslateTransform(g.Frame.Left, g.Frame.Top);

				g.Draw(devent);

				// Restore the state
                devent.GraphPort.ResetState();
			}
		}

        public override void DrawSelf(DrawEvent devent)
		{
			DrawChildren(devent);
        }
        #endregion

        #region Movement and Sizing
        public override void MoveBy(int x, int y)
        {
			Rectangle f = Frame;
			f.Offset(x, y);
			Frame = f;
        }


        #endregion

        #region IGraphic
        /// <summary>
        ///  When geometry changes, we might want to relayout graphics, propagate
        ///  world transforms, regather bounding rectangles and the like.
        /// </summary>
        protected override void OnUpdateGeometryState()
        {
            foreach (IGraphic g in GraphicChildren)
            {
                g.UpdateGeometryState();
            }
            LayoutHandler.Layout(this);

        }
        #endregion

        #region IGraphicGroup

		public virtual void AddGraphic(IGraphic aGraphic)
		{
			AddGraphic(aGraphic, null);
		}

		public virtual void	AddGraphic(IGraphic aGraphic, IGraphic before)
		{
			if (null == aGraphic)
			{
				return ;
			}

			lock(this)
			{
				GraphicChildren.Add(aGraphic);
			}

			aGraphic.Container = this;

			OnGraphicAdded(aGraphic);
		}

		public virtual void	AddGraphicAfter(IGraphic aGraphic, IGraphic after)
		{
			if (aGraphic == null)
			{
				return ;
			}

			lock(this)
			{
				GraphicChildren.Add(aGraphic);
			}
			aGraphic.Container = this;

			OnGraphicAdded(aGraphic);
		}

        public virtual void OnGraphicAdded(IGraphic aGraphic)
        {
            // Layout the graphic again
            LayoutHandler.AddToLayout(aGraphic);

            if (AutoGrow)
            {
                // Make sure our frame expands appropriately
                Rectangle frame = Frame;

                Point gOrigin = new Point(frame.Left + aGraphic.Frame.Left, frame.Top + aGraphic.Frame.Top);
                //float3 iPoint = WorldTransform.ApplyInverse(new float3(gOrigin.X, gOrigin.Y, 0));
                //Point tOrigin = new Point((int)iPoint.x, (int)iPoint.y);
                Rectangle tRect = new Rectangle(gOrigin, aGraphic.Dimension);

                // WAA - need to do this
                frame = Rectangle.Union(frame, tRect);

                Dimension = new Size(frame.Width, frame.Height);
                fFrame = frame;
            }
        }

        public virtual bool RemoveGraphic(IGraphic aGraphic)
		{
			lock(this)
			{
				GraphicChildren.Remove(aGraphic);
			}

            aGraphic.Container = null;

			// Layout the graphic again
			LayoutHandler.Layout(this);

			return false;
		}

		public virtual void	RemoveAllGraphics()
		{
			lock(this)
			{
			    // WAA - need to go through each one of them and remove
                // them individually.
                GraphicChildren.RemoveRange(0,GraphicChildren.Count);
			}

			LayoutHandler.Layout(this);
		}

        public virtual void MoveGraphicToFront(IGraphic graphic)
        {
            if (null == graphic)
                return;

            RemoveGraphic(graphic);

            // Move the new graphic to the front in the hierarchy
            AddGraphic(graphic);
        }

function GraphicGroup.CountGraphics(self)
	return #self.GraphicChildren;
end

		// Find which graphic is in the group at a particular
		// location.
		public virtual IGraphic	GraphicAt(int index)
		{
			return (IGraphic)fChildList[index];
		}

--[[
		// WAA - do this like GraphicsAt
		public virtual IGraphic	GraphicAt(float x, float y)
		{
			if (!Frame.Contains(x, y))
				return null;

			IGraphic returnGraphic = null;

			// If it is in my frame, the see which of my children
			// it might be in.  We're looking for the child which is
			// closest to the user's eyes, which means it's deepest
			// in the hierarchy.
			foreach (IGraphic g in fChildList)
			{
				bool contains = g.Contains(x, y);
				if (contains)
				{
					if (g is IGraphicHierarchy)
					{
						IGraphic tmp = ((IGraphicHierarchy)g).GraphicAt(x,y);

						if (tmp != null)
							returnGraphic = tmp;
						else
							returnGraphic = g;
					} else
						returnGraphic = g;
				}
			}

			if (returnGraphic != null)
				return returnGraphic;

			// If we're here, then none of our descendants contained the hit point,
			// but we do, so return self.
			return this;
		}
--]]

        // return all the graphics in the hierarchy that are hit by the point
        public virtual void GraphicsAt(int x, int y, ref Stack<IGraphic> coll)
		{
            foreach (IGraphic g in fChildList)
            {
                if (g.Frame.Contains(x, y))
                {
                    coll.Push(g);

                    if (g is IGraphicGroup)
                    {
                        // Transform the point so the graphic we are checking
                        // uses a point that is within its frame, not the parent's frame
                        int newX = x - g.Frame.Left;
                        int newY = y - g.Frame.Top;
                        ((IGraphicGroup)g).GraphicsAt(newX, newY, ref coll);
                    }
                }
            }

		}

		// Just check immediate children for a graphic of the given name
		public virtual IGraphic	GraphicNamed(string graphicName)
		{
			foreach (IGraphic g in fChildList)
			{
				if (g.Name.CompareTo(graphicName) == 0)
					return g;
			}

			return null;
		}

		// Check the whole hierarchy for a graphic of the given name
		public virtual IGraphic	GraphicNamedRecurse(string graphicName)
		{
			foreach (IGraphic g in fChildList)
			{
				// We found a graphic of the given name, so return
				if (g.Name.CompareTo(graphicName) == 0)
				{
					return g;

				} else if (g is IGraphicHierarchy)
				{
					IGraphic aGraphic = ((IGraphicHierarchy)g).GraphicNamedRecurse(graphicName);
					if (aGraphic != null)
						return aGraphic;
				}
			}

			return null;
        }


