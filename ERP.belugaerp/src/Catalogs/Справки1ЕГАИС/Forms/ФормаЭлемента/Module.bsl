
#Область ОбработчикиСобытий

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	бг_ДобавитьПоляГТД();
	бг_ДобавитьПолеКрепость();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьПоляГТД()
	
	бг_ДобавитьПолеНомерГТД();
	бг_ДобавитьПолеДатаГТД();
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПолеНомерГТД()
	
	бг_НомерГТД = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_НомерГТД",
		,
		"Объект.бг_НомерГТД");
	бг_НомерГТД.АвтоМаксимальнаяШирина = Ложь;
	бг_НомерГТД.МаксимальнаяШирина = 25;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПолеДатаГТД()
	
	бг_ДатаГТД = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ДатаГТД",
		,
		"Объект.бг_ДатаГТД");
	бг_ДатаГТД.АвтоМаксимальнаяШирина = Ложь;
	бг_ДатаГТД.МаксимальнаяШирина = 25;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьПолеКрепость()
	
	бг_Крепость = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Крепость",
		,
		"Объект.бг_Крепость");
	бг_Крепость.АвтоМаксимальнаяШирина = Ложь;
	бг_Крепость.МаксимальнаяШирина = 25;
	
КонецПроцедуры

#КонецОбласти
