#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства, СтандартнаяОбработка) Экспорт
	
	Если бг_ОбщегоНазначенияСервер.ОтменитьЗагрузкуОбъекта(ЗагружаемыйОбъект, 
		СтруктураОбъекта, Неопределено, Неопределено, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗагружаемыйОбъект.ЭтоНовый() Тогда
		ЗагружаемыйОбъект.Заполнить(Неопределено);
		ЗагружаемыйОбъект.УстановитьНовыйКод();
		СтруктураОбъекта.Код = ЗагружаемыйОбъект.Код;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьМассивПроверяемыхРеквизитовБлокировки(МетаданныеОбъекта, МассивПроверяемыхРеквизитов, СтандартнаяОбработка) Экспорт
	
	МассивПроверяемыхРеквизитов.Добавить("Код");
	МассивПроверяемыхРеквизитов.Добавить("Наименование");
	МассивПроверяемыхРеквизитов.Добавить("ПометкаУдаления");
	МассивПроверяемыхРеквизитов.Добавить("Предопределенный");
	
КонецПроцедуры

#КонецОбласти
