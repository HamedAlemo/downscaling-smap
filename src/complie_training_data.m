function [inputs, target] = complie_training_data(SMInput, NDVIInput, SMTarget)


[iNAN, ~] = find(isnan(SMInput));
SMInput(iNAN, :) = [];
NDVIInput(iNAN, :) = [];
SMTarget(iNAN, :) = [];

[iNAN, ~] = find(isnan(SMTarget));
SMInput(iNAN, :) = [];
NDVIInput(iNAN, :) = [];
SMTarget(iNAN, :) = [];

[iNAN, ~] = find(SMInput==0);
SMInput(iNAN, :) = [];
NDVIInput(iNAN, :) = [];
SMTarget(iNAN, :) = [];

NDVI = [NDVIInput(:, 1), mean(NDVIInput, 2)];
inputs = [SMInput'; NDVI'];
target = SMTarget';