function medium = build_medium(bone_mask)
%BUILD_MEDIUM  Map demo bone mask to a simple two-material acoustic medium.

shui = ones(size(bone_mask)) - bone_mask;

lugu_speed = 3360;
lugu_density = 1750;
lugu_alpha = 0.8 * (0.5e6)^1.35;

shui_speed = 1580;
shui_density = 1000;
shui_alpha = 0.02 * (5e5)^2;

medium.sound_speed = shui * shui_speed + bone_mask * lugu_speed;
medium.density     = shui * shui_density + bone_mask * lugu_density;
medium.alpha_coeff = shui * shui_alpha + bone_mask * lugu_alpha;
medium.alpha_power = 0;
end
