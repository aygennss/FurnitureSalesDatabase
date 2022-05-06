create database mobilyasirket
use mobilyasirket
create table bölge(
bölgeid int primary key,
bölgeadi varchar(30)
)
create table koltuk(
koltukid int primary key,
koltuktür varchar(30),
koltukfiyatý int
)
create table dolap(
dolapid int primary key,
dolaptür varchar(30),
dolapfiyati int
)
create table yatak(
yatakid int primary key,
yataktür varchar (30),
yatakfiyati int
)
create table masa(
masaid int primary key,
masatürü varchar(15),
masafiyat int
)
create table takým(
takýmid int primary key,
takýmadi varchar(15),
masaid int foreign key references masa(masaid),
koltukid int foreign key references koltuk(koltukid),
yatakid int foreign key references yatak(yatakid),
dolapid int foreign key references dolap(dolapid),
takýmfiyat int
)
create table mobilya(
mobilyaid int primary key,
mobilyaadi varchar(15), 
takýmid int foreign key references takým(takýmid)
)
create table depo(
depoid int primary key,
depogiriþ datetime,
depoçýkýþ datetime,
mobilyaid int foreign key references mobilya(mobilyaid)
)
create table reklam(
reklamid int primary key,
reklamadi varchar(15)
)

create table kampanya(
kampanyaid int primary key,
kampanyaadi varchar (15),
kampanyabaslangýc datetime,
kampanyabitiþ datetime,
reklamid int foreign key references reklam(reklamid)
)
create table maas(
maasid int primary key,
maasücret money,
maasödemetarihi datetime,
)

create table calisan(
calisanid int primary key,
calisanadi varchar (15),
calisansoyadi varchar (15),
calisanadres text,
çalisantür varchar(20),
calisantel varchar (15),
maasid int foreign key references maas(maasid)
)


create table sube(
subeid int primary key,
subeadi varchar(15),
subeadres text,
subetel varchar(15),
bölgeid int foreign key references bölge(bölgeid),
calisanid int foreign key references calisan(calisanid),
kampanyaid int foreign key references kampanya(kampanyaid)
)


create table müþteri(
müþteriid int primary key,
müþteriadi varchar (15),
müþterisoyadi varchar (15),
müþteriadresi text,
müþteritel varchar (15)
)
create table alým(
alýmid int primary key,
mobilyaid int foreign key references mobilya(mobilyaid),
depoid int foreign key references depo(depoid),
subeid int foreign key references sube(subeid),
alýmfiyat int,
alýmtarih datetime
) 
create table sipariþ_takým(
sipariþtakýmid int primary key,
takýmid int foreign key references takým(takýmid),
müþteri int foreign key references müþteri(müþteriid),
sipariþid int
)
create table sipariþ_mobilya(
sipariþmobilyaid int primary key,
mobilyaid int foreign key references mobilya(mobilyaid),
müþteri int foreign key references müþteri(müþteriid),

)

create table ödemesekli(
ödemesekliid int primary key,
ödemetürü varchar(20)
)

create table fatura(
faturaid int primary key,
faturatarih datetime,
faturamiktarý int,
subeid int foreign key references sube(subeid),
sipariþmobilyaid int foreign key references sipariþ_mobilya(sipariþmobilyaid),
siparistakýmid int foreign key references sipariþ_takým(sipariþtakýmid),
ödemesekliid int foreign key references ödemesekli(ödemesekliid)
)
create table iade(
iadeid int primary key,
iadenedeni text,

faturaid int foreign key references fatura(faturaid),
iadetarihi datetime
)


create table internet(
sipariþmobilyaid int foreign key references sipariþ_mobilya(sipariþmobilyaid),
sipariþtakýmid int foreign key references sipariþ_takým(sipariþtakýmid),
müþteriid int foreign key references müþteri(müþteriid),
faturaid int foreign key references fatura(faturaid),
ödemesekliid int foreign key references ödemesekli(ödemesekliid)
)


--1.Bölgelerin isimlerini gösteren sql sorgusunu yazýnýz
select *from bölge

--2.Müþterilerin bilgilerini gösteren sql sorgusunu yazýnýz
select müþteri.müþteriadi from müþteri

--3.Tablolara sütun eklemek için gerekli sql sorgusunu yazýnýz.
Alter table Mobilya add Mobilyafiyat money
Alter table calisan add subeid int foreign key references sube(subeid)

--4.Çalýþanlarýn prim ücretini hesaplayan ve ekrana yazdýran view yazýnýz.
go
create view primi(adi,soyadi,primi)
as select calisan.calisanadi, calisan.calisansoyadi,(maasücret*20/1000) from calisan,maas 
go

--5.Masa türünün adýný 'masa ismi deðiþti'olarak deðiþtiren ve sonra eski haline getiren transaction yazýnýz.
begin transaction
 save transaction deneme
  update masa set masatürü='Masa ismi deðiþti'
  select * from masa
  rollback transaction deneme
  select * from masa

  --6.Dolap tablosuna eklenen yeni kayýtlar için bir output yazýnýz.
  declare @eklenenler table(
  dolapid int,
  dolaptür varchar(30),
  dolapfiyati int
  )
  INSERT INTO dolap
  output INSERTED.dolapid,INSERTED.dolaptür, INSERTED.dolapfiyati INTO @eklenenler
  Values('8','Erzak Dolabý','500')
  select *from @eklenenler

  --7.Maaþý 5000den az olan çalýþanlarýn kayýtlarýný silen tablo geri döndüren fonksiyon yazýnýz.
  go
  create function calisansil()
  returns int 
  as
  begin
  declare @calisansayisi int
  select @calisansayisi=count(*) from calisan where maasid in(select maasid from maas where maasücret<5000)
  return @calisansayisi
  end 
  go
  select dbo.calisansil()

  --8.Takým sipariþi veren ve ödeme türü kredi kartý olan müþterileri bulan ssql sorgusunu yazýnýz.
  select *from müþteri where müþteriid in (select müþteri from sipariþ_takým where sipariþtakýmid in 
  (select siparistakýmid from fatura where ödemesekliid=1))

  --9.Takým fiyatlarýnda %25 indirim yapan bir transaction giriniz.
  begin transaction
  save transaction deneme)
  update takým set takýmfiyat=takýmfiyat-(takýmfiyat*25/100)
  select*from takým
  rollback transaction deneme

-- 10.Fatura miktarý 5000den az olan ve geri iade edilen mobilyalarýn neler olduðunu gösteren sql sorgusu yazýnýz.
select *from mobilya where mobilyaid in ( select mobilyaid from sipariþ_mobilya where sipariþmobilyaid in(
select sipariþmobilyaid from fatura where faturamiktarý<5500 and faturaid in( select faturaid from iade))) 

--11.Þubeleri Bölgelerine Göre Sýralayan sql sorgusunu yazýnýz.
SELECT bölgeadi, subeid, subeadi FROM sube
inner join bölge  on bölge.bölgeid = sube.bölgeid  order by bölgeadi

--12.Maaþý 4000 ve 7000 arasýnda olan çalýþanlarý sorgulyan ve maas ücretlerine göre sýralayan sql sorgusunu yazýnýz
 select calisanadi , calisansoyadi , maasücret 
 from calisan
 inner join maas on maas.maasid = calisan.maasid 
 where maasücret > 4000 and maasücret < 7000
 order by maasücret

 --13.Müþterilerin adýný küçük harfle yazan fonksiyon yazýnýz.
 go
 create function küçükharf(@müþteriadi varchar(max))
 returns varchar(max)
 as
 begin
 return lower(@müþteriadi)
 end
 go
 select dbo.küçükharf(müþteri.müþteriadi) from müþteri
 go

 --14.Müþterinin Soyadýný büyük harf yapan fonksiyon giriniz.
 create function büyükharf(@müþterisoyadi varchar(max))
 returns varchar (max)
 as
 begin
 return upper(@müþterisoyadi)
 end
 go
 select dbo.büyükharf(müþteri.müþterisoyadi) from müþteri

 --15.Çalýþanlarýn Maaþ ortalamasýný bulan sql sorgusunu yazýnýz.
 select avg(maasücret) as 'Ortalama maaþ'from maas where maasid in( select maasid from calisan)

 --16.Ege bölgesinden takým alan müþterileri gösteren sql sorgusu yazýnýz.
 select * from müþteri where müþteriid in( select müþteri from sipariþ_takým inner join fatura on 
 sipariþ_takým.sipariþtakýmid=fatura.siparistakýmid where faturaid in( select faturaid from sube where bölgeid='1'))

 --17.Görevi maliye olan personlleri silen transaciton yazýnýz. 
 begin transaction 
 save transaction deneme
 delete calisan where calisan.çalisantür='maliye'
 select * from calisan
 rollback transaction deneme
 select*from calisan

 --18.Kampanya adýný ve baþlangýç tarihini deðiþtiren view yazýnýz
 go
 create view kampanya1(kampanyaad,kampanyabaþlangýc)
as select kampanyaadi='sonbahar kampanyasý', kampanyabaslangýc='03.09.2017' from kampanya
go

--Calisan tablosundaki satýr sayýsý gösteren sorgu
set nocount off
select *from calisan

--20.Maaþý 1000den az olan calisanlarý sil.
go 
create trigger deletetrigger
on calisan
after delete
as
print('calisan silindi')
delete from calisan where maasid in (select maasid from maas where maasücret<1000)
select * from calisan-- maaþý 1000den az olanc calisan olmadýðý için calýþanlar ayný kalýr.

--21.depodan ayakkabýlýk alýmý yapan subeyi gösteren sql sorgusunu yazýnýz.
 select * from sube,alým
 where sube.subeid=alým.subeid and alým.mobilyaid=3 
 
 --22.Çalýþan ekleyen triggerý yazýnýz.
go
create trigger calisanekle 
on calisan
after insert
as
print ('calisan eklendi')

select *from calisan
insert into calisan values(10,'Ahmet','solgun','Bilecik','Maliye','2222222','2','3')

--23.Sezon sonu indiriminde faturada %25indirim yapan sql sorgusunu yazýnýz.
begin transaction deneme2
save transaction deneme2
begin
select distinct fatura.faturamiktarý from fatura,sube,kampanya
update fatura set faturamiktarý=faturamiktarý-(faturamiktarý*25/100) where subeid in(
select subeid from sube where kampanyaid in(select kampanyaid from kampanya where kampanyaid=2))
select fatura.faturamiktarý from fatura
end
rollback transaction deneme2
select distinct fatura.faturamiktarý from fatura
--

--24.Masa fiyatýnýn toplam masa fiyatýnýn ortalamasýna göre durumunu gösteren sql sorgusunu yazýnýz.
declare @fiyat int
set @fiyat=250
if(@fiyat>(select avg(masafiyat) from masa))
begin
print('masa fiyatý ortalamanýn üstündedir')
end
else
begin
print('masa fiyatý ortalamanýn altýndadýr')
end

--25. Müþteri silinirken müþteriyi gösteren output 
declare @müþterisil table(
müþteriid int,
müþteriad varchar(20),
müþterisoyad varchar(20),
müþteriadres varchar(20),
müþteritel varchar(20)
)
delete from @müþterisil
output deleted.müþteriid, deleted.müþteriad, deleted.müþterisoyad,
 deleted.müþteriadres,deleted.müþteritel
 into @müþterisil where müþteriid=2
 select *from @müþterisil
 
 --26.Kemal uslunun maaþ durumunu gösteren sql sorgusunu yazýnýz
 declare @ücret1 int,
 @ortalama int
 set @ücret1=(select maas.maasücret from maas,calisan where maas.maasid=calisan.maasid and calisanid=2)
 set @ortalama=(select avg(maasücret) from maas)
 if(@ücret1>@ortalama)
 begin
 print('kemal uslu ortalamanýn üstünde maaþ almaktadýr')
 end
 else 
 begin
 print('kemal uslu ortalamanýn altýnda maaþ almaktadýr')
 end 

--27.Hangi personel hangi þubede çalýþtýðýný gösteren sql sorgusunu yazýnýz.
select calisan.calisanadi, sube.subeadi from calisan, sube where calisan.subeid=sube.subeid
 
 --28.Hangi þubede hangi kampanya olduðunu gösteren sql sorgusunu yazýnýz
  select kampanya.kampanyaadi, sube.subeadi from kampanya,sube where kampanya.kampanyaid=sube.kampanyaid
 
 --29.Fatura miktarý 3500den fazla olan ve mobilya sipariþi veren
 --müþterinin adýnýn baþ harfini ve soyadýndan ilk 3 harfi gösteren sql sorgusunu yazýnýz.
 select substring(müþteri.müþteriadi,1,1)+'.'+substring (müþteri.müþterisoyadi,0,3)as 'Ad Soyad' from müþteri 
 where müþteriid in( select müþteri from sipariþ_mobilya where sipariþmobilyaid in( select sipariþmobilyaid 
 from fatura where faturamiktarý>3500))

 --30.Ege bölgesindeki þubelerden mobilya alan müþterileri bulan stored procedure yazýnýz.
 go
 create proc sipariþ
 as
 select müþteri.müþteriadi from müþteri where müþteriid in( select müþteri
from sipariþ_mobilya where sipariþmobilyaid in(select sipariþmobilyaid from fatura where 
subeid in( select subeid from bölge where bölgeid=1)))
exec sipariþ


--31.Müþterilerin adýný ve soyadýný birleþtirip müþteri adýna göre azalan sýralayan sql yazýnýz.
select müþteri.müþteriadi+''+müþteri.müþterisoyadi from müþteri order by müþteriadi desc


--32.Ýçinde tek kiþilik yatak olan takýmý gösten stored proc yazýnýz
go
create proc kontrol
as 
begin
select takým.takýmadi from takým inner join yatak on takým.yatakid=yatak.yatakid where takým.yatakid=4
end
exec kontrol
drop proc kontrol/*proc silme komutu*/
