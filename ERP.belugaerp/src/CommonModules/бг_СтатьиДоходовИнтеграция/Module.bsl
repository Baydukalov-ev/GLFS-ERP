Процедура ЗаполнитьЗагружаемыйОбъект(ЗагружаемыйОбъект, СтруктураОбъекта, СписокСвойств, ИсключаяСвойства, СтандартнаяОбработка) Экспорт
	
	Если бг_ОбщегоНазначенияСервер.ОтменитьЗагрузкуОбъекта(ЗагружаемыйОбъект, СтруктураОбъекта, Неопределено, "ЕК", СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	ИсключаяСвойства = бг_ОбщегоНазначенияСервер.СуммаСписков(ИсключаяСвойства, бг_ОбщегоНазначенияСервер.СуществующиеСвойства(СтруктураОбъекта, "Родитель"), Ложь);
	
	Если ЗагружаемыйОбъект.ЭтоНовый() Тогда
		ЗагружаемыйОбъект.Заполнить(Неопределено);
	КонецЕсли;
	
	Если СтруктураОбъекта.ВидДвижения.ЗначениеПеречисления = "ДоходИДДС" Тогда
		СтатьяДвиженияДенежныхСредствОбъект = бг_СтатьиДвиженияДенежныхСредствИнтеграция.ЗагрузитьОбъектИзОбъектаЕК_СтатьиДиР(СтруктураОбъекта);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьМассивПроверяемыхРеквизитовБлокировки(МетаданныеОбъекта, МассивПроверяемыхРеквизитов, СтандартнаяОбработка) Экспорт
	
	МассивПроверяемыхРеквизитов.Добавить("Предопределенный");
	МассивПроверяемыхРеквизитов.Добавить("ПометкаУдаления");
	МассивПроверяемыхРеквизитов.Добавить("Наименование");
	МассивПроверяемыхРеквизитов.Добавить("Код");
	
КонецПроцедуры
