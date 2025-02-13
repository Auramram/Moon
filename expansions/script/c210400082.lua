--created & coded by Lyris, art from Fate/Apocrypha's Saber of "Black"
--復剣主サイフリード
local cid,id=GetID()
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cid.val)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(cid.sptg)
	e3:SetOperation(cid.spop)
	c:RegisterEffect(e3)
end
function cid.val(e,c)
	return Duel.GetMatchingGroupCount(cid.rfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
end
function cid.rfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER)
end
function cid.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function cid.spfilter(c,e,tp)
	return c:IsSetCard(0xbb2) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	if Duel.IsExistingTarget(cid.desfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(cid.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectTarget(tp,cid.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectTarget(tp,cid.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	end
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,dg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex2,cg=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if not dg or not cg then return end
	local dc=dg:GetFirst()
	local cc=cg:GetFirst()
	if dc:IsRelateToEffect(e) and cc:IsRelateToEffect(e) and dc:IsDestructable() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.Destroy(dc,REASON_EFFECT)
		Duel.SpecialSummon(cc,0,tp,tp,false,false,POS_FACEUP)
	end
end
