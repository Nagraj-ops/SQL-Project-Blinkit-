

use [Blinkit DB]
select * from dbo.BlinkIT_Data;
select count(*) from BlinkIT_Data;

UPDATE BlinkIT_Data
set Item_Fat_Content =
case 
when Item_Fat_Content in ('LF', 'low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end

select distinct(Item_Fat_Content) from BlinkIT_Data;

---Total Sales

select cast(sum(Total_sales)/1000000 as decimal(10,2)) as Total_Sales
from BlinkIT_Data

---Avg Sales

select cast(avg(Total_Sales) as decimal (10,1))as Avg_Sales from BlinkIT_Data

---No Of Items

select count(*) as N0_Of_Items from BlinkIT_Data

---Avg Rating

select cast(avg(Rating) as decimal(10,2)) as Avg_Rating from BlinkIT_Data

--Item Fat Content Anlysis on year wise

select Item_Fat_Content, 
        cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
        cast(avg(Total_Sales) as decimal (10,1))as Avg_Sales,
        count(*) as N0_Of_Items,
        cast(avg(Rating) as decimal(10,2)) as Avg_Rating
from BlinkIT_Data
where Outlet_Establishment_Year = 2022
group by Item_Fat_Content
order by Total_sales Desc

---Item Type Analysis on 

select top 5 Item_Type, 
        cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
        cast(avg(Total_Sales) as decimal (10,1))as Avg_Sales,
        count(*) as N0_Of_Items,
        cast(avg(Rating) as decimal(10,2)) as Avg_Rating
from BlinkIT_Data
group by Item_Type
order by Total_sales asc;

---Fat content by Outlet for total Sales

select Outlet_Location_Type,
       ISNULL([Low Fat], 0) as Low_Fat,
       ISNULL([Regular], 0) as Regular
from
(
    select Outlet_Location_Type, Item_Fat_Content,
        cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
    from BlinkIT_Data
    group by Outlet_Location_Type, Item_Fat_Content
) as SourceTable
PIVOT
(       
     sum(Total_Sales)
     for Item_Fat_Content in ([Low Fat], [Regular])
) as PivotTable
Order by Outlet_Location_Type;

---Total Sales by Year

select Outlet_establishment_Year,
        cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
from BlinkIT_Data
group by Outlet_establishment_Year
order by Outlet_Establishment_Year asc

--percentage of sales

select Outlet_Size,
        cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
        cast((sum(Total_Sales)*100.0 / sum(sum(Total_Sales)) over ()) as decimal(10,2)) as sales_Percentage
from BlinkIT_Data
group by Outlet_Size
order by Total_Sales desc;

--Slaes by Outlet Location

select Outlet_Location_Type, 
        cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
        cast(avg(Total_Sales) as decimal (10,1))as Avg_Sales,
        cast((sum(Total_Sales)*100.0 / sum(sum(Total_Sales)) over ()) as decimal(10,2)) as sales_Percentage,
        count(*) as N0_Of_Items,
        cast(avg(Rating) as decimal(10,2)) as Avg_Rating
from BlinkIT_Data
group by Outlet_Location_Type
order by Total_sales asc;

--All metrics by Outlet

select Outlet_Type, 
        cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
        cast(avg(Total_Sales) as decimal (10,1))as Avg_Sales,
        cast((sum(Total_Sales)*100.0 / sum(sum(Total_Sales)) over ()) as decimal(10,2)) as sales_Percentage,
        count(*) as N0_Of_Items,
        cast(avg(Rating) as decimal(10,2)) as Avg_Rating
from BlinkIT_Data
group by Outlet_Type
order by Total_sales asc;


select * from dbo.BlinkIT_Data;

----Stored Procedure

alter procedure spitemtypebyprameter
(
   @Item_Type varchar(40),
   @Outlet_Establishment_year int
)
as
begin

select * from BlinkIT_Data where Item_Type = @Item_Type and Outlet_Establishment_Year = @Outlet_Establishment_year

end

spitemtypebyprameter 'Canned', 2012


create procedure spoutletlocationtypebyprameter
(
   @Outlet_Location_type varchar(40)
)
as
begin

select * from BlinkIT_Data where Outlet_Location_type = @Outlet_Location_type

end

spoutletlocationtypebyprameter 'Tier 1';

---crete view--

create view blinkit_view as

select Item_Fat_Content, Item_Type, Outlet_Location_type from BlinkIT_Data

where Item_Fat_Content = 'Regular';

drop view blimkit_data;
drop view blimkit_view;
drop view blinkit_view;

select * from blinkit_view

 












