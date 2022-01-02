create table tbl_Users(
ID int identity(1,1),
Email varchar(50),
Password varchar(50)
)

declare
@psqlstr varchar(250),
@pcolumns varchar(250),
@pcolumns@ varchar(250),
@pcolumnstoupdate varchar(250),
@pcolumns56 varchar(250),
@pcolumns167 varchar(250),
@pcolumnsall varchar(1000),
@ptrantype varchar(15),
@pproc varchar(30),
@pcolumnxtype int,
@index int,
@maxColororder int,
@ptableName varchar(250),
@ptableId int
set @ptableName='tbl_Users'
set @index=1
set @pproc ='create proc up_'+ @ptableName
set @pcolumns=''
set @pcolumns@=''
set @pcolumnstoupdate=''
set @pcolumns167=''
set @ptrantype='@ptrantype = '
set @ptableId=(select so.id from  sysobjects so where xtype='U' and so.name=@ptableName)--burada id numarasýný set ettik.
set @maxColororder = (select max(colorder) from syscolumns sx where sx.id=@ptableId ) --kaç tane eleman olduðunun sayýsýný aldýk.
while @index<=@maxColororder
begin
set @pcolumnxtype =(select sc.xtype from  syscolumns sc where sc.id=@ptableId and sc.colorder=@index)
--select @pcolumnxtype
if @pcolumnxtype=56
begin
set @pcolumns56= '@p'+(select name from  syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+' int=null,'
end
else if @pcolumnxtype=167
begin
set @pcolumns167=+@pcolumns167+char(13)+'@p'+(select name from  syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+' varchar('+convert(nvarchar, (select sc.length from  syscolumns sc where sc.id=@ptableId and sc.colorder=@index))+')=null,'
end
set @index=@index+1
end
set @pcolumns167 = SUBSTRING(@pcolumns167,1,(len(@pcolumns167)-1)) --en sonda virgül getiriyor. bu satýrý yazmazsak yanlýþ bir syntax olacak hata alacaðýz.
set @index=2
while @index<=@maxColororder
begin
set @pcolumns=@pcolumns+','+(select name from syscolumns sc where sc.id=@ptableId and sc.colorder=@index)
set @pcolumns@=@pcolumns@+'@p'+(select name from syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+','
set @pcolumnstoupdate=(select name from syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+'='+'@p'+(select name from syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+','+@pcolumnstoupdate
set @index=@index+1
end
set @pcolumns='('+SUBSTRING(@pcolumns,2,(len(@pcolumns)))+')'
set @pcolumns@='('+SUBSTRING(@pcolumns@,1,(len(@pcolumns@)-1))+')'
set @pcolumnstoupdate=SUBSTRING(@pcolumnstoupdate,1,(len(@pcolumnstoupdate)-1))
set @pcolumnsall =@pproc+char(13)+'@ptrantype int,'+char(13)+@pcolumns56+@pcolumns167+char(13)+'as'+CHAR(13)+char(13)+
				 'if '+@ptrantype+'1'+CHAR(13)+'Begin'+CHAR(13)+'insert into '+@ptableName+@pcolumns+CHAR(13)+'values'+@pcolumns@+char(13)+'set '+SUBSTRING(@pcolumns56,1,4) +'='+'@@IDENTITY'+char(13)+'End'+CHAR(13)+CHAR(13)+
				 'else if ' +@ptrantype+'2'+CHAR(13)+'Begin'+CHAR(13)+'update '+@ptableName+char(13)+'set '+@pcolumnstoupdate+char(13)+'where '+SUBSTRING(@pcolumns56,3,2) +'='+SUBSTRING(@pcolumns56,1,4)+CHAR(13)+'End'+CHAR(13)+CHAR(13)+
				 'else if ' +@ptrantype+'3'+CHAR(13)+'Begin'+CHAR(13)+'delete '+@ptableName+' where '+SUBSTRING(@pcolumns56,3,2) +'='+SUBSTRING(@pcolumns56,1,4)+CHAR(13)+'End'+CHAR(13)+CHAR(13)+
				 'else if ' +@ptrantype+'4'+CHAR(13)+'Begin'+CHAR(13)+'select * from '+@ptableName+' where '+SUBSTRING(@pcolumns56,3,2) +'='+SUBSTRING(@pcolumns56,1,4)+CHAR(13)+'End'+CHAR(13)+CHAR(13)+
				 'else if ' +@ptrantype+'5'+CHAR(13)+'Begin'+CHAR(13)+'select * from '+@ptableName+' (nolock)'+char(13)+'End'+char(13)+char(13)+
				 'else if ' +@ptrantype+'6'+CHAR(13)+'Begin'+CHAR(13)+'select top 1 * from '+@ptableName+' (nolock)'+' where '+SUBSTRING(@pcolumns56,3,2) +'<'+SUBSTRING(@pcolumns56,1,4)+char(13)+'order by '+SUBSTRING(@pcolumns56,3,2)+' desc'+char(13)+'End'+char(13)+CHAR(13)+
				 'else if ' +@ptrantype+'7'+CHAR(13)+'Begin'+CHAR(13)+'select top 1 * from '+@ptableName+' (nolock)'+' where '+SUBSTRING(@pcolumns56,3,2) +'>'+SUBSTRING(@pcolumns56,1,4)+char(13)+'order by '+SUBSTRING(@pcolumns56,3,2)+char(13)+'End'+char(13)+CHAR(13)
print @pcolumnsall
--exec(@pcolumnsall)

alter proc up_tbl_Users@ptrantype int,@pID int=null,@pEmail varchar(50)=null,@pPassword varchar(50)=nullasif @ptrantype = 1Begininsert into tbl_Users(Email,Password)values(@pEmail,@pPassword)set @pID=@@IDENTITYselect @pID as ID Endelse if @ptrantype = 2Beginupdate tbl_Usersset Password=@pPassword,Email=@pEmailwhere ID=@pIDEndelse if @ptrantype = 3Begindelete tbl_Users where ID=@pIDEndelse if @ptrantype = 4Beginselect * from tbl_Users where ID=@pIDEndelse if @ptrantype = 5Beginselect * from tbl_Users (nolock)Endelse if @ptrantype = 6Beginselect top 1 * from tbl_Users (nolock) where ID<@pIDorder by ID descEndelse if @ptrantype = 7Beginselect top 1 * from tbl_Users (nolock) where ID>@pIDorder by IDEndelse if @ptrantype = 8Beginselect  * from tbl_Users (nolock) order by IDEndcreate table tbl_Customers(ID int identity(1,1),TCKN varchar(50),Adres varchar(50),Adý varchar(50),IBAN varchar(50))declare
@psqlstr varchar(250),
@pcolumns varchar(250),
@pcolumns@ varchar(250),
@pcolumnstoupdate varchar(250),
@pcolumns56 varchar(250),
@pcolumns167 varchar(250),
@pcolumnsall varchar(1000),
@ptrantype varchar(15),
@pproc varchar(30),
@pcolumnxtype int,
@index int,
@maxColororder int,
@ptableName varchar(250),
@ptableId int
set @ptableName='tbl_Customers'
set @index=1
set @pproc ='create proc up_'+ @ptableName
set @pcolumns=''
set @pcolumns@=''
set @pcolumnstoupdate=''
set @pcolumns167=''
set @ptrantype='@ptrantype = '
set @ptableId=(select so.id from  sysobjects so where xtype='U' and so.name=@ptableName)--burada id numarasýný set ettik.
set @maxColororder = (select max(colorder) from syscolumns sx where sx.id=@ptableId ) --kaç tane eleman olduðunun sayýsýný aldýk.
while @index<=@maxColororder
begin
set @pcolumnxtype =(select sc.xtype from  syscolumns sc where sc.id=@ptableId and sc.colorder=@index)
--select @pcolumnxtype
if @pcolumnxtype=56
begin
set @pcolumns56= '@p'+(select name from  syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+' int=null,'
end
else if @pcolumnxtype=167
begin
set @pcolumns167=+@pcolumns167+char(13)+'@p'+(select name from  syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+' varchar('+convert(nvarchar, (select sc.length from  syscolumns sc where sc.id=@ptableId and sc.colorder=@index))+')=null,'
end
set @index=@index+1
end
set @pcolumns167 = SUBSTRING(@pcolumns167,1,(len(@pcolumns167)-1)) --en sonda virgül getiriyor. bu satýrý yazmazsak yanlýþ bir syntax olacak hata alacaðýz.
set @index=2
while @index<=@maxColororder
begin
set @pcolumns=@pcolumns+','+(select name from syscolumns sc where sc.id=@ptableId and sc.colorder=@index)
set @pcolumns@=@pcolumns@+'@p'+(select name from syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+','
set @pcolumnstoupdate=(select name from syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+'='+'@p'+(select name from syscolumns sc where sc.id=@ptableId and sc.colorder=@index)+','+@pcolumnstoupdate
set @index=@index+1
end
set @pcolumns='('+SUBSTRING(@pcolumns,2,(len(@pcolumns)))+')'
set @pcolumns@='('+SUBSTRING(@pcolumns@,1,(len(@pcolumns@)-1))+')'
set @pcolumnstoupdate=SUBSTRING(@pcolumnstoupdate,1,(len(@pcolumnstoupdate)-1))
set @pcolumnsall =@pproc+char(13)+'@ptrantype int,'+char(13)+@pcolumns56+@pcolumns167+char(13)+'as'+CHAR(13)+char(13)+
				 'if '+@ptrantype+'1'+CHAR(13)+'Begin'+CHAR(13)+'insert into '+@ptableName+@pcolumns+CHAR(13)+'values'+@pcolumns@+char(13)+'set '+SUBSTRING(@pcolumns56,1,4) +'='+'@@IDENTITY'+char(13)+'End'+CHAR(13)+CHAR(13)+
				 'else if ' +@ptrantype+'2'+CHAR(13)+'Begin'+CHAR(13)+'update '+@ptableName+char(13)+'set '+@pcolumnstoupdate+char(13)+'where '+SUBSTRING(@pcolumns56,3,2) +'='+SUBSTRING(@pcolumns56,1,4)+CHAR(13)+'End'+CHAR(13)+CHAR(13)+
				 'else if ' +@ptrantype+'3'+CHAR(13)+'Begin'+CHAR(13)+'delete '+@ptableName+' where '+SUBSTRING(@pcolumns56,3,2) +'='+SUBSTRING(@pcolumns56,1,4)+CHAR(13)+'End'+CHAR(13)+CHAR(13)+
				 'else if ' +@ptrantype+'4'+CHAR(13)+'Begin'+CHAR(13)+'select * from '+@ptableName+' where '+SUBSTRING(@pcolumns56,3,2) +'='+SUBSTRING(@pcolumns56,1,4)+CHAR(13)+'End'+CHAR(13)+CHAR(13)+
				 'else if ' +@ptrantype+'5'+CHAR(13)+'Begin'+CHAR(13)+'select * from '+@ptableName+' (nolock)'+char(13)+'End'+char(13)+char(13)+
				 'else if ' +@ptrantype+'6'+CHAR(13)+'Begin'+CHAR(13)+'select top 1 * from '+@ptableName+' (nolock)'+' where '+SUBSTRING(@pcolumns56,3,2) +'<'+SUBSTRING(@pcolumns56,1,4)+char(13)+'order by '+SUBSTRING(@pcolumns56,3,2)+' desc'+char(13)+'End'+char(13)+CHAR(13)+
				 'else if ' +@ptrantype+'7'+CHAR(13)+'Begin'+CHAR(13)+'select top 1 * from '+@ptableName+' (nolock)'+' where '+SUBSTRING(@pcolumns56,3,2) +'>'+SUBSTRING(@pcolumns56,1,4)+char(13)+'order by '+SUBSTRING(@pcolumns56,3,2)+char(13)+'End'+char(13)+CHAR(13)
print @pcolumnsall
--exec(@pcolumnsall)


create proc up_tbl_Customers@ptrantype int,@pID int=null,@pTCKN varchar(50)=null,@pAdres varchar(50)=null,@pAdý varchar(50)=null,@pIBAN varchar(50)=nullasif @ptrantype = 1Begininsert into tbl_Customers(TCKN,Adres,Adý,IBAN)values(@pTCKN,@pAdres,@pAdý,@pIBAN)set @pID=@@IDENTITYselect @pID as ID Endelse if @ptrantype = 2Beginupdate tbl_Customersset IBAN=@pIBAN,Adý=@pAdý,Adres=@pAdres,TCKN=@pTCKNwhere ID=@pIDEndelse if @ptrantype = 3Begindelete tbl_Customers where ID=@pIDEndelse if @ptrantype = 4Beginselect * from tbl_Customers where ID=@pIDEndelse if @ptrantype = 5Beginselect * from tbl_Customers (nolock)Endelse if @ptrantype = 6Beginselect top 1 * from tbl_Customers (nolock) where ID<@pIDorder by ID descEndelse if @ptrantype = 7Beginselect top 1 * from tbl_Customers (nolock) where ID>@pIDorder by IDEnd