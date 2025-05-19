function ss_parallel_shutdowngcp
%
% Tries to shut down parallel pool.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 20/07/2023: Generated (SS)
% 22/08/2024: Last modified (SS)

%% .............................................................................Delete current parallel pool
try
    Pool = gcp('nocreate');
    delete(Pool);
    disp('I shut down the parallel pool for you.');
catch
    error('I could not shut down the parallel pool for you.');
end

end