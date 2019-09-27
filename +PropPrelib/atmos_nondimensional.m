function [theta, delta, sigma] = atmos_nondimensional(h, varargin)
%DEPRECATED, now just a forwarder for atmos
import PropPrelib.*;
[~, ~, ~, ~, theta, delta, sigma] = atmos(h, varargin{:});
end

