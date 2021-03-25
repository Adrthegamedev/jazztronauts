if SERVER then
	AddCSLuaFile()
end

SWEP.Base					= "weapon_base"
SWEP.PrintName				= "Hacking Goggles"
SWEP.Slot					= 0
SWEP.Category				= "Jazztronauts"
SWEP.Purpose				= "Peek into the inner I/O workings of the map"
SWEP.WepSelectIcon			= Material( "weapons/weapon_hacker.png" )

SWEP.ViewModel				= "models/weapons/c_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_pistol.mdl"

SWEP.UseHands		= true

SWEP.HoldType				= "duel"

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

SWEP.Primary.Delay			= 0.1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Sound			= Sound( "weapons/357/357_fire2.wav" )
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo		= "none"

SWEP.Spawnable				= true
SWEP.RequestInfo			= {}

-- List this weapon in the store
local storeHacker = jstore.Register(SWEP, 35000, { type = "tool" })

local upgrade_enableWrites = jstore.Register("hacker_write", 500000, {
	name = "Privilege Escalation",
	cat = "Hacking Goggles",
	desc = "Enables write access on the hacking goggles to manually trigger map I/O events",
	type = "upgrade",
	requires = storeHacker
})

function SWEP:Initialize()

	self.BaseClass.Initialize( self )
	self:SetWeaponHoldType( self.HoldType )

	if CLIENT then
		hook.Add("JazzShouldDrawHackerview", self, function()
			return self:ShouldDrawHackerview()
		end)
	end
end

function SWEP:ShouldDrawHackerview()
	if IsValid(self.Owner) and self.Owner != LocalPlayer() then
		hook.Remove("JazzShouldDrawHackerview", self)
		return
	end

	if self.Owner != LocalPlayer() or self.Owner:GetActiveWeapon() != self then return 0 end
	if !unlocks.IsUnlocked("store", self.Owner, upgrade_enableWrites) then return 1 end
	return 2 //Turbo
end

function SWEP:SetupDataTables()
	--self.BaseClass.SetupDataTables( self )
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()

	return true
end


function SWEP:DrawWorldModel()

end

function SWEP:PreDrawViewModel(viewmodel, weapon, ply)

end

function SWEP:ViewModelDrawn( viewmodel )

end

function SWEP:DrawHUD()

end

function SWEP:CalcViewModelView( viewmodel, oldpos, oldang, pos, ang )

	return pos, ang

end

function SWEP:CalcView( ply, pos, ang, fov )

	return pos, ang, fov

end

function SWEP:Think()

end

function SWEP:CanPrimaryAttack()

	return false

end

function SWEP:PrimaryAttack()

	self.BaseClass.PrimaryAttack( self )

end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	surface.SetDrawColor(255, 255, 255, alpha)
	if self.WepSelectIcon then
		surface.SetMaterial(self.WepSelectIcon)
	else
		surface.SetTexture("weapons/swep")
	end

	surface.DrawTexturedRect(x + w / 2 - 128, y + h / 2 - 64, 256, 128)
	self:PrintWeaponInfo(x + w + 20, y + h, alpha)
end

function SWEP:Reload() return false end
function SWEP:CanSecondaryAttack() return false end
