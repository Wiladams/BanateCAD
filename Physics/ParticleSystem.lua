--require ("Shape")

ParticleSystem = inheritsFrom(Shape);
function ParticleSystem.new(params)
	local new_inst = ParticleSystem.create()

	ParticleSystem.Init(new_inst, params)

	return new_inst
end

function ParticleSystem.Init(self, params)
	self.Position = params.Position or {}
	self.Velocity = params.Velocity or {}
	self.Acceleration = params.Acceleration or {}
	self.Mass = params.Mass or {}
	self.MassInverse = params.MassInverse or {}
	self.NumParticles = params.NumParticles or 0
	self.Step = params.Step or 1
	self.HalfStep = params.HalfStep or 1/2 * self.Step
	self.SixthStep = params.SixthStep or 1/6*self.Step

	self:SetStep(self.Step)

	--fAccumulatedTime;
    self.Force = vec3(0,0,0);

	-- temporary storage for solver
	m_akPTmp={}; m_akDPTmp1={}; m_akDPTmp2={}; m_akDPTmp3={}; m_akDPTmp4={};
	m_akVTmp={}; m_akDVTmp1={}; m_akDVTmp2={}; m_akDVTmp3={}; m_akDVTmp4={};

end

function ParticleSystem.SetStep(self, step)
	self.Step = step;
	self.HalfStep = step / 2;
	self.SixthStep = step / 6;
end

--        abstract protected float3 Acceleration (int i, Real fTime, float3[] position, float3[] velocity);
--        abstract public void Render(GraphicsInterface gi);
--        abstract protected void InitializeParticle(int index);


function ParticleSystem.Update(self, toTime)
	self:Resolve(toTime)
end

function ParticleSystem.ReSolve(self, toTime)
	-- Runge-Kutta fourth-order solver
	local halfTime = toTime + self.HalfStep;
	local fullTime = toTime + self.Step;

	-- first step
	for i = 1, i < self.NumParticles do
		if self.MassInverse[i] > 0.0 then
			self.m_akDPTmp1[i] = self.Velocity[i];
			self.m_akDVTmp1[i] = self.Acceleration(i, toTime, self.Position, self.Velocity);
		end
	end

	for i = 1, self.NumParticles do
		if self.MassInverse[i] > 0.0 then
			self.m_akPTmp[i] = self.Position[i] + self.HalfStep * self.m_akDPTmp1[i];
			self.m_akVTmp[i] = self.Velocity[i] + self.HalfStep * self.m_akDVTmp1[i];
		else
			self.m_akPTmp[i] = self.Position[i];
			self.m_akVTmp[i] = vec3(0,0,0);
        end
	end

	-- second step
	for i = 1, self.NumParticles do
		if self.MassInverse[i] > 0.0 then
                    m_akDPTmp2[i] = m_akVTmp[i];
                    m_akDVTmp2[i] = Acceleration(i, fHalfTime, m_akPTmp, m_akVTmp);
		end
	end

	for i = 1, self.NumParticles do
		if MassInverse[i] > 0.0 then
			self.m_akPTmp[i] = self.Position[i] + self.HalfStep * self.m_akDPTmp2[i];
			self.m_akVTmp[i] = self.Velocity[i] + self.HalfStep * self.m_akDVTmp2[i];
		else
			self.m_akPTmp[i] = self.Position[i];
			self.m_akVTmp[i] = vec3(0,0,0);
		end
	end

	-- third step
	for i = 1, self.NumParticles do
		if self.MassInverse[i] > 0.0 then
			self.m_akDPTmp3[i] = self.m_akVTmp[i];
			self.m_akDVTmp3[i] = self:Acceleration(i, halfTime, self.m_akPTmp, self.m_akVTmp);
		end
	end

	for i = 1, self.NumParticles do
		if self.MassInverse[i] > 0.0 then
			self.m_akPTmp[i] = self.Position[i] + self.Step * self.m_akDPTmp3[i];
			self.m_akVTmp[i] = self.Velocity[i] + self.Step * self.m_akDVTmp3[i];
		else
			self.m_akPTmp[i] = self.Position[i];
			self.m_akVTmp[i] = vec3(0,0,0);
		end
	end

	-- fourth step
	for i = 1, self.NumParticles do
		if self.MassInverse[i] > 0.0 then
			self.m_akDPTmp4[i] = self.m_akVTmp[i];
			self.m_akDVTmp4[i] = self:Acceleration(i, fullTime, self.m_akPTmp, self.m_akVTmp);
		end
	end

	for i = 1, self.NumParticles do
		if self.MassInverse[i] > 0.0 then
			self.Position[i] = self.Position[i] + self.SixthStep * (self.m_akDPTmp1[i] +
                        (2.0) * (self.m_akDPTmp2[i] + self.m_akDPTmp3[i]) + self.m_akDPTmp4[i]);
			self.Velocity[i] = self.Velocity[i] + self.SixthStep * (self.m_akDVTmp1[i] +
                        (2.0) * (self.m_akDVTmp2[i] + self.m_akDVTmp3[i]) + self.m_akDVTmp4[i]);
		end
	end
end

--[[
        //public virtual int Emit(int numParticles)
        //{
        //    // create new particles, up to the amount of room we have
        //    // available based on maxParticles
        //    while ((numParticles > 0) && (fNumParticles < fMaxParticles))
        //    {
        //        // Initialize current particle, and increase the count
        //        InitializeParticle(fNumParticles);
        //        fNumParticles++;
        //        numParticles--;
        //    }

        //    return numParticles;
        //}

        //public virtual void InitializeSystem()
        //{
        //    fParticles = new Particles(fMaxParticles);

        //    fNumParticles = 0;
        //    fAccumulatedTime = 0;
        //}
--]]

function ParticleSystem.KillSystem(self)
            self.fNumParticles = 0;
end
