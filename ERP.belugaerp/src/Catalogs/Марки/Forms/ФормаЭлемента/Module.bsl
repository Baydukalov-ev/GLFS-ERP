#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КодНСИ",
		, //Родитель
		"Объект.бг_КодНСИ");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КатегорияБренда",
		, //Родитель
		"Объект.бг_КатегорияБренда");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Проект",
		, //Родитель
		"Объект.бг_Проект");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ПроектПЭО",
		, //Родитель
		"Объект.бг_ПроектПЭО");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_БрендТМ",
		, //Родитель
		"Объект.бг_БрендТМ");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_БрендМТ",
		, //Родитель
		"Объект.бг_БрендМТ");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_БрендКУ",
		, //Родитель
		"Объект.бг_БрендКУ");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КатегорияМотивации",
		, //Родитель
		"Объект.бг_КатегорияМотивации");
	
	Элемент = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_КатегорияВладельца",
		, //Родитель
		"Объект.бг_КатегорияВладельца");
	
КонецПроцедуры

#КонецОбласти
