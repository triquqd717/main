-- credit to original creators of forbidden! @https://discord.gg/FT5XKxphgM @https://create.roblox.com/store/asset/99009254123330/Forbidden-V2-Unpackaged

return function()
    local AIT
    local AI
    local Common
    local Math
    local StateMachine
    local TablesLibrary
    local DeepCopy
    local MergeTables
    local Signal
    local Trove
    local State
    local Transition
    local MessageQueue
    local PathfindingProcessor
    local ConfigHandler
    local DetectBadPaths
    local WaypointsVisualization
    local AntiLag
    local Info
    local CommonMathRequests
    local Defaults
    local Debugging
    local DirectMoveTo
    local WaypointLooper
    local TriggerCleanup
    local PositionalOptimization
    local RetrackingOptimization
    local TConfig
    local TRequestPriority
    local Storage
    local TypeHelp
    local CommonMathCollection
    local MathVisualization
    local old

    DeepCopy = (function()
        local function DeepCopy(Object)
            local NewObject = setmetatable({}, getmetatable(Object))
            for Index, Value in Object do
                if typeof(Value) == "table" then
                    NewObject[Index] = DeepCopy(Value)
                    continue
                end
                NewObject[Index] = Value
            end
            return NewObject
        end
        return DeepCopy
    end)()

    MergeTables = (function()
        local function MergeTables(BaseTable, TargetTable)
            for Index, Value in TargetTable do
                if typeof(BaseTable[Index]) == typeof(Value) then
                    if BaseTable[Index] ~= (getmetatable(BaseTable) or {})[Index] then
                        continue
                    end
                end
                if type(Value) == "table" then
                    BaseTable[Index] = table.clone(Value)
                else
                    BaseTable[Index] = Value
                end
            end
            return BaseTable
        end
        return MergeTables
    end)()

    Signal = (function()
        local FreeRunnerThread = nil
        local function AcquireRunnerThreadAndCallEventHandler(Fn, ...)
            local AcquiredRunnerThread = FreeRunnerThread
            FreeRunnerThread = nil
            Fn(...)
            FreeRunnerThread = AcquiredRunnerThread
        end
        local function RunEventHandlerInFreeThread(...)
            AcquireRunnerThreadAndCallEventHandler(...)
            while true do
                AcquireRunnerThreadAndCallEventHandler(coroutine.yield())
            end
        end
        local Connection = {}
        Connection.__index = Connection
        function Connection.new(Signal, Fn)
            return setmetatable({
                Connected = true,
                _signal = Signal,
                _fn = Fn,
                _next = false,
            }, Connection)
        end
        function Connection:Disconnect()
            if not self.Connected then
                return
            end
            self.Connected = false
            if self._signal._handlerListHead == self then
                self._signal._handlerListHead = self._next
            else
                local Prev = self._signal._handlerListHead
                while Prev and Prev._next ~= self do
                    Prev = Prev._next
                end
                if Prev then
                    Prev._next = self._next
                end
            end
        end
        Connection.Destroy = Connection.Disconnect
        setmetatable(Connection, {
            __index = function(_Tb, Key)
                error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(Key)), 2)
            end,
            __newindex = function(_Tb, Key, _Value)
                error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(Key)), 2)
            end,
        })
        local Signal = {}
        Signal.__index = Signal
        function Signal.new()
            local Self = setmetatable({
                _handlerListHead = false,
                _proxyHandler = nil,
            }, Signal)
            return Self
        end
        function Signal.Wrap(RbxScriptSignal)
            assert(typeof(RbxScriptSignal) == "RBXScriptSignal", "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(RbxScriptSignal))
            local Signal = Signal.new()
            Signal._proxyHandler = RbxScriptSignal:Connect(function(...)
                Signal:Fire(...)
            end)
            return Signal
        end
        function Signal.Is(Obj)
            return type(Obj) == "table" and getmetatable(Obj) == Signal
        end
        function Signal:Connect(Fn)
            local Connection = Connection.new(self, Fn)
            if self._handlerListHead then
                Connection._next = self._handlerListHead
                self._handlerListHead = Connection
            else
                self._handlerListHead = Connection
            end
            return Connection
        end
        function Signal:ConnectOnce(Fn)
            return self:Once(Fn)
        end
        function Signal:Once(Fn)
            local Connection
            local Done = false
            Connection = self:Connect(function(...)
                if Done then
                    return
                end
                Done = true
                Connection:Disconnect()
                Fn(...)
            end)
            return Connection
        end
        function Signal:GetConnections()
            local Items = {}
            local Item = self._handlerListHead
            while Item do
                table.insert(Items, Item)
                Item = Item._next
            end
            return Items
        end
        function Signal:DisconnectAll()
            local Item = self._handlerListHead
            while Item do
                Item.Connected = false
                Item = Item._next
            end
            self._handlerListHead = false
        end
        function Signal:Fire(...)
            local Item = self._handlerListHead
            while Item do
                if Item.Connected then
                    if not FreeRunnerThread then
                        FreeRunnerThread = coroutine.create(RunEventHandlerInFreeThread)
                    end
                    task.spawn(FreeRunnerThread, Item._fn, ...)
                end
                Item = Item._next
            end
        end
        function Signal:FireDeferred(...)
            local Item = self._handlerListHead
            while Item do
                task.defer(Item._fn, ...)
                Item = Item._next
            end
        end
        function Signal:Wait()
            local WaitingCoroutine = coroutine.running()
            local Connection
            local Done = false
            Connection = self:Connect(function(...)
                if Done then
                    return
                end
                Done = true
                Connection:Disconnect()
                task.spawn(WaitingCoroutine, ...)
            end)
            return coroutine.yield()
        end
        function Signal:Destroy()
            self:DisconnectAll()
            local ProxyHandler = rawget(self, "_proxyHandler")
            if ProxyHandler then
                ProxyHandler:Disconnect()
            end
        end
        setmetatable(Signal, {
            __index = function(_Tb, Key)
                error(("Attempt to get Signal::%s (not a valid member)"):format(tostring(Key)), 2)
            end,
            __newindex = function(_Tb, Key, _Value)
                error(("Attempt to set Signal::%s (not a valid member)"):format(tostring(Key)), 2)
            end,
        })
        return {
            new = Signal.new,
            Wrap = Signal.Wrap,
            Is = Signal.Is,
        }
    end)()

    Trove = (function()
        local FnMarker = newproxy()
        local ThreadMarker = newproxy()
        local RunService = game:GetService("RunService")
        local function GetObjectCleanupFunction(Object, CleanupMethod)
            local T = typeof(Object)
            if T == "function" then
                return FnMarker
            elseif T == "thread" then
                return ThreadMarker
            end
            if CleanupMethod then
                return CleanupMethod
            end
            if T == "Instance" then
                return "Destroy"
            elseif T == "RBXScriptConnection" then
                return "Disconnect"
            elseif T == "table" then
                if typeof(Object.Destroy) == "function" then
                    return "Destroy"
                elseif typeof(Object.Disconnect) == "function" then
                    return "Disconnect"
                end
            end
            error("Failed to get cleanup function for object " .. T .. ": " .. tostring(Object), 3)
        end
        local function AssertPromiseLike(Object)
            if typeof(Object) ~= "table" or typeof(Object.getStatus) ~= "function" or typeof(Object.finally) ~= "function" or typeof(Object.cancel) ~= "function" then
                error("Did not receive a Promise as an argument", 3)
            end
        end
        local Trove = {}
        Trove.__index = Trove
        function Trove.new()
            local Self = setmetatable({}, Trove)
            Self._objects = {}
            Self._cleaning = false
            return Self
        end
        function Trove:Extend()
            if self._cleaning then
                error("Cannot call trove:Extend() while cleaning", 2)
            end
            return self:Construct(Trove)
        end
        function Trove:Clone(Instance)
            if self._cleaning then
                error("Cannot call trove:Clone() while cleaning", 2)
            end
            return self:Add(Instance:Clone())
        end
        function Trove:Construct(Class, ...)
            if self._cleaning then
                error("Cannot call trove:Construct() while cleaning", 2)
            end
            local Object = nil
            local T = type(Class)
            if T == "table" then
                Object = Class.new(...)
            elseif T == "function" then
                Object = Class(...)
            end
            return self:Add(Object)
        end
        function Trove:Connect(Signal, Fn)
            if self._cleaning then
                error("Cannot call trove:Connect() while cleaning", 2)
            end
            return self:Add(Signal:Connect(Fn))
        end
        function Trove:BindToRenderStep(Name, Priority, Fn)
            if self._cleaning then
                error("Cannot call trove:BindToRenderStep() while cleaning", 2)
            end
            RunService:BindToRenderStep(Name, Priority, Fn)
            self:Add(function()
                RunService:UnbindFromRenderStep(Name)
            end)
        end
        function Trove:AddPromise(Promise)
            if self._cleaning then
                error("Cannot call trove:AddPromise() while cleaning", 2)
            end
            AssertPromiseLike(Promise)
            if Promise:getStatus() == "Started" then
                Promise:finally(function()
                    if self._cleaning then
                        return
                    end
                    self:_findAndRemoveFromObjects(Promise, false)
                end)
                self:Add(Promise, "cancel")
            end
            return Promise
        end
        function Trove:Add(Object, CleanupMethod)
            if self._cleaning then
                error("Cannot call trove:Add() while cleaning", 2)
            end
            local Cleanup = GetObjectCleanupFunction(Object, CleanupMethod)
            table.insert(self._objects, { Object, Cleanup })
            return Object
        end
        function Trove:Remove(Object)
            if self._cleaning then
                error("Cannot call trove:Remove() while cleaning", 2)
            end
            return self:_findAndRemoveFromObjects(Object, true)
        end
        function Trove:Clean()
            if self._cleaning then
                return
            end
            self._cleaning = true
            for _, Obj in self._objects do
                self:_cleanupObject(Obj[1], Obj[2])
            end
            table.clear(self._objects)
            self._cleaning = false
        end
        function Trove:_findAndRemoveFromObjects(Object, Cleanup)
            local Objects = self._objects
            for I, Obj in ipairs(Objects) do
                if Obj[1] == Object then
                    local N = #Objects
                    Objects[I] = Objects[N]
                    Objects[N] = nil
                    if Cleanup then
                        self:_cleanupObject(Obj[1], Obj[2])
                    end
                    return true
                end
            end
            return false
        end
        function Trove:_cleanupObject(Object, CleanupMethod)
            if CleanupMethod == FnMarker then
                Object()
            elseif CleanupMethod == ThreadMarker then
                pcall(task.cancel, Object)
            else
                Object[CleanupMethod](Object)
            end
        end
        function Trove:AttachToInstance(Instance)
            if self._cleaning then
                error("Cannot call trove:AttachToInstance() while cleaning", 2)
            elseif not Instance:IsDescendantOf(game) then
                error("Instance is not a descendant of the game hierarchy", 2)
            end
            return self:Connect(Instance.Destroying, function()
                self:Destroy()
            end)
        end
        function Trove:Destroy()
            self:Clean()
        end
        return Trove
    end)()

    TablesLibrary = (function()
        local TablesLibrary = {}
        TablesLibrary.DeepCopy = function(Object)
            local NewObject = {}
            for Index, Value in Object do
                if typeof(Value) == "table" then
                    NewObject[Index] = TablesLibrary.DeepCopy(Value)
                    continue
                end
                NewObject[Index] = Value
            end
            return setmetatable(NewObject, getmetatable(Object))
        end
        TablesLibrary.DeepCopyPaste = function(Overwriter, Target)
            for Index, Value in Overwriter do
                if typeof(Value) == "table" then
                    TablesLibrary.DeepCopyPaste(Value, Target[Index])
                else
                    Target[Index] = Value
                end
            end
            setmetatable(Target, getmetatable(Overwriter))
        end
        function TablesLibrary.LockKeyInTable(Tbl, KeyToLock)
            local Mt = getmetatable(Tbl) or {}
            local OriginalIndex = Mt.__index
            Mt.__index = function(T, Key)
                if Key == KeyToLock then
                    error(`Attempt to read locked key: {Key}`)
                elseif type(OriginalIndex) == "function" then
                    return OriginalIndex(T, Key)
                elseif type(OriginalIndex) == "table" then
                    return OriginalIndex[Key]
                end
            end
            Mt.__newindex = function(T, Key, Value)
                if Key == KeyToLock then
                    error(`Attempt to modify locked key: {Key}`)
                else
                    rawset(T, Key, Value)
                end
            end
            setmetatable(Tbl, Mt)
        end
        TablesLibrary.RemoveMetatable = function(Target)
            setmetatable(Target, nil)
        end
        return TablesLibrary
    end)()

    Transition = (function()
        local Transition = {}
        Transition.__index = Transition
        Transition.Type = "Transition"
        Transition.Name = ""
        Transition.TargetState = ""
        Transition.Data = {}
        Transition._transitions = {}
        Transition._changeState = nil
        Transition._changeData = nil
        Transition._getState = nil
        Transition._getPreviousState = nil
        function Transition.new(TargetState)
            local Self = setmetatable({}, Transition)
            Self.TargetState = TargetState or ""
            return Self
        end
        function Transition:Extend(TargetState)
            return MergeTables(Transition.new(TargetState), self)
        end
        function Transition:OnInit(_Data)
        end
        function Transition:OnEnter(_Data)
        end
        function Transition:OnLeave(_Data)
        end
        function Transition:CanChangeState(Data)
            assert(Data, "")
            return true
        end
        function Transition:ChangeState(NewState)
            if not self._changeState then
                return
            end
            self._changeState(NewState)
        end
        function Transition:OnDataChanged(Data)
            assert(Data, "")
            return false
        end
        function Transition:GetState()
            if not self._getState then
                return ""
            end
            return self._getState()
        end
        function Transition:GetPreviousState()
            if not self._getPreviousState then
                return ""
            end
            return self._getPreviousState()
        end
        function Transition:ChangeData(Index, NewValue)
            if not self._changeData then
                return
            end
            self._changeData(Index, NewValue)
        end
        function Transition:OnDestroy()
        end
        return setmetatable(Transition, {
            __call = function(_, Properties)
                return Transition.new(Properties)
            end,
        })
    end)()

    State = (function()
        local State = {}
        State.__index = State
        State.Type = "State"
        State.Name = ""
        State.Transitions = {}
        State.Data = {}
        State._transitions = {}
        State._changeState = nil
        State._changeData = nil
        State._getState = nil
        State._getPreviousState = nil
        function State.new(StateName)
            local Self = setmetatable({}, State)
            Self.Name = StateName or ""
            Self.Transitions = {}
            return Self
        end
        function State:Extend(StateName)
            return MergeTables(State.new(StateName), self)
        end
        function State:ChangeState(NewState)
            if not self._changeState then
                return
            end
            self._changeState(NewState)
        end
        function State:GetState()
            if not self._getState then
                return ""
            end
            return self._getState()
        end
        function State:GetPreviousState()
            if not self._getPreviousState then
                return ""
            end
            return self._getPreviousState()
        end
        function State:ChangeData(Index, NewValue)
            if not self._changeData then
                return
            end
            self._changeData(Index, NewValue)
        end
        function State:OnInit(_Data)
        end
        function State:CanChangeState(_TargetState)
            return true
        end
        function State:OnDataChanged(_Data, _Index, _Value, _OldValue)
        end
        function State:OnEnter(_Data)
        end
        function State:OnHeartbeat(_Data, _DeltaTime)
        end
        function State:OnLeave(_Data)
        end
        function State:OnDestroy()
        end
        return setmetatable(State, {
            __call = function(_, Properties)
                return State.new(Properties)
            end,
        })
    end)()

    StateMachine = (function()
        local HttpService = game:GetService("HttpService")
        local RunService = game:GetService("RunService")
        local DuplicateError = "There cannot be more than 1 state by the same name"
        local DataWarning = "[Warning]: The data of this state machine is not a table. It will be converted to a table. Please do not set data to a non table object"
        local StateNotFound = "Attempt to %s, but there is no state by the name of %s"
        local WrongTransition = "Attempt to add a transition that is not a transition"
        local CacheDirectories = {}
        local StateMachine = {}
        StateMachine.__index = StateMachine
        StateMachine.Data = {}
        StateMachine.StateChanged = nil
        StateMachine.DataChanged = nil
        StateMachine.State = State
        StateMachine.Transition = Transition
        StateMachine._States = {}
        StateMachine._trove = newproxy()
        StateMachine._stateTrove = newproxy()
        StateMachine._CurrentState = ""
        StateMachine._PreviousState = ""
        StateMachine._Destroyed = false
        function StateMachine.new(InitialState, States, InitialData)
            local Self = setmetatable({}, StateMachine)
            Self._States = {}
            Self._trove = Trove.new()
            Self._stateTrove = Trove.new()
            Self._Destroyed = false
            Self.Data = InitialData or {}
            Self.StateChanged = Signal.new()
            Self.DataChanged = Signal.new()
            for _, State in States do
                if Self._States[State.Name] then
                    error(DuplicateError .. " \"" .. State.Name .. "\"", 2)
                end
                local StateClone = DeepCopy(State)
                StateClone.Data = Self.Data
                StateClone._changeState = function(NewState)
                    Self:ChangeState(NewState)
                end
                StateClone._changeData = function(Index, NewValue)
                    Self:ChangeData(Index, NewValue)
                end
                StateClone._getState = function()
                    return Self:GetCurrentState()
                end
                StateClone._getPreviousState = function()
                    return Self:GetPreviousState()
                end
                StateClone._transitions = {}
                for _, Transition in StateClone.Transitions do
                    if #Transition.Name == 0 then
                        Transition.Name = HttpService:GenerateGUID(false)
                    end
                    local TransitionClone = DeepCopy(Transition)
                    TransitionClone._changeData = function(Index, NewValue)
                        Self:ChangeData(Index, NewValue)
                    end
                    TransitionClone._getState = function()
                        return Self:GetCurrentState()
                    end
                    TransitionClone._getPreviousState = function()
                        return Self:GetPreviousState()
                    end
                    if TransitionClone.Type ~= Transition.Type then
                        error(WrongTransition, 2)
                    end
                    TransitionClone.Data = StateClone.Data
                    TransitionClone._changeState = function(NewState)
                        Self:ChangeState(NewState)
                    end
                    StateClone._transitions[TransitionClone.Name] = TransitionClone
                    task.spawn(TransitionClone.OnInit, TransitionClone, Self.Data)
                    Self._trove:Add(TransitionClone, "OnDestroy")
                end
                Self._States[State.Name] = StateClone
                task.spawn(StateClone.OnInit, StateClone, Self.Data)
                Self._trove:Add(StateClone, "OnDestroy")
            end
            if not Self._States[InitialState] then
                error(StateNotFound:format("create a state machine", InitialState), 2)
            end
            local PreviousState = nil
            Self._trove:Add(RunService.Heartbeat:Connect(function(DeltaTime)
                if Self._Destroyed then
                    return
                end
                Self:_CheckTransitions()
                local State = Self:_GetCurrentStateObject()
                local FirstFrame = State ~= PreviousState
                PreviousState = State
                if FirstFrame then
                    return
                end
                if not State or getmetatable(State).OnHeartbeat == State.OnHeartbeat then
                    return
                end
                task.spawn(State.OnHeartbeat, State, Self:GetData(), DeltaTime)
            end))
            Self._trove:Add(Self.StateChanged)
            Self._trove:Add(Self.DataChanged)
            Self:_ChangeState(InitialState)
            return Self
        end
        function StateMachine:GetCurrentState()
            return self._CurrentState
        end
        function StateMachine:GetPreviousState()
            return self._PreviousState
        end
        function StateMachine:ChangeData(Index, NewValue)
            if self._Destroyed or self.Data[Index] == NewValue then
                return
            end
            local OldValue = self.Data[Index]
            self.Data[Index] = NewValue
            local State = self._States[self:GetCurrentState()]
            task.spawn(State.OnDataChanged, State, self.Data, Index, NewValue, OldValue)
            self.DataChanged:Fire(self.Data, Index, NewValue, OldValue)
        end
        function StateMachine:GetData()
            if typeof(self.Data) ~= "table" then
                warn(DataWarning)
                self.Data = {}
            end
            return self.Data
        end
        function StateMachine:LoadDirectory(Directory, Names)
            if not CacheDirectories[Directory] then
                CacheDirectories[Directory] = {}
                for _, Child in Directory:GetDescendants() do
                    if not Child:IsA("ModuleScript") then
                        continue
                    end
                    local Success, Result = pcall(function()
                        return require(Child)
                    end)
                    if not Success or typeof(Result) ~= "table" then
                        continue
                    end
                    if Result.Type ~= State.Type and Result.Type ~= Transition.Type then
                        continue
                    end
                    if not Result.Name or Result.Name == "" then
                        Result.Name = Child.Name
                    end
                    table.insert(CacheDirectories[Directory], Result)
                end
            end
            if not Names then
                return CacheDirectories[Directory]
            end
            local FilteredFiles = {}
            for _, File in CacheDirectories[Directory] do
                if table.find(Names, File.Name) then
                    table.insert(FilteredFiles, File)
                end
            end
            return FilteredFiles
        end
        function StateMachine:Destroy()
            if self._Destroyed then
                return
            end
            self._Destroyed = true
            local State = self:_GetCurrentStateObject()
            if State then
                task.spawn(State.OnLeave, State, self:GetData())
            end
            self._trove:Destroy()
            self._stateTrove:Destroy()
        end
        function StateMachine:ChangeState(NewState)
            local CurrentState = self:_GetCurrentStateObject()
            if CurrentState and not CurrentState:CanChangeState(NewState) then
                return
            end
            self:_ChangeState(NewState)
        end
        function StateMachine:_StateExists(StateName)
            return self._States[StateName] ~= nil
        end
        function StateMachine:_ChangeState(NewState)
            if self._Destroyed then
                return
            end
            assert(self:_StateExists(NewState), StateNotFound:format(`change to {NewState}`, NewState))
            if self._CurrentState == NewState then
                return
            end
            local PreviousState = self:_GetCurrentStateObject()
            local State = self._States[NewState]
            if not State then
                return
            end
            self._stateTrove:Clean()
            if PreviousState then
                task.spawn(PreviousState.OnLeave, PreviousState, self:GetData())
                self:_CallTransitions(PreviousState, "OnLeave", self:GetData())
            end
            task.defer(function()
                self:_CallTransitions(State, "OnEnter", self:GetData())
            end)
            self._stateTrove:Add(task.defer(State.OnEnter, State, self:GetData()))
            self._CurrentState = NewState
            if PreviousState then
                self._PreviousState = PreviousState.Name
                self.StateChanged:Fire(NewState, PreviousState.Name or "")
            end
        end
        function StateMachine:_GetCurrentStateObject()
            return self._States[self:GetCurrentState()]
        end
        function StateMachine:_CheckTransitions()
            for _, Transition in self:_GetCurrentStateObject()._transitions do
                if Transition:CanChangeState(self:GetData()) and Transition:OnDataChanged(self:GetData()) then
                    self:ChangeState(Transition.TargetState)
                    break
                end
            end
        end
        function StateMachine:_CallTransitions(State, MethodName, ...)
            for _, Transition in State._transitions do
                task.spawn(Transition[MethodName], Transition, ...)
            end
        end
        return setmetatable(StateMachine, {
            __call = function(_, InitialState, States, InitialData)
                return StateMachine.new(InitialState, States, InitialData)
            end,
        })
    end)()

    TRequestPriority = (function()
        local API = {}
        API.ConvertNumberToPriority = function(Number)
            if Number <= 0 then
                return "Low"
            elseif Number == 1 then
                return "Normal"
            elseif Number == 2 then
                return "High"
            elseif Number >= 3 then
                return "Critical"
            else
                error("Invalid number for RequestPriority: " .. tostring(Number))
            end
        end
        API.ConvertPriorityToNumber = function(Priority)
            if Priority == "Low" then
                return 0
            elseif Priority == "DefaultStart" then
                return 1
            elseif Priority == "Normal" then
                return 1
            elseif Priority == "DefaultStop" then
                return 2
            elseif Priority == "High" then
                return 2
            elseif Priority == "Critical" then
                return 3
            else
                error("Invalid RequestPriority: " .. tostring(Priority))
            end
        end
        API.GetPriorityNumber = function(Priority)
            if typeof(Priority) == "number" then
                return Priority
            end
            return API.ConvertPriorityToNumber(Priority)
        end
        return API
    end)()

    TConfig = (function()
        return {}
    end)()

    AIT = (function()
        return {
            RequestPriority = TRequestPriority,
        }
    end)()

    Storage = (function()
        local API = {}
        local FbdnWorkspaceTemp = nil
        API.GetForbiddenTemporaryWorkspaceFolder = function()
            if FbdnWorkspaceTemp ~= nil then
                return FbdnWorkspaceTemp
            end
            FbdnWorkspaceTemp = Instance.new("Folder")
            FbdnWorkspaceTemp.Name = "ForbiddenTemporaryFolder"
            FbdnWorkspaceTemp.Parent = workspace
            return FbdnWorkspaceTemp
        end
        local FbdnWorkspaceWsTemp = nil
        API.GetForbiddenWSPartsFolder = function()
            if FbdnWorkspaceWsTemp ~= nil then
                return FbdnWorkspaceWsTemp
            end
            local ForbiddenTempPartFolder = Instance.new("Folder")
            ForbiddenTempPartFolder.Name = "Common-Parts"
            ForbiddenTempPartFolder.Parent = API.GetForbiddenTemporaryWorkspaceFolder()
            return FbdnWorkspaceWsTemp
        end
        local FbdnWorkspaceStorageTemp = nil
        API.GetForbiddenStorageFolder = function()
            if FbdnWorkspaceStorageTemp ~= nil then
                return FbdnWorkspaceStorageTemp
            end
            FbdnWorkspaceStorageTemp = Instance.new("Folder")
            FbdnWorkspaceStorageTemp.Name = "ForbiddenStorageFolder"
            FbdnWorkspaceStorageTemp.Parent = workspace
            return FbdnWorkspaceStorageTemp
        end
        return API
    end)()

    TypeHelp = (function()
        local Debris = game:GetService("Debris")
        local UpdateList = {}
        local API = {}
        local Nameseq = 0
        local function GetNumberedName()
            Nameseq += 1
            return "AUTO-NAMED " .. tostring(Nameseq)
        end
        local function _MakePart(V3, DoUpdateObject)
            local Part = nil
            if DoUpdateObject then
                Part = UpdateList[DoUpdateObject]
            end
            if Part == nil then
                Part = Instance.new("Part")
                Part.Transparency = 1
                Part.CanCollide = false
                Part.Anchored = true
                Part.CastShadow = true
                Part.Material = Enum.Material.Neon
                Part.Color = Color3.fromHex("#FFFF00")
                Part.Size = Vector3.new(1, 1, 1)
                Part.Name = GetNumberedName()
                Part.Parent = Storage.GetForbiddenWSPartsFolder()
                if DoUpdateObject then
                    UpdateList[DoUpdateObject] = Part
                end
            end
            Part.Position = V3
            return Part
        end
        local function GetBasePartFromModel(Model)
            if Model:FindFirstChildOfClass("Humanoid") then
                local PartToReturn = Model:FindFirstChild("HumanoidRootPart")
                if PartToReturn ~= nil then
                    return PartToReturn
                end
                PartToReturn = Model:FindFirstChild("Torso")
                if PartToReturn ~= nil then
                    return PartToReturn
                end
            end
            if Model.PrimaryPart then
                return Model.PrimaryPart
            end
            local Ffoc = Model:FindFirstChildOfClass("BasePart")
            if Ffoc then
                return Ffoc
            end
            return nil
        end
        API.GetBasePart = function(Object, MakePart, DoUpdateOwner)
            local ObjectType = typeof(Object)
            if ObjectType == "Instance" then
                if Object:IsA("BasePart") then
                    return Object
                end
                if Object:IsA("Model") then
                    return GetBasePartFromModel(Object)
                end
                if Object:IsA("Player") then
                    local Character = Object.Character
                    if Character then
                        return GetBasePartFromModel(Character)
                    end
                end
            end
            if ObjectType == "CFrame" then
                if MakePart then
                    return _MakePart(Object.Position, DoUpdateOwner)
                end
            end
            if ObjectType == "Vector3" then
                if MakePart then
                    return _MakePart(Object, DoUpdateOwner)
                end
            end
            return nil
        end
        API.GetDistanceFromNPCToTarget = function(NPC, Target)
            local NPCActual = API.GetBasePart(NPC)
            local TargetActual = API.GetBasePart(Target, true, NPC)
            if NPCActual == nil then
                error("NPC Actual nil")
            end
            if TargetActual == nil then
                error("Target Actual nil")
            end
            local Dist = (NPCActual.CFrame.Position - TargetActual.CFrame.Position).Magnitude
            return Dist
        end
        API.TriggerCleanup = function(NPC)
            if not UpdateList[NPC] then
                return
            end
            Debris:AddItem(UpdateList[NPC], 0)
            UpdateList[NPC] = nil
        end
        return API
    end)()

    Common = (function()
        return {
            GetForbiddenStorageFolder = Storage.GetForbiddenStorageFolder,
            GetForbiddenTemporaryWorkspaceFolder = Storage.GetForbiddenTemporaryWorkspaceFolder,
            GetForbiddenWSPartsFolder = Storage.GetForbiddenWSPartsFolder,
            GetBasePart = TypeHelp.GetBasePart,
            GetDistanceFromNPCToTarget = TypeHelp.GetDistanceFromNPCToTarget,
            TriggerCleanupTypeHelp = TypeHelp.TriggerCleanup,
        }
    end)()

    Defaults = (function()
        local Defaults = {}
        local function Nullbind()
        end
        Defaults.StopType = "CurrentPosition"
        Defaults.Unstucking = {}
        Defaults.Unstucking.Enabled = true
        Defaults.Unstucking.FireStuckHook = true
        Defaults.Unstucking.MaxStuckCount = 2
        Defaults.RequestPrioritization = {}
        Defaults.RequestPrioritization.PreferTimeOverPriority = {}
        Defaults.RequestPrioritization.PreferTimeOverPriority.Enabled = true
        Defaults.RequestPrioritization.PreferTimeOverPriority.ResetOlderRequests = true
        Defaults.AgentInfo = {}
        Defaults.AgentInfo.AgentRadius = 2.5
        Defaults.AgentInfo.AgentHeight = 5
        Defaults.AgentInfo.AgentCanJump = true
        Defaults.AgentInfo.AgentCanClimb = false
        Defaults.AgentInfo.WaypointSpacing = 4
        Defaults.AgentInfo.Cost = { Obstacle = math.huge }
        Defaults.Visualization = {}
        Defaults.Visualization.Enabled = false
        Defaults.Visualization.Path = true
        Defaults.Visualization.PathColor = Color3.fromRGB(98, 87, 255)
        Defaults.Visualization.Celling = false
        Defaults.Visualization.CellingColor = Color3.fromRGB(0, 255, 0)
        Defaults.Visualization.MovetoRaycast = false
        Defaults.Visualization.MovetoRaycastColor = Color3.fromRGB(0, 0, 255)
        Defaults.Visualization.Tether = false
        Defaults.Visualization.TetherColor = Color3.fromRGB(255, 255, 0)
        Defaults.Tracking = {}
        Defaults.Tracking.Enabled = false
        Defaults.Tracking.CollinearTargetPositionOffset = 0.25
        Defaults.Tracking.PredictionMagnitude = 2
        Defaults.Tracking.DistanceMovedThreshold = 1
        Defaults.WaypointSkipping = {}
        Defaults.WaypointSkipping.RegularPathfindSkip = 2
        Defaults.WaypointSkipping.TrackingPathfindSkip = 3
        Defaults.Tracking.DynamicRetrack = {}
        Defaults.Tracking.DynamicRetrack.MoveTo = {}
        Defaults.Tracking.DynamicRetrack.MoveTo.MinTimer = 0
        Defaults.Tracking.DynamicRetrack.MoveTo.MaxTimer = 1
        Defaults.Tracking.DynamicRetrack.MoveTo.GetRetrackTimeFunction = function(NPC, Target)
            local Timer = math.max(Common.GetDistanceFromNPCToTarget(NPC, Target) - 20, 0) / 40
            return Timer
        end
        Defaults.Tracking.DynamicRetrack.MoveTo.ShouldRetrackFunction = function(NPC, Target)
            return true
        end
        Defaults.Tracking.DynamicRetrack.Pathfind = {}
        Defaults.Tracking.DynamicRetrack.Pathfind.MinTimer = 0.5
        Defaults.Tracking.DynamicRetrack.Pathfind.MaxTimer = 3
        Defaults.Tracking.DynamicRetrack.Pathfind.GetRetrackTimeFunction = function(NPC, Target)
            local Timer = Common.GetDistanceFromNPCToTarget(NPC, Target) / 80
            return Timer
        end
        Defaults.Tracking.DynamicRetrack.Pathfind.ShouldRetrackFunction = function(NPC, Target)
            return true
        end
        Defaults.DirectMoveTo = {}
        Defaults.DirectMoveTo.Enabled = true
        Defaults.DirectMoveTo.ActivationDistance = 60
        Defaults.DirectMoveTo.HeightLimit = 10
        Defaults.DirectMoveTo.TrackingOnly = true
        Defaults.DirectMoveTo.AvoidUseHook = Nullbind
        Defaults.DirectMoveTo.Raycast = {}
        Defaults.DirectMoveTo.Raycast.Enabled = true
        Defaults.DirectMoveTo.Raycast.Range = Defaults.DirectMoveTo.ActivationDistance + 10
        Defaults.DirectMoveTo.Raycast.SeeThroughTransparentParts = false
        Defaults.DirectMoveTo.Raycast.SeeThroughNonCollidable = true
        Defaults.DirectMoveTo.Raycast.MinimumTransparency = 0.001
        Defaults.DirectMoveTo.Raycast.FilterAttempts = 10
        Defaults.DirectMoveTo.Raycast.OffsetFromOrigin = Vector3.new(0, 0, 0)
        Defaults.DirectMoveTo.Raycast.OffsetFromTarget = Vector3.new(0, 0, 0)
        Defaults.DirectMoveTo.Raycast.FilterFunction = function(Hit)
            return false
        end
        Defaults.DirectMoveTo.JumpHandler = {}
        Defaults.DirectMoveTo.JumpHandler.Enabled = true
        Defaults.DirectMoveTo.JumpHandler.MinConditionReachedTime = 0.25
        Defaults.DirectMoveTo.JumpHandler.NextJumpMinTime = 1
        Defaults.DirectMoveTo.JumpHandler.DistanceFromMoveToPoint = 2
        Defaults.DirectMoveTo.JumpHandler.CustomJumpFunction = nil
        Defaults.DirectMoveTo.CheckFloor = {}
        Defaults.DirectMoveTo.CheckFloor.Enabled = true
        Defaults.DirectMoveTo.CheckFloor.FailHeight = 12
        Defaults.DirectMoveTo.CheckFloor.RaycastSpacing = 5
        Defaults.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance = 2
        Defaults.DirectMoveTo.CheckFloor.CheckFrequencyTimer = 1
        Defaults.DirectMoveTo.CheckFloor.BlockDirectMoveToTimer = 3
        Defaults.DirectMoveTo.CheckFloor.DisableIfDistanceIsLessThan = Defaults.AgentInfo.AgentRadius * 3
        Defaults.Hooks = {}
        Defaults.Hooks.PathfindingLinkReached = function(NPC, Waypoint)
            local NPCActual = Common.GetBasePart(NPC)
            if NPCActual then
                NPCActual.CFrame = CFrame.new(Waypoint.Position)
            end
            return true
        end
        Defaults.Hooks.MovingToWaypoint = Nullbind
        Defaults.Hooks.Stuck = function(NPC, Target)
            local NPCHuman = NPC:FindFirstChildOfClass("Humanoid")
            if NPCHuman == nil then
                return false
            end
            if NPCHuman.Health == 0 then
                return false
            end
            local NPCActual = Common.GetBasePart(NPC)
            if NPCActual == nil then
                return false
            end
            local NPCPos = NPCActual.CFrame.Position
            local RandDir = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
            if RandDir.X ~= RandDir.X then
                return false
            end
            NPCHuman:MoveTo(NPCPos + RandDir * 10)
            NPCHuman.Jump = true
            task.wait(1)
            return true
        end
        Defaults.Hooks.GoalReached = Nullbind
        Defaults.Hooks.StartAcknowledged = Nullbind
        Defaults.Hooks.StopAcknowledged = Nullbind
        Defaults.Hooks.PathingFailed = Nullbind
        Defaults.Hooks.PathingStarted = Nullbind
        Defaults.Debugging = {}
        Defaults.Debugging.Enabled = false
        Defaults.Debugging.OutputToConsole = true
        Defaults.Debugging.StateTransitioning = true
        Defaults.Debugging.MovingToWaypoint = false
        Defaults.Debugging.Verbosity = 3
        return Defaults
    end)()

    ConfigHandler = (function()
        local ConfigHandler = {}
        local ActiveConfigInstances = {}
        local LocalConfigInstances = {}
        local GlobalPresets = {}
        local LocalPresets = {}
        local function RemoveMetatable(Tbl)
            TablesLibrary.RemoveMetatable(Tbl)
        end
        local function AddMetatable(Tbl)
            TablesLibrary.LockKeyInTable(Tbl, "NPC")
        end
        local CreateConfig = nil
        local function InitializeConfig(NPC)
            if LocalConfigInstances[NPC] then
                return
            end
            local Config = CreateConfig(NPC)
            LocalConfigInstances[NPC] = Config
            ActiveConfigInstances[NPC] = TablesLibrary.DeepCopy(Config)
            LocalPresets[NPC] = {}
        end
        local function CreateCleanConfig(Tbl)
            local NewCfg = TablesLibrary.DeepCopy(Tbl)
            RemoveMetatable(NewCfg)
            NewCfg.NPC = nil
            return NewCfg
        end
        function RestoreDefaults(Self)
            local Npc = Self.NPC
            RemoveMetatable(Self)
            TablesLibrary.DeepCopyPaste(Defaults, Self)
            Self.NPC = Npc
            AddMetatable(Self)
        end
        function RestoreActiveConfig(Self)
            RemoveMetatable(LocalConfigInstances[Self.NPC])
            TablesLibrary.DeepCopyPaste(ActiveConfigInstances[Self.NPC], LocalConfigInstances[Self.NPC])
            AddMetatable(LocalConfigInstances[Self.NPC])
        end
        function SavePreset(Self, PresetName, SaveGlobally)
            if PresetName == "" or PresetName == nil then
                warn("Preset name cannot be nil or empty.")
                return
            end
            if SaveGlobally then
                ConfigHandler.SaveGlobalPreset(PresetName, Self)
                return
            end
            local Preset = CreateCleanConfig(Self)
            if not SaveGlobally then
                LocalPresets[Self.NPC][PresetName] = Preset
            end
        end
        function LoadPreset(Self, PresetName, UseGlobalIfBothFound)
            if PresetName == nil or PresetName == "" then
                warn("Preset name cannot be nil or empty.")
                return
            end
            local LocalPreset = LocalPresets[Self.NPC][PresetName]
            local GlobalPreset = GlobalPresets[PresetName]
            local PresetToUse = LocalPreset
            if UseGlobalIfBothFound and GlobalPreset then
                PresetToUse = GlobalPreset
            end
            if not LocalPreset then
                PresetToUse = GlobalPreset
            end
            if not PresetToUse then
                warn(`Preset '{PresetName}' does not exist locally or globally.`)
                return
            end
            local NewCfg = TablesLibrary.DeepCopy(PresetToUse)
            NewCfg.NPC = Self.NPC
            RemoveMetatable(LocalConfigInstances[Self.NPC])
            TablesLibrary.DeepCopyPaste(NewCfg, Self)
            AddMetatable(Self)
        end
        function ApplyNow(Self)
            if not Self.NPC then
                error("Cannot apply config to NPC, NPC field is nil.")
            end
            TablesLibrary.DeepCopyPaste(LocalConfigInstances[Self.NPC], ActiveConfigInstances[Self.NPC])
        end
        CreateConfig = function(NPC)
            local NewCfg = TablesLibrary.DeepCopy(Defaults)
            NewCfg.NPC = NPC
            function NewCfg:SavePreset(PresetName, SaveGlobally)
                SavePreset(self, PresetName, SaveGlobally)
            end
            function NewCfg:LoadPreset(PresetName, UseGlobalIfBothFound)
                LoadPreset(self, PresetName, UseGlobalIfBothFound)
            end
            function NewCfg:RestoreDefaults()
                RestoreDefaults(self)
            end
            function NewCfg:RestoreActiveConfig()
                RestoreActiveConfig(self)
            end
            function NewCfg:ApplyNow()
                ApplyNow(self)
            end
            AddMetatable(NewCfg)
            return NewCfg
        end
        ConfigHandler.SaveGlobalPreset = function(PresetName, Config)
            if PresetName == "" or PresetName == nil then
                warn("Preset name cannot be nil or empty.")
                return
            end
            local Preset = CreateCleanConfig(Config)
            GlobalPresets[PresetName] = Preset
        end
        ConfigHandler.GetConfig = function(NPC)
            if not LocalConfigInstances[NPC] then
                InitializeConfig(NPC)
            end
            return LocalConfigInstances[NPC]
        end
        ConfigHandler.GetActiveConfig = function(NPC)
            if not ActiveConfigInstances[NPC] then
                InitializeConfig(NPC)
            end
            return ActiveConfigInstances[NPC]
        end
        ConfigHandler.TriggerCleanup = function(NPC)
            ActiveConfigInstances[NPC] = nil
            LocalConfigInstances[NPC] = nil
            LocalPresets[NPC] = nil
        end
        return ConfigHandler
    end)()

    Debugging = (function()
        local API = {}
        local ConversionByType = {}
        ConversionByType.Instance = function(V)
            return V:GetFullName()
        end
        ConversionByType.CFrame = function(V)
            return tostring(V.Position)
        end
        local function Log(NPC, ...)
            local Ac = ConfigHandler.GetActiveConfig(NPC)
            if not Ac.Debugging.Enabled then
                return
            end
            local CallerName = debug.info(3, "s")
            local Inputtedinfo = { ... }
            local Msg = "[" .. CallerName .. "]: "
            for I, V in pairs(Inputtedinfo) do
                local ThisValMsg = "COULD NOT CONVERT VAL TYPE!"
                local ValType = typeof(V)
                local Temp = nil
                local CbtExists = ConversionByType[ValType]
                if CbtExists ~= nil then
                    Temp = CbtExists(V)
                end
                if Temp then
                    ThisValMsg = Temp
                end
                if not Temp then
                    ThisValMsg = tostring(V)
                end
                Msg = Msg .. ThisValMsg
            end
            print(Msg)
        end
        API.Log = function(NPC, ...)
            Log(NPC, ...)
        end
        API.LogWithVerbosity = function(NPC, Verbosity, ...)
            local Ac = ConfigHandler.GetActiveConfig(NPC)
            if not Ac.Debugging.Enabled then
                return
            end
            if Ac.Debugging.Verbosity < Verbosity then
                return
            end
            Log(NPC, ...)
        end
        API.TimeIt = function(Name, Callback)
            local StartTime = os.clock()
            local Success, Result = pcall(Callback)
            local EndTime = os.clock()
            local Elapsed = EndTime - StartTime
            if Success then
                print(string.format(Name .. " | Elapsed time: %.6f seconds", Elapsed))
            else
                warn(string.format(Name .. " | Callback failed after %.6f seconds: %s", Elapsed, Result))
            end
            return Elapsed, Success, Result
        end
        return API
    end)()

    MathVisualization = (function()
        local API = {}
        local InstanceTable = {}
        local ForbiddenVSTable = nil
        local function GetInstance(Origin)
            if ForbiddenVSTable == nil then
                ForbiddenVSTable = Instance.new("Folder")
                ForbiddenVSTable.Name = "ForbiddenMathVisualizerParts"
                ForbiddenVSTable.Parent = workspace
            end
            if InstanceTable[Origin] then
                return InstanceTable[Origin]
            end
            InstanceTable[Origin] = {}
            local NewTIntFolder = Instance.new("Folder")
            NewTIntFolder.Name = Origin.Name
            NewTIntFolder.Parent = ForbiddenVSTable
            local function MakeNewPart(Name)
                local NewPart = Instance.new("Part")
                NewPart.Size = Vector3.new(1, 1, 1)
                NewPart.Material = Enum.Material.Neon
                NewPart.CanCollide = false
                NewPart.CanQuery = false
                NewPart.CanTouch = false
                NewPart.Anchored = true
                NewPart.CastShadow = false
                NewPart.Transparency = 0.5
                return NewPart
            end
            local Op = MakeNewPart("originPart")
            Op.Shape = Enum.PartType.Ball
            Op.Parent = NewTIntFolder
            InstanceTable[Origin]["originPart"] = Op
            local Ep = MakeNewPart("endPart")
            Ep.Shape = Enum.PartType.Ball
            Ep.Parent = NewTIntFolder
            InstanceTable[Origin]["endPart"] = Ep
            local Cp = MakeNewPart("connectingPart")
            Cp.Parent = NewTIntFolder
            InstanceTable[Origin]["connectingPart"] = Cp
            return InstanceTable[Origin]
        end
        local function IsValidVector3(V)
            return V.X == V.X and V.Y == V.Y and V.Z == V.Z
        end
        API.VisualizeRaycast = function(ORIGIN_INT, Origin, Target, Success)
            local TInt = GetInstance(ORIGIN_INT)
            local OriginPart = TInt["originPart"]
            local EndPart = TInt["endPart"]
            local ConnectingPart = TInt["connectingPart"]
            if not (IsValidVector3(Origin) and IsValidVector3(Target)) then
                warn("Invalid Vector3 detected. Skipping visualization.")
                return
            end
            OriginPart.Position = Origin
            EndPart.Position = Target
            local NewPos = (Origin + Target) / 2
            if IsValidVector3(NewPos) then
                ConnectingPart.CFrame = CFrame.lookAt(NewPos, Target)
            end
            local function ChangeColor(Color)
                OriginPart.BrickColor = Color
                EndPart.BrickColor = Color
                ConnectingPart.BrickColor = Color
            end
            if Success then
                ChangeColor(BrickColor.Green())
            end
            if not Success then
                ChangeColor(BrickColor.Red())
            end
        end
        return API
    end)()

    Math = (function()
        local API = {}
        API.LineOfSight = function(Object1, Object2, RaycastSettings)
            if Object1 == nil then
                error("Object1 was nil!")
            end
            if Object2 == nil then
                error("Object2 was nil!")
            end
            RaycastSettings = RaycastSettings or {}
            RaycastSettings.OriginPart = RaycastSettings.OriginPart or nil
            RaycastSettings.Range = RaycastSettings.Range or 100
            RaycastSettings.SeeThroughTransparentParts = RaycastSettings.SeeThroughTransparentParts or false
            RaycastSettings.SeeThroughNonCollidable = RaycastSettings.SeeThroughNonCollidable or false
            RaycastSettings.MinimumTransparency = RaycastSettings.MinimumTransparency or 0.001
            RaycastSettings.FilterTable = RaycastSettings.FilterTable or { Object1 }
            RaycastSettings.FilterAttempts = RaycastSettings.FilterAttempts or 10
            RaycastSettings.OffsetFromOrigin = RaycastSettings.OffsetFromOrigin or Vector3.new(0, 0, 0)
            RaycastSettings.OffsetFromTarget = RaycastSettings.OffsetFromTarget or Vector3.new(0, 0, 0)
            RaycastSettings.OutputCollision = RaycastSettings.OutputCollision or false
            RaycastSettings.FilterFunction = RaycastSettings.FilterFunction or function()
                return false
            end
            local OriginMainBody = RaycastSettings.OriginPart
            if OriginMainBody == nil then
                OriginMainBody = Common.GetBasePart(Object1)
            end
            local TargetMainBody = Common.GetBasePart(Object2)
            local OriginFinalPosition = OriginMainBody.CFrame.Position + RaycastSettings.OffsetFromOrigin
            local TargetFinalPosition = TargetMainBody.CFrame.Position + RaycastSettings.OffsetFromTarget
            if (TargetFinalPosition - OriginFinalPosition).Magnitude > RaycastSettings.Range then
                if RaycastSettings.OutputCollision then
                    print("Out of range!")
                end
                return false
            end
            local Direction = (TargetFinalPosition - OriginFinalPosition).Unit
            local RaycastParams = RaycastParams.new()
            RaycastParams.FilterDescendantsInstances = TablesLibrary.DeepCopy(RaycastSettings.FilterTable)
            RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
            RaycastParams.CollisionGroup = OriginMainBody.CollisionGroup
            local function IsFiltered(Hit)
                if RaycastSettings.SeeThroughTransparentParts then
                    if Hit.Transparency >= RaycastSettings.MinimumTransparency then
                        return true
                    end
                end
                if RaycastSettings.SeeThroughNonCollidable then
                    if not Hit.CanCollide then
                        return true
                    end
                end
                if RaycastSettings.FilterFunction(Hit) then
                    return true
                end
                return false
            end
            local function IsDescendantOfTarget(Hit, Parent)
                local P = Hit
                local Limit = 5
                if Hit == Parent then
                    return true
                end
                for I = 1, Limit, 1 do
                    if P.Parent == nil then
                        return false
                    end
                    P = P.Parent
                    if P == Parent then
                        return true
                    end
                end
                return false
            end
            local function DoRaycast()
                return workspace:Raycast(OriginFinalPosition, Direction * RaycastSettings.Range, RaycastParams)
            end
            local ParentTarget = TargetMainBody
            if typeof(Object2) == "Instance" then
                if Object2:IsA("Model") or Object2:IsA("BasePart") then
                    ParentTarget = Object2
                end
                if Object2:IsA("Player") then
                    ParentTarget = Object2.Character
                end
            end
            for I = 1, RaycastSettings.FilterAttempts, 1 do
                local Result = DoRaycast()
                if Result == nil or Result.Instance == nil then
                    return false
                end
                if RaycastSettings.OutputCollision then
                    print(Result.Instance)
                end
                if not (Result.Instance:IsA("BasePart") or Result.Instance:IsA("Model")) then
                    return false
                end
                if IsDescendantOfTarget(Result.Instance, ParentTarget) then
                    return true
                end
                if IsFiltered(Result.Instance) then
                    RaycastParams:AddToFilter(Result.Instance)
                    continue
                end
                return false
            end
            return false
        end
        API.IsOnScreen = function(PartToCheck, DoRaycast)
            if PartToCheck == nil then
                error("[Forbidden.Math.InPlayerView] PartToCheck was nil!")
            end
            local LosCharacter = true
            local Player = game.Players.LocalPlayer
            local Camera = game.Workspace.CurrentCamera
            local Final = PartToCheck
            if PartToCheck:IsA("Model") then
                if PartToCheck.PrimaryPart ~= nil then
                    Final = PartToCheck.PrimaryPart
                end
            end
            local _Vector, InViewport = Camera:WorldToViewportPoint(Final.Position)
            if DoRaycast then
                local RaycastSettings = { Range = 100, SeeThroughTransparentParts = true, FilterTable = { Player.Character } }
                LosCharacter = API.LineOfSight(Player.Character, PartToCheck, RaycastSettings)
            end
            local IsVisible = InViewport and LosCharacter
            if IsVisible then
                return true
            end
            return false
        end
        API.IsInView = function(FromCharacter, TargetOther, DetectionFOV, DoRaycast, RaycastSets)
            if FromCharacter == nil then
                error("[Forbidden.Math.InPlayerView] FromCharacter was nil!")
            end
            if TargetOther == nil then
                error("[Forbidden.Math.InPlayerView] TargetOther was nil!")
            end
            if DetectionFOV == nil then
                DetectionFOV = 70
            end
            if DoRaycast == nil then
                DoRaycast = false
            end
            if DetectionFOV < 0 then
                DetectionFOV = 0
            end
            if DetectionFOV > 180 then
                DetectionFOV = 180
            end
            local FromActual = FromCharacter:FindFirstChild("HumanoidRootPart")
            local ActualOther = Common.GetBasePart(TargetOther)
            if FromActual == nil then
                error("[Forbidden.Math.InPlayerView] The NPC provided does not contain a HumanoidRootPart!")
            end
            if ActualOther == nil then
                error("[Forbidden.Math.InPlayerView] The Target provided does not contain a BasePart!")
            end
            if RaycastSets == nil then
                RaycastSets = {}
            end
            if RaycastSets.FilterTable == nil then
                RaycastSets.FilterTable = { FromCharacter }
            end
            if DoRaycast then
                if not API.LineOfSight(FromActual, TargetOther, RaycastSets) then
                    return false
                end
            end
            local Angle = math.acos(FromActual.CFrame.LookVector:Dot((ActualOther.CFrame.Position - FromActual.CFrame.Position).Unit))
            local IsInFOVAngle = Angle < DetectionFOV * (math.pi / 180)
            if not IsInFOVAngle then
                return false
            end
            return true
        end
        return API
    end)()

    PositionalOptimization = (function()
        local API = {}
        API.GetGroundedPosition = function(Position, PartsToFilter, HeightLimit)
            local RaycastParams = RaycastParams.new()
            local FilterTable = { PartsToFilter }
            RaycastParams.FilterDescendantsInstances = FilterTable
            RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
            RaycastParams.RespectCanCollide = true
            local Range = 3
            if HeightLimit then
                Range = HeightLimit
            end
            local Result = workspace:Raycast(Position, Vector3.new(0, -1, 0) * Range, RaycastParams)
            if Result == nil then
                return nil
            end
            if Result.Instance then
                return Result.Position + Vector3.new(0, 2, 0)
            end
            return Position
        end
        API.GetCollinearTargetPositionOffset = function(Origin, Target, Offset)
            local Delta = Target - Origin
            if Offset == 0 then
                return Origin
            end
            if Delta.Magnitude == 0 then
                return Origin
            end
            if Delta.Magnitude < Offset then
                return Target
            end
            return Origin + (Delta.Unit * Offset)
        end
        API.PredictMovement = function(TargetPart, PredictionMagnitude)
            local TargetPos = TargetPart.CFrame.Position
            if PredictionMagnitude <= 0 then
                return TargetPos
            end
            if TargetPart.AssemblyLinearVelocity.Magnitude < 0.1 then
                return TargetPos
            end
            local TRVeloCorrected = Vector3.new(TargetPart.AssemblyLinearVelocity.X, 0, TargetPart.AssemblyLinearVelocity.Z).Unit
            if TRVeloCorrected.X ~= TRVeloCorrected.X then
                return TargetPos
            end
            TargetPos = TargetPos + TRVeloCorrected * PredictionMagnitude
            return TargetPos
        end
        return API
    end)()

    CommonMathRequests = (function()
        local API = {}
        API.CanMoveToRaycast = function(NPC, Target)
            local Config = ConfigHandler.GetActiveConfig(NPC)
            if not Config.DirectMoveTo.Raycast.Enabled then
                return true
            end
            local RaycastSettings = Config.DirectMoveTo.Raycast
            return Math.LineOfSight(NPC, Target, RaycastSettings)
        end
        API.CanCrossFloorRaycast = function(NPC, Target)
            local Config = ConfigHandler.GetActiveConfig(NPC)
            local NpcMain = Common.GetBasePart(NPC, true, NPC)
            local TargetMain = Common.GetBasePart(Target, true, NPC)
            if NpcMain == nil then
                error("Cannot get BasePart in NPC: " .. NPC:GetFullName())
            end
            if TargetMain == nil then
                error("Cannot get BasePart in Target: " .. Target:GetFullName())
            end
            local Subv3 = (TargetMain.CFrame.Position - NpcMain.CFrame.Position)
            local Dist = Subv3.Magnitude
            local Dir = Subv3.Unit
            local function ValidRaycastToGround(Position)
                local RaycastParams = RaycastParams.new()
                local FilterTable = { NPC }
                if typeof(Target) == "Instance" then
                    RaycastParams:AddToFilter(Target)
                else
                    RaycastParams:AddToFilter(TargetMain)
                end
                RaycastParams.FilterDescendantsInstances = FilterTable
                RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                RaycastParams.RespectCanCollide = true
                local Result = workspace:Raycast(Position, Vector3.new(0, -1, 0) * Config.DirectMoveTo.CheckFloor.FailHeight, RaycastParams)
                return Result ~= nil
            end
            local function FirstRaycastValid()
                if Config.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance ~= 0 then
                    if Dist > Config.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance then
                        return true
                    end
                    return ValidRaycastToGround(NpcMain.CFrame.Position + Dir * Config.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance)
                end
                return true
            end
            if not FirstRaycastValid() then
                return false
            end
            local DistRemaining = Dist
            while DistRemaining - Config.DirectMoveTo.CheckFloor.RaycastSpacing > Config.DirectMoveTo.CheckFloor.AlwaysRaycastThisDistance do
                DistRemaining -= Config.DirectMoveTo.CheckFloor.RaycastSpacing
                if not ValidRaycastToGround(NpcMain.CFrame.Position + DistRemaining * Dir) then
                    return false
                end
            end
            return true
        end
        return API
    end)()

    DirectMoveTo = (function()
        local API = {}
        local TimedRequests = {}
        API.CanUseDirectMoveTo = function(NPC, Target)
            local Config = ConfigHandler.GetActiveConfig(NPC)
            if not Config.DirectMoveTo.Enabled then
                return false
            end
            if not TimedRequests[NPC] then
                TimedRequests[NPC] = { LastCheckFloorFailTime = 0, JumpStuckTime = 0, JumpDebounceTime = 0 }
            end
            if TimedRequests[NPC] then
                if os.clock() < TimedRequests[NPC].LastCheckFloorFailTime + Config.DirectMoveTo.CheckFloor.BlockDirectMoveToTimer then
                    return false
                end
            end
            local function GetRes()
                if typeof(Target) ~= "Instance" then
                    return false
                end
                if Config.DirectMoveTo.TrackingOnly and not Config.Tracking.Enabled then
                    return false
                end
                local NpcPart = Common.GetBasePart(Target)
                if NpcPart == nil then
                    error("NO NPC BASE")
                end
                local TargetPart = Common.GetBasePart(Target, true, NPC)
                if TargetPart == nil then
                    error("NO NPC BASE")
                end
                local NpcPos = NpcPart.CFrame.Position
                local TargetPos = TargetPart.CFrame.Position
                local Dist = (NpcPos - TargetPos).Magnitude
                if Config.DirectMoveTo.ActivationDistance < Dist then
                    return false
                end
                local YDist = NpcPos.Y - TargetPos.Y
                if Config.DirectMoveTo.HeightLimit < YDist then
                    return false
                end
                if Config.DirectMoveTo.Raycast.Enabled then
                    if not CommonMathRequests.CanMoveToRaycast(NPC, Target) then
                        Debugging.LogWithVerbosity(NPC, 5, "[" .. NPC:GetFullName() .. "] cannot see target.")
                        return false
                    end
                end
                if Config.DirectMoveTo.CheckFloor.Enabled then
                    if Common.GetDistanceFromNPCToTarget(NPC, Target) > Config.DirectMoveTo.CheckFloor.DisableIfDistanceIsLessThan then
                        if not CommonMathRequests.CanCrossFloorRaycast(NPC, Target) then
                            Debugging.Log(NPC, "Failed cross floor check to target.")
                            return false
                        end
                    end
                end
                if Config.DirectMoveTo.AvoidUseHook() then
                    Debugging.Log(NPC, "DirectMoveTo was avoided by the user hook.")
                    return false
                end
                return true
            end
            local Result = GetRes()
            if not Result then
                TimedRequests[NPC].LastCheckFloorFailTime = os.clock()
            end
            return Result
        end
        API.GetDirectMoveToPosition = function(NPC, Target)
            local NpcPart = Common.GetBasePart(NPC)
            if NpcPart == nil then
                error("NO NPC BASE")
            end
            local TargetPart = Common.GetBasePart(Target, true, NPC)
            if TargetPart == nil then
                error("NO TARGET BASE")
            end
            local NpcPos = NpcPart.CFrame.Position
            local TargetPos = TargetPart.CFrame.Position
            local Config = ConfigHandler.GetActiveConfig(NPC)
            if Config.Tracking.Enabled and Config.Tracking.PredictionMagnitude > 0 then
                TargetPos = PositionalOptimization.PredictMovement(TargetPart, Config.Tracking.PredictionMagnitude)
            end
            local GoToPos = PositionalOptimization.GetCollinearTargetPositionOffset(TargetPos, NpcPos, Config.Tracking.CollinearTargetPositionOffset)
            return GoToPos
        end
        API.DoJumpTick = function(NPC, Target)
            local NPCHuman = NPC:FindFirstChildOfClass("Humanoid")
            if NPCHuman == nil then
                return
            end
            if not TimedRequests[NPC] then
                TimedRequests[NPC] = { LastCheckFloorFailTime = 0, JumpStuckTime = 0, JumpDebounceTime = 0 }
            end
            local Config = ConfigHandler.GetActiveConfig(NPC)
            if Config.DirectMoveTo.JumpHandler.CustomJumpFunction then
                if Config.DirectMoveTo.JumpHandler.CustomJumpFunction(NPC, Target) then
                    Debugging.Log(NPC, "Custom jump function returned true, jumping.")
                    NPCHuman.Jump = true
                    return true
                end
            end
            if not Config.AgentInfo.AgentCanJump then
                return
            end
            if not Config.DirectMoveTo.TrackingOnly and Config.Tracking.Enabled then
                return
            end
            if not Config.DirectMoveTo.JumpHandler.Enabled then
                return
            end
            local NPCActual = Common.GetBasePart(NPC)
            local TargetActual = Common.GetBasePart(Target, true, NPC)
            if TargetActual == nil then
                error("This should not happen!")
            end
            local Dist = (TargetActual.CFrame.Position - NPCActual.CFrame.Position).Magnitude
            local VeloMax = NPCActual.AssemblyLinearVelocity.Magnitude < NPCHuman.WalkSpeed * 0.5
            local AdditionalVeloCheck = (Vector3.new(NPCActual.AssemblyLinearVelocity.X, 0, NPCActual.AssemblyLinearVelocity.Z).Magnitude < NPCHuman.WalkSpeed * 0.33)
            local MoveToCheck = (NPCHuman.WalkToPoint - NPCActual.CFrame.Position).Magnitude > Config.DirectMoveTo.JumpHandler.DistanceFromMoveToPoint
            local TooCloseToTarget = (not Config.Tracking.Enabled) or (Dist < Config.Tracking.CollinearTargetPositionOffset + Config.Tracking.DistanceMovedThreshold + 0.1)
            if VeloMax and AdditionalVeloCheck and MoveToCheck and not TooCloseToTarget then
                if TimedRequests[NPC].JumpStuckTime + Config.DirectMoveTo.JumpHandler.MinConditionReachedTime < os.clock() then
                    if TimedRequests[NPC].JumpDebounceTime + Config.DirectMoveTo.JumpHandler.NextJumpMinTime > os.clock() then
                        return false
                    end
                    NPCHuman.Jump = true
                    TimedRequests[NPC].JumpDebounceTime = os.clock()
                    Debugging.Log(NPC, "Jumping")
                    return true
                end
            else
                TimedRequests[NPC].JumpStuckTime = os.clock()
            end
            return false
        end
        API.TriggerCleanup = function(NPC)
            TimedRequests[NPC] = nil
        end
        return API
    end)()

    MessageQueue = (function()
        local Messages = {}
        local API = {}
        local function InitializeMQ(NPC)
            if Messages[NPC] then
                return
            end
            Messages[NPC] = {
                ActiveConfig = TablesLibrary.DeepCopy(Defaults),
                NewestStartRequest = {
                    RequestType = "Start",
                    Time = os.clock(),
                    Yields = false,
                    Target = nil,
                    Priority = AIT.RequestPriority.ConvertPriorityToNumber("DefaultStart"),
                    ProcessingState = "Processed",
                },
                NewestStopRequest = {
                    RequestType = "Stop",
                    Time = os.clock(),
                    Yields = false,
                    Priority = AIT.RequestPriority.ConvertPriorityToNumber("DefaultStop"),
                    ProcessingState = "Processed",
                },
                LastSuccessfulPath = { time = os.clock(), wps = {} },
                ActiveRequest = nil,
                Processing = false,
            }
        end
        local function GetMQSingleton(NPC)
            if not Messages[NPC] then
                InitializeMQ(NPC)
            end
            return Messages[NPC]
        end
        API.SetLastSuccessfulPath = function(NPC, Waypoints)
            if Waypoints == nil then
                warn("Waypoints table was nil!")
            end
            Messages[NPC].LastSuccessfulPath = { time = os.clock(), wps = Waypoints }
        end
        API.GetLastSuccessfulPath = function(NPC, TimeoutSeconds)
            local LastPathInfo = Messages[NPC].LastSuccessfulPath
            if LastPathInfo.time + 1 < os.clock() then
                return nil
            end
            return LastPathInfo.wps
        end
        API.SetActiveRequest = function(NPC, Request)
            Request.ProcessingState = "Processing"
            GetMQSingleton(NPC).ActiveRequest = Request
        end
        API.PrintOutRequests = function(NPC)
            print(Messages)
        end
        API.GetNewRequest = function(NPC)
            local MQSingleton = GetMQSingleton(NPC)
            local StartExists = MQSingleton.NewestStartRequest.ProcessingState == "Requested"
            local StopExists = MQSingleton.NewestStopRequest.ProcessingState == "Requested"
            if not StartExists and not StopExists then
                return nil
            end
            if StartExists and not StopExists then
                return MQSingleton.NewestStartRequest
            end
            if StopExists and not StartExists then
                return MQSingleton.NewestStopRequest
            end
            local function GetPrioritizedRequest()
                local StartPriority = MQSingleton.NewestStartRequest.Priority
                local StopPriority = MQSingleton.NewestStopRequest.Priority
                if StartPriority > StopPriority then
                    return MQSingleton.NewestStartRequest
                end
                if StopPriority > StartPriority then
                    return MQSingleton.NewestStopRequest
                end
                return MQSingleton.NewestStartRequest
            end
            local function GetLatestRequest()
                local StartTime = MQSingleton.NewestStartRequest.Time
                local StopTime = MQSingleton.NewestStopRequest.Time
                if StartTime > StopTime then
                    return MQSingleton.NewestStartRequest
                end
                if StopTime > StartTime then
                    return MQSingleton.NewestStopRequest
                end
                return MQSingleton.NewestStartRequest
            end
            if not MQSingleton.ActiveConfig.RequestPrioritization.PreferTimeOverPriority.Enabled then
                return GetPrioritizedRequest()
            end
            if MQSingleton.ActiveConfig.RequestPrioritization.PreferTimeOverPriority.Enabled then
                local LatestRequest = GetLatestRequest()
                if MQSingleton.ActiveConfig.RequestPrioritization.PreferTimeOverPriority.ResetOlderRequests then
                    if LatestRequest.RequestType == "Start" then
                        MQSingleton.NewestStopRequest.ProcessingState = "Processed"
                    end
                    if LatestRequest.RequestType == "Stop" then
                        MQSingleton.NewestStartRequest.ProcessingState = "Processed"
                    end
                end
                return LatestRequest
            end
            error("this shouldn't be showing, if you can replicate contact @crit-dev")
            return nil
        end
        API.IsProcessingStartRequest = function(NPC)
            local MQSingleton = GetMQSingleton(NPC)
            return MQSingleton.NewestStartRequest.ProcessingState == "Processing"
        end
        API.IsProcessingEndRequest = function(NPC)
            local MQSingleton = GetMQSingleton(NPC)
            return MQSingleton.NewestStopRequest.ProcessingState == "Processing"
        end
        API.IsProcessing = function(NPC)
            return API.IsProcessingStartRequest(NPC) or API.IsProcessingEndRequest(NPC)
        end
        API.SendStartMessage = function(NPC, Target, Yields, Priority)
            local MQSingleton = GetMQSingleton(NPC)
            local Prio = AIT.RequestPriority.ConvertPriorityToNumber("DefaultStart")
            if Priority ~= nil then
                Prio = AIT.RequestPriority.GetPriorityNumber(Priority)
            end
            if MQSingleton.NewestStartRequest.ProcessingState == "Requested" then
                if MQSingleton.NewestStartRequest.Priority > Prio then
                    return
                end
            end
            MQSingleton.NewestStartRequest = {
                Time = os.clock(),
                Target = Target,
                Yields = Yields or false,
                Priority = Prio,
                ProcessingState = "Requested",
                RequestType = "Start",
                FinishedSignal = nil,
            }
            local Event = nil
            if Yields then
                Event = Instance.new("BindableEvent")
                MQSingleton.NewestStartRequest.FinishedSignal = Event
            end
            return Event
        end
        API.SendStopMessage = function(NPC, Yields, Priority)
            local MQSingleton = GetMQSingleton(NPC)
            local Prio = AIT.RequestPriority.ConvertPriorityToNumber("DefaultStop")
            if Priority ~= nil then
                Prio = AIT.RequestPriority.GetPriorityNumber(Priority)
            end
            if MQSingleton.NewestStopRequest.ProcessingState == "Requested" then
                if MQSingleton.NewestStopRequest.Priority > Prio then
                    return
                end
            end
            MQSingleton.NewestStopRequest = {
                Time = os.clock(),
                Yields = Yields or false,
                Priority = Prio,
                ProcessingState = "Requested",
                RequestType = "Stop",
                FinishedSignal = nil,
            }
            local Event = nil
            if Yields then
                Event = Instance.new("BindableEvent")
                MQSingleton.NewestStopRequest.FinishedSignal = Event
            end
            return Event
        end
        return API
    end)()

    local IdleState = (function()
        local Idle = StateMachine.State.new("Idle")
        local function StopNPCByStopType(Config)
            if Config.StopType == "CurrentPosition" then
                local ActualNPC = Common.GetBasePart(Config.NPC)
                local NPCHuman = Config.NPC:FindFirstChildOfClass("Humanoid")
                if ActualNPC and NPCHuman then
                    NPCHuman:MoveTo(ActualNPC.CFrame.Position)
                    ActualNPC.CFrame = ActualNPC.CFrame
                else
                    Debugging.Log(Config.NPC, "StopNPCByStopType: No ActualNPC or NPCHuman found.")
                end
            end
            if Config.StopType == "NoStopLogic" then
            end
        end
        local function NewRequestHandler(Data)
            local Config = Data.Config
            local NextRequest = MessageQueue.GetNewRequest(Config.NPC)
            if NextRequest == nil then
                return
            end
            if NextRequest.ProcessingState == "Processing" or NextRequest.ProcessingState == "Processed" then
                return
            end
            MessageQueue.SetActiveRequest(Config.NPC, NextRequest)
            if NextRequest.RequestType == "Stop" then
                if Data.Request == nil then
                    return
                end
                Data.Request.ProcessingState = "Processed"
                WaypointLooper.EndContinuity(Config.NPC)
                task.spawn(Config.Hooks.StopAcknowledged, Config.NPC, NextRequest.Target)
                WaypointsVisualization.DeleteVisualization(Config.NPC)
                if Data.Target ~= nil then
                    StopNPCByStopType(Config)
                end
                NextRequest.ProcessingState = "Processed"
                Data.StateMachine:ChangeData("Target", nil)
                return
            end
            Data.StateMachine:ChangeData("Request", NextRequest)
            Data.StateMachine:ChangeData("Target", NextRequest.Target)
            if NextRequest.Target then
                Config:ApplyNow()
                task.spawn(Config.Hooks.StartAcknowledged, Config.NPC, NextRequest.Target)
                if Config.Tracking.Enabled and typeof(NextRequest.Target) == "Instance" then
                    Data.StateMachine:ChangeState("Tracking")
                else
                    Data.StateMachine:ChangeState("Pathing")
                end
            else
                Debugging.Log(Config.NPC, "No target set for Idle state, cannot change to Pathing or Tracking.")
            end
        end
        function Idle:OnInit()
        end
        function Idle:OnEnter(Data)
            if not Data.NPC then
                error("No NPC in data!")
            end
            Debugging.Log(Data.NPC, "Idle: " .. Data.NPC:GetFullName())
            if Data.Request and Data.Request.FinishedSignal then
                Data.Request.FinishedSignal:Fire()
            end
        end
        function Idle:OnHeartbeat(Data)
            local Success, Err = pcall(function()
                NewRequestHandler(Data)
            end)
            if not Success then
                print("StateMachine error:", Err)
            end
        end
        function Idle:OnLeave()
            local Config = self.Data.Config
            Debugging.Log(Config.NPC, "Leaving Idle State for ", Config.NPC:GetFullName())
        end
        return Idle
    end)()

    local PathingState = (function()
        local Pathing = StateMachine.State.new("Pathing")
        local function NewRequestHandler(Data)
            local Config = Data.Config
            local NextRequest = MessageQueue.GetNewRequest(Config.NPC)
            if NextRequest == nil then
                return
            end
            if Data.Request == NextRequest then
                return
            end
            Data.StateMachine:ChangeState("Idle")
            return true
        end
        function Pathing:OnInit()
        end
        function Pathing:OnEnter(Data)
            Data.StateMachine:ChangeData("Waypoints", {})
            if not Data.NPC then
                error("No NPC in data!")
            end
            Debugging.Log(Data.NPC, "Pathing: " .. Data.NPC:GetFullName())
            local Config = Data.Config
            local Target = Data.Target
            if not Target then
                Debugging.Log(Config.NPC, "No target set for Pathing state, cannot compute path.")
                return
            end
            local Waypoints = PathfindingProcessor.ComputePath(Config.NPC, Target)
            if not Waypoints then
                Debugging.Log(Config.NPC, "Failed to compute path for Pathing state.")
                return
            end
            if Config.WaypointSkipping.RegularPathfindSkip > 1 then
                local SkipIndex = math.min(Config.WaypointSkipping.RegularPathfindSkip, #Waypoints)
                Waypoints = { table.unpack(Waypoints, SkipIndex) }
            end
            Data.StateMachine:ChangeData("Waypoints", Waypoints)
            local Request = Data.Request
            local function CompletedSignal()
                if Data.StateMachine:GetCurrentState() ~= "Pathing" then
                    Debugging.Log(Config.NPC, "Pathing state has changed, stopping waypoint looper.")
                    return
                end
                Debugging.Log(Config.NPC, "Pathing completed for ", Config.NPC:GetFullName())
                if Request ~= Data.Request then
                    Debugging.Log(Config.NPC, "Request has changed during pathing, stopping current pathing.")
                    return
                end
                Data.Request.ProcessingState = "Processed"
                Data.StateMachine:ChangeState("Idle")
            end
            WaypointLooper.StartContinuity(Config.NPC, Target, Waypoints, CompletedSignal)
        end
        function Pathing:OnHeartbeat(Data)
            if NewRequestHandler(Data) then
                return
            end
            local Config = Data.Config
            local Target = Data.Target
            if not Target then
                Debugging.Log(Config.NPC, "No target set for Pathing state, cannot continue pathing.")
                return
            end
            if Config.DirectMoveTo.JumpHandler.Enabled and not Config.DirectMoveTo.TrackingOnly then
                if #Data.Waypoints > 0 and Data.Waypoints[1].Label == "ForbiddenDirectMoveTo" then
                    DirectMoveTo.DoJumpTick(Config.NPC, Target)
                end
            end
        end
        function Pathing:OnLeave()
            local Config = self.Data.Config
            Debugging.Log(Config.NPC, "Leaving Pathing State for ", Config.NPC:GetFullName())
        end
        return Pathing
    end)()

    RetrackingOptimization = (function()
        local API = {}
        API.GetDynamicRetrackTimer = function(NPC, Target, MovementType)
            local Config = ConfigHandler.GetActiveConfig(NPC)
            if MovementType == "DirectMoveTo" then
                local Timer = Config.Tracking.DynamicRetrack.MoveTo.GetRetrackTimeFunction(NPC, Target)
                if Timer == nil then
                    return Config.Tracking.DynamicRetrack.MoveTo.MaxTimer
                end
                return math.clamp(Timer, Config.Tracking.DynamicRetrack.MoveTo.MinTimer, Config.Tracking.DynamicRetrack.MoveTo.MaxTimer)
            end
            if MovementType == "Pathfind" then
                local Timer = Config.Tracking.DynamicRetrack.Pathfind.GetRetrackTimeFunction(NPC, Target)
                if Timer == nil then
                    return Config.Tracking.DynamicRetrack.Pathfind.MaxTimer
                end
                return math.clamp(Timer, Config.Tracking.DynamicRetrack.Pathfind.MinTimer, Config.Tracking.DynamicRetrack.Pathfind.MaxTimer)
            end
            warn("this should not occur")
            return 1
        end
        API.ShouldRetrack = function(NPC, Target, MovementType)
            local Config = ConfigHandler.GetActiveConfig(NPC)
            if MovementType == "DirectMoveTo" then
                local Result = Config.Tracking.DynamicRetrack.MoveTo.ShouldRetrackFunction(NPC, Target)
                if Result == nil then
                    return Config.Tracking.DynamicRetrack.MoveTo.MaxTimer
                end
                return Result
            end
            if MovementType == "Pathfind" then
                local Result = Config.Tracking.DynamicRetrack.Pathfind.ShouldRetrackFunction(NPC, Target)
                if Result == nil then
                    return Config.Tracking.DynamicRetrack.Pathfind.MaxTimer
                end
                return Result
            end
            warn("this should not occur")
            return false
        end
        return API
    end)()

    local TrackingState = (function()
        local Tracking = StateMachine.State.new("Tracking")
        local function NewRequestHandler(Data)
            local Config = Data.Config
            local NextRequest = MessageQueue.GetNewRequest(Config.NPC)
            if NextRequest == nil then
                return
            end
            Data.StateMachine:ChangeState("Idle")
        end
        function Tracking:OnInit()
        end
        function Tracking:Pathfind(Data)
            local Config = Data.Config
            local Target = Data.Target
            if not Target then
                Debugging.Log(Config.NPC, "No target set for Tracking state, cannot compute path.")
                return false
            end
            local Waypoints = PathfindingProcessor.ComputePath(Config.NPC, Target)
            if not Waypoints then
                Debugging.Log(Config.NPC, "Failed to compute path for Tracking state.")
                return false
            end
            if Config.WaypointSkipping.TrackingPathfindSkip > 1 then
                local SkipIndex = math.min(Config.WaypointSkipping.TrackingPathfindSkip, #Waypoints)
                Waypoints = { table.unpack(Waypoints, SkipIndex) }
            end
            Data.StateMachine:ChangeData("Waypoints", Waypoints)
            if #Waypoints > 1 then
                Data.StateMachine:ChangeData("RecallType", "Pathfind")
            else
                Data.StateMachine:ChangeData("RecallType", "DirectMoveTo")
            end
            local function CompletedSignal()
            end
            WaypointLooper.StartContinuity(Config.NPC, Target, Waypoints, CompletedSignal)
            return true
        end
        function Tracking:OnEnter(Data)
            if not Data.NPC then
                error("No NPC in data!")
            end
            Debugging.Log(Data.NPC, "Tracking: " .. Data.NPC:GetFullName())
            Data.StateMachine:ChangeData("LastTrackingRecall", 0)
            Data.StateMachine:ChangeData("LastTargetPosition", Vector3.new(math.huge, math.huge, math.huge))
            Data.StateMachine:ChangeData("Waypoints", {})
        end
        function Tracking:OnHeartbeat(Data)
            NewRequestHandler(Data)
            local Config = Data.Config
            local NPC = Config.NPC
            local NPCHuman = NPC:FindFirstChildOfClass("Humanoid")
            if NPC == nil or NPCHuman == nil or NPCHuman.Health == 0 then
                Debugging.Log(NPC, "NPC is nil, has no Humanoid, or is dead in Tracking state, cannot continue.")
                Data.StateMachine:ChangeState("Idle")
                return
            end
            if Data.Target == nil then
                Debugging.Log(NPC, "Target is nil or invalid in Tracking state, cannot continue.")
                Data.StateMachine:ChangeState("Idle")
                return
            end
            local TargetBasePart = Common.GetBasePart(Data.Target, true, NPC)
            if TargetBasePart == nil then
                Debugging.Log(NPC, "Target is nil or invalid in Tracking state, cannot continue.")
                Data.StateMachine:ChangeState("Idle")
                return
            end
            if Config.DirectMoveTo.JumpHandler.Enabled and #Data.Waypoints > 0 and Data.Waypoints[1].Label == "ForbiddenDirectMoveTo" then
                DirectMoveTo.DoJumpTick(Config.NPC, Data.Target)
            end
            local NextRecallTime = Data.LastTrackingRecall + RetrackingOptimization.GetDynamicRetrackTimer(NPC, Data.Target, Data.RecallType)
            if os.clock() < NextRecallTime then
                return
            end
            local DistanceMoved = (Data.LastTargetPosition - TargetBasePart.CFrame.Position).Magnitude
            if DistanceMoved < Config.Tracking.DistanceMovedThreshold then
                Debugging.LogWithVerbosity(NPC, 6, string.format("Distance moved requirement not exceeded. (%.3f)", DistanceMoved))
                return
            end
            if not RetrackingOptimization.ShouldRetrack(NPC, Data.Target, Data.RecallType) then
                return
            end
            Data.StateMachine:ChangeData("LastTrackingRecall", os.clock())
            Debugging.Log("Recalling!")
            local Success = Tracking:Pathfind(Data)
            if not Success then
                Debugging.Log(NPC, "Recall failed! Target: ", Data.Target)
            end
            Data.StateMachine:ChangeData("LastTargetPosition", TargetBasePart.CFrame.Position)
        end
        function Tracking:OnLeave(Data)
            local Config = Data.Config
            Debugging.Log(Config.NPC, "Leaving Tracking State for ", Config.NPC:GetFullName())
        end
        return Tracking
    end)()

    PathfindingProcessor = (function()
        local PathfindingService = game:GetService("PathfindingService")
        local Debris = game:GetService("Debris")
        local API = {}
        local StateMachines = {}
        local BlockedIndices = {}
        local Paths = {}
        API.InitializeStateMachine = function(NPC)
            if StateMachines[NPC] then
                return
            end
            local NPCHuman = NPC:FindFirstChildOfClass("Humanoid")
            if NPCHuman == nil then
                error("NPC Human is nil!")
            end
            local States = { IdleState, PathingState, TrackingState }
            local ThisStateMachine = StateMachine.new("Idle", States, {
                Config = ConfigHandler.GetActiveConfig(NPC),
                NPC = NPC,
                Target = nil,
                Waypoints = {},
                LastTrackingRecall = 0,
                RecallType = "DirectMoveTo",
            })
            ThisStateMachine.StateChanged:Connect(function()
                local PrevState = ThisStateMachine:GetPreviousState()
                local NewState = ThisStateMachine:GetCurrentState()
                Debugging.Log(NPC, "State Changed: [", PrevState, "] -> [", NewState, "]")
            end)
            ThisStateMachine.Data.StateMachine = ThisStateMachine
            StateMachines[NPC] = ThisStateMachine
            local function DestroyStateMachine()
                Debugging.Log(NPC, "Destroying State Machine for NPC: ", NPC:GetFullName())
                if not StateMachines[NPC] then
                    return
                end
                StateMachines[NPC]:Destroy()
                StateMachines[NPC] = nil
                if Paths[NPC].PathObject then
                    Paths[NPC].PathObject:Destroy()
                end
                Paths[NPC] = nil
                BlockedIndices[NPC] = nil
                collectgarbage("count")
            end
            NPCHuman.Died:Connect(DestroyStateMachine)
            NPC.Destroying:Connect(DestroyStateMachine)
        end
        API.PrintStateMachines = function()
            print(StateMachines)
        end
        local function OnPathBlocked(NPC, WaypointIndexNumber)
            if StateMachines[NPC] == nil then
                return
            end
            if StateMachines[NPC].State.Name == "Idle" then
                return
            end
        end
        local function OnPathUnblocked(NPC, WaypointIndexNumber)
            if StateMachines[NPC] == nil then
                return
            end
            if StateMachines[NPC].State.Name == "Idle" then
                return
            end
        end
        local function ConfigurePath(NPC, Path)
            if Paths[NPC] == nil then
                Paths[NPC] = {
                    AgentInfo = ConfigHandler.GetActiveConfig(NPC).AgentInfo,
                    PathObject = Path,
                    UsingPathfind = false,
                }
            else
                Paths[NPC].PathObject = Path
            end
            Paths[NPC].UsingPathfind = true
            BlockedIndices[NPC] = {}
        end
        local function TablesAreEqual(Table1, Table2)
            if #Table1 ~= #Table2 then
                return false
            end
            for I, V in pairs(Table1) do
                local Val1isTbl = typeof(V) == "table"
                local Val2isTbl = Table2[I] == "table"
                if (Val1isTbl and not Val2isTbl) or (Val2isTbl and not Val1isTbl) then
                    return false
                end
                if Val1isTbl and Val2isTbl then
                    if not TablesAreEqual(V, Table2[I]) then
                        return false
                    end
                end
                if V ~= Table2[I] then
                    return false
                end
            end
            return true
        end
        local function GetPath(NPC)
            local Config = ConfigHandler.GetActiveConfig(NPC)
            if Paths[NPC] and Paths[NPC].PathObject and TablesAreEqual(Paths[NPC].AgentInfo, Config.AgentInfo) then
                return Paths[NPC].PathObject
            end
            local Path = PathfindingService:CreatePath(Config.AgentInfo)
            Path.Blocked:Connect(function(Wpi)
                OnPathBlocked(NPC, Wpi)
            end)
            Path.Unblocked:Connect(function(Wpi)
                OnPathUnblocked(NPC, Wpi)
            end)
            if not Paths[NPC] then
                Paths[NPC] = {}
            end
            if Paths[NPC].PathObject then
                Debris:AddItem(Paths[NPC].PathObject, 0)
            end
            Paths[NPC].AgentInfo = Config.AgentInfo
            Paths[NPC].PathObject = Path
            return Path
        end
        API.ComputePath = function(NPC, Target)
            local Config = ConfigHandler.GetActiveConfig(NPC)
            local TargetActual = Common.GetBasePart(Target, true, NPC)
            if TargetActual == nil then
                error("Could not convert Target into an Actual Instance")
            end
            if DirectMoveTo.CanUseDirectMoveTo(NPC, Target) then
                if Paths[NPC] == nil then
                    Paths[NPC] = {}
                end
                Paths[NPC].UsingPathfind = false
                return { PathWaypoint.new(DirectMoveTo.GetDirectMoveToPosition(NPC, Target), Enum.PathWaypointAction.Walk, "ForbiddenDirectMoveTo") }
            end
            local Path = GetPath(NPC)
            ConfigurePath(NPC, Path)
            local NPCActual = Common.GetBasePart(NPC)
            local TargetActual = Common.GetBasePart(Target, true, NPC)
            Path:ComputeAsync(NPCActual.Position, TargetActual.Position)
            if Path.Status == Enum.PathStatus.Success then
                return Path:GetWaypoints()
            end
            task.spawn(Config.Hooks.PathingFailed, NPC, "Path Not Found")
            return nil
        end
        API.RawCompute = function(Origin, Destination, AgentInfo)
            local Path = PathfindingService:CreatePath(AgentInfo)
            Path:ComputeAsync(Origin, Destination)
            if Path.Status == Enum.PathStatus.Success then
                return Path:GetWaypoints()
            else
                return nil
            end
        end
        return API
    end)()

    WaypointsVisualization = (function()
        local Debris = game:GetService("Debris")
        local API = {}
        local Folders = {}
        local StorageFolderWS = Common.GetForbiddenStorageFolder()
        local VisualizationFolder = Instance.new("Folder")
        VisualizationFolder.Name = "Visualization"
        VisualizationFolder.Parent = StorageFolderWS
        local function CreateVisualizedParts(Config, Nodes)
            local PartsList = {}
            local function CreatePart(Index, Node)
                local NewPart = Instance.new("Part")
                NewPart.Shape = Enum.PartType.Ball
                NewPart.Color = Config.Visualization.PathColor
                NewPart.Material = Enum.Material.Neon
                NewPart.CFrame = CFrame.new(Node.Position)
                NewPart.Name = tostring(Index)
                NewPart.Anchored = true
                NewPart.Size = Vector3.new(1, 1, 1)
                NewPart.CanCollide = false
                NewPart.CanQuery = false
                return NewPart
            end
            for Index, Node in pairs(Nodes) do
                table.insert(PartsList, CreatePart(Index, Node))
            end
            return PartsList
        end
        local function DeleteVisualizedParts(Folder)
            for _, Part in pairs(Folder:GetChildren()) do
                Debris:AddItem(Part, 0)
            end
        end
        local function ParentVisualizedParts(NPC, Parts)
            local Folder = Folders[NPC]
            for _, Part in pairs(Parts) do
                Part.Parent = Folder
            end
        end
        API.VisualizeWaypoints = function(NPC, Nodes)
            local Config = ConfigHandler.GetConfig(NPC)
            if Folders[NPC] then
                local NewParts = CreateVisualizedParts(Config, Nodes)
                DeleteVisualizedParts(Folders[NPC])
                ParentVisualizedParts(NPC, NewParts)
            end
            if not Folders[NPC] then
                local ThisFolder = Instance.new("Folder")
                ThisFolder.Name = NPC:GetFullName()
                ThisFolder.Parent = VisualizationFolder
                Folders[NPC] = ThisFolder
                local NewParts = CreateVisualizedParts(Config, Nodes)
                ParentVisualizedParts(NPC, NewParts)
            end
            return Folders[NPC]
        end
        API.DeleteVisualization = function(NPC)
            if NPC == nil then
                return
            end
            if not Folders[NPC] then
                return
            end
            if #Folders[NPC]:GetChildren() < 1 then
                return
            end
            DeleteVisualizedParts(Folders[NPC])
        end
        API.TriggerCleanup = function(NPC)
            if not Folders[NPC] then
                return
            end
            DeleteVisualizedParts(Folders[NPC])
            Folders[NPC]:Destroy()
            Folders[NPC] = nil
        end
        return API
    end)()

    WaypointLooper = (function()
        local API = {}
        local ActiveContinuities = {}
        local function IsValid(NPC)
            local NPCHuman = NPC:FindFirstChildOfClass("Humanoid")
            if NPCHuman == nil then
                return false
            end
            if NPCHuman.Health == 0 then
                return false
            end
            return true
        end
        local function LoopThroughWaypoints(NPC)
            local NPCHuman = NPC:FindFirstChildOfClass("Humanoid")
            if NPCHuman == nil then
                error("nil human")
            end
            local Config = ConfigHandler.GetActiveConfig(NPC)
            local ThisCont = ActiveContinuities[NPC]
            local ThisId = ThisCont.RequestId
            local ThisTarget = ThisCont.Target
            local TheseWaypoints = ThisCont.waypoints
            local ThisCompletedSignal = ThisCont.CompletedSignal
            local ThisWaypointCount = #TheseWaypoints
            local TimesStuck = 0
            task.spawn(Config.Hooks.PathingStarted, NPC, TheseWaypoints)
            if Config.Visualization.Enabled then
                if Config.Visualization.Path then
                    WaypointsVisualization.VisualizeWaypoints(NPC, TheseWaypoints)
                end
            end
            for I = 1, ThisWaypointCount, 1 do
                if ThisId ~= ActiveContinuities[NPC].RequestId then
                    break
                end
                if not IsValid(NPC) then
                    break
                end
                local Wp = TheseWaypoints[I]
                if not Wp then
                    break
                end
                local function FormatString(Number)
                    return string.format("%.2f", Number)
                end
                if Config.Debugging.MovingToWaypoint then
                    Debugging.Log(NPC, "Moving to waypoint: ", "(", FormatString(Wp.Position.X), ", ", FormatString(Wp.Position.Y), ", ", FormatString(Wp.Position.Z), ") ", " with action: ", Wp.Action, " and label: ", Wp.Label)
                end
                if Wp.Action == Enum.PathWaypointAction.Custom then
                    task.spawn(Config.Hooks.MovingToWaypoint, NPC, Wp, "PathfindingLink")
                    local PathfindingLinkResult = Config.Hooks.PathfindingLinkReached(NPC, Wp)
                    if PathfindingLinkResult then
                        continue
                    end
                    error("The PathfindingLinkReached returned false or nil, meaning it was unsuccessful for the Label: " .. Wp.Label)
                end
                if Wp.Action == Enum.PathWaypointAction.Jump then
                    NPCHuman.Jump = true
                end
                NPCHuman:MoveTo(Wp.Position)
                if Wp.Label == "ForbiddenDirectMoveTo" then
                    task.spawn(Config.Hooks.MovingToWaypoint, NPC, Wp, "DirectMoveTo")
                else
                    task.spawn(Config.Hooks.MovingToWaypoint, NPC, Wp, "Pathing")
                end
                local Success = NPCHuman.MoveToFinished:Wait()
                if not Success and Config.Unstucking.Enabled then
                    Debugging.Log(NPC, "Failed to move to waypoint: ", "(", FormatString(Wp.Position.X), ", ", FormatString(Wp.Position.Y), ", ", FormatString(Wp.Position.Z), ") with action: ", Wp.Action, " and label: ", Wp.Label)
                    TimesStuck += 1
                    if TimesStuck >= Config.Unstucking.MaxStuckCount then
                        Debugging.Log(NPC, "Max stuck count reached, breaking out of the loop.")
                        task.spawn(Config.Hooks.PathingFailed, NPC, "Stuck Limit Reached")
                        break
                    end
                    if Config.Unstucking.FireStuckHook then
                        if Config.Hooks.Stuck(NPC, ThisTarget) then
                            if ThisId ~= ActiveContinuities[NPC].RequestId then
                                break
                            end
                            Debugging.Log(NPC, "Stuck hook was successful, continuing to next waypoint.")
                        else
                            if ThisId ~= ActiveContinuities[NPC].RequestId then
                                break
                            end
                            Debugging.Log(NPC, "Stuck hook was unsuccessful, breaking out of the loop.")
                            break
                        end
                    end
                end
                if not Success and not Config.Unstucking.Enabled then
                    task.spawn(Config.Hooks.PathingFailed, NPC, "Stuck Limit Reached")
                    break
                end
            end
            if ThisId == ThisCont.RequestId then
                ThisCompletedSignal()
                Config.Hooks.GoalReached(NPC, ThisCont.Target)
                API.EndContinuity(NPC)
            end
        end
        API.StartContinuity = function(NPC, Target, WPs, CompletedSignal)
            if not ActiveContinuities[NPC] then
                ActiveContinuities[NPC] = { RequestId = 0, Target = nil, index = 1, waypoints = {}, CompletedSignal = function()
                end }
            end
            local ThisCont = ActiveContinuities[NPC]
            ThisCont.RequestId = ActiveContinuities[NPC].RequestId + 1
            ThisCont.Target = Target
            ThisCont.index = 1
            ThisCont.waypoints = WPs
            ThisCont.CompletedSignal = CompletedSignal
            task.spawn(LoopThroughWaypoints, NPC)
        end
        API.EndContinuity = function(NPC)
            local ThisCont = ActiveContinuities[NPC]
            if ThisCont == nil then
                return
            end
            ThisCont.RequestId = ActiveContinuities[NPC].RequestId + 1
            ThisCont.Target = nil
            ThisCont.index = 1
            ThisCont.waypoints = {}
            ThisCont.CompletedSignal = function()
            end
        end
        API.TriggerCleanup = function(NPC)
            ActiveContinuities[NPC] = nil
        end
        return API
    end)()

    TriggerCleanup = (function()
        local API = {}
        API.TriggerCleanup = function(NPC)
            WaypointsVisualization.DeleteVisualization(NPC)
            ConfigHandler.TriggerCleanup(NPC)
            WaypointLooper.TriggerCleanup(NPC)
            DirectMoveTo.TriggerCleanup(NPC)
            Common.TriggerCleanupTypeHelp(NPC)
        end
        return API
    end)()

    AI = (function()
        local DefaultAntilag = Instance.new("Script")
        DefaultAntilag.Name = "AntiLag"
        DefaultAntilag.Source = [[
            task.wait(1)
            local hrt = script.Parent:FindFirstChild("HumanoidRootPart")
            local t = script.Parent:FindFirstChild("Torso")
            if t ~= nil and hrt == nil then hrt = t end
            if hrt ~= nil then hrt:SetNetworkOwner(nil) end
            if hrt == nil then warn("Unable to use anti-lag script.") return end
            script:Destroy()
        ]]
        local API = {}
        API.SmartPathfind = function(NPC, Target, Yields, Priority)
            Yields = Yields or false
            Priority = Priority or "DefaultStart"
            PathfindingProcessor.InitializeStateMachine(NPC)
            local Signal = MessageQueue.SendStartMessage(NPC, Target, Yields, Priority)
            if Yields and Signal then
                Signal.Event:Wait()
            end
        end
        API.Stop = function(NPC, Yields, Priority)
            Yields = Yields or false
            Priority = Priority or "DefaultStop"
            local Signal = MessageQueue.SendStopMessage(NPC, Yields, Priority)
            if Yields and Signal then
                Signal.Event:Wait()
            end
        end
        API.GetConfig = function(NPC)
            return ConfigHandler.GetConfig(NPC)
        end
        API.InsertAntiLag = function(NPC, UseExtremeCase, IgnoreHumanoidCheck)
            if NPC == nil then
                error("NPC is nil! Cannot insert the anti-lag script.")
            end
            if NPC:FindFirstChildOfClass("Humanoid") == nil and not IgnoreHumanoidCheck then
                error("Cannot find the humanoid in this NPC. Cannot insert the anti-lag script.")
            end
            if not UseExtremeCase then
                DefaultAntilag:Clone().Parent = NPC
                DefaultAntilag.Enabled = true
            end
            if UseExtremeCase then
                DefaultAntilag:Clone().Parent = NPC
                DefaultAntilag.Enabled = true
            end
        end
        return API
    end)()

    return {
        AI = AI,
        Math = Math,
    }
end
