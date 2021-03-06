#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import numpy as np
import sklearn as sk
import matplotlib.pyplot as plt 
from openpyxl import load_workbook
from scipy import stats
from gekko import GEKKO
from scipy.optimize import minimize
from pandas.plotting import scatter_matrix
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sklearn.metrics import r2_score as r2_error
import math

get_ipython().run_line_magic('matplotlib', 'inline')

xlsx = pd.ExcelFile("Folds5x2_pp.xlsx")
data = pd.read_excel(xlsx, "Sheet3")
#print(data)

df1 = data[0:7501] #Training Data
#print(df1)


df2 = data[7501:] #Test Data
#print(df2)

writer = pd.ExcelWriter("Folds5x2_pp.xlsx", engine = "openpyxl")
book = load_workbook("Folds5x2_pp.xlsx")
writer.book = book
df1.to_excel(writer,sheet_name= "Training_Data", index=False)
df2.to_excel(writer,sheet_name= "Test_Data", index=False)
writer.save()
writer.close()


mean1 = np.mean(df1) #1 is Training
mean2 = np.mean(df2) #2 is Test

median1 = np.median(df1,axis=0)
median2 = np.median(df2,axis=0)

mode1 = stats.mode(df1)
mode2 = stats.mode(df2)

stdev1 = np.std(df1)
stdev2 = np.std(df2)

var1 = np.var(df1)
var2 = np.var(df2)


# print("Training Mode:\n",mode1)
# print("Training Mean:\n",mean1)

# print("Training Median:\n",median1)
# print("Training Standard Deviation:\n", stdev1)
# print("Training Variance:\n", var1)
# print(\n)
# print("Test Mode:\n",mode2)
# print("Test Mean:\n",mean2)
# print("Test Median:\n",median2)
# print("Test Standard Deviation:\n", stdev2)
# print("Test Variance:\n",var2)


#scatter_matrix(df1,figsize = (15,12),diagonal='kde')
#scatter matrix of Training Data, diagonal kernel density instead of histogram

np.corrcoef(df1,rowvar=False)
#bottom-most row=PE,numbers closest to 1 are best choice
#Best to Worst: AP, RH, V. AP is 3rd column(.522), RH=.389, V=-.869



normalized_training = sk.preprocessing.normalize(df1)
normalized_test = sk.preprocessing.normalize(df2)
#print(normalized_training)



X = df1.iloc[:,1:2].values
# V=[:,1:2],AP=[:,2:3],RH=[:,3:4],PE=[:,4:5]
Y = df1.iloc[:,4:5].values
reg = LinearRegression(normalize=True)
reg.fit(X,Y)
Y_pred = reg.predict(X)
#reg.coef_
# plt.figure(figsize=(25,15))
# plt.scatter(X,Y)
# plt.plot(X,Y_pred,color='red')
# plt.axis([20,110,420,500])
# plt.show()
# mean_squared_error(Y,Y_pred)
# r2_error(Y,Y_pred)


# In[17]:


xm1 = np.array(df1["V"])
xm2 = np.array(df1["AP"])
xm3 = np.array(df1["RH"])
ym = np.array(df1["PE"])

# In[22]:

def calc_y(x):
    a = x[0]
    b = x[1]
    c = x[2]
    d = x[3]
    #y = a * xm1 + b  # linear regression
    y = a * ( xm1 ** b ) * ( xm2 ** c ) * ( xm3 ** d )
    return y

# define objective
def objective(x):
    # calculate y
    y = calc_y(x)
    # calculate objective
    obj = 0.0
    for i in range(len(ym)):
        obj = obj + ((y[i]-ym[i])/ym[i])**2    
    # return result
    return obj

# initial guesses
x0 = np.zeros(4)
x0[0] = 0.0 # a
x0[1] = 0.0 # b
x0[2] = 0.0 # c
x0[3] = 0.0 # d

# show initial objective
print('Initial Objective: ' + str(objective(x0)))

# optimize
# bounds on variables
my_bnds = (-100.0, 100.0)
bnds = (my_bnds, my_bnds, my_bnds, my_bnds)
solution = minimize(objective, x0, method='SLSQP', bounds=bnds)
x = solution.x
y = calc_y(x)

# show final objective
cObjective = 'Final Objective: ' + str(objective(x))
print(cObjective)

# print solution
print('Solution')

cA = 'A = ' + str(x[0])
print(cA)
cB = 'B = ' + str(x[1])
print(cB)
cC = 'C = ' + str(x[2])
print(cC)
cD = 'D = ' + str(x[3])
print(cD)

cFormula = "Formula: " + "\n" +             r"$A * V^B * AP^C * RH^D$"
cLegend = cFormula + "\n" + cA + "\n" + cB + "\n"            + cC + "\n" + cD + "\n" + cObjective

#ym measured outcome
#y  predicted outcome

from scipy import stats
slope, intercept, r_value, p_value, std_err = stats.linregress(ym,y)
r2 = r_value**2
cR2 = "R^2 correlation = " + str(r_value**2)
print(cR2)

# plot solution
plt.figure(1)
plt.title('Actual (YM) versus Predicted (Y) Outcomes For Non-Linear Regression')
plt.plot(ym,y,'o')
plt.xlabel('Measured Outcome (YM)')
plt.ylabel('Predicted Outcome (Y)')
plt.legend([cLegend])
plt.grid(True)
plt.show()

