create table tblTest
(ID int identity(1,1) not null,
 Name varchar(50) not null,
 Surname varchar(50) not null,
 ParentName varchar(50)  null
)

 ALTER TABLE tblTest ADD City varchar(50)

 Alter table tblTest Drop Column City

 

DECLARE @SAYAC INT 
SET @SAYAC=1
WHILE @SAYAC <= 20
BEGIN
  select @SAYAC
  insert into tblTest(Name,Surname) values(CONVERT(VARCHAR,@SAYAC)+'Name',CONVERT(VARCHAR,@SAYAC)+'Surname')
  SET @SAYAC = @SAYAC + 1
END

select * from tblTest


Truncate table tblTest

delete  tblTest

create procedure up_tblTest
@SAYAC int
AS
WHILE @SAYAC <= 20
BEGIN
  select @SAYAC
  insert into tblTest(Name,Surname) values(CONVERT(VARCHAR,@SAYAC)+'Name',CONVERT(VARCHAR,@SAYAC)+'Surname')
  SET @SAYAC = @SAYAC + 1
END

exec up_tblTest 2


alter procedure up_TableInfo
@tablename varchar(50)
as
declare @tableid int
set @tableid = ( select Id from sysobjects where xtype='U' and name='tblTest' and name=@tablename)  
select * from syscolumns where id = @tableid and number=0 


exec up_TableInfo tblTest


alter procedure up_crudtest
@pTranType int,
@pName varchar(50) = null,
@pSurname varchar(50) = null,
@pParentName varchar(50) = null,
@pID int = null
as --aldýðý deðerleri tabloya insert et
if @pTranType=1
begin
insert into tblTest(Name,Surname,ParentName) values (@pName,@pSurname,@pParentName)
set @pID= @@IDENTITY
select @pID
end
else if @pTranType = 2
begin 
update tblTest set Name=@pName,Surname=@pSurname,ParentName=@pParentName where ID=@pID
end

else if @pTranType = 3
begin --id deðeri ile kaydý sil
delete from tblTest where ID=@pID
end

else if @pTranType = 4
begin --id deðeri ile kaydý select et
select Name,Surname,ParentName from tblTest where ID=@pID
end

else if @pTranType = 5
begin --id deðeri ile kaydý select * all yap
select * from tblTest 
end

else if @pTranType = 6
begin --id deðeri ile bir önceki kaydý getir
select top 1 * from tblTest(nolock) where ID<@pID order by ID desc
end

else if @pTranType = 7
begin --id deðeri ile bir sonraki kaydý getir

select top 1 * from tblTest(nolock) where ID>@pID order by ID desc
end

exec up_crudtest  @pTranType = 7,@pId=18

select * from tblTest

-----

select * from sysobjects where xtype='U' and name='tblTest'

select * from syscolumns where id=597577167

alter procedure up_crudtest
@pName varchar(50) = null,
@pSurname varchar(50) = null,
@pParentName varchar(50) = null,
@pID int = null
as
select '@p'+ name +case when xtype=56 then ' int=null'
                      when xtype=167 then ' varchar (50) null'
					  end 
					  from ##tmp_table
while up_crudtest

					  

exec up_crudtest 'ss','ss','ss'

select s.name,s.xtype,s.colorder into ##tmp_table  from syscolumns s where id=1525580473
select * from ##tmp_table
drop table ##tmp_table