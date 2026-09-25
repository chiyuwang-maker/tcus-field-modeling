function medium = build_medium(bone_mask, P)
%BUILD_MEDIUM  Map synthetic bone mask to a two-material acoustic medium.
%   Naming: water / bone (formerly shui / lugu — Chinese pinyin for water / skull bone).
%   Absorption uses k-Wave power-law form:
%     alpha_coeff [dB/(MHz^y cm)], alpha_power = y (must be non-zero).
%   Values are demo nominals, not fitted to any real scan.

if nargin < 2 || isempty(P)
    P = demo_params();
end

water = 1 - bone_mask;   % shui → water
bone  = bone_mask;       % lugu → bone

medium.sound_speed = water * P.water.sound_speed + bone * P.bone.sound_speed;
medium.density     = water * P.water.density     + bone * P.bone.density;
medium.alpha_coeff = water * P.water.alpha_coeff + bone * P.bone.alpha_coeff;

% alpha_power: scalar is fine when a single power applies; here bone and water
% differ, so use a same-size map (supported by k-Wave when sizes match fields).
medium.alpha_power = water * P.water.alpha_power + bone * P.bone.alpha_power;
end
