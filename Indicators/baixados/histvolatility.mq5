//+------------------------------------------------------------------+
//|                                               HistVolatility.mq5 | 
//|                              Copyright © 2008, Victor Umnyashkin |
//|                                                   v354@hotbox.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Victor Umnyashkin"
#property link      "v354@hotbox.ru"
//---- indicator version number
#property version   "1.00"
//---- drawing indicator in a separate window
#property indicator_separate_window
//---- number of indicator buffers
#property indicator_buffers 2 
//---- only one plot is used
#property indicator_plots   1
//+-----------------------------------+
//|  Indicator drawing parameters   |
//+-----------------------------------+
//---- drawing the indicator as a three-color histogram
#property indicator_type1 DRAW_COLOR_HISTOGRAM
//---- the following colors are used
#property indicator_color1 clrGray,clrPurple,clrDarkTurquoise
//---- the indicator line is a continuous curve
#property indicator_style1 STYLE_SOLID
//---- the indicator line width is 4
#property indicator_width1  2
//---- displaying the indicator label
#property indicator_label1  "HistVolatility"
//+-----------------------------------+
//|  declaration of enumerations          |
//+-----------------------------------+
enum Scale_ //Type of the constant
  {
   S1_ = 1,     //1
   S2_,         //2
   S3_          //3
  };
//+-----------------------------------+
//|  INDICATOR INPUT PARAMETERS     |
//+-----------------------------------+
input int Per=21;
input Scale_ Scale=S3_;
input int Trading_Day_In_Year=365;
input int Percent=100;
input double Coeff=1;
input int Shift=0; // horizontal shift of the indicator in bars
//+-----------------------------------+
//---- indicator buffers
double LineBuffer[],ColorLineBuffer[];
//---- Declaration of integer variables of data starting point
int YearBase,min_rates_total;
//+------------------------------------------------------------------+   
//| HistVolatility initialization function                           | 
//+------------------------------------------------------------------+ 
void OnInit()
  {
//---- Initialization of variables of data starting point
   min_rates_total=Per+1;

//---- Initialization of variables
   YearBase=Trading_Day_In_Year*PeriodSeconds(PERIOD_D1)/PeriodSeconds(PERIOD_CURRENT);

//---- setting dynamic array as indicator buffer
   SetIndexBuffer(0,LineBuffer,INDICATOR_DATA);
//---- shifting the indicator 1 horizontally
   PlotIndexSetInteger(0,PLOT_SHIFT,Shift);
//---- shifting the starting point of the indicator drawing
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total+1);
//---- setting the indicator values that will be invisible on the chart
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
//---- indexing elements in the buffer as time series
   ArraySetAsSeries(LineBuffer,true);

//---- setting dynamic array as a color index buffer   
   SetIndexBuffer(1,ColorLineBuffer,INDICATOR_COLOR_INDEX);
//---- indexing elements in the buffer as time series
   ArraySetAsSeries(ColorLineBuffer,true);

//---- initialization of a variable for a short name of the indicator
   string shortname;
   StringConcatenate(shortname,"HistVolatility(",Per,")");
//--- creating a name to be displayed in a separate subwindow and in a tooltip
   IndicatorSetString(INDICATOR_SHORTNAME,shortname);
//--- determining the accuracy of displaying the indicator values
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+1);
//---- end of initialization
  }
//+------------------------------------------------------------------+ 
//| HistVolatility iteration function                                | 
//+------------------------------------------------------------------+ 
int OnCalculate(
                const int rates_total,    // history in bars at the current tick
                const int prev_calculated,// history in bars at the previous tick
                const int begin,          // number of beginning of reliable counting of bars
                const double &price[]     // price array for the indicator calculation
                )
  {
//---- checking for the sufficiency of the number of bars for the calculation
   if(rates_total<min_rates_total+begin) return(0);

//---- Declaration of variables with a floating point  
   double Volatility;
//---- Declaration of integer variables and getting the bars already calculated
   int limit,bar;

//---- calculations of the necessary amount of data to be copied and
//the starting number limit for the bar recalculation loop
   if(prev_calculated>rates_total || prev_calculated<=0)// checking for the first start of the indicator calculation
     {
      limit=rates_total-1-min_rates_total-begin; // starting index for the calculation of all bars
     }
   else
     {
      limit=rates_total-prev_calculated; // starting index for the calculation of new bars
     }

//---- indexing array elements as time series  
   ArraySetAsSeries(price,true);

//---- Main indicator calculation loop
   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {

      Volatility=WVHiVol(Per,price,bar,Scale);
      LineBuffer[bar]=Volatility*MathSqrt(1.0*YearBase/Per)*Percent*Coeff;
     }

   if(prev_calculated>rates_total || prev_calculated<=0) limit--;
//---- Main indicator coloring loop
   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {
      ColorLineBuffer[bar]=0;
      if(LineBuffer[bar]>LineBuffer[bar+1]) ColorLineBuffer[bar]=2;
      if(LineBuffer[bar]<LineBuffer[bar+1]) ColorLineBuffer[bar]=1;
     }
//----     
   return(rates_total);
  }
//+------------------------------------------------------------------+  
//| Custom iteration function                                        | 
//+------------------------------------------------------------------+
double WVHiVol(int N,const double &Price[],int index,Scale_ IsLog)
  {
//----
   double Mid,MidLog,MidIncr,delta,Vol,VolLog,VolIncr;

   Mid=0;
   MidIncr=0;
   MidLog=0;

   for(int i=0; i<N; i++)
     {
      delta=Price[index+i]-Price[index+i+1];
      Mid+=delta;
      delta/=Price[index+i];
      MidIncr+=delta;
      delta=Price[index+i]/Price[index+i+1];
      MidLog+=MathLog(delta);
     }

   Vol=0;
   VolLog=0;
   VolIncr=0;

   for(int i=0; i<N; i++)
     {
      delta=Price[index+i]-Price[index+i+1];
      Vol+=(delta-Mid)*(delta-Mid);
      delta/=Price[i];
      VolIncr+=(delta-MidIncr)*(delta-MidIncr);
      delta=MathLog(Price[index+i]/Price[index+i+1]);
      VolLog+=(delta-MidLog)*(delta-MidLog);
     }

   if(IsLog == S2_) return(MathSqrt(Vol/(N-1.0)));
   if(IsLog == S1_) return(MathSqrt(VolIncr/(N-1.0)));
//----
   return(MathSqrt(VolLog/(N-1.0)));
  }
//+------------------------------------------------------------------+
