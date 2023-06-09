#Область ОбработчикиСобытий

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	бг_ДобавитьРеквизитыШапки();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьРеквизитыШапки()
	
	бг_Организация = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтотОбъект,
		"бг_Организация",
		Элементы.ГруппаРеквизитыПраво,
		"Объект.бг_Организация",,
		Элементы.ГруппаКод);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция бг_ИнвентарныйНомерСПрефиксом(Код, Организация)
	
	ПрефиксОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Префикс");
	ИнвентарныйНомер = ПрефиксОрганизации + Прав(Код, 6);
		
	Возврат ИнвентарныйНомер;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура бг_ЗаполнитьИнвентарныйНомерПосле(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Код) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Перед установкой инветарного номера обязательно запишите элемент справочника'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.бг_Организация) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Перед установкой инветарного номера обязательно заполните организацию'"));
		Возврат;
	КонецЕсли;
	
	Объект.ИнвентарныйНомер = бг_ИнвентарныйНомерСПрефиксом(Объект.Код, Объект.бг_Организация);
	
КонецПроцедуры

#КонецОбласти