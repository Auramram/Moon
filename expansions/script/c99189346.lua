--Fine del MONDO
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cid.condition)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
--filters
function cid.check_arcarums(c,start)
	if not start then return false end
	local check=1
	for i=1,22 do
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,start+i) then
			check=check+1
		end
	end
	return c:IsCode(start) and check==23
end
--Activate
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.check_arcarums,tp,LOCATION_GRAVE,0,1,nil,99189323)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_ZAWARUDO=0x1
	Duel.Win(tp,WIN_REASON_ZAWARUDO)
end