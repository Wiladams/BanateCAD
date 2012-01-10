local styler = GUIStyle()
background(230)

--styler:DrawFrame(Processing.Renderer, 10, 10, 100, 100, FrameStyle.Sunken)

styler:DrawSunkenRect(Processing.Renderer, 30, 30, 100, 100)

styler:DrawRaisedRect(Processing.Renderer, 30, 150, 100, 100)
