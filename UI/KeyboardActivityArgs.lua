--[[
RawKeyEventType =
    {
        Make = User32.RI_KEY_MAKE,
        Break = User32.RI_KEY_BREAK,
        E0 = User32.RI_KEY_E0,
        E1 = User32.RI_KEY_E1,
        TermServSetLED = User32.RI_KEY_TERMSRV_SET_LED,
        TermServShadow = User32.RI_KEY_TERMSRV_SHADOW
    }
--]]

KeyActivityType =
    {
        None = 0,

        -- A virtual key has been pressed.
        KeyDown = 1,

        -- A virtual key has been released.
        KeyUp = 2,

        -- A virtual key has been turned into an actual character.
        KeyChar = 3,

        SysKeyDown = 4,
        SysKeyUp = 5,
        SysChar = 6,
    }

--[[
    /// <summary>
    /// KeyboardDevice events represent keyboard activity.  The event can be a KeyDown, KeyUp,
    /// or KeyChar.
    /// The down and up events report the raw virtual key code that is
    /// being pressed and released.
    /// The KeyChar event type represents an actual key once it has been translated
    /// by the system.
    /// </summary>
--]]

--[[
KeyboardDevice keyboard,
IntPtr windowHandle,
KeyActivityType eventType,
VirtualKeyCodes vKeyCode,
KeyMasks masks,
int scanCode,
int repeatCount,
bool extended,
char aChar
--]]

local class = require "pl.class"

class.KeyboardActivityArgs()

function KeyboardActivityArgs:_init(params)

	self.Keyboard = params.Keyboard;
	self.Window = params.Window;
	self.EventType = params.EventType;
	self.VirtualKeyCode = params.KeyCode;
	self.KeyMasks = params.KeyMasks;
	self.KeyChar = params.KeyChar;

	self.RepeatCount = params.RepeatCount or 0;
	self.OEMScanCode = params.OEMScanCode;
	self.IsExtended = params.Extended;

end

function KeyboardActivityArgs.__tostring(self)
	return "Keycode: "..self.VirtualKeyCode.." Activity: "..self.AcitivityType;
end

--[[
        public static KeyboardActivityArgs CreateFromWindowsMessage(IntPtr windowHandle, int msg, IntPtr wParam, IntPtr lParam)
        {
            KeyActivityType kEType = KeyActivityType.None;
            VirtualKeyCodes virtualKey = VirtualKeyCodes.None;
            KeyMasks masks = KeyMasks.None;
            Char aChar = '\0';
            UInt64 keyFlags = (UInt64)lParam;


            //if (((UInt16)User32.GetKeyState((int)VirtualKeyCodes.ShiftKey) & (UInt16)0x8000) > 0)
            //    masks |= KeyMasks.Shift;

            //if (((UInt16)User32.GetKeyState((int)VirtualKeyCodes.ControlKey) & (UInt16)0x8000) > 0)
            //    masks |= KeyMasks.Control;


            // The lParam (keyflags) are decoded in the following way
            // bits 0 - 15      Repeat Count
            // bits 16 - 23     OEM specific scan code
            // bit  24          Whether the key is an extended key
            // bits 25 - 28     Reserved, do not use
            // bit  29          Context code.  Zero for key down
            // bit  30          Specifies previous key state.
            //                  The value is 1 if the key is down before the message is sent,
            //                  or it is zero if the key is up.
            // bit 31           Specifies the transition state.  Always zero for keydown
            int repeatCount = (int)keyFlags & 0xffff;
            int scanCode = ((int)keyFlags & 0xff0000) >> 16;
            bool isExtended = (((int)keyFlags & 0x1000000) >> 24) == 1;
            int context = ((int)keyFlags & 0x20000000) >> 29;
            bool altPressed;

            KeyboardActivityArgs ke = null;

            switch (msg)
            {
                case (int)WinMsg.WM_SYSKEYDOWN:
                    kEType = KeyActivityType.SysKeyDown;
                    break;

                case (int)WinMsg.WM_SYSKEYUP:
                    kEType = KeyActivityType.SysKeyUp;
                    break;

                case (int)WinMsg.WM_SYSCHAR:
                    kEType = KeyActivityType.SysChar;
                    aChar = (char)wParam;
                    if (1 == context)
                        altPressed = true;
                    break;

                case (int)WinMsg.WM_KEYDOWN:
                    {
                        kEType = KeyActivityType.KeyDown;
                        virtualKey = (VirtualKeyCodes)wParam.ToInt32();
                    }
                    break;

                case (int)WinMsg.WM_KEYUP:
                    {
                        kEType = KeyActivityType.KeyUp;
                        virtualKey = (VirtualKeyCodes)wParam.ToInt32();
                    }
                    break;

                case (int)WinMsg.WM_CHAR:
                    kEType = KeyActivityType.KeyChar;
                    aChar = (char)wParam.ToInt32();
                    if (1 == context)
                        altPressed = true;
                    break;
            }

            ke = new KeyboardActivityArgs(null, windowHandle, kEType, virtualKey, masks, scanCode, repeatCount, isExtended, aChar);

            return ke;
        }

        public static KeyboardActivityArgs CreateFromKeyboardHookProc(IntPtr wParam, IntPtr lParam)
        {
            IntPtr windowHandle = IntPtr.Zero;
            VirtualKeyCodes virtualKey = (VirtualKeyCodes)wParam.ToInt32();
            KeyActivityType kEType = KeyActivityType.None;
            ulong keyFlags = (ulong)lParam;
            Char aChar = '\0';

            // The keyflags are decoded in the following way
            // bits 0 - 15      Repeat count
            // bits 16 - 23     scan code (OEM Specific)
            // bit 24           Whether the key is an extended key
            // bits 25 - 28     Reserved, do not use
            // bit 29           Context code.  Zero for key down
            // bit 30           Specifies previous key state.
            //                  The value is 1 if the key is down before the message is sent, or it is zero if the key is up.
            // bit 31           Specifies the transition state.
            int repeatCount = (int)keyFlags & 0xffff;
            int scanCode = ((int)keyFlags & 0xff0000) >> 16;
            bool isExtended = (((int)keyFlags & 0x1000000) >> 24) == 1;
            int context = ((int)keyFlags & 0x20000000) >> 29;
            bool altPressed = (1 == context);

            uint transition = ((uint)keyFlags & 0x80000000) >> 31;
            if (0 == transition)
                kEType = KeyActivityType.KeyDown;
            else
                kEType = KeyActivityType.KeyUp;


            KeyboardActivityArgs ke = new KeyboardActivityArgs(null, windowHandle, kEType, virtualKey, KeyMasks.None, scanCode, repeatCount, isExtended, aChar);

            return ke;


        }
    }
--]]

--[[
        public bool IsExtendedKey
        {
            get { return fIsExtended; }
        }

        public char Character
        {
            get { return fKeyChar; }
        }

        public KeyActivityType AcitivityType
        {
            get { return fEventType; }
        }

        public KeyboardDevice Keyboard
        {
            get { return fKeyboard; }
        }

        //public int KeyFlags
        //{
        //    get { return fKeyFlags; }
        //}

        public VirtualKeyCodes VirtualKeyCode
        {
            get
            {
                return m_VirtualKeyCode;
            }
        }

        public KeyMasks Modifiers
        {
            get
            {
                return m_KeyMasks;
            }
        }

        public int RepeatCount
        {
            get { return fRepeatCount; }
        }

        public int ScanCode
        {
            get { return m_OEMScanCode; }
        }

        public bool Alt
        {
            get
            {
                return ((int)m_VirtualKeyCode & (int)KeyMasks.Alt) == (int)KeyMasks.Alt;
            }
        }

        public bool Control
        {
            get
            {
                return (m_KeyMasks & KeyMasks.Control) == KeyMasks.Control;
            }
        }

        public bool Shift
        {
            get
            {
                return (m_KeyMasks & KeyMasks.Shift) == KeyMasks.Shift;
            }
        }
--]]
