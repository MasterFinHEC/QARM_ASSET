%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EMPIRICAL METHODS FOR FINANCE
% Homework I
%
% Benjamin Souane, Antoine-Michel Alexeev and Julien Bisch
% Due Date: 5 March 2020
%==========================================================================

close all
clc

%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 38);

% Specify sheet and range
opts.Sheet = "Energy";
opts.DataRange = "A1:AL7946";

% Specify column names and types
opts.VariableNames = ["date", "BrentOil", "NatGas", "LightCrudeOil", "Gasoline", "GasOil", "HeatingOil", "Coal", "Bitcoin", "JGB10Y", "US5Y", "US10Y", "US30Y", "GM5Y", "GM10Y", "COCOA", "COPPER", "CORN", "COTTON", "GOLD", "CATTLE", "SILVER", "SOYBEANS", "SUGAR", "WHEAT", "DAX", "FTSE100", "KOSPI200", "NASDAQ100", "NIKKEI225", "SP500", "CAC40", "AUDUSD", "CADUSD", "CHFUSD", "EURUSD", "GBPUSP", "JPYUSD"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, "date", "InputFormat", "");

% Import the data
QARMDATA = readtable("C:\Users\Benjamin\OneDrive\1. HEC\Master\MScF 4.2\5. QARM\2020\QARM_Project\QARM_DATA.xlsx", opts, "UseExcel", false);
clear opts

%% Creating the vector we will use

txt = QARMDATA.Properties.VariableNames; %Extract the Variables Names
names = txt(2:end); %Vector of Names (Mainly used for plots)
price = table2array(QARMDATA(2:end,2:end)); %Take out the date from the matrix of price
date = datetime(table2array(QARMDATA(2:end,1))); %Vector of date

%%

% Setting parameters out of the financial returns 
N = length(price); %Vector setting the duration of the strategy
asset = size(price,2); %Vector setting the number of asset classes at our disposal

%Find the first non NAN Value
firstData = zeros(1,asset);
for i = 1:asset
firstData(1,i) = find (~ isnan (price(:,i)), 1);
end