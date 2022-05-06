create database mobilyasirket
use mobilyasirket
create table b�lge(
b�lgeid int primary key,
b�lgeadi varchar(30)
)
create table koltuk(
koltukid int primary key,
koltukt�r varchar(30),
koltukfiyat� int
)
create table dolap(
dolapid int primary key,
dolapt�r varchar(30),
dolapfiyati int
)
create table yatak(
yatakid int primary key,
yatakt�r varchar (30),
yatakfiyati int
)
create table masa(
masaid int primary key,
masat�r� varchar(15),
masafiyat int
)
create table tak�m(
tak�mid int primary key,
tak�madi varchar(15),
masaid int foreign key references masa(masaid),
koltukid int foreign key references koltuk(koltukid),
yatakid int foreign key references yatak(yatakid),
dolapid int foreign key references dolap(dolapid),
tak�mfiyat int
)
create table mobilya(
mobilyaid int primary key,
mobilyaadi varchar(15), 
tak�mid int foreign key references tak�m(tak�mid)
)
create table depo(
depoid int primary key,
depogiri� datetime,
depo��k�� datetime,
mobilyaid int foreign key references mobilya(mobilyaid)
)
create table reklam(
reklamid int primary key,
reklamadi varchar(15)
)

create table kampanya(
kampanyaid int primary key,
kampanyaadi varchar (15),
kampanyabaslang�c datetime,
kampanyabiti� datetime,
reklamid int foreign key references reklam(reklamid)
)
create table maas(
maasid int primary key,
maas�cret money,
maas�demetarihi datetime,
)

create table calisan(
calisanid int primary key,
calisanadi varchar (15),
calisansoyadi varchar (15),
calisanadres text,
�alisant�r varchar(20),
calisantel varchar (15),
maasid int foreign key references maas(maasid)
)


create table sube(
subeid int primary key,
subeadi varchar(15),
subeadres text,
subetel varchar(15),
b�lgeid int foreign key references b�lge(b�lgeid),
calisanid int foreign key references calisan(calisanid),
kampanyaid int foreign key references kampanya(kampanyaid)
)


create table m��teri(
m��teriid int primary key,
m��teriadi varchar (15),
m��terisoyadi varchar (15),
m��teriadresi text,
m��teritel varchar (15)
)
create table al�m(
al�mid int primary key,
mobilyaid int foreign key references mobilya(mobilyaid),
depoid int foreign key references depo(depoid),
subeid int foreign key references sube(subeid),
al�mfiyat int,
al�mtarih datetime
) 
create table sipari�_tak�m(
sipari�tak�mid int primary key,
tak�mid int foreign key references tak�m(tak�mid),
m��teri int foreign key references m��teri(m��teriid),
sipari�id int
)
create table sipari�_mobilya(
sipari�mobilyaid int primary key,
mobilyaid int foreign key references mobilya(mobilyaid),
m��teri int foreign key references m��teri(m��teriid),

)

create table �demesekli(
�demesekliid int primary key,
�demet�r� varchar(20)
)

create table fatura(
faturaid int primary key,
faturatarih datetime,
faturamiktar� int,
subeid int foreign key references sube(subeid),
sipari�mobilyaid int foreign key references sipari�_mobilya(sipari�mobilyaid),
siparistak�mid int foreign key references sipari�_tak�m(sipari�tak�mid),
�demesekliid int foreign key references �demesekli(�demesekliid)
)
create table iade(
iadeid int primary key,
iadenedeni text,

faturaid int foreign key references fatura(faturaid),
iadetarihi datetime
)


create table internet(
sipari�mobilyaid int foreign key references sipari�_mobilya(sipari�mobilyaid),
sipari�tak�mid int foreign key references sipari�_tak�m(sipari�tak�mid),
m��teriid int foreign key references m��teri(m��teriid),
faturaid int foreign key references fatura(faturaid),
�demesekliid int foreign key references �demesekli(�demesekliid)
)


--1.B�lgelerin isimlerini g�steren sql sorgusunu yaz�n�z
select *from b�lge

--2.M��terilerin bilgilerini g�steren sql sorgusunu yaz�n�z
select m��teri.m��teriadi from m��teri

--3.Tablolara s�tun eklemek i�in gerekli sql sorgusunu yaz�n�z.
Alter table Mobilya add Mobilyafiyat money
Alter table calisan add subeid int foreign key references sube(subeid)

--4.�al��anlar�n prim �cretini hesaplayan ve ekrana yazd�ran view yaz�n�z.
go
create view primi(adi,soyadi,primi)
as select calisan.calisanadi, calisan.calisansoyadi,(maas�cret*20/1000) from calisan,maas 
go

--5.Masa t�r�n�n ad�n� 'masa ismi de�i�ti'olarak de�i�tiren ve sonra eski haline getiren transaction yaz�n�z.
begin transaction
 save transaction deneme
  update masa set masat�r�='Masa ismi de�i�ti'
  select * from masa
  rollback transaction deneme
  select * from masa

  --6.Dolap tablosuna eklenen yeni kay�tlar i�in bir output yaz�n�z.
  declare @eklenenler table(
  dolapid int,
  dolapt�r varchar(30),
  dolapfiyati int
  )
  INSERT INTO dolap
  output INSERTED.dolapid,INSERTED.dolapt�r, INSERTED.dolapfiyati INTO @eklenenler
  Values('8','Erzak Dolab�','500')
  select *from @eklenenler

  --7.Maa�� 5000den az olan �al��anlar�n kay�tlar�n� silen tablo geri d�nd�ren fonksiyon yaz�n�z.
  go
  create function calisansil()
  returns int 
  as
  begin
  declare @calisansayisi int
  select @calisansayisi=count(*) from calisan where maasid in(select maasid from maas where maas�cret<5000)
  return @calisansayisi
  end 
  go
  select dbo.calisansil()

  --8.Tak�m sipari�i veren ve �deme t�r� kredi kart� olan m��terileri bulan ssql sorgusunu yaz�n�z.
  select *from m��teri where m��teriid in (select m��teri from sipari�_tak�m where sipari�tak�mid in 
  (select siparistak�mid from fatura where �demesekliid=1))

  --9.Tak�m fiyatlar�nda %25 indirim yapan bir transaction giriniz.
  begin transaction
  save transaction deneme)
  update tak�m set tak�mfiyat=tak�mfiyat-(tak�mfiyat*25/100)
  select*from tak�m
  rollback transaction deneme

-- 10.Fatura miktar� 5000den az olan ve geri iade edilen mobilyalar�n neler oldu�unu g�steren sql sorgusu yaz�n�z.
select *from mobilya where mobilyaid in ( select mobilyaid from sipari�_mobilya where sipari�mobilyaid in(
select sipari�mobilyaid from fatura where faturamiktar�<5500 and faturaid in( select faturaid from iade))) 

--11.�ubeleri B�lgelerine G�re S�ralayan sql sorgusunu yaz�n�z.
SELECT b�lgeadi, subeid, subeadi FROM sube
inner join b�lge  on b�lge.b�lgeid = sube.b�lgeid  order by b�lgeadi

--12.Maa�� 4000 ve 7000 aras�nda olan �al��anlar� sorgulyan ve maas �cretlerine g�re s�ralayan sql sorgusunu yaz�n�z
 select calisanadi , calisansoyadi , maas�cret 
 from calisan
 inner join maas on maas.maasid = calisan.maasid 
 where maas�cret > 4000 and maas�cret < 7000
 order by maas�cret

 --13.M��terilerin ad�n� k���k harfle yazan fonksiyon yaz�n�z.
 go
 create function k���kharf(@m��teriadi varchar(max))
 returns varchar(max)
 as
 begin
 return lower(@m��teriadi)
 end
 go
 select dbo.k���kharf(m��teri.m��teriadi) from m��teri
 go

 --14.M��terinin Soyad�n� b�y�k harf yapan fonksiyon giriniz.
 create function b�y�kharf(@m��terisoyadi varchar(max))
 returns varchar (max)
 as
 begin
 return upper(@m��terisoyadi)
 end
 go
 select dbo.b�y�kharf(m��teri.m��terisoyadi) from m��teri

 --15.�al��anlar�n Maa� ortalamas�n� bulan sql sorgusunu yaz�n�z.
 select avg(maas�cret) as 'Ortalama maa�'from maas where maasid in( select maasid from calisan)

 --16.Ege b�lgesinden tak�m alan m��terileri g�steren sql sorgusu yaz�n�z.
 select * from m��teri where m��teriid in( select m��teri from sipari�_tak�m inner join fatura on 
 sipari�_tak�m.sipari�tak�mid=fatura.siparistak�mid where faturaid in( select faturaid from sube where b�lgeid='1'))

 --17.G�revi maliye olan personlleri silen transaciton yaz�n�z. 
 begin transaction 
 save transaction deneme
 delete calisan where calisan.�alisant�r='maliye'
 select * from calisan
 rollback transaction deneme
 select*from calisan

 --18.Kampanya ad�n� ve ba�lang�� tarihini de�i�tiren view yaz�n�z
 go
 create view kampanya1(kampanyaad,kampanyaba�lang�c)
as select kampanyaadi='sonbahar kampanyas�', kampanyabaslang�c='03.09.2017' from kampanya
go

--Calisan tablosundaki sat�r say�s� g�steren sorgu
set nocount off
select *from calisan

--20.Maa�� 1000den az olan calisanlar� sil.
go 
create trigger deletetrigger
on calisan
after delete
as
print('calisan silindi')
delete from calisan where maasid in (select maasid from maas where maas�cret<1000)
select * from calisan-- maa�� 1000den az olanc calisan olmad��� i�in cal��anlar ayn� kal�r.

--21.depodan ayakkab�l�k al�m� yapan subeyi g�steren sql sorgusunu yaz�n�z.
 select * from sube,al�m
 where sube.subeid=al�m.subeid and al�m.mobilyaid=3 
 
 --22.�al��an ekleyen trigger� yaz�n�z.
go
create trigger calisanekle 
on calisan
after insert
as
print ('calisan eklendi')

select *from calisan
insert into calisan values(10,'Ahmet','solgun','Bilecik','Maliye','2222222','2','3')

--23.Sezon sonu indiriminde faturada %25indirim yapan sql sorgusunu yaz�n�z.
begin transaction deneme2
save transaction deneme2
begin
select distinct fatura.faturamiktar� from fatura,sube,kampanya
update fatura set faturamiktar�=faturamiktar�-(faturamiktar�*25/100) where subeid in(
select subeid from sube where kampanyaid in(select kampanyaid from kampanya where kampanyaid=2))
select fatura.faturamiktar� from fatura
end
rollback transaction deneme2
select distinct fatura.faturamiktar� from fatura
--

--24.Masa fiyat�n�n toplam masa fiyat�n�n ortalamas�na g�re durumunu g�steren sql sorgusunu yaz�n�z.
declare @fiyat int
set @fiyat=250
if(@fiyat>(select avg(masafiyat) from masa))
begin
print('masa fiyat� ortalaman�n �st�ndedir')
end
else
begin
print('masa fiyat� ortalaman�n alt�ndad�r')
end

--25. M��teri silinirken m��teriyi g�steren output 
declare @m��terisil table(
m��teriid int,
m��teriad varchar(20),
m��terisoyad varchar(20),
m��teriadres varchar(20),
m��teritel varchar(20)
)
delete from @m��terisil
output deleted.m��teriid, deleted.m��teriad, deleted.m��terisoyad,
 deleted.m��teriadres,deleted.m��teritel
 into @m��terisil where m��teriid=2
 select *from @m��terisil
 
 --26.Kemal uslunun maa� durumunu g�steren sql sorgusunu yaz�n�z
 declare @�cret1 int,
 @ortalama int
 set @�cret1=(select maas.maas�cret from maas,calisan where maas.maasid=calisan.maasid and calisanid=2)
 set @ortalama=(select avg(maas�cret) from maas)
 if(@�cret1>@ortalama)
 begin
 print('kemal uslu ortalaman�n �st�nde maa� almaktad�r')
 end
 else 
 begin
 print('kemal uslu ortalaman�n alt�nda maa� almaktad�r')
 end 

--27.Hangi personel hangi �ubede �al��t���n� g�steren sql sorgusunu yaz�n�z.
select calisan.calisanadi, sube.subeadi from calisan, sube where calisan.subeid=sube.subeid
 
 --28.Hangi �ubede hangi kampanya oldu�unu g�steren sql sorgusunu yaz�n�z
  select kampanya.kampanyaadi, sube.subeadi from kampanya,sube where kampanya.kampanyaid=sube.kampanyaid
 
 --29.Fatura miktar� 3500den fazla olan ve mobilya sipari�i veren
 --m��terinin ad�n�n ba� harfini ve soyad�ndan ilk 3 harfi g�steren sql sorgusunu yaz�n�z.
 select substring(m��teri.m��teriadi,1,1)+'.'+substring (m��teri.m��terisoyadi,0,3)as 'Ad Soyad' from m��teri 
 where m��teriid in( select m��teri from sipari�_mobilya where sipari�mobilyaid in( select sipari�mobilyaid 
 from fatura where faturamiktar�>3500))

 --30.Ege b�lgesindeki �ubelerden mobilya alan m��terileri bulan stored procedure yaz�n�z.
 go
 create proc sipari�
 as
 select m��teri.m��teriadi from m��teri where m��teriid in( select m��teri
from sipari�_mobilya where sipari�mobilyaid in(select sipari�mobilyaid from fatura where 
subeid in( select subeid from b�lge where b�lgeid=1)))
exec sipari�


--31.M��terilerin ad�n� ve soyad�n� birle�tirip m��teri ad�na g�re azalan s�ralayan sql yaz�n�z.
select m��teri.m��teriadi+''+m��teri.m��terisoyadi from m��teri order by m��teriadi desc


--32.��inde tek ki�ilik yatak olan tak�m� g�sten stored proc yaz�n�z
go
create proc kontrol
as 
begin
select tak�m.tak�madi from tak�m inner join yatak on tak�m.yatakid=yatak.yatakid where tak�m.yatakid=4
end
exec kontrol
drop proc kontrol/*proc silme komutu*/
