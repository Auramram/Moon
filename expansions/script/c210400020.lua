--created & coded by Lyris, art by Chahine Sfar
--S・VINEの女王クライッシャ
local cid,id=GetID()
cid.spt_other_space=210400095
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	aux.AddSpatialProc(c,cid.mcheck,8,300,nil,aux.FilterBoolFunction(Card.IsSetCard,0x285b),cid.mfilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(function(e) return e:GetHandler():GetMaterial():IsExists(Card.IsSetCard,2,nil,0x285b) end)
	e3:SetCost(cid.cost)
	e3:SetTarget(cid.target)
	e3:SetOperation(cid.operation)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1109)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end)
	e2:SetCost(cid.rmcost)
	e2:SetTarget(cid.rmtg)
	e2:SetOperation(cid.rmop)
	c:RegisterEffect(e2)
end
function cid.mfilter(c)
	return c:IsSetCard(0x85a) or c:IsSetCard(0x85b)
end
function cid.mcheck(sg)
	local sg=sg:Clone()
	local vg=sg:Filter(Card.IsSetCard,nil,0x285b)
	if vg:GetCount()==sg:GetCount() then return true end
	sg:Sub(vg)
	return vg:GetFirst():GetAttack()>sg:GetFirst():GetAttack()
end
function cid.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cid.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cid.spfilter(c,e,tp)
	return c:IsFaceup() and (c:IsSetCard(0x85a) or c:IsSetCard(0x85b)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cid.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,cid.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	if tg1:GetFirst():IsRelateToEffect(e)
		and Duel.SpecialSummon(tg1,0,tp,tp,false,false,POS_FACEUP)~=0 and tg2:GetFirst():IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Remove(tg2,POS_FACEUP,REASON_EFFECT)
	end
end
function cid.filter(c,n)
	if not c:IsType(TYPE_MONSTER) or not c:IsSetCard(0x285b) then return false end
	return n~=0 and c:IsAbleToHand() or c:IsAbleToRemoveAsCost()
end
function cid.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_HAND,0,1,nil,0) end
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_HAND,0,1,1,nil,0)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,1)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
