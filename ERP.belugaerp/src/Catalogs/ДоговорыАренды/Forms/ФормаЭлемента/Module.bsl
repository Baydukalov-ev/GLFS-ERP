
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
		
	бг_ДобавитьРеквизитыНаФорму();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьРеквизитыНаФорму()
	
	бг_ВидВзаиморасчетов = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_ВидВзаиморасчетов",
		Элементы.ГруппаДополнительныеРеквизиты,
		"Объект.бг_ВидВзаиморасчетов");
	бг_ВидВзаиморасчетов.АвтоМаксимальнаяШирина = Ложь;
	бг_ВидВзаиморасчетов.МаксимальнаяШирина = 28;
	
КонецПроцедуры

#КонецОбласти