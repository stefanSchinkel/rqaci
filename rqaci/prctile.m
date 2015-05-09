function p = percentile(X, Nk)

   X = squeeze(X);

   if length(Nk)~=length(Nk(:))                         % wrong Nk
      error('Nk must either be a scalar or a vector');
   else
      if (length(X)==length(X(:))) & (size(X,1)==1)     % X is 1D row
         X = X';
      end
   end

   x = [0, ([0.5 : (length(X)-0.5)] ./ length(X)) * 100, 100];
   y = [min(X); sort(X); max(X)];
   p = interp1(x, y, Nk);

