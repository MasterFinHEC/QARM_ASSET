function [Weights] = TrendFollowVolParity(TargetVol,Prices)
%This function compute the weights of the Trend following strategy under a 
%volatility parity weighting scheme

%INPUT
% TargetVol : The targeted Volatility of the Strategy
% FinancialReturns : A time series of financial price

%************************
%OUPUT
% Weights : A matrix of weights for each asset class each futur
% Returns : A vector of monthly returns
% Sharpe : The Sharpe Ratio of the strategy
% Turn : The Turnover of the strategy

%Returns,Sharpe,Turn
% Setting parameters out of the financial returns 
N = length(Prices); %Vector setting the duration of the strategy
asset = size(Prices,2); %Vector setting the number of asset classes at our disposal

%Find the first non NAN Value
firstData = zeros(1,asset);
for i = 1:asset
firstData(1,i) = find (~ isnan (Prices(:,i)), 1);
end
% Computing Daily returns 
SimpleReturn = Prices(2:end,:)./Prices(1:end-1,:) + 1;


% Computing the initial signal of the strategy 
iniSignal = zeros(1,asset);
for i = 1:asset
   iniSignal(i) = prod(SimpleReturn(1:252,i));
   
     if iniSignal(i) > 0
         
       iniSignal(i) = 1;
       
     else
            
       iniSignal(1) = -1;
    end
end 


% Computing the initial (90 days) volatility to set up the Weights 
VolIni = std(SimpleReturn(252-90:252,:));
TotalVolIni = sum(VolIni); 

%Computing the inital (theoric) weights
WgrossIni = zeros(1,asset);
for i = 1:asset
    
    WgrossIni(i) = (VolIni(i).^-1)/TotalVolIni.^-1;
    
end 

%Computing the running volatltiy after 60 days and Leveraging the position
IniRisk = sqrt(var(WgrossIni*SimpleReturn(253:253+59,:).')); 
leverageIni = TargetVol/IniRisk;


%Implementing the strategy
weights = [];
position = 1;


%While Computing the weights for each month
for i = 312:20:length(Prices)
  vola = std(SimpleReturn(i-90:i,:));
  sumvola = sum(vola);
   for j = 1:asset
    %Computing the Gross weights
  
    weights(position,j) = (vola(j).^-1)/((sumvola).^-1);
  
   end
   position = position + 1;
end 

Weights = weights;



end

