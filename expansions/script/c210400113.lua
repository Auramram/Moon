--created & coded by Lyris, art by Takayama Toshiaki
--襲雷属性－インフェルnil
local cid,id=GetID()
function cid.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetCondition(cid.descon)
	e0:SetTarget(cid.destg)
	e0:SetOperation(cid.desop)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,id)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetTarget(cid.pftg)
	e4:SetOperation(cid.pfop)
	c:RegisterEffect(e4)
end
function cid.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateAttack()
	if c:IsRelateToEffect(e) and c:IsDestructable() then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cid.cfilter(c,tp)
	return (c:IsPreviousLocation(LOCATION_MZONE) or c:IsType(TYPE_MONSTER)) and (c:IsPreviousPosition(POS_FACEUP) or c:GetPreviousControler()==tp) and c:IsSetCard(0x7c4) and c:IsType(TYPE_MONSTER)
end
function cid.mffilter0(c)
	return c:IsCanBeFusionMaterial() and c:IsFaceup() and c:IsDestructable()
end
function cid.pffilter1(c)
	return c:IsOnField() and c:IsDestructable()
end
function cid.pffilter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x7c4) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function cid.pftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if not c:IsAbleToRemove() then return end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cid.pffilter1,nil)
		mg1:Merge(Duel.GetMatchingGroup(cid.mffilter0,tp,LOCATION_EXTRA,0,nil)+c)
		local res=Duel.IsExistingMatchingCard(cid.pffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)+c
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cid.pffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.pfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsAbleToRemove() or c:IsImmuneToEffect(e) then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cid.pffilter1,nil,e)
	mg1:Merge(Duel.GetMatchingGroup(cid.mffilter0,tp,LOCATION_EXTRA,0,nil)+c)
	local sg1=Duel.GetMatchingGroup(cid.pffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)+c
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cid.pffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Destroy(mat1-c,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
