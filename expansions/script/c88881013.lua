--Number card00: Galaxy-Eyes Intergalactic Dragon
local card = c88881013
local m=88881013
local cm=_G["c"..m]
cm.dfc_front_side=m-1000
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function card.initial_effect(c)
  --Xyz Summon
  c:EnableReviveLimit()
  --(1) This card can only be Xyz Summoned by the effect of a "Rank-Up-Magic" spell card or by the effect of a "CREATION" Pendulum monster.
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(card.splimit)
  c:RegisterEffect(e1)
  --(2) This card cannot be destroyed in battle while it has material.
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetCondition(card.indescon)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(3) Once per turn, you can detach 1 material: banish 1 monster your opponent controls for each card in your Pendulum Zone, then, gain ATK equal to half the banished monster(s) combined ATK.
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(88880013,0))
  e3:SetCategory(CATEGORY_REMOVE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCost(card.atkcost)
  e3:SetTarget(card.atktg)
  e3:SetOperation(card.atkop)
  e3:SetCountLimit(1)
  c:RegisterEffect(e3)
  local exx=Effect.CreateEffect(c)
  exx:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  exx:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  exx:SetCode(EVENT_TURN_END)
  exx:SetRange(LOCATION_MZONE)
  exx:SetCondition(card.artcon)
  exx:SetOperation(card.artop)
  c:RegisterEffect(exx)
  --(4) When this card destroys a monster by battle: deal damage equal to the destroyed monsters ATK. 
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(88880013,1))
  e4:SetCategory(CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetCode(EVENT_BATTLE_DESTROYING)
  e4:SetTarget(card.damtg)
  e4:SetOperation(card.damop)
  c:RegisterEffect(e4)
  --(5) Any monster sent to the GY is banished instead.
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD)
  e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
  e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
  e5:SetRange(LOCATION_MZONE)
  e5:SetTargetRange(0,0xff)
  e5:SetValue(LOCATION_REMOVED)
  e5:SetTarget(card.rmtg)
  c:RegisterEffect(e5)
end
card.xyz_number=300
--(1) spsummon limit
function card.splimit(e,se,sp,st)
  return (se:GetHandler():IsSetCard(0x95) and se:GetHandler():IsType(TYPE_SPELL)) or (se:GetHandler():IsSetCard(0x889) and (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER)) and se:GetHandler():IsType(TYPE_PENDULUM))
end
--(2) This card cannot be destroyed in battle while it has material.
function card.indescon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayCount()>0
end
--(3) Once per turn, you can detach 1 material: banish 1 monster your opponent controls for each card in your Pendulum Zone, then, gain ATK equal to half the banished monster(s) combined ATK.
function card.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function card.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function card.atkop(e,tp,eg,ep,ev,re,r,rp)
  local ht=Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)
  if ht==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,ht,nil)
  local c=e:GetHandler()
  local atk=rg:GetSum(Card.GetAttack)
  if rg:GetCount()>0 then
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk/2)
	c:RegisterEffect(e1)
  end
end
function card.artcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetOriginalCode()==m or c:GetOriginalCode()==cm.dfc_front_side)
end
function card.artop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Senya.TransformDFCCard(c)
end
--(4) When this card destroys a monster by battle: deal damage equal to the destroyed monsters ATK.
function card.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local bc=e:GetHandler():GetBattleTarget()
  Duel.SetTargetCard(bc)
  local dam=bc:GetAttack()
  if dam<0 then dam=0 end
  Duel.SetTargetPlayer(1-tp)
  Duel.SetTargetParam(dam)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function card.damop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=tc:GetAttack()
	if dam<0 then dam=0 end
	Duel.Damage(p,dam,REASON_EFFECT)
  end
end
--(5) Any card sent to the GY is banished instead.
function card.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end