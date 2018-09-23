function [data1, data2] = removeNaN(data1, data2)
% This function removes entries from two datasets if the value in either of them is NaN

[~, iNAN] = find(isnan(data1));
data1(:, iNAN) = [];
data2(:, iNAN) = [];

[~, iNAN] = find(isnan(data2));
data1(:, iNAN) = [];
data2(:, iNAN) = [];
