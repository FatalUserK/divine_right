---@class (exact) Weighted
---@field weight number

---@generic T : Weighted
---@param t T[]
---@return T
---Function for picking a random table entry on `weight` as weight
function RandomFromTable(t)
	local total_weight = 0
	for _, entry in ipairs(t) do
		total_weight = total_weight + entry.weight
	end

	local rnd = Randomf(0, total_weight)
	for _, entry in ipairs(t) do
		if rnd <= entry.weight then
			return entry
		else rnd = rnd - entry.weight end
	end
	return t[#t] --Randomf has OOB issue
end

---@generic T : Weighted
---@param t T[]
---@param context any
---@return T|nil
---Compiles entries from `t` into a new table based on optional `condition` value in the entry and passes it through `RandomFromTable`. `context` is passed into the function as a parameter.
function RandomFromTableConditional(t, context)
	local temp = {}
	for _, entry in ipairs(t) do
		if entry.condition and not entry:condition(context) then goto continue end
		temp[#temp+1] = entry
		::continue::
	end

	if #temp == 0 then return end
	return RandomFromTable(temp)
end