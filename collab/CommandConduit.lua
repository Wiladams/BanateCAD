
local http = require("socket.http")
local ltn12 = require("ltn12")
local mime = require("mime")
require("LuaXML")


-- Command Conduit
--local propfunctor = PaxosProposeFunctor.new()

CommandConduit={}
CommandConduit.Url = "http://pvs-demo2-ch1.cloudapp.net/paxosvotingservice.svc/votes"
CommandConduit.LastVote = 1

--CommandConduit.ProposalQueue = AsyncQueue.new(propfunctor)
CommandConduit.ReceivedCommandQueue = AsyncQueue.new(listenfunctor)


--CommandConduit.ReceiveQueue = AsyncQueue.new(PaxosReceiveFunctor)
function CommandConduit.Propose(cmd)
	-- pickle the Command
	--local pcmd = pickle.dumps(cmd)

	-- Turn it into base64
	local b64cmd, B = mime.b64(cmd)

	-- Do a POST
	http.request(CommandConduit.Url, b64cmd)
end

function CommandConduit.DispatchVote(vote)
	-- query for the votes since last query
	print("CommandConduit.DispatchVote")

	local instance = xml.find(vote,"Instance")[1]
	local result = xml.find(vote,"Result")[1]

	-- Tell the system about the last vote we Received
	CommandConduit.LastVote = instance

	--print(instance)
	--print(result)

	-- Decode from base64
	local unpacked, B = mime.unb64(result)
	print(unpacked)

	-- unpickle
	--local cmd = pickle.loads(unpacked)
--print(cmd)

	-- Set the most recent vote
	CommandConduit.LastVote = instance

	--print("Instance: ", instance)
	--print("Result: ", result)
	-- send the command to the default scene for processing
	--SceneProxy.ReceiveCommand(cmd)
	local f = loadstring(unpacked)
	f()

	-- Update the gl view
	iup.Update(glcanvas)
end

function CommandConduit.GetVotes(firstVote)
	-- Retrieve all the votes since CommandConduit.FirstVote
	-- get the data from the server
	local req = CommandConduit.Url..'/'..firstVote
	local votes = http.request(req)

	-- parse it into individual votes
	local votetable = xml.eval(votes)

	-- Assign the value of the last vote found
	-- to .LastVote
	for _,vote in ipairs(votetable) do
		CommandConduit.DispatchVote(vote)
	end
end

function CommandConduit.GetRecentVotes()
	CommandConduit.GetVotes(CommandConduit.LastVote+1)
end

-- Setup the communications conduit
-- Setup the ChatConduit
CommandConduit.LastVote = 2
