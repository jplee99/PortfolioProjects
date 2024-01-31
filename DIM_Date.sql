-- Cleaning DIM_DataTable
SELECT TOP (1000) [DateKey]
      ,[FullDateAlternateKey] AS Date,
      --,[DayNumberOfWeek]
      [EnglishDayNameOfWeek] AS Day,
      --,[SpanishDayNameOfWeek]
      --,[FrenchDayNameOfWeek]
      --[DayNumberOfMonth]
      --,[DayNumberOfYear]
      [WeekNumberOfYear] AS WeekNr,
      [EnglishMonthName] AS Month,
	  LEFT([EnglishMonthName],3) AS MonthShort,
      --,[SpanishMonthName]
      --,[FrenchMonthName]
      [MonthNumberOfYear] As MonthNo,
      [CalendarQuarter] AS Quarter,
      [CalendarYear] AS Year
      --,[CalendarSemester]
      --,[FiscalQuarter]
      --,[FiscalYear]
      --,[FiscalSemester]
  FROM [AdventureWorksDW2019].[dbo].[DimDate]
  Where [CalendarYear] >= 2019