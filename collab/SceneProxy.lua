-- Create a proxy to catch all the calls
SceneProxy = {}
SceneProxy_mt={}
setmetatable(SceneProxy, SceneProxy_mt)

function createSceneProxy(inst)
	SceneProxy.Instance = inst
	setmetatable(SceneProxy, SceneProxy_mt)

	ConsensusLoopback.SetReceiver(SceneProxy)

	return SceneProxy
end

SceneProxy_mt.__index = function(t, key)
		--print("Scene Proxy lookup: ", key)

	if (key == 'appendCommand') then
			-- Hand back our own appendCommand routine
			-- So we can distribute the call to the
			-- consensus handler
		return Scene_appendCommand
	elseif 'ReceiveCommand' == key then
		return SceneProxy.ReceiveCommand
	end

	return SceneProxy.Instance[key]
end


function SceneProxy.ReceiveCommand(params)
	print("===== SceneProxy.ReceivedCommand() BEGIN =====")
	if aCommand ~= nil then
		-- append the command to the real scene
		SceneProxy.Instance:appendCommand(aCommand)
	else
		print("SceneProxy.ReceiveCommand - Received NIL command:")
	end
	print("===== SceneProxy.ReceivedCommand() END =====")
end

function Scene_appendCommand(self, aCommand)
	print("==========  Scene_appendCommand BEGIN ==========")
	CommandConduit.Propose(aCommand)
	print("==========  Scene_appendCommand END ==========")

end


--defaultscene = createSceneProxy(defaultscene)
