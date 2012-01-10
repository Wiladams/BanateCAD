local styler = GUIStyle();

background(170)

rec1 = Rectangle({10, 10}, {100, 100})
rec2 = Rectangle({60, 60}, {100, 100})
rec3 = rec1:Intersect(rec2)

styler:DrawFrame(Processing.Renderer, rec1.Left, rec1.Top, rec1.Width, rec1.Height, FrameStyle.Sunken)
styler:DrawFrame(Processing.Renderer, rec2.Left, rec2.Top, rec2.Width, rec2.Height, FrameStyle.Sunken)
styler:DrawFrame(Processing.Renderer, rec3.Left, rec3.Top, rec3.Width, rec3.Height, FrameStyle.Raised)
