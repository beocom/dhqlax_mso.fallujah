// Written by BON_IF
// Adapted by EightySix

_objects = _this;

{
	_x addEventHandler ["HandleDamage", {
		_damage = _this select 2;
		_projectile = _this select 4;

		if(_projectile == "PipeBomb" || _projectile == "ACE_PipebombExplosion") then { 1 } else { 0 };
	}];

} foreach _objects;
