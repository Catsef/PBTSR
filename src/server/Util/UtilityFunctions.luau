local m = {}

function m.SwitchWithCaseTable(Parameter, CaseTable)
	local case = CaseTable[Parameter]
	if case then
		return case()
	end
	local def = CaseTable["default"]
	return def and def() or nil
end

return m
