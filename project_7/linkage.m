function Z = linkage(Y, method, pdistArg, varargin)

[k, n] = size(Y);
m = ceil(sqrt(2*n)); % m = (1+sqrt(1+8*n))/2, but works for large n
if k>1  % data matrix input
    if nargin<2
        method = 'single';
    end
    if nargin<3
        pdistArg = 'euclidean';
    end
    nargs = 3;
else % distance matrix input or bad input
    nargs = nargin;
end

if nargs>=3 % should be data input
    if k == 1 && m*(m-1)/2 == n
         warning(message('stats:linkage:CallingPDIST'));
    end
    if k < 2
        error(message('stats:linkage:TooFewDistances'));
    end
    passX = true; % the input is the data matrix.
    
    if ischar(pdistArg)
        pdistArg = {pdistArg};
    elseif ~iscell(pdistArg)
        error(message('stats:linkage:BadPdistArgs'));
    end
        
else % should be distance input
    passX = false;
    if n < 1
        error(message('stats:linkage:TooFewDistances'));
    end
    if k ~= 1 || m*(m-1)/2 ~= n
        error(message('stats:linkage:BadSize'));
    end
    
end

% Selects appropriate method
if nargs == 1 % set default switch to be 'si'
    methodStr = 'single';
else
    %           Preferred   Synonym
    methods = {'single',   'nearest'; ...
               'complete', 'farthest'; ...
               'average',  'upgma'; ...
               'weighted', 'wpgma'; ...
               'centroid', 'upgmc'; ...
               'median',   'wpgmc'; ...
               'ward''s',  'incremental'};
    [methodStr,s] = internal.stats.getParamVal(method,methods(:),'METHOD');

    if s>size(methods,1)
        methodStr = methods{s-size(methods,1), 1};
    end
end
method = methodStr(1:2);


nonEuc = false;
isCeMeWa = false;
if any(strcmp(method,{'ce' 'me' 'wa'}))
    isCeMeWa = true;
    if ~passX % The distance matrix is passed
        if (any(~isfinite(Y)) || ~iseuclidean(Y))
            warning(message('stats:linkage:NotEuclideanMatrix', methodStr));
        end
    else % the data matrix is passed
      
        if (~isempty(pdistArg))
            if (~ischar (pdistArg{1}))
                nonEuc = true;
            else
                %  method may be a known name or the name of a user function
                distMethods = {'euclidean'; 'minkowski';'mahalanobis'};
                i = find(strncmpi(pdistArg{1}, distMethods, length(pdistArg{1})));
                if length(i) > 1
                    error(message('stats:linkage:BadDistance', pdistArg{ 1 }));
                elseif (isempty(i) || i == 3 || ...
                  (i == 2 && length(pdistArg) ~= 1 && isscalar(pdistArg{2}) && pdistArg{2} ~= 2) )
                    nonEuc = true;
                end
            end
            
        end
        if (nonEuc)
            warning(message('stats:linkage:NotEuclideanMethod', methodStr));
        end
    end
end

%Parse the memory efficient option 'Savememory'
pnames ={'savememory'};
dflts = {[]};

[memEff] = internal.stats.parseArgs(pnames, dflts, varargin{:});

if ~isempty(memEff)
    memEff = internal.stats.getParamVal(memEff,{'on'; 'off'},'SaveMemory');
    memEff = strcmp(memEff,'on');
end


if passX && isCeMeWa && ~nonEuc
    if isempty(memEff) %Set the default choice for memEff
        if  n<=20
            memEff = true;
        else
            memEff = false;
        end
        
        try
            tempDistMat=zeros(1,k*(k-1)/2,class(Y));
        catch ME
            if (strcmp(ME.identifier,'MATLAB:nomem') || ...
                strcmp(ME.identifier,'MATLAB:pmaxsize'));
             memEff = true;          
            else % Otherwise, just let the error propagate.
                throw(ME);
            end
        end
        clear tempDistMat;
    end
else
    if ~isempty(memEff) && memEff
       warning(message('stats:linkage:IgnoringMemEff'));
    end
    memEff = false; 
end

if exist('linkagemex','file')==3
    % call mex file
    if passX
        if (memEff)
            %call the memory efficient algorithm
            Z = linkagemex(Y',method,{'euc'},memEff); %note that Y is transposed here
        else
           Z = linkagemex(Y,method,pdistArg, memEff);
        end
    else
        Z = linkagemex(Y,method);
    end
    
    if any(strcmp(method,{'av' 'wa' 'co' 'we'}))
    % if 'ave','ward', 'com' or 'weighted average' is used, we need to 
    % re-arrange the rows in Z matrix by sorting the third rows of Z matrix.
      Z = rearrange(Z);
    end
else
    warning(message('stats:linkage:NoMexFilePresent'));
    if passX
        Y = pdist(Y,pdistArg{:});
    end
    % optional old linkage function (use if mex file is not present)
    Z = linkageold(Y,method);
end


zdiff = diff(Z(:,3));
if any(zdiff<0)

    negLocs = find(zdiff<0);
    if any(abs(zdiff(negLocs)) > eps(Z(negLocs,3))) % eps(the larger of the two values)
        warning(message('stats:linkage:NonMonotonicTree', methodStr));
    end
end



function Z = linkageold(Y, method)

n = size(Y,2);
m = ceil(sqrt(2*n)); % (1+sqrt(1+8*n))/2, but works for large n
if isa(Y,'single')
   Z = zeros(m-1,3,'single'); % allocate the output matrix.
else
   Z = zeros(m-1,3); % allocate the output matrix.
end


N = zeros(1,2*m-1);
N(1:m) = 1;
n = m; % since m is changing, we need to save m in n.
R = 1:n;


if any(strcmp(method,{'ce' 'me' 'wa'}))
   Y = Y .* Y;
end

for s = 1:(n-1)
   if strcmp(method,'av')
      p = (m-1):-1:2;
      I = zeros(m*(m-1)/2,1);
      I(cumsum([1 p])) = 1;
      I = cumsum(I);
      J = ones(m*(m-1)/2,1);
      J(cumsum(p)+1) = 2-p;
      J(1)=2;
      J = cumsum(J);
      W = N(R(I)).*N(R(J));
      [v, k] = min(Y./W);
   else
      [v, k] = min(Y);
   end

   i = floor(m+1/2-sqrt(m^2-m+1/4-2*(k-1)));
   j = k - (i-1)*(m-i/2)+i;

   Z(s,:) = [R(i) R(j) v]; % update one more row to the output matrix A

   % Update Y. In order to vectorize the computation, we need to compute
   % all the indices corresponding to cluster i and j in Y, denoted by I
   % and J.
   I1 = 1:(i-1); I2 = (i+1):(j-1); I3 = (j+1):m; % these are temp variables
   U = [I1 I2 I3];
   I = [I1.*(m-(I1+1)/2)-m+i i*(m-(i+1)/2)-m+I2 i*(m-(i+1)/2)-m+I3];
   J = [I1.*(m-(I1+1)/2)-m+j I2.*(m-(I2+1)/2)-m+j j*(m-(j+1)/2)-m+I3];

   switch method
   case 'si' % single linkage
      Y(I) = min(Y(I),Y(J));
   case 'co' % complete linkage
      Y(I) = max(Y(I),Y(J));
   case 'av' % average linkage
      Y(I) = Y(I) + Y(J);
   case 'we' % weighted average linkage
      Y(I) = (Y(I) + Y(J))/2;
   case 'ce' % centroid linkage
      K = N(R(i))+N(R(j));
      Y(I) = (N(R(i)).*Y(I)+N(R(j)).*Y(J)-(N(R(i)).*N(R(j))*v)./K)./K;
   case 'me' % median linkage
      Y(I) = (Y(I) + Y(J))/2 - v /4;
   case 'wa' % Ward's linkage
      Y(I) = ((N(R(U))+N(R(i))).*Y(I) + (N(R(U))+N(R(j))).*Y(J) - ...
	  N(R(U))*v)./(N(R(i))+N(R(j))+N(R(U)));
   end
   J = [J i*(m-(i+1)/2)-m+j];
   Y(J) = []; % no need for the cluster information about j.

   % update m, N, R
   m = m-1;
   N(n+s) = N(R(i)) + N(R(j));
   R(i) = n+s;
   R(j:(n-1))=R((j+1):n);
end

if any(strcmp(method,{'ce' 'me' 'wa'}))
   Z(:,3) = sqrt(Z(:,3));
end

Z(:,[1 2])=sort(Z(:,[1 2]),2);



function Z = rearrange(Z)
  %Get indices to sort Z
    [~,idx] = sort(Z(:,3));
    
    % Get indices in the reverse direction
    revidx(idx) = 1:length(idx);
    
    % Get vector of desired cluster numbers for Z2
    nrows=size(Z,1);
    v2 = [1:nrows+1,nrows+1+revidx];
    
    % Put Z2 into sorted order, without renumbering the clusters
    Z = Z(idx,:);
    
    % Renumber the clusters
    Z(:,1:2) = v2(Z(:,1:2));
    
    % Make sure the lower-numbered cluster is in column 1
    t = Z(:,1)>Z(:,2);
    Z(t,1:2) = Z(t,[2 1]);
    
    % is Z in chronological order?
    if any((Z(:,2) >= (1:nrows)'+nrows+1))
        Z = fixnonchronologicalZ(Z);
        t = Z(:,1)>Z(:,2);
        Z(t,1:2) = Z(t,[2 1]);
    end

function Z = fixnonchronologicalZ(Z)
% Fixes a binary tree that has branches defined in a non-chronological order  
 
nl = size(Z,1)+1; % number of leaves
nb = size(Z,1); % number of branches
last = nl; % last defined node, we start only with leaves
for i = 1:nb
    tn = nl+i; %this node
    if any(Z(i,[1,2])>last)
        % this node (tn) uses nodes not defined yet, find a node (h) that
        % does use nodes already defined so we can interchange them:
        h = find(all(Z(i+1:end,[1 2])<=last,2),1)+i;
        % change nodes:
        Z([i h],:) = Z([h i],:);
        nn = nl+h; % new node
        % change references to such nodes
        %Z([find(Z(1:2*nb) == nn,1) find(Z(1:2*nb) == tn,1)]) = [tn nn];          
        %try
        tonn=find(Z(1:2*nb) == tn,1);
        Z([find(Z(1:2*nb) == nn,1)]) = [tn];          
        %catch,keyboard;end
        if(~isempty(tonn))
          Z(tonn) = [nn];          
        end
    end
    last = tn;
end