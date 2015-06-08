//+------------------------------------------------------------------+
//|                                                      i-VaR95.mq5 |
//|                                       Copyright © 2009, piccioli | 
//|                                    http://piccstick.blogspot.com |
//+------------------------------------------------------------------+
//| Indicator shows the values of history volatility                 |
//| It is possible to calculate a volatility in several methods      |
//|  - Simple Historical Volatility                                  |
//|  - Exponential Historical Volatility                             |
//|  - High-Low Historical Volatility                                |
//|                                                                  |  
//| A few commentaries:                                              |
//| 1. This indicator does not show the entry points of the market   |
//|    and exit points too ;-)                                       |
//| 2. The indicator image is similar to the ATR indicator image,    |
//|    particularly when calculating by Parkinson method.            |
//|    Nevertheless the values are different                         |
//| 3. For the VaR calculation the 95-percentage probability is used,|
//|    that is the indicator shows a value in points (without        | 
//|    5-th character), which may be achieved by price with          |
//|    the propability of 5% for a period which equal to investment  |
//|    horizon (grznt)                                               |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, piccioli@gmail.com"
#property link      "http://piccstick.blogspot.com"
//----
#property description "Indicator shows the values of history volatility"
#property description "Some remarks: "
#property description "1. This indicator does not show the entry and exit points of the market"
#property description "2. The indicator image is similar to the ATR indicator image, particularly"
#property description "   when calculating by Parkinson method. Nevertheless the values are different"
#property description "3. For the VaR calculation the 95-percentage probability is used,"
#property description "   that is the indicator shows a value in points, which may be achieved by price"
#property description "   with the propability of 5% for a period which equal to investment horizon (grznt)"
//---- indicator version number
#property version   "1.00"
//---- drawing indicator in a separate window
#property indicator_separate_window
//---- number of indicator buffers
#property indicator_buffers 2 
//---- only one plot is used
#property indicator_plots   1
//+-----------------------------------+
//|  Indicator drawing parameters     |
//+-----------------------------------+
//---- drawing the indicator as a three-color histogram
#property indicator_type1 DRAW_COLOR_HISTOGRAM
//---- the following colors are used
#property indicator_color1 clrGray,clrIndianRed,clrDodgerBlue
//---- the indicator line is a continuous curve
#property indicator_style1 STYLE_SOLID
//---- indicator line width is equal to 4
#property indicator_width1  2
//---- displaying the indicator label
#property indicator_label1  "HistVolatility"
//+-----------------------------------+
//|  Declaration of enumerations      |
//+-----------------------------------+
enum MODE //Type of constant
  {
   SHV = 1,     //Simple Historical Volatility
   EHV,         //Exponential Historical Volatility
   HLHV,        //High-Low Historical Volatility
   VaR95        //95-процентный VaR
  };
//+-----------------------------------+
//|  INDICATOR INPUT PARAMETERS       |
//+-----------------------------------+
input int HV_Period = 21;     // history volatility calculation period
input MODE Mode=SHV;          // Method of calculation      
input double decline=0.94;    // smoothing ratio
                              // Traditionally equals to 0.94
                              // this parameter only affects to the exponential-weighted method
input int grznt=3;            // investment horizon to calculation the 95% VaR
input int Shift=0;            // horizontal shift of the indicator in bars
//+-----------------------------------+
//---- indicator buffers
double LineBuffer[],ColorLineBuffer[];
//---- Declaration of integer variables of data starting point
int min_rates_total;
//+------------------------------------------------------------------+   
//| HistVolatility initialization function                           | 
//+------------------------------------------------------------------+ 
void OnInit()
  {
//---- Initialization of variables of the start of data calculation
   min_rates_total=HV_Period+1;

//---- set dynamic array as an indicator buffer
   SetIndexBuffer(0,LineBuffer,INDICATOR_DATA);
//---- moving the indicator 1 horizontally
   PlotIndexSetInteger(0,PLOT_SHIFT,Shift);
//---- performing the shift of beginning of indicator drawing
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total+1);
//---- setting the indicator values that won't be visible on a chart
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,EMPTY_VALUE);
//---- indexing elements in the buffer as time series
   ArraySetAsSeries(LineBuffer,true);

//---- setting dynamic array as a color index buffer   
   SetIndexBuffer(1,ColorLineBuffer,INDICATOR_COLOR_INDEX);
//---- indexing elements in the buffer as time series
   ArraySetAsSeries(ColorLineBuffer,true);

//---- initializations of variable for indicator short name
   string shortname;
   StringConcatenate(shortname,"Historical Volatility(",HV_Period,")");
//--- creation of the name to be displayed in a separate sub-window and in a pop up help
   IndicatorSetString(INDICATOR_SHORTNAME,shortname);
//--- determining the accuracy of displaying the indicator values
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+1);
//---- end of initialization
  }
//+------------------------------------------------------------------+ 
//| HistVolatility iteration function                                | 
//+------------------------------------------------------------------+ 
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---- checking the number of bars to be enough for calculation
   if(rates_total<min_rates_total) return(0);

//---- Declaration of integer variables and getting the bars already calculated
   int limit,bar;

//---- calculations of the necessary amount of data to be copied and
//the starting number limit for the bar recalculation loop
   if(prev_calculated>rates_total || prev_calculated<=0)// checking for the first start of the indicator calculation
     {
      limit=rates_total-1-min_rates_total; // starting index for the calculation of all bars
     }
   else
     {
      limit=rates_total-prev_calculated; // starting index for the calculation of new bars
     }

//---- indexing elements in arrays as timeseries  
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(spread,true);

//---- Main calculation loop of the indicator
   for(bar=limit; bar>=0 && !IsStopped(); bar--)LineBuffer[bar]=HistoricalVolatility(Mode,low,high,close,spread,bar);

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
double HistoricalVolatility(MODE mode,const double &Low[],const double &High[],const double &Close[],const int &Spread[],int index)
  {
//----
   int start=int(HV_Period+index-1);

   switch(mode)
     {
      case SHV:
        {
         double tshv=0;
         for(int i=start; i>=index; i--) tshv+=MathLog(Close[i+1]/Close[i+1]);
         tshv/=HV_Period;

         double shv=0;
         for(int i=start; i>=index; i--) shv+=(tshv -(MathLog(Close[i]/Close[i+1])))*(tshv -(MathLog(Close[i]/Close[i+1])));
         return(MathSqrt(shv/(HV_Period-1)));
        }

      case EHV:
        {
         double tshv=0;
         for(int i=start; i>=index; i--) tshv+=MathLog(Close[i+1]/Close[i+1]);
         tshv/=HV_Period;

         double shv=0;
         for(int i=start; i>=index; i--) shv+=(tshv -(MathLog(Close[i]/Close[i+1])))*(tshv -(MathLog(Close[i]/Close[i+1])));
         shv=MathSqrt(shv/(HV_Period-1));
         double ehv=MathSqrt((1-decline)*shv);
        }

      case HLHV:
        {
         double hlhv=0;
         for(int i=start; i>=index; i--) hlhv+=(MathLog(High[i]/Low[i])*MathLog(High[i]/Low[i]))/(4*MathLog(2));
         return(MathSqrt(hlhv/HV_Period));
        }

      case VaR95:
        {
          double tshv=0;
         for(int i=start; i>=index; i--) tshv+=MathLog(Close[i+1]/Close[i+1]);
         tshv/=HV_Period;

         double shv=0;
         for(int i=start; i>=index; i--) shv+=(tshv -(MathLog(Close[i]/Close[i+1])))*(tshv -(MathLog(Close[i]/Close[i+1])));
         shv=MathSqrt(shv/(HV_Period-1));
          return(1.65 *(shv)*10000*MathSqrt(grznt)+2*Spread[index]);
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
