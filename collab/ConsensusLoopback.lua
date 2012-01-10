ConsensusLoopback={}
ConsensusLoopback["MessageQueue"] = queue.new()

-- Receiver.ReceiveCommand(acommand)

function ConsensusLoopback.SetReceiver(params)
	ConsensusLoopback.Receiver=params

	return ConsensusLoopback
end

function ConsensusLoopback.Propose(params)
	-- Just put the message into the outgoing queue
	-- A worker thread should pick it up and dispatch it
	-- for consensus
	ConsensusLoopback.MessageQueue.enqueue(params)

	ConsensusLoopback.OnConsensusReached(params)
end

function ConsensusLoopback.OnConsensusReached(params)
	if ConsensusLoopback.Receiver ~= nil then
		ConsensusLoopback.Receiver.ReceiveCommand(params)
	end
end

